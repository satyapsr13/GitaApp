import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:logger/logger.dart';

import '../../../Constants/enums.dart';
import '../../../Data/model/api/frames_response.dart';
import '../../../Data/repositories/sticker_repository.dart';
import '../../../Data/repositories/tools_repository.dart';
import '../../../Data/repositories/user_repository.dart';
import '../../../Data/services/api_result.dart';
import '../../../Data/services/network_exceptions.dart';

part 'dpmaker_state.dart';

class DpMakerCubit extends HydratedCubit<DpMakerState> {
  // final LocaleRepository localeRepository;
  final ToolsRepository toolsRepository;
  final UserRepository userRepository;
  final StickerRepository stickerRepository;
  // final PostCubit postState;
  DpMakerCubit({
    // required this.localeRepository,
    required this.toolsRepository,
    required this.stickerRepository,
    required this.userRepository,
    // required this.postState,
  }) : super(DpMakerState());

  Future<void> fetchFrames() async {
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

  void updateStateVariable({
    double? xPos,
    double? yPos,
    double? dpProfileSize,
    double? defaultXPos,
    double? defaultYPos,
    bool? isProfileDragging,
  }) {
    emit(state.copyWith(
      xPos: xPos,
      yPos: yPos,
      dpProfileSize: dpProfileSize,
      isProfileDragging: isProfileDragging,
      defaultXPos: defaultXPos,
      defaultYPos: defaultYPos,
    ));
  }

  @override
  DpMakerState? fromJson(Map<String, dynamic> json) {
    return DpMakerState.fromMap(json);
  }

  @override
  Map<String, dynamic>? toJson(DpMakerState state) {
    return state.toMap();
  }
}
