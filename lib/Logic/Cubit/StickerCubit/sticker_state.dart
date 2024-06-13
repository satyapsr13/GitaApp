// ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'package:flutter/foundation.dart';

// import 'dart:convert';

part of 'sticker_cubit.dart';

class StickerState extends Equatable {
  // enum
  final Status status;
  final Status dpFramesStatus;
  final Status removeBgStatus;
  final EditorWidgets editorWidget;
  final double secondStickerSize;
  final String temp;
  final String errorMessage;
  final String imageWithRemovedBg;
  final double firstStickerSize;
  final String firstSticker;
  final Color blankPostBorderColor;
  final Color dateBorderColor;
  final Color blankPostTextColor;
  final Color dateColor;
  final String blankPostEditorText;
  final String dateStickerText;
  final int blankPostTextFontIndex;
  final int fontIndex;
  final double blankPostTextFontSize;
  final double dateFontSize;
  final String secondSticker;
  final bool lockEditor;
  final bool isDateTabOpen;
  final bool isFirstStickerVisible;
  final bool isSecondStickerVisible;
  final bool isDateStickerVisible;
  List<String> tagListFromBackend;
  final List<BgImagesCategory> bgImagesCategories;
  final List<StickerResponse> stickerTopicList;
  List<StickerFromNetwork> stickerDList;
  List<double> stickerDListSides;
  List<Frame> listOfFrames;
  List<DpFrames> listOfDpFrames;
  List<Frame> listOfActiveFrames;
  List<num> listOfActiveFramesIds; 
  List<StickerFromAssets> listOfUserStickers;
  List<StickerFromAssets> listOfActiveUserStickers;
  List<double> listOfUserStickerSides; 

  StickerState({
    this.status = Status.initial,
    this.dpFramesStatus = Status.initial,
    this.removeBgStatus = Status.initial,
    this.editorWidget = EditorWidgets.none,
    this.secondStickerSize = 100,
    this.temp = "",
    this.errorMessage = "",
    this.imageWithRemovedBg = "",
    this.firstStickerSize = 100,
    this.firstSticker = "",
    this.blankPostTextFontIndex = 4,
    this.fontIndex = 4,
    this.tagListFromBackend = const [],
    this.listOfDpFrames = const [],
    this.listOfActiveUserStickers = const [],
    this.listOfUserStickers = const [],
    this.listOfUserStickerSides = const [],
    this.listOfFrames = const [],
    this.listOfActiveFrames = const [],
    this.listOfActiveFramesIds = const [],
    this.blankPostTextFontSize = 25,
    this.dateFontSize = 25, 
    this.blankPostTextColor = Colors.black,
    this.dateColor = Colors.black,
    this.blankPostBorderColor = Colors.white,
    this.dateBorderColor = Colors.white,
    this.blankPostEditorText = "",
    this.dateStickerText = "",
    this.secondSticker = "",
    this.bgImagesCategories = const [],
    this.stickerTopicList = const [],
    this.stickerDList = const [],
    this.stickerDListSides = const [],
    this.lockEditor = false,
    this.isDateTabOpen = false,
    this.isFirstStickerVisible = false,
    this.isSecondStickerVisible = false,
    this.isDateStickerVisible = false,
  });

  @override
  List<Object?> get props => [
        status,
        dpFramesStatus,
        removeBgStatus,
        editorWidget,
        lockEditor,
        listOfActiveUserStickers,
        listOfDpFrames,
        blankPostTextFontIndex,
        listOfActiveFrames,
        listOfActiveFramesIds,
        fontIndex,
        listOfFrames,
        tagListFromBackend,
        blankPostTextFontSize,
        dateFontSize,
        secondStickerSize,
        temp,
        errorMessage,
        imageWithRemovedBg,
        firstStickerSize,
        firstSticker,
        blankPostBorderColor,
        dateBorderColor,
        blankPostTextColor,
        dateColor,
        blankPostEditorText,
        dateStickerText,
        secondSticker,
        bgImagesCategories,
        stickerTopicList,
        stickerDList,
        stickerDListSides,
        isDateTabOpen,
        isFirstStickerVisible,
        isSecondStickerVisible,
        isDateStickerVisible,
        listOfUserStickerSides,
        listOfUserStickers,
      ];

