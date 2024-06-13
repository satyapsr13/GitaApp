import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';

import '../../../Constants/enums.dart';
import '../../../Data/model/api/bg_images.response.dart';
import '../../../Data/model/api/dpframes_response.dart';
import '../../../Data/model/api/frames_response.dart';
import '../../../Data/model/api/sticker_model.dart';
import '../../../Data/repositories/localization.dart';
import '../../../Data/repositories/sticker_repository.dart';
import '../../../Data/services/api_result.dart';
import '../../../Data/services/network_exceptions.dart';

part 'sticker_state.dart';

class StickerCubit extends HydratedCubit<StickerState> {
  final LocaleRepository localeRepository;
  final StickerRepository stickerRepository;

  StickerCubit({
    required this.localeRepository,
    required this.stickerRepository,
  }) : super(StickerState());

  Future<void> fetchStickers() async {
    emit(state.copyWith(status: Status.loading));
    ApiResult<List<StickerResponse>> stickerResponse =
        await stickerRepository.fetchStickers();

    stickerResponse.when(
        success: (List<StickerResponse> stickerResponseData) async {
      if (stickerResponseData.isNotEmpty) {
        emit(state.copyWith(
            status: Status.success, stickerTopicList: stickerResponseData));
      }
    }, failure: (NetworkExceptions error) {
      emit(state.copyWith(
        status: Status.failure,
      ));
    });
  }

  Future<void> fetchDpFrames(
      {String? keyword, bool isTestFrame = false}) async {
    emit(state.copyWith(dpFramesStatus: Status.loading));
    Logger().i("Logger");
    ApiResult<DpFramesResponse> stickerResponse = await stickerRepository
        .fetchDpFrames(keyword: keyword, isTestFrame: isTestFrame);

    stickerResponse.when(success: (DpFramesResponse data) async {
      // if (data.isNotEmpty) {

      emit(state.copyWith(
          dpFramesStatus: Status.success,
          listOfDpFrames: (data.data?.isEmpty ?? true) ? null : data.data));
      // }
    }, failure: (NetworkExceptions error) {
      emit(state.copyWith(
        dpFramesStatus: Status.failure,
      ));
    });
  }

  Future<void> fetchBackgroundImages() async {
    // emit(state.copyWith(status: Status.loading));
    ApiResult<List<BgImagesCategory>> stickerResponse =
        await stickerRepository.fetchBackgroundImages();

    stickerResponse.when(
        success: (List<BgImagesCategory> data) async {
          // Logger().i(jsonEncode(data));
          if (data.isNotEmpty) {
            emit(state.copyWith(bgImagesCategories: data));
          }
        },
        failure: (NetworkExceptions error) {});
  }

  Future<void> userStickerOperations(
      {required String imageUrl,
      bool isDelete = false,
      bool isOperationForAddingInEditor = false,
      bool isIncreaseStickerSize = false,
      int index = 0,
      String? userId,
      double side = 100}) async {
    if (isOperationForAddingInEditor == true) {
      if (isIncreaseStickerSize == true) {
        List<double> temp = [];
        temp.addAll(state.listOfUserStickerSides);
        temp[index] = side;
        emit(state.copyWith(listOfUserStickerSides: temp));

        return;
      }
      if (isDelete) {
        // final result = state.listOfUserStickers.removeWhere((e) {
        //   return e.imageLink == imageUrl;
        // });
        List<StickerFromAssets> data = [];
        List<double> data1 = [];
        data1.addAll(state.listOfUserStickerSides);
        data.addAll(state.listOfActiveUserStickers);
        int i = 0;
        for (var e in state.listOfActiveUserStickers) {
          if (e.imageLink == imageUrl) {
            // data.add(e);
            break;
          }
          i++;
        }
        data1.removeAt(i);
        data.removeAt(i);

        emit(state.copyWith(
            listOfActiveUserStickers: data, listOfUserStickerSides: data1));
        return;
      }
      emit(state.copyWith(listOfActiveUserStickers: [
        ...state.listOfActiveUserStickers,
        StickerFromAssets(id: "", imageLink: imageUrl, sideLength: 100),
      ], listOfUserStickerSides: [
        ...state.listOfUserStickerSides,
        100 + ((DateTime.now().second % 6) * 5),
      ]));
    } else {
      if (isDelete) {
        // final result = state.listOfUserStickers.removeWhere((e) {
        //   return e.imageLink == imageUrl;
        // });
        List<StickerFromAssets> data = [];
        for (var e in state.listOfUserStickers) {
          if (e.imageLink != imageUrl) {
            data.add(e);
          }
        }

        emit(state.copyWith(listOfUserStickers: data));
        return;
      }
      emit(state.copyWith(listOfUserStickers: [
        StickerFromAssets(id: "", imageLink: imageUrl, sideLength: 100),
        ...state.listOfUserStickers,
      ]));
      try {
        removeBG(
            imagePath: imageUrl, reason: "For User Sticker", userId: userId);
      } catch (e) {}
    }
  }

