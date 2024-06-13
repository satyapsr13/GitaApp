import 'dart:convert';
import 'dart:developer';

import '../../Constants/constants.dart';
import '../model/api/Tags/similar_tags_response.dart';
import '../model/api/post_model.dart';
import '../model/api/special_ocassion_model.dart';
import '../model/api/tags_model.dart';
import '../model/api/toc_response.dart';
import '../model/api/today_posts_response.dart';
import '../services/api_result.dart';
import '../services/dio_client.dart';
import '../services/network_exceptions.dart';

class PostRepository {
  late DioClient dioClient;

  PostRepository() {
    dioClient = DioClient();
  }

  Future<ApiResult<PostResponseData>> fetchNextPagePosts(int pageNo) async {
    try {
      final response = await dioClient.get("/posts/random?page=$pageNo");
      PostResponseData postResponseData = PostResponseData.fromMap(response);
      return ApiResult.success(data: postResponseData);
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult<TodayPostsResponse>> fetchTodayData() async {
    try {
      final response = await dioClient.get("/today-new");
      TodayPostsResponse todayPostsResponse =
          TodayPostsResponse.fromMap(response);
      return ApiResult.success(data: todayPostsResponse);
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult<dynamic>> fetchBackupImages() async {
    try {
      final response = await dioClient.get("/posts/backup");

      return ApiResult.success(data: response);
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult<TocResponse>> fetchTOCData() async {
    try {
      final response = await dioClient.get("/toc/newest");
      TocResponse todayPostsResponse = TocResponse.fromMap(response);
      return ApiResult.success(data: todayPostsResponse);
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult<PostResponseData>> fetchSpecificCategoryResponse(
      String postId, int currentPage, bool isOcassionScreen) async {
    try {
      final response = await dioClient.get(!isOcassionScreen
          ? "/posts/bycategory/$postId/?page=$currentPage"
          : "/posts/byoccasion/$postId/?page=$currentPage");
      PostResponseData postResponseData = PostResponseData.fromMap(response);
      return ApiResult.success(data: postResponseData);
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult<SimilarTagsResponse>> fetchSimilarTags(
      {required String tagsKeyword, bool isCategory = false}) async {
    try {
      final response = await dioClient
          .get("/${!isCategory ? "getTag" : "getCategory"}/$tagsKeyword");
      SimilarTagsResponse data = SimilarTagsResponse.fromMap(response);
      return ApiResult.success(data: data);
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult<PostResponseData>> fetchSpecificTagsResponse(
      {required String postKeyword,
      required int currentPage,
      bool isNews = false}) async {
    try {
      final response = await dioClient.get(isNews == true
          ? 'posts/news/?page=$currentPage'
          : 'posts/bytag/$postKeyword/?page=$currentPage');
      PostResponseData postResponseData = PostResponseData.fromMap(response);
      return ApiResult.success(data: postResponseData);
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult<List<SpecialOcassion>>>
      fetchSpecialOcassionResponse() async {
    try {
      final response = await dioClient.get("/activeoccasions/v2");
      List<SpecialOcassion> data =
          specialOcassionResponseFromMap(json.encode(response));
      return ApiResult.success(data: data);
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult<PostResponseData>> fetchDaySpecialPost({int? page}) async {
    try {
      final response =
          await dioClient.get("/day-special?page=${(page ?? 0) + 1}");
      PostResponseData data = PostResponseData.fromMap(response);
      // specialOcassionResponseFromMap(json.encode(response));
      return ApiResult.success(data: data);
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult<PostModel>> fetchTodayPost() async {
    try {
      final response = await dioClient.get("/today");

      PostModel data = PostModel.fromMap(response);
      // specialOcassionResponseFromMap(json.encode(response));
      return ApiResult.success(data: data);
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult<List<TagsModel>>> fetchTags(bool toFetchAllTags) async {
    try {
      final response =
          await dioClient.get(toFetchAllTags ? "/alltags" : "/activetags");
      List<TagsModel> data = tagModelFromMap(json.encode(response));
      return ApiResult.success(data: data);
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult<dynamic>> sendShareResponseToBackendAdmin(
    String postId, {
    String? name,
    bool? isAfterEdit,
    String? imagePath,
    String? userNumber,
    String? userId,
  }) async {
    List<String> tempUserPath = [];

    try {
      tempUserPath.addAll(pathTracker);
      tempUserPath.removeWhere((element) {
        return element.startsWith("Ver");
      });
      Map postInfo = {
        "post": postId,
        "version": GlobalVariables.appVersion,
        "userPath": tempUserPath.toString(),
        "isEdited": isAfterEdit != null ? "Edited" : "Not-Edited",
        "user": name,
        "user_id": userId,
        "data": {
          "name": name,
          "isEdited": isAfterEdit != null ? "Edited" : "Not-Edited",
          // "phone_number": userNumber ?? "Not added",
          "postId": postId,
          "user_id": userId,
          "userPath": tempUserPath.toString(),
        },
      };
      final response = await dioClient.post("/share", data: postInfo);

      return ApiResult.success(data: response);
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }
}