  StickerState copyWith({
    Status? status,
    Status? dpFramesStatus,
    Status? removeBgStatus,
    EditorWidgets? editorWidget,
    double? secondStickerSize,
    String? temp,
    String? errorMessage,
    String? imageWithRemovedBg,
    double? firstStickerSize,
    String? firstSticker,
    int? blankPostTextFontIndex,
    int? fontIndex,
    double? blankPostTextFontSize,
    double? dateFontSize,
    Color? blankPostBorderColor,
    Color? dateBorderColor,
    Color? blankPostTextColor,
    Color? dateColor,
    List<String>? tagListFromBackend,
    List<Frame>? listOfFrames,
    List<DpFrames>? listOfDpFrames,
    List<Frame>? listOfActiveFrames,
    List<num>? listOfActiveFramesIds,
    String? blankPostEditorText,
    String? dateStickerText,
    String? secondSticker,
    List<BgImagesCategory>? bgImagesCategories,
    List<StickerResponse>? stickerTopicList,
    List<StickerFromNetwork>? stickerDList,
    List<double>? listOfUserStickerSides,
    List<StickerFromAssets>? listOfUserStickers,
    List<StickerFromAssets>? listOfActiveUserStickers,
    // List<StickerD>? stickerDList,
    List<double>? stickerDListSides,
    bool? isDateTabOpen,
    bool? isFirstStickerVisible,
    bool? isSecondStickerVisible,
    bool? isDateStickerVisible,
    bool? hideCancelButton,
  }) {
    return StickerState(
      status: status ?? this.status,
      dpFramesStatus: dpFramesStatus ?? this.dpFramesStatus,
      removeBgStatus: removeBgStatus ?? this.removeBgStatus,
      listOfUserStickers: listOfUserStickers ?? this.listOfUserStickers,
      listOfActiveFrames: listOfActiveFrames ?? this.listOfActiveFrames,
      listOfActiveUserStickers:
          listOfActiveUserStickers ?? this.listOfActiveUserStickers,
      listOfUserStickerSides:
          listOfUserStickerSides ?? this.listOfUserStickerSides,
      listOfDpFrames: listOfDpFrames ?? this.listOfDpFrames,
      listOfActiveFramesIds:
          listOfActiveFramesIds ?? this.listOfActiveFramesIds,
      listOfFrames: listOfFrames ?? this.listOfFrames,
      editorWidget: editorWidget ?? this.editorWidget,
      tagListFromBackend: tagListFromBackend ?? this.tagListFromBackend,
      blankPostTextFontIndex:
          blankPostTextFontIndex ?? this.blankPostTextFontIndex,
      fontIndex: fontIndex ?? this.fontIndex,
      blankPostTextFontSize:
          blankPostTextFontSize ?? this.blankPostTextFontSize,
      dateFontSize: dateFontSize ?? this.dateFontSize,
      lockEditor: hideCancelButton ?? this.lockEditor,
      secondStickerSize: secondStickerSize ?? this.secondStickerSize,
      temp: temp ?? this.temp,
      errorMessage: errorMessage ?? this.errorMessage,
      imageWithRemovedBg: imageWithRemovedBg ?? this.imageWithRemovedBg,
      firstStickerSize: firstStickerSize ?? this.firstStickerSize,
      firstSticker: firstSticker ?? this.firstSticker,
      blankPostBorderColor: blankPostBorderColor ?? this.blankPostBorderColor,
      dateBorderColor: dateBorderColor ?? this.dateBorderColor,
      blankPostTextColor: blankPostTextColor ?? this.blankPostTextColor,
      dateColor: dateColor ?? this.dateColor,
      blankPostEditorText: blankPostEditorText ?? this.blankPostEditorText,
      dateStickerText: dateStickerText ?? this.dateStickerText,
      secondSticker: secondSticker ?? this.secondSticker,
      bgImagesCategories: bgImagesCategories ?? this.bgImagesCategories,
      stickerTopicList: stickerTopicList ?? this.stickerTopicList,
      stickerDList: stickerDList ?? this.stickerDList,
      stickerDListSides: stickerDListSides ?? this.stickerDListSides,
      isSecondStickerVisible:
          isSecondStickerVisible ?? this.isSecondStickerVisible,
      isDateStickerVisible: isDateStickerVisible ?? this.isDateStickerVisible,
      isDateTabOpen: isDateTabOpen ?? this.isDateTabOpen,
      isFirstStickerVisible:
          isFirstStickerVisible ?? this.isFirstStickerVisible,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'blankPostTextFontSize': blankPostTextFontSize,
      'blankPostTextFontIndex': blankPostTextFontIndex,
      'fontIndex': fontIndex,
      'blankPostBorderColor': blankPostBorderColor.value,
      'dateBorderColor': dateBorderColor.value,
      'blankPostTextColor': blankPostTextColor.value,
      'dateColor': dateColor.value,
      'dateFontSize': dateFontSize,
      'dateStickerText': dateStickerText,
      'bgImagesCategories': bgImagesCategories.map((e) => e.toMap()).toList(),
      'listOfDpFrames': listOfDpFrames.map((e) => e.toMap()).toList(),
      'listOfUserStickers': listOfUserStickers.map((e) => e.toMap()).toList(),
      'stickerTopicList': stickerTopicList.map((e) => e.toMap()).toList(),
      'listOfFrames': listOfFrames.map((e) => e.toMap()).toList(),
      'listOfActiveFramesIds': listOfActiveFramesIds,
    };
  }