  Future<void> removeBG(
      {required String imagePath, String? userId, String? reason}) async {
    emit(state.copyWith(
        imageWithRemovedBg: imagePath, removeBgStatus: Status.loading));
    // Logger().i("-------------bkchodi yaha ho rhi hai-------------------------");
    ApiResult<dynamic> toolsResponse = await stickerRepository.removeBG(
        imagePath: imagePath, userId: userId, reason: reason);

    toolsResponse.when(success: (dynamic response) async {
      Dio dio = Dio();
      String imagePath = (response["path"] ?? "").toString();
      try {
        Logger().i("bkchodi 1 $imagePath");
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

        // Logger().i("bkchodi 2 $imagePath");
        // emit(state.copyWith(imageWithRemovedBg: ima?gePath));
        // emit(state.copyWith(imageWithRemovedBg: imagePath));
        if (imagePath.isNotEmpty) {
          // Logger().i("bkchodi 6 ");
          emit(state.copyWith(
            listOfUserStickers: [
              StickerFromAssets(
                  id: "",
                  imageLink: imagePath,
                  sideLength: 100,
                  isPremium: true),
              ...state.listOfUserStickers,
            ],
            removeBgStatus: Status.success,
          ));
          emit(state.copyWith(
              removeBgStatus: Status.initial, imageWithRemovedBg: ""));
        }
        // return imagePath;
      } catch (e) {
        // Logger().i("bkchodi 3 $e");
        emit(state.copyWith(
            imageWithRemovedBg: "", removeBgStatus: Status.failure));
        emit(state.copyWith(
            removeBgStatus: Status.initial, imageWithRemovedBg: ""));
        // print('Error downloading image: $e');
      }
    }, failure: (NetworkExceptions error) {
      Logger().i("bkchodi 4 $error");
      emit(state.copyWith(
          imageWithRemovedBg: "", removeBgStatus: Status.failure));
      emit(state.copyWith(
          removeBgStatus: Status.initial, imageWithRemovedBg: ""));
    });
  }

  Future<void> fetchFrames() async {
    // emit(state.copyWith(listOfFrames: []));
    ApiResult<FrameResponse> stickerResponse =
        await stickerRepository.fetchFrames();

    // int ii = 0;
    stickerResponse.when(success: (FrameResponse data) async {
      if (data.data != null) {
        if (data.data!.isEmpty) {
          return;
        }
        // Logger().d("FrameResponse   ${data.data}");
        // Logger().d("FrameResponse 00  ${ii++}");
        List<Frame> temp = [];
        List<num> temp1 = [];
        int i = 0;
        if (state.listOfActiveFramesIds.isEmpty) {
          // Logger().d("FrameResponse  11 ${ii++}");
          for (final e in data.data!) {
            if (i < 4) {
              temp.add(e.copyWith(isActive: state.listOfFrames.isEmpty));
              if (e.id != null && state.listOfFrames.isEmpty) {
                // Logger().d("FrameResponse 22  ${ii++}");
                temp1.add(e.id!);
              }
            } else {
              temp.add(e.copyWith(isActive: false));
            }
            i++;
          }
          emit(state.copyWith(
            listOfFrames: temp,
            listOfActiveFramesIds: temp1,
          ));
        } else {
          for (final e in data.data!) {
            if (state.listOfActiveFramesIds.contains(e.id)) {
              temp.add(e.copyWith(isActive: true));
            } else {
              temp.add(e.copyWith(isActive: false));
            }
          }
          emit(state.copyWith(
            listOfFrames: temp,
          ));
        }

        syncActiveFrameById();
      }
    }, failure: (NetworkExceptions error) {
      Logger().d("FrameResponse error  $error");
    });
  }

