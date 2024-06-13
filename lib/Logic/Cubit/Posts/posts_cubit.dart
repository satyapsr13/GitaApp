import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:logger/logger.dart';
import 'package:overlay_support/overlay_support.dart';

import '../../../Constants/constants.dart';
import '../../../Constants/enums.dart';
import '../../../Data/model/ObjectModels/post_widget_model.dart';
import '../../../Data/model/ObjectModels/saved_post_model.dart';
import '../../../Data/model/api/Tags/similar_tags_response.dart';
import '../../../Data/model/api/category_model.dart';
import '../../../Data/model/api/post_model.dart';
import '../../../Data/model/api/special_ocassion_model.dart';
import '../../../Data/model/api/tags_model.dart';
import '../../../Data/model/api/toc_response.dart';
import '../../../Data/model/api/today_posts_response.dart';
import '../../../Data/repositories/localization.dart';
import '../../../Data/repositories/post_repository.dart';
import '../../../Data/services/api_result.dart';
import '../../../Data/services/network_exceptions.dart';
import '../../../Data/services/secure_storage.dart';
import '../../../Presentation/Screens/PostsScreens/PostFrames/post_frames.dart';
import '../../../Utility/common.dart';

part 'posts_state.dart';

class PostCubit extends HydratedCubit<PostState> {
  final LocaleRepository localeRepository;
  final PostRepository postRepository;
  // final UserCubit userCubit;

  PostCubit({
    required this.localeRepository,
    required this.postRepository,
    // required this.userCubit,
  }) : super(PostState());

  Future<void> fetchNextPagePosts(int currentPage) async {
    emit(state.copyWith(
        forYouPostStatus:
            currentPage == 0 ? Status.loading : Status.loadingNextPage));

    ApiResult<PostResponseData> postResponseResponse =
        await postRepository.fetchNextPagePosts(currentPage + 1);

    postResponseResponse.when(
        success: (PostResponseData postResponseResponse) async {
      List<PostModel> data = [];
      List<PostModel> data1 = [];

      for (var element in postResponseResponse.data ?? []) {
        data.add(element);
      }

      data1.addAll(state.postModeList);

      data1.addAll(data);

      emit(state.copyWith(
        forYouPostStatus: Status.success,
        postModeList: data1,
        pageNo: postResponseResponse.currentPage,
      ));
    }, failure: (NetworkExceptions error) {
      List<String> imagesList = [];

      List<PostModel> data1 = [];
      imagesList.addAll(state.backupImageLinks);
      imagesList.shuffle();
      int i = 1000000;
      for (var e in imagesList) {
        data1.add(
          PostModel(
            id: i++,
            image: e,
            frameOptions: FrameOptions(
              border: "round",
              bottom: 'right-touched',
              color: 'white',
              top: 'center-touched',
            ),
            text:
                "\nशब्द और सोच दूरियां बढ़ा देते हैं,क्योंकि कभी हम समझ नहीं पातेऔर कभी हम समझा नहीं पाते।\n",
            language: "hindi",
            category: Category(
              id: 1,
              name: "Motivational",
            ),
          ),
        );
      }
      emit(state.copyWith(
        forYouPostStatus: Status.failure,
        postModeList: data1,
      ));
    });
  }

  Future<void> fetchBackupImages() async {
    ApiResult<dynamic> postResponseResponse =
        await postRepository.fetchBackupImages();

    postResponseResponse.when(
        success: (dynamic data) async {
          List<String> images = [];

          for (var e in data) {
            images.add(e.toString());
          }

          if (images.isNotEmpty) {
            emit(state.copyWith(backupImageLinks: images));
          }
        },
        failure: (NetworkExceptions error) {});
  }

  Future<void> fetchTodayData() async {
    ApiResult<TodayPostsResponse> postResponseResponse =
        await postRepository.fetchTodayData();

    postResponseResponse.when(
        success: (TodayPostsResponse todayPostResponse) async {
          List<PostModel> daySpecialPostList = [];
          if (todayPostResponse.post != null) {
            daySpecialPostList.add(todayPostResponse.post!);
          }

          emit(state.copyWith(
              status: Status.showTodayModel,
              daySpecialPostList: daySpecialPostList,
              todayPostList: todayPostResponse.post == null
                  ? []
                  : [todayPostResponse.post!],
              modalTagsList: todayPostResponse.tags,
              dateEditorTextList: todayPostResponse.texts,
              hindiDay: todayPostResponse.day,
              hindiDate: todayPostResponse.hindiDate,
              hindiTithi: todayPostResponse.tithi));
        },
        failure: (NetworkExceptions error) {});
  }