  factory StickerState.fromMap(Map<String, dynamic> map) {
    List<dynamic> t1 = map['bgImagesCategories'] ?? [];
    List<dynamic> t2 = map['stickerTopicList'] ?? [];
    List<dynamic> t3 = map['listOfFrames'] ?? [];
    List<dynamic> t5 = map['listOfActiveFrames'] ?? [];
    List<dynamic> t4 = map['listOfActiveFramesIds'] ?? [];
    List<dynamic> t6 = map['listOfUserStickers'] ?? [];
    List<dynamic> t7 = map['listOfDpFrames'] ?? [];
    List<BgImagesCategory> bgImagesCategories =
        t1.map((e) => BgImagesCategory.fromMap(e)).toList();
//--------------------------for stickers----------------------------------

    List<StickerResponse> stickerList =
        t2.map((e) => StickerResponse.fromMap(e)).toList();
    List<DpFrames> dpFrameList = t7.map((e) => DpFrames.fromMap(e)).toList();
    List<Frame> frameList = t3.map((e) => Frame.fromMap(e)).toList();
    List<Frame> activeFrameList = t5.map((e) => Frame.fromMap(e)).toList();
    List<StickerFromAssets> userStickers =
        t6.map((e) => StickerFromAssets.fromMap(e)).toList();
    List<num> activeFrameListId = t4.cast<num>().toList();
    return StickerState(
      bgImagesCategories: bgImagesCategories,
      stickerTopicList: stickerList,
      listOfFrames: frameList,
      listOfActiveFrames: activeFrameList,
      listOfUserStickers: userStickers,
      listOfActiveFramesIds: activeFrameListId,
      listOfDpFrames: dpFrameList,
      blankPostTextFontSize: map["blankPostTextFontSize"],
      fontIndex: map["fontIndex"],
      blankPostTextColor: Color(map["blankPostTextColor"] as int),
      dateColor: Color(map["dateColor"] as int),
      dateFontSize: map["dateFontSize"],
      dateStickerText: map["dateStickerText"],
      blankPostBorderColor: Color(map["blankPostBorderColor"] as int),
      dateBorderColor: Color(map["dateBorderColor"] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory StickerState.fromJson(String source) =>
      StickerState.fromMap(json.decode(source));
}

class StickerFromNetwork {
  String id;
  String imageLink;
  double sideLength;
  StickerFromNetwork({
    required this.id,
    required this.imageLink,
    required this.sideLength,
  });

  @override
  String toString() =>
      'StickerD(id: $id, imageLink: $imageLink, sideLength: $sideLength)';

  @override
  bool operator ==(covariant StickerFromNetwork other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.imageLink == imageLink &&
        other.sideLength == sideLength;
  }

  @override
  int get hashCode => id.hashCode ^ imageLink.hashCode ^ sideLength.hashCode;

  StickerFromNetwork copyWith({
    String? id,
    String? imageLink,
    double? sideLength,
  }) {
    return StickerFromNetwork(
      id: id ?? this.id,
      imageLink: imageLink ?? this.imageLink,
      sideLength: sideLength ?? this.sideLength,
    );
  }
}

class StickerFromAssets {
  String id;
  String imageLink;
  double sideLength;
  bool isPremium;
  StickerFromAssets({
    required this.id,
    required this.imageLink,
    required this.sideLength,
    this.isPremium = false,
  });

  StickerFromAssets copyWith({
    String? id,
    String? imageLink,
    double? sideLength,
    bool? isPremium,
  }) {
    return StickerFromAssets(
      id: id ?? this.id,
      imageLink: imageLink ?? this.imageLink,
      sideLength: sideLength ?? this.sideLength,
      isPremium: isPremium ?? this.isPremium,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'imageLink': imageLink,
      'sideLength': sideLength,
      'isPremium': isPremium,
    };
  }

  factory StickerFromAssets.fromMap(Map<String, dynamic> map) {
    return StickerFromAssets(
      id: map['id'] as String,
      imageLink: map['imageLink'] as String,
      sideLength: map['sideLength'] as double,
      isPremium: map['isPremium'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory StickerFromAssets.fromJson(String source) =>
      StickerFromAssets.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'StickerFromAssets(id: $id, imageLink: $imageLink, sideLength: $sideLength, isPremium: $isPremium)';
  }
}
