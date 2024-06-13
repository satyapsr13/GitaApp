import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:rishteyy/Data/model/api/leaderboard_response.dart';
import 'package:rishteyy/Data/model/api/message_response.dart';

import '../../Constants/constants.dart';
import '../model/ObjectModels/user.model.dart';
import '../model/api/Premium/premium_plan_response.dart';
import '../model/api/Premium/subscribe_plan_list_response.dart';
import '../model/api/getprofile.response.dart';
import '../services/api_result.dart';
import '../services/dio_client.dart';
import '../services/network_exceptions.dart';

class UserRepository {
  late DioClient dioClient;

  UserRepository() {
    dioClient = DioClient();
  }

  Future<ApiResult<dynamic>> authorizeUser(UserModel user) async {
    try {
      Logger().i(user.toMap());
      final response = await dioClient.post("/login", data: user.toMap());

      return ApiResult.success(data: response);
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult<MessageResponse>> getMessages({int pageNo = 0}) async {
    try {
      final response = await dioClient.get("/get-messages");
      MessageResponse data = MessageResponse.fromJson(jsonEncode(response));
      return ApiResult.success(data: data);
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult<dynamic>> dumpData({
    required String dummyData,
    required String userId,
    required String number,
    // required String number,
  }) async {
    try {
      final response = await dioClient.post("/dump-data", data: {
        "user_id": userId,
        "contact": number,
        "data": dummyData,
        "type": "user_contacts"
      });
      // MessageResponse data = MessageResponse.fromJson(jsonEncode(response));
      return ApiResult.success(data: response);
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult<MessageResponse>> sendMessages(
      {required Message message}) async {
    try {
      final response =
          await dioClient.post("/send-message", data: message.toJson());
      MessageResponse data = MessageResponse.fromJson(jsonEncode(response));
      return ApiResult.success(data: data);
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult<LeaderboardResponse>> fetchLeaderboardData() async {
    try {
      final response = await dioClient.get(
        "/leaderboard",
      );
      LeaderboardResponse data =
          LeaderboardResponse.fromJson(jsonEncode(response));
      return ApiResult.success(data: data);
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult<GetProfileResponse>> getProfileDate() async {
    try {
      final response = await dioClient.post("/get-profile");
      GetProfileResponse data =
          GetProfileResponse.fromJson(jsonEncode(response));

      return ApiResult.success(data: data);
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult<PremiumPlanResponse>> fetchPremiumPlan() async {
    try {
      final response = await dioClient.get(
        "/plans",
      );
      PremiumPlanResponse data =
          PremiumPlanResponse.fromJson(jsonEncode(response));

      return ApiResult.success(data: data);
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult<SubscribePlanListResponse>> fetchSubscribePlans() async {
    try {
      final response = await dioClient.post(
        "/get-payments",
      );
      SubscribePlanListResponse data =
          SubscribePlanListResponse.fromJson(jsonEncode(response));

      return ApiResult.success(data: data);
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult<dynamic>> sendRatingFeedback({
    required String message,
    required String userId,
    String? number,
    String? channelName,
    String? reason,
    String? other_data,
  }) async {
    try {
      final response = await dioClient.post("/feedback", data: {
        "message": message,
        "user_id": userId,
        "number": number,
        "channel_name": channelName,
        "other_data": other_data,
        "reason": reason,
        "version":
            "${GlobalVariables.appVersionInD} + ${GlobalVariables.appVersion}",
      });

      return ApiResult.success(data: response);
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult<dynamic>> fetchBlockedNumbers() async {
    try {
      final response = await dioClient.get(
        "/blocked-numbers",
      );

      return ApiResult.success(data: response);
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult<dynamic>> updateProfile(UserModel user) async {
    try {
      log("---------${user.toMap()}--------");
      final response =
          await dioClient.post("/update-profile", data: user.toMap());

      return ApiResult.success(data: response);
    } catch (e) {
      // log("***** Category ** Response **error *****-> [$e ]****************************");
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult<dynamic>> uploadMedia(String imagePath) async {
    try {
      FormData formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          imagePath,
        ),

        // Send additional data if needed
      });
      final response = await dioClient.post("/upload-media", data: formData);

      return ApiResult.success(data: response);
    } catch (e) {
      // log("***** Category ** Response **error *****-> [$e ]****************************");
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  // sendPremiumPurchaseToBackend() {}
  Future<ApiResult<dynamic>> sendPremiumPurchaseToBackend({
    bool? isSuccess,
    String? orderId,
    String? paymentId,
    String? signature,
    String? error,
    num? planId,
    num? amount,
  }) async {
    try {
      final response = await dioClient.post("/handle/payment", data: {
        "razorpay_order_id": orderId,
        "razorpay_payment_id": paymentId,
        "razorpay_signature": signature,
        "is_success": isSuccess,
        "error": error,
        "plan_id": planId,
        "currency": "INR",
        "amount": amount
      });

      return ApiResult.success(data: response);
    } catch (e) {
      // log("***** Category ** Response **error *****-> [$e ]****************************");
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }
}