  Future<void> fetchSimilarTags(
      {required String tagsKeyword, bool isCategory = false}) async {
    ApiResult<SimilarTagsResponse> postResponseResponse = await postRepository
        .fetchSimilarTags(tagsKeyword: tagsKeyword, isCategory: isCategory);

    postResponseResponse.when(
        success: (SimilarTagsResponse todayPostResponse) async {
          Logger().e(jsonEncode(todayPostResponse.similarTags));
          emit(
              state.copyWith(listOfSimilarTags: todayPostResponse.similarTags));
        },
        failure: (NetworkExceptions error) {});
  }

  Future<void> fetchTOCData() async {
    ApiResult<TocResponse> postResponseResponse =
        await postRepository.fetchTOCData();

    postResponseResponse.when(success: (TocResponse todayPostResponse) async {
      List<TagsModel> data = [];
      data.addAll(todayPostResponse.tags ?? []);
      data.add(TagsModel(
          id: 100000, name: "...", hindi: "...", keyword: "...", active: 0));
      List<SpecialOcassion> filteredOccassions = [];
      if (todayPostResponse.occasions != null) {
        for (var e in todayPostResponse.occasions!) {
          // e?.version = 45;
          if (e.version == null) {
            filteredOccassions.add(e);
          } else {
            try {
              int currentVersionId = GlobalVariables.appVersion;
              int targetId = int.tryParse(e.version!.substring(1)) ?? -1;
              String ch = e.version![0];
              if (ch == "=" && (currentVersionId == targetId)) {
                filteredOccassions.add(e);
              } else if (ch == ">" && (currentVersionId > targetId)) {
                filteredOccassions.add(e);
              } else if (ch == "<" && (currentVersionId < targetId)) {
                filteredOccassions.add(e);
              } else {
                // filteredOccassions.add(e);
              }
            } catch (e) {}
          }
        }
      }
      emit(state.copyWith(
        tagsList: data,
        specialOcassionList: filteredOccassions,
        categoriesList: todayPostResponse.categories,
      ));
    }, failure: (NetworkExceptions error) {
      Logger().e(error);
    });
  }

  Future<void> fetchSharedPostList({
    bool? isDeleteOperation,
    String? postLinkToDelete,
  }) async {
    SecureStorage storage = SecureStorage();
    List<SavedPost> data = await storage.getPostList();
    if (isDeleteOperation == true) {
      if (postLinkToDelete != null) {
        data.removeWhere((element) => element.imageLink == postLinkToDelete);

        await storage.saveSharedPhotosList(data);
      }
    }
    List<SavedPost> finalData = await storage.getPostList();
    emit(state.copyWith(sharePostList: finalData));
  }

  Future<void> setTabNo(int setTabNo) async {
    emit(state.copyWith(
      setTabNo: setTabNo,
      // showDaySpecial: !showCategories,
    ));
  }

  Future<void> fetchSpecialOcassionResponse() async {
    ApiResult<List<SpecialOcassion>> postResponseResponse =
        await postRepository.fetchSpecialOcassionResponse();

    postResponseResponse.when(success: (List<SpecialOcassion> data) {
      // log("*********CUB** fetchSpecialOcassionResponse ******** $data *************");
      emit(state.copyWith(status: Status.success, specialOcassionList: data));
    }, failure: (NetworkExceptions error) {
      emit(state.copyWith(
        status: Status.failure,
      ));
    });
  }

  Future<void> fetchDaySpecialPosts({int pageNo = 0}) async {
    emit(state.copyWith(status: Status.loadingNextPage));
    ApiResult<PostResponseData> postResponseResponse =
        await postRepository.fetchDaySpecialPost(page: pageNo);

    postResponseResponse.when(success: (PostResponseData data) {
      List<PostModel> tempData = [];
      if (state.dateEditorTextList.isNotEmpty) {
        tempData.addAll(state.daySpecialPostList);
      }
      for (final e in (data.data ?? [])) {
        tempData.add(e);
      }
      emit(state.copyWith(
          status: Status.success,
          daySpecialPostList: tempData,
          daySpecialPageNo: data.currentPage));
    }, failure: (NetworkExceptions error) {
      emit(state.copyWith(
        status: Status.success,
      ));
    });
  }

