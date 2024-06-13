import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart'; 

import '../../../Constants/enums.dart';
import '../../../Data/model/api/frames_response.dart';
import '../../../Data/repositories/sticker_repository.dart';
import '../../../Data/repositories/tools_repository.dart';
import '../../../Data/repositories/user_repository.dart';
import '../../../Data/services/api_result.dart';
import '../../../Data/services/network_exceptions.dart';

part 'test_state.dart';

class TestCubit extends HydratedCubit<TestState> {
  // final LocaleRepository localeRepository;
  final ToolsRepository toolsRepository;
  final UserRepository userRepository;
  final StickerRepository stickerRepository;
  // final PostCubit postState;
  TestCubit({
    // required this.localeRepository,
    required this.toolsRepository,
    required this.stickerRepository,
    required this.userRepository,
    // required this.postState,
  }) : super(TestState());

  // Future<void> removeBG({required String imagePath}) async {
  //   emit(state.copyWith(status: Status.loading));
  //   Logger().i("-------------bkchodi yaha ho rhi hai-------------------------");
  //   ApiResult<dynamic> toolsResponse =
  //       await toolsRepository.removeBG(imagePath: imagePath);

  //   toolsResponse.when(success: (dynamic response) async {
  //     Dio dio = Dio();
  //     String imagePath = (response["path"] ?? "").toString();
  //     try {
  //       // Fetch image from network
  //       Response response = await dio.get(imagePath,
  //           options: Options(responseType: ResponseType.bytes));

  //       // Get the temporary directory using path_provider
  //       Directory tempDir = await getTemporaryDirectory();

  //       // Write the file to the temporary directory
  //       File file = File(
  //           '${tempDir.path}/${DateTime.now().microsecondsSinceEpoch.toString()}_rishteyy_.png');
  //       await file.writeAsBytes(response.data);
  //       imagePath = file.path;
  //     } catch (e) {
  //       print('Error downloading image: $e');
  //     }

  //     emit(state.copyWith(
  //         status: Status.success, imageWithRemovedBg: imagePath));
  //   }, failure: (NetworkExceptions error) {
  //     emit(state.copyWith(status: Status.failure));
  //   });
  // }
  Future<void> fetchFrames() async {
    // emit(state.copyWith(listOfFrames: []));
    emit(state.copyWith(status: Status.loading));
    ApiResult<FrameResponse> stickerResponse =
        await stickerRepository.fetchFrames(isTestFrame: true);

    // int ii = 0;
    stickerResponse.when(success: (FrameResponse data) async {
      if (data.data != null) {
        emit(state.copyWith(
            status: Status.success,
            listOfTestFrames: data.data,
            currentFrame: data.data?.first));
      }
    }, failure: (NetworkExceptions error) {
      emit(state.copyWith(status: Status.failure));
      Logger().d("FrameResponse error  $error");
    });
  }

  void updateStateVariable({Frame? currentFrame, List<String>? messages}) {
    List<String> tempMessages = [];
    if (messages != null) {
      tempMessages.addAll(messages);
    }
    tempMessages.addAll(state.messages);
    emit(state.copyWith(currentFrame: currentFrame, messages: tempMessages));
  }

  @override
  TestState? fromJson(Map<String, dynamic> json) {
    return TestState.fromMap(json);
  }

  @override
  Map<String, dynamic>? toJson(TestState state) {
    return state.toMap();
  }
}
