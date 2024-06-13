import 'package:dio/dio.dart';

import '../services/api_result.dart';
import '../services/dio_client.dart';
import '../services/network_exceptions.dart';

class ToolsRepository {
  late DioClient dioClient;

  ToolsRepository() {
    dioClient = DioClient();
  }

  Future<ApiResult<dynamic>> removeBG({required String imagePath}) async {
    try {
      FormData formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(
          imagePath,
        ),
      });
      final response = await dioClient.post("",
          customUri: "https://tools.rishteyy.in/generate-png", data: formData);

      return ApiResult.success(data: response);
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }
}
