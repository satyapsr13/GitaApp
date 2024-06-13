import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:logger/logger.dart';
import 'package:overlay_support/overlay_support.dart';

import '../../../Constants/constants.dart';
import '../../../Constants/enums.dart';
import '../../../Data/model/api/frames_response.dart';
import '../../../Data/repositories/localization.dart';
part 'post_editor_state.dart';

class PostEditorCubit extends HydratedCubit<PostEditorState> {
  final LocaleRepository localeRepository;

  PostEditorCubit({
    required this.localeRepository,
  }) : super(PostEditorState());

  void updateStateVariables({
    String? userName,
    String? dateFormate,
    String? tagColor,
    String? topTagPosition,
    DatePos? datePosition,
    String? profileShape,
    Frame? currentFrame,
    String? profilePos,
    String? dateBGTagImage,
    String? networkImage,
    Offset? profileInitialPos,
    String? blankPostBgImage,
    bool? isRishteyyVisible,
    bool? isWhiteFrame,
    bool? isDateTagVisible,
    bool? isOccupationVisible,
    bool? isFrameVisible,
    bool? isNameVisible,
    bool? isInteractiveBoxActive,
    bool? isAdvanceEditorMode,
    bool? isNumberVisible,
    bool? isProfileVisible,
    bool? isShowMotionToastForProfileDrag,
    double? profileSize,
    Color? profileBoundryColor,
    Color? nameColor,
    Color? numberColor,
    Color? occupationColor,
    Color? customFrameColor,
    DateTime? editedDate,
    List<String>? listOfCustomText,
    List<TextStyle>? listOfCustomTextStyles,
    // List<String>? listOfCustomTextStyles,
  }) async {
    emit(state.copyWith(
      dateBGTagImage: dateBGTagImage ?? state.dateBGTagImage,
      listOfCustomTextStyles: listOfCustomTextStyles ?? state.listOfCustomTextStyles,
      isInteractiveBoxActive:
          isInteractiveBoxActive ?? state.isInteractiveBoxActive,
      dateFormate: dateFormate ?? state.dateFormate,
      editedDate: editedDate ?? state.editedDate,
      listOfCustomText: listOfCustomText ?? state.listOfCustomText,
      isWhiteFrame: isWhiteFrame ?? state.isWhiteFrame,
      customFrameColor: customFrameColor ?? state.customFrameColor,
      occupationColor: occupationColor ?? state.occupationColor,
      nameColor: nameColor ?? state.nameColor,
      numberColor: numberColor ?? state.numberColor,
      isOccupationVisible: isOccupationVisible ?? state.isOccupationVisible,
      isFrameVisible: isFrameVisible ?? state.isFrameVisible,
      currentFrame: currentFrame ?? state.currentFrame,
      isDateTagVisible: isDateTagVisible ?? state.isDateTagVisible,
      isRishteyyVisible: isRishteyyVisible ?? state.isRishteyyVisible,
      datePosition: datePosition ?? state.datePosition,
      profileInitialPos: profileInitialPos ?? state.profileInitialPos,
      isShowMotionToastForProfileDrag: isShowMotionToastForProfileDrag ??
          state.isShowMotionToastForProfileDrag,
      isAdvanceEditorMode: isAdvanceEditorMode ?? state.isAdvanceEditorMode,
      blankPostBgImage: blankPostBgImage ?? state.blankPostBgImage,
      profileSize: profileSize ?? state.profileSize,
      isNameVisible: isNameVisible ?? state.isNameVisible,
      isNumberVisible: isNumberVisible ?? state.isNumberVisible,
      profileBoundryColor: profileBoundryColor ?? state.profileBoundryColor,
      isProfileVisible: isProfileVisible ?? state.isProfileVisible,
      userName: userName ?? state.userName,
      tagColor: tagColor ?? state.tagColor,
      topTagPosition: topTagPosition ?? state.rishteyyTagPosition,
      profileShape: profileShape ?? state.profileShape,
      profilePos: profilePos ?? state.profilePos,
      networkImage: networkImage ?? state.networkImage,
    ));
  }

