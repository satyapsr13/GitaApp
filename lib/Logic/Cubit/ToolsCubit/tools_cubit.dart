import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';

import '../../../Constants/enums.dart';
import '../../../Data/repositories/tools_repository.dart';
import '../../../Data/services/api_result.dart';
import '../../../Data/services/network_exceptions.dart'; 

part 'tools_state.dart';

class ToolsCubit extends HydratedCubit<ToolsState> {
  // final LocaleRepository localeRepository;
  final ToolsRepository toolsRepository;
  // final PostCubit postState;
  ToolsCubit({
    // required this.localeRepository,
    required this.toolsRepository,
    // required this.postState,
  }) : super(ToolsState());

  Future<void> removeBG({required String imagePath}) async {
    emit(state.copyWith(status: Status.loading));
    Logger().i("-------------bkchodi yaha ho rhi hai-------------------------");
    ApiResult<dynamic> toolsResponse =
        await toolsRepository.removeBG(imagePath: imagePath);

    toolsResponse.when(success: (dynamic response) async {
      Dio dio = Dio();
      String imagePath = (response["path"] ?? "").toString();
      try {
        // Fetch image from network
        Response response = await dio.get(imagePath,
            options: Options(responseType: ResponseType.bytes));

        // Get the temporary directory using path_provider
        Directory tempDir = await getTemporaryDirectory();

        // Write the file to the temporary directory
        File file = File(
            '${tempDir.path}/${DateTime.now().microsecondsSinceEpoch.toString()}_rishteyy_.png');
        await file.writeAsBytes(response.data);
        imagePath = file.path;
      } catch (e) {
        print('Error downloading image: $e');
      }

      emit(state.copyWith(
          status: Status.success, imageWithRemovedBg: imagePath));
    }, failure: (NetworkExceptions error) {
      emit(state.copyWith(status: Status.failure));
    });
  }

  @override
  ToolsState? fromJson(Map<String, dynamic> json) {
    return ToolsState.fromMap(json);
  }

  @override
  Map<String, dynamic>? toJson(ToolsState state) {
    return state.toMap();
  }
}
