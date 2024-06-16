import 'dart:convert';

import 'package:gita/Data/model/api/ImageSearch/pixabay_response.dart';
import 'package:gita/Data/model/api/ImageSearch/unsplash_response.dart';
import 'package:logger/logger.dart';

import '../model/api/SeriesPostResponse/gita_post_response.dart';
import '../model/api/SeriesPostResponse/panchang_response.dart';
import '../model/api/mini_apps_response.dart';
import '../services/api_result.dart';
import '../services/dio_client.dart';
import '../services/network_exceptions.dart';

class SeriesPostRepository {
  late DioClient dioClient;

  SeriesPostRepository() {
    dioClient = DioClient();
  }

  Future<ApiResult<GitaPostResponse>> fetchGitaPost(
      {required String chapter}) async {
    try {
      final response = await dioClient.get("/gita?chapter=$chapter");
      GitaPostResponse data = GitaPostResponse.fromJson(jsonEncode(response));
      return ApiResult.success(data: data);
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult<MiniAppsResponse>> fetchMiniApps() async {
    try {
      final response = await dioClient.get("/mini-apps");
      MiniAppsResponse data = MiniAppsResponse.fromJson(jsonEncode(response));
      return ApiResult.success(data: data);
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult<PanchangResponse>> fetchPanditData() async {
    try {
      final response = await dioClient.get("/today-panchang");
      PanchangResponse data = PanchangResponse.fromJson(jsonEncode(response));
      return ApiResult.success(data: data);
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult<PixabayImageResponse>> fetchPixabayImage(
      {String? searchKey}) async {
    if (searchKey != null) {
      searchKey = searchKey.replaceAll(" ", "+");
    }
    try {
      final response = await dioClient.getCustom("",
          authKey: "44056652-c8fcd37c801e74a38ec088a49",
          customUrl:
              "https://pixabay.com/api/?key=44056652-c8fcd37c801e74a38ec088a49&q=$searchKey&image_type=photo&per_page=200&orientation=vertical&safesearch=true");
      Logger().i(response);
      PixabayImageResponse data =
          PixabayImageResponse.fromJson(jsonEncode(response));
      return ApiResult.success(data: data);
    } catch (e) {
      Logger().i(e);
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult<PixabayImageResponse>> fetchPixelsImage(
      {String? searchKey}) async {
    if (searchKey != null) {
      searchKey = searchKey.replaceAll(" ", "+");
    }
    try {
      final response = await dioClient.getCustom("",
          authKey: "cf4ap5MqAsaeC7kPNKpC07FHMiZsoq2fRr1t47TOTcp1XkhT2eELTFOm",
          customUrl:
              "https://pixabay.com/api/?key=44056652-c8fcd37c801e74a38ec088a49&q=$searchKey&image_type=photo&per_page=200&orientation=vertical&safesearch=true");
      Logger().i(response);
      PixabayImageResponse data =
          PixabayImageResponse.fromJson(jsonEncode(response));
      return ApiResult.success(data: data);
    } catch (e) {
      Logger().i(e);
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult<UnsplashImgResponse>> fetchUnsplashImage(
      {String? searchKey}) async {
    if (searchKey != null) {
      searchKey = searchKey.replaceAll(" ", "+");
    }
    try {
      final response = await dioClient.getCustom("",
          accessKey: '8Latu7nN7MabQKOoYxqfSC0PkiGepCi6jtYt8wSWnQc',
          secretKey: 'h-BEInSCGbMEV3PB-cXySSDCP7s1ylZVD1wzjL2MA5Y',
          customUrl:
              "https://api.unsplash.com/search/photos?client_id=8Latu7nN7MabQKOoYxqfSC0PkiGepCi6jtYt8wSWnQc&page=1&query=$searchKey&per_page=50&orientation=portrait");
      Logger().i(response);
      UnsplashImgResponse data =
          UnsplashImgResponse.fromJson(jsonEncode(response));
      return ApiResult.success(data: data);
    } catch (e) {
      Logger().i(e);
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }
  // cf4ap5MqAsaeC7kPNKpC07FHMiZsoq2fRr1t47TOTcp1XkhT2eELTFOm
}