  customTextStylesOperations({
    required int index,
    bool isAddOperation = false,
    bool isDeleteOperation = false,
    bool isEditOperation = false,
    String? text,
    double? size,
    Color? color,
  }) {
    emit(state.copyWith(status: Status.loading));
    List<TextStyle> temp = [];
    List<String> textList = [];
    temp.addAll(state.listOfCustomTextStyles);
    textList.addAll(state.listOfCustomText);
    if (isAddOperation) {
      toast("Text Added");
      temp.add(TextStyle(
        color: temp.length % 2 == 0 ? Colors.white : Colors.amber,
        fontSize: 30,
      ));
      textList.add("Your text");
    } else if (isEditOperation) {
      if (text != null) {
        textList[index] = text;
      }
      try {
        Logger().i("Clicked $color");

        TextStyle tempStyle = TextStyle();
        tempStyle.copyWith(color: color, fontSize: size);
        temp.removeAt(index);
        temp.insert(index, tempStyle);
        Logger().i("Clicked 1 $color ${temp[index].backgroundColor}");
      } catch (e) {
        Logger().i(e);
      }
    } else if (isDeleteOperation) {
      temp.removeAt(index);
      textList.removeAt(index);
    } else {
      temp[index].copyWith(fontSize: size);
    }
    emit(state.copyWith(
        listOfCustomTextStyles: temp, listOfCustomText: textList));
  }

  void stickerOperation({
    int? index,
    String? stickerId,
    String? imageLink,
    double? side,
    bool isAddSticker = false,
    bool isRemoveSticker = false,
    bool isUpdateStickerSize = false,
  }) {
    // emit(state.copyWith( status: Status.success));
    // Logger().e("function call nhi ho rha hai 1");
    if (isUpdateStickerSize && side != null && index != null) {
      // Logger().e("function call nhi ho rha hai 2");
      try {
        // state.stickerDListSides[index] = side;
        // emit(state.copyWith(
        //   stickerDListSides: state.stickerDListSides,
        //   temp: DateTime.now().toString(),
        // ));
      } catch (e) {}

      return;
    }
    if (isAddSticker && imageLink != null) {
      // List<StickerD> temp = [];
      // temp.addAll(state.stickerDList);
      // Logger().e(imageLink);
      // temp.add(StickerD(
      //     id: DateTime.now().toString(),
      //     imageLink: imageLink,
      //     sideLength: 100));
      // List<double> tt = [];
      // tt.addAll(state.stickerDListSides);
      // tt.add(100);
      // emit(state.copyWith(stickerDList: temp, stickerDListSides: tt));
      // Logger().e(state.stickerDList.length);
      return;
    }
    if (isRemoveSticker && stickerId != null && index != null) {
      // List<StickerD> temp = [];
      // temp.addAll(state.stickerDList);
      // temp.removeAt(index);
      // List<double> tt = [];
      // tt.addAll(state.stickerDListSides);
      // tt.removeAt(index);

      // emit(state.copyWith(stickerDList: temp, stickerDListSides: tt));
      return;
    }
  }

  void updateEmojiPosition(double left, double top) async {
    emit(state.copyWith(emojiLeftPos: left, emojiTopPos: top));
  }

  void setRandomDateBGImage() async {
    emit(state.copyWith(
        dateBGTagImage:
            "assets/images/banners/${Random().nextInt(6) + 1}.png"));
  }

  void changeEditorFields({Gradient? gradient}) async {
    if (gradient != null) {
      emit(state.copyWith(postGradient: gradient));
    }
  }

  @override
  PostEditorState? fromJson(Map<String, dynamic> json) {
    return PostEditorState.fromMap(json);
  }

  @override
  Map<String, dynamic>? toJson(PostEditorState state) {
    return state.toMap();
  }
}