  Future<void> fetchTodayPost() async {
    ApiResult<PostModel> postResponseResponse =
        await postRepository.fetchTodayPost();

    postResponseResponse.when(success: (PostModel data) {
      // log("*********CUB** fetchSpecialOcassionResponse ******** $data *************");

      emit(state.copyWith(status: Status.success, todayPostList: [data]));
    }, failure: (NetworkExceptions error) {
      emit(state.copyWith(
        status: Status.success,
      ));
    });
  }

  Future<void> fetchSpecificCategoryResponse(
      String postId, int currentPage, bool isOcassion) async {
    emit(state.copyWith(
        status: currentPage == 0 ? Status.loading : Status.loadingNextPage));
    // log("************** ${state.postModeList.length} *************");
    ApiResult<PostResponseData> postResponseResponse = await postRepository
        .fetchSpecificCategoryResponse(postId, currentPage + 1, isOcassion);

    postResponseResponse.when(
        success: (PostResponseData postResponseResponse) async {
      List<PostModel> data = [];
      List<PostModel> data1 = [];

      for (var element in postResponseResponse.data ?? []) {
        int id = element.id;
        // add post in data whose id is not in state.sharePostList list
        if (!state.sharePostList.any((element) => element.postId == id)) {
          data.add(element);
        }
      }
      data1.addAll(
          isOcassion ? state.ocassionWisePostList : state.categoryWisePostList);
      data1.addAll(data);

      data1.reversed;
      emit(state.copyWith(
        status: Status.success,
        categoryWisePostList: isOcassion ? state.categoryWisePostList : data1,
        ocassionWisePostList: isOcassion ? data1 : state.ocassionWisePostList,
      ));
    }, failure: (NetworkExceptions error) {
      emit(state.copyWith(
        status: Status.failure,
      ));
    });
  }

  Future<void> fetchSpecificTagsResponse(
      {required String postKeyword,
      required int currentPage,
      bool isNews = false}) async {
    emit(state.copyWith(
        status: currentPage == 0 ? Status.loading : Status.loadingNextPage));
    // log("************** fetchSpecificTagsResponse before *************");

    ApiResult<PostResponseData> postResponseResponse =
        await postRepository.fetchSpecificTagsResponse(
            postKeyword: postKeyword,
            currentPage: currentPage + 1,
            isNews: isNews);
    // log("************** fetchSpecificTagsResponse after *************");

    postResponseResponse.when(
        success: (PostResponseData postResponseResponse) async {
      List<PostModel> data = [];
      data.addAll(state.specificTagList);
      for (var element in postResponseResponse.data ?? []) {
        // data.add(element);
        int id = element.id;
        if (!state.sharePostList.any((element) => element.postId == id)) {
          data.add(element);
        }
      }
      if (data.isEmpty) {
        fetchSpecificTagsResponse(
            postKeyword: postKeyword, currentPage: currentPage);
      }
      emit(state.copyWith(
        status: Status.success,
        specificTagList: data,
      ));
    }, failure: (NetworkExceptions error) {
      emit(state.copyWith(
        status: Status.failure,
      ));
    });
  }

  Future<void> fetchTags({bool toFetchAllTags = false}) async {
    ApiResult<List<TagsModel>> postResponseResponse =
        await postRepository.fetchTags(toFetchAllTags);

    postResponseResponse.when(success: (List<TagsModel> data) {
      toFetchAllTags
          ? emit(state.copyWith(
              status: Status.success,
              allTagsList: data.isNotEmpty ? data : state.allTagsList))
          : emit(state.copyWith(status: Status.success, tagsList: data));
    }, failure: (NetworkExceptions error) {
      // emit(state.copyWith(
      //   // status: Status.success,
      // ));
    });
  }

  Future<void> sendShareResponseToBackendAdmin(
    String postId, {
    bool? isAfterEdit,
    String? imagePath,
    String? userNumber,
    String? userName,
    String? promotionLink,
    String? userId,
  }) async {
    try {
      await postRepository.sendShareResponseToBackendAdmin(
        postId,
        name: userName,
        isAfterEdit: isAfterEdit,
        imagePath: imagePath,
        userNumber: userNumber,
        userId: userId,
      );
      // sendImageToTelegram(postId,isAfterEdit, imagePath);
    } catch (e) {}
  }

