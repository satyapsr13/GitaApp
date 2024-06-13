import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

import '../model/api/bg_images.response.dart';
import '../model/api/dpframes_response.dart';
import '../model/api/frames_response.dart';
import '../model/api/sticker_model.dart';
import '../services/api_result.dart';
import '../services/dio_client.dart';
import '../services/network_exceptions.dart';

class StickerRepository {
  late DioClient dioClient;

  StickerRepository() {
    dioClient = DioClient();
  }

  Future<ApiResult<dynamic>> removeBG(
      {required String imagePath, String? userId, String? reason}) async {
    try {
      FormData formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(
          imagePath,
        ),
        "user_id": userId,
        "reason": reason,
        // Send additional data if needed
      });
      final response = await dioClient.post("",
          customUri: "https://tools.rishteyy.in/generate-png", data: formData);
      // List<StickerResponse> postResponseData =
      //     stickerResponseFromMap(json.encode(response));
      return ApiResult.success(data: response);
    } catch (e) {
      // log("*******fetchNextPagePosts*******$e**********");
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult<List<StickerResponse>>> fetchStickers() async {
    try {
      final response = await dioClient.get("/stickers");
      List<StickerResponse> postResponseData =
          stickerResponseFromMap(json.encode(response));
      return ApiResult.success(data: postResponseData);
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult<List<BgImagesCategory>>> fetchBackgroundImages() async {
    try {
      final response = await dioClient.get("/backgrounds");
      List<BgImagesCategory> data = bgResponseFromMap(json.encode(response));
      return ApiResult.success(data: data);
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult<FrameResponse>> fetchFrames(
      {bool isTestFrame = false}) async {
    try {
      final response =
          await dioClient.get(isTestFrame ? "/frames-test" : "/frames");
      FrameResponse data = FrameResponse.fromMap(response);
      return ApiResult.success(data: data);
    } catch (e) {
      // Logger().e("FrameResponse $e");
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult<DpFramesResponse>> fetchDpFrames({
    bool isTestFrame = false,
    String? keyword,
  }) async {
    try {
      final response =
          await dioClient.get(  isTestFrame?"/dpframes-test" : keyword==null? "/dpframes": "/dpframes/$keyword");
      DpFramesResponse data = DpFramesResponse.fromMap(response);
      return ApiResult.success(data: data);
    } catch (e) {
      // Logger().e("FrameResponse $e");
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult<dynamic>> fetchHindiDate() async {
    try {
      final response = await dioClient.get("/tithi");
      // HindiDate data = HindiDate.fromMap(response);
      return ApiResult.success(data: response);
    } catch (e) {
      // log("*******fetchNextPagePosts*******$e**********");
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }
}