  syncActiveFrameById() {
    List<Frame> temp = [];

    for (final e in state.listOfFrames) {
      if (state.listOfActiveFramesIds.contains(e.id)) {
        temp.add(e);
      }
    }

    emit(state.copyWith(listOfActiveFrames: temp));
    Logger().i(jsonEncode(state.listOfActiveFramesIds));
    Logger().i(jsonEncode(state.listOfActiveFrames));
  }

  Future<void> addDatesAndTagsForTextEditor(List<String> editorText,
      {String? hindiDate}) async {
    // emit(state.copyWith(status: Status.loading));
    final DateTime currentDate = DateTime.now();

    List<String> dateFormate = [
      DateFormat('d-MMMM', 'hi').format(currentDate),
      DateFormat('d-MMMM').format(currentDate),
      DateFormat('EEEE, MMMM d, y', 'hi').format(currentDate),
      DateFormat('d-M-y').format(currentDate),
      "ॐ",
      "जय श्री कृष्णा",
      "राधे राधे",
      "जय श्री राम",
      "सुप्रभात",
      "राम राम",
      "धन्यवाद",
      "नमस्ते",
      "जय हो",
      "सत्यमेव जयते",
      "हर हर महादेव",
      "ओम नमः शिवाय",
      "जय महाकाल",
      "जय माता दी",
      "शुभ संध्या",
      "शुभ रात्रि",
      "आपका दिन शुभ हो",
      "जय बजरंग बली",
      "ॐ नमो नारायणाय",
      "हरि ओम तत् सत्"
    ];
    emit(state.copyWith(
        status: Status.success, tagListFromBackend: dateFormate));
  }

  void updateFirstSticker(
    String link,
  ) async {
    // log("------updateEmojiPosition $left-----------");
    emit(state.copyWith(firstSticker: link));
  }

  void frameActiveInactiveOperations(
      // bool isDateTabOpen,
      {
    required num frameId,
    bool isActiveOperation = false,
    bool isInActiveOperation = false,
  }) async {
    // emit(state.copyWith(listOfActiveFrames: [], listOfFrames: []));
    if (isActiveOperation) {
      List<Frame> temp = [];
      List<num> temp1 = [];
      temp1.addAll(state.listOfActiveFramesIds);
      for (final e in state.listOfFrames) {
        if (e.id == frameId) {
          temp.add(e.copyWith(isActive: true));
          // temp1.add(frameId);
          temp1.insert(0, frameId);
        } else {
          temp.add(e);
        }
      }

      emit(state.copyWith(listOfFrames: temp, listOfActiveFramesIds: temp1));
      syncActiveFrameById();

      return;
    }
    if (isInActiveOperation) {
      List<Frame> temp = [];
      List<num> temp1 = [];
      temp1.addAll(state.listOfActiveFramesIds);
      for (final e in state.listOfFrames) {
        if (e.id == frameId) {
          temp.add(e.copyWith(isActive: false));
        } else {
          temp.add(e);
        }
      }
      temp1.remove(frameId);

      emit(state.copyWith(listOfActiveFramesIds: temp1, listOfFrames: temp));
      syncActiveFrameById();
      return;
    }
  }

  void updateStickerSize({
    double? firstStickerSize,
    double? secondStickerSize,
  }) async {
    // log("------updateEmojiPosition $left-----------");
    if (firstStickerSize != null) {
      emit(state.copyWith(firstStickerSize: firstStickerSize));
    }
    if (secondStickerSize != null) {
      emit(state.copyWith(secondStickerSize: secondStickerSize));
    }
  }

