import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:gita/Data/model/api/ImageSearch/image_search_res.dart';
import 'package:gita/Data/model/api/mini_apps_response.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

import '../../../Constants/enums.dart';
import '../../../Data/model/api/ImageSearch/pixabay_response.dart';
import '../../../Data/model/api/ImageSearch/unsplash_response.dart';
import '../../../Data/model/api/SeriesPostResponse/gita_post_response.dart';
import '../../../Data/model/api/SeriesPostResponse/panchang_response.dart';
import '../../../Data/repositories/localization.dart';
import '../../../Data/repositories/series_post_repository.dart';
import '../../../Data/services/api_result.dart';
import '../../../Data/services/network_exceptions.dart';
import '../../../Data/services/secure_storage.dart';

part "series_post_state.dart";

class SeriesPostCubit extends HydratedCubit<SeriesPostState> {
  final LocaleRepository localeRepository;
  final SeriesPostRepository seriesPostRepository;
  final SecureStorage secureStorage;
  SeriesPostCubit({
    required this.localeRepository,
    required this.seriesPostRepository,
    required this.secureStorage,
  }) : super(SeriesPostState());

  Future<void> fetchGitaPosts({required String chapter}) async {
    emit(state.copyWith(status: Status.loading));
    ApiResult<GitaPostResponse> categoriesResponse =
        await seriesPostRepository.fetchGitaPost(chapter: chapter);

    categoriesResponse.when(success: (GitaPostResponse data) async {
      emit(state.copyWith(
          status: Status.success,
          gitaSlokeList: data.data?.gitaSloks,
          chapter: data.data?.chapter,
          totalSloke: data.data?.totalShloks));
    }, failure: (NetworkExceptions error) {
      emit(state.copyWith(status: Status.failure));
    });
  }

  void updateState({List<String>? listOfImgSearchKeys}) {
    emit(state.copyWith(
      listOfImgSearchKeys: listOfImgSearchKeys,
    ));
  }

  Future<void> fetchPanditData() async {
    emit(state.copyWith(panditDataStatus: Status.loading));
    ApiResult<PanchangResponse> categoriesResponse =
        await seriesPostRepository.fetchPanditData();

    categoriesResponse.when(success: (PanchangResponse data) async {
      emit(state.copyWith(
        panditDataStatus: Status.success,
        panditData: data.data,
      ));
    }, failure: (NetworkExceptions error) {
      emit(state.copyWith(
          panditDataStatus: Status.failure,
          error: NetworkExceptions.getErrorMessage(error)));
    });
  }

  Future<void> fetchPixabayImage({String? searchKey}) async {
    emit(state.copyWith(imageSearchStatus: Status.loading));
    ApiResult<PixabayImageResponse> categoriesResponse =
        await seriesPostRepository.fetchPixabayImage(searchKey: searchKey);

    categoriesResponse.when(success: (PixabayImageResponse data) async {
      List<ImageSearch> temp = [];
      List<String> searchKeys = [];
      for (var e in data.hits!) {
        temp.add(ImageSearch(
            previewImgUrl: e.previewUrl ?? "",
            actualImgUrl: e.largeImageUrl ?? ""));
      }
      if (temp.isNotEmpty) {
        if (searchKey != null) {
          if (state.listOfImgSearchKeys.contains(searchKey)) {
            state.listOfImgSearchKeys.remove(searchKey);
          }
          searchKeys.add(searchKey);
        }
        searchKeys.addAll(state.listOfImgSearchKeys);
      }

      emit(state.copyWith(
        imageSearchStatus: Status.success,
        listOfImgSearchKeys: searchKeys,
        listOfSearchImage: temp,
      ));
    }, failure: (NetworkExceptions error) {
      emit(state.copyWith(
          imageSearchStatus: Status.failure,
          error: NetworkExceptions.getErrorMessage(error)));
    });
    fetchUnplashImage(searchKey: searchKey);
  }

  Future<void> fetchUnplashImage({String? searchKey}) async {
    // emit(state.copyWith(imageSearchStatus: Status.loading));
    ApiResult<UnsplashImgResponse> categoriesResponse =
        await seriesPostRepository.fetchUnsplashImage(searchKey: searchKey);

    categoriesResponse.when(success: (UnsplashImgResponse data) async {
      List<ImageSearch> temp = [];
      // List<String> searchKeys = [];
      for (var e in (data.results ?? [])) {
        temp.add(ImageSearch(
            previewImgUrl: e.urls?.full.toString() ?? "",
            actualImgUrl: e.urls?.full.toString() ?? ""));
      }
      temp.addAll(state.listOfSearchImage);
      temp.shuffle();
      emit(state.copyWith(
        imageSearchStatus: Status.success,
        listOfSearchImage: temp,
      ));
    }, failure: (NetworkExceptions error) {
      emit(state.copyWith(
          imageSearchStatus: Status.failure,
          error: NetworkExceptions.getErrorMessage(error)));
    });
  }

  Future<void> fetchMiniapps() async {
    emit(state.copyWith(status: Status.loading));
    ApiResult<MiniAppsResponse> categoriesResponse =
        await seriesPostRepository.fetchMiniApps();

    categoriesResponse.when(success: (MiniAppsResponse data) async {
      emit(state.copyWith(status: Status.success, listOfMiniapps: data.data));
    }, failure: (NetworkExceptions error) {
      emit(state.copyWith(status: Status.failure));
    });
  }

  @override
  SeriesPostState? fromJson(Map<String, dynamic> json) {
    return SeriesPostState.fromMap(json);
  }

  @override
  Map<String, dynamic>? toJson(SeriesPostState state) {
    return state.toMap();
  }
}