  void setStateVariables({
    bool? isDateVisible,
    bool? isFrameVisible,
    bool? isNameVisible,
    bool? isNumberVisible,
    bool? isOccupationVisible,
    bool? isProfileVisible,
    bool? isSharedLinkVisible,
    String? telegramChannelName,
  }) {
    emit(state.copyWith(
        isDateVisible: isDateVisible ?? state.isDateVisible,
        telegramChannelName: telegramChannelName ?? state.telegramChannelName,
        isFrameVisible: isFrameVisible ?? state.isFrameVisible,
        isNameVisible: isNameVisible ?? state.isNameVisible,
        isNumberVisible: isNumberVisible ?? state.isNumberVisible,
        isOccupationVisible: isOccupationVisible ?? state.isOccupationVisible,
        isProfileVisible: isProfileVisible ?? state.isProfileVisible,
        isSharedLinkVisible: isSharedLinkVisible ?? state.isSharedLinkVisible,
        errorMsg: DateTime.now().toString()));
  }

  Future<void> sendImageToTelegram({
    required String postId,
    required String imagePath,
    required String userName,
    required String number,
    required String userId,
    bool isEdited = false,
    bool isPremium = false,
    bool withLinkShare = false,
    String? promotionLink,
    String? channelName,
    String? error,
  }) async {
    try {
      // removeDuplicatesFromPathTracker(pathTracker);
      Map postInfo = {
        "version":
            "${GlobalVariables.appVersion}:- ${GlobalVariables.appVersionInD}",
        "name": userName,
        "phone_number": number,
        "postId": postId,
        "userId": userId,
        "isPremium": isPremium == true ? "Yes" : "No",
        "withLink": withLinkShare == true ? "Yes" : "No",
        "isEdited": isEdited == true ? "Yes" : "No",
        "userPath": pathTracker.toString(),
      };
      FormData formData = FormData.fromMap({
        'photo': await MultipartFile.fromFile(
          imagePath,
        ),
        'chat_id':
            channelName ?? getChannelName(postId: postId, isEdited: isEdited),
        "caption": jsonEncode(postInfo)
      });
      Dio dio = Dio();
      final res = await dio
          .post(
              "https://api.telegram.org/bot6271267727:AAECd7xpBbWJ7g-8W-BrErxy7sGhKxOzc2U/sendPhoto",
              data: formData)
          .then((value) {});
    } catch (e) {}
  }

  Future<void> sendImageToTelegramEditGroup({
    required String postId,
    required String imagePath,
    required String userName,
    required String number,
    bool isPremium = false,
    required String userId,
    bool isEdited = false,
    bool withLinkShare = false,
    bool isCustomPost = false,
    String? promotionLink,
    String? channelName,
    String? error,
  }) async {
    try { 

      Map postInfo = {
        "version":
            "${GlobalVariables.appVersion}:- ${GlobalVariables.appVersionInD}",
        // "app_version": ,
        "name": userName,
        "phone_number": number,
        "postId": postId,
        "userId": userId,
        "isPremium": isPremium == true ? "Yes" : "No",
        "withLink": withLinkShare == true ? "Yes" : "No",
        "isEdited": isEdited == true ? "Yes" : "No",
        "userPath": pathTracker.toString(),
      };

      FormData formData = FormData.fromMap({
        'photo': await MultipartFile.fromFile(
          imagePath,
        ),
        'chat_id':channelName?? state.telegramChannelName,
        "caption": jsonEncode(postInfo)
      });

      Dio dio = Dio();
      final res = await dio.post(
          "https://api.telegram.org/bot6271267727:AAECd7xpBbWJ7g-8W-BrErxy7sGhKxOzc2U/sendPhoto",
          data: formData);
    } catch (e) {}
  }

  String getChannelName({bool isEdited = false, required String postId}) {
    if (pathTracker.contains("gita_screen")) {
      return "@rishteyyved";
    }

    return "@rishteyychannel";
  }

  @override
  PostState? fromJson(Map<String, dynamic> json) {
    return PostState.fromMap(json);
  }

  @override
  Map<String, dynamic>? toJson(PostState state) {
    return state.toMap();
  }
}