  // int t = 0;

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
        state.stickerDListSides[index] = side;
        emit(state.copyWith(
          stickerDListSides: state.stickerDListSides,
          temp: DateTime.now().toString(),
        ));
      } catch (e) {}

      return;
    }
    if (isAddSticker && imageLink != null) {
      List<StickerFromNetwork> temp = [];
      temp.addAll(state.stickerDList);
      Logger().e(imageLink);
      temp.add(StickerFromNetwork(
          id: DateTime.now().toString(),
          imageLink: imageLink,
          sideLength: 100));
      List<double> tt = [];
      tt.addAll(state.stickerDListSides);
      tt.add(100);
      emit(state.copyWith(stickerDList: temp, stickerDListSides: tt));
      // Logger().e(state.stickerDList.length);
      return;
    }
    if (isRemoveSticker && stickerId != null && index != null) {
      List<StickerFromNetwork> temp = [];
      temp.addAll(state.stickerDList);
      temp.removeAt(index);
      List<double> tt = [];
      tt.addAll(state.stickerDListSides);
      tt.removeAt(index);

      emit(state.copyWith(stickerDList: temp, stickerDListSides: tt));
      return;
    }
  }

  void updateSecondSticker(String link) async {
    // log("------updateEmojiPosition $left-----------");

    emit(state.copyWith(secondSticker: link));
  }

  void updateStateVariables({
    String? blankPostEditorText,
    String? dateStickerText,
    EditorWidgets? editorWidgets,
    double? blankPostTextFontSize,
    double? fontSize,
    Color? fontColor,
    Color? blankPostTextColor,
    Color? dateBorderColor,
    Color? blankPostBorderColor,
    bool? isDateVisible,
    int? fontIndex,
    int? blankPostTextFontIndex,
    bool? hideCancelButton,
  }) async {
    emit(state.copyWith(
      blankPostTextColor: blankPostTextColor ?? state.blankPostTextColor,
      editorWidget: editorWidgets ?? state.editorWidget,
      blankPostTextFontIndex:
          blankPostTextFontIndex ?? state.blankPostTextFontIndex,
      blankPostBorderColor: blankPostBorderColor ?? state.blankPostBorderColor,
      dateStickerText: dateStickerText ?? state.dateStickerText,
      hideCancelButton: hideCancelButton ?? state.lockEditor,
      blankPostEditorText: blankPostEditorText ?? state.blankPostEditorText,
      blankPostTextFontSize:
          blankPostTextFontSize ?? state.blankPostTextFontSize,
      fontIndex: fontIndex ?? state.fontIndex,
      dateFontSize: fontSize ?? state.dateFontSize,
      dateColor: fontColor ?? state.dateColor,
      dateBorderColor: dateBorderColor ?? state.dateBorderColor,
      isDateStickerVisible: isDateVisible ?? state.isDateStickerVisible,
    ));
  }

  void hideCancelButton(bool hideCancelButton) async {
    emit(state.copyWith(hideCancelButton: hideCancelButton));
  }

  void updateStickerVisibility({
    bool? isFirstStickerVisible,
    bool? isSecondStickerVisible,
    bool? isThirdStickerVisible,
    bool? isFourthStickerVisible,
  }) async {
    // log("------updateEmojiPosition $left-----------");

    if (isFirstStickerVisible != null) {
      if (isFirstStickerVisible == false) {
        emit(state.copyWith(firstStickerSize: 100));
      }

      emit(state.copyWith(isFirstStickerVisible: isFirstStickerVisible));
    }
    if (isSecondStickerVisible != null) {
      if (isSecondStickerVisible == false) {
        emit(state.copyWith(secondStickerSize: 100));
      }
      emit(state.copyWith(isSecondStickerVisible: isSecondStickerVisible));
    }
  }

  @override
  StickerState? fromJson(Map<String, dynamic> json) {
    return StickerState.fromMap(json);
  }

  @override
  Map<String, dynamic>? toJson(StickerState state) {
    return state.toMap();
  }
}
