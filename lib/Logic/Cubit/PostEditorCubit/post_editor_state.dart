part of 'post_editor_cubit.dart';

class PostEditorState {
  // enum
  final Status status;
  final DatePos datePosition;
  final Gradient postGradient;
  final String userName;
  final String dateBGTagImage;
  final String blankPostBgImage;
  final String tagColor;
  final String rishteyyTagPosition;
  final String profileShape;
  final String profilePos;
  final String dateFormate;
  final String networkImage;
  final bool isRishteyyVisible;
  final bool isDateTagVisible;
  final bool isShowMotionToastForProfileDrag;
  final bool isNumberVisible;
  final bool isNameVisible;
  final bool isProfileVisible;
  final bool isFrameVisible;
  final bool isOccupationVisible;
  final bool isEmojiVisible;
  final Offset profileInitialPos;
  final bool isAdvanceEditorMode;
  final bool isWhiteFrame;
  final bool isInteractiveBoxActive;
  final DateTime? editedDate;
  final double profileSize;
  final double emojiLeftPos;
  final double emojiTopPos;
  final Color profileBoundryColor;
  final Color nameColor;
  final Color numberColor;
  final Color occupationColor;
  final Color customFrameColor;
  List<String> listOfCustomText;
  final Frame? currentFrame;
  List<TextStyle> listOfCustomTextStyles;

  PostEditorState({
    this.status = Status.initial,
    this.datePosition = DatePos.topLeft,
    this.profileSize = 70,
    this.emojiLeftPos = 50,
    this.emojiTopPos = 50,
    this.profileInitialPos = const Offset(150, 200),
    this.isRishteyyVisible = true,
    this.isDateTagVisible = true,
    this.isShowMotionToastForProfileDrag = true,
    this.profileBoundryColor = Colors.transparent,
    this.isNumberVisible = true,
    this.isNameVisible = true,
    this.isEmojiVisible = false,
    this.isInteractiveBoxActive = false,
    this.isAdvanceEditorMode = false,
    this.listOfCustomText = const [],
    this.listOfCustomTextStyles = const [],
    this.isWhiteFrame = false,
    // this.isThirdStickerVisible = false,
    // this.isFourthStickerVisible = false,
    this.isProfileVisible = true,
    this.isFrameVisible = true,
    this.editedDate,
    this.isOccupationVisible = true,
    this.postGradient = Gradients.blueGradient,
    this.userName = "",
    this.dateFormate = "E,d MMM",
    this.dateBGTagImage = "assets/images/banners/1.png",
    this.blankPostBgImage = "",
    this.tagColor = "",
    this.rishteyyTagPosition = "",
    this.profileShape = "",
    this.profilePos = "",
    this.networkImage = "",
    this.currentFrame,
    this.nameColor = Colors.black,
    this.numberColor = Colors.black,
    this.occupationColor = Colors.black,
    this.customFrameColor = Colors.white,
  });

  @override
  List<Object?> get props => [
        status,
        nameColor,
        editedDate,
        listOfCustomText,
        listOfCustomTextStyles,
        numberColor,
        occupationColor,
        customFrameColor,
        datePosition,
        isInteractiveBoxActive,
        currentFrame,
        emojiTopPos,
        profileSize,
        emojiLeftPos,
        profileBoundryColor,
        profileInitialPos,
        isEmojiVisible,
        isAdvanceEditorMode,
        isWhiteFrame,
        // isThirdStickerVisible,
        // isFourthStickerVisible,
        postGradient,
        dateFormate,
        userName,
        dateBGTagImage,
        networkImage,
        blankPostBgImage,
        tagColor,
        rishteyyTagPosition,
        profileShape,
        profilePos,
        isRishteyyVisible,
        isDateTagVisible,
        isShowMotionToastForProfileDrag,
        isNumberVisible,
        isNameVisible,
        isProfileVisible,
        isFrameVisible,
        isOccupationVisible,
      ];

  PostEditorState copyWith(
      {double? emojiTopPos,
      double? profileSize,
      Frame? currentFrame,
      double? emojiLeftPos,
      Status? status,
      DatePos? datePosition,
      Offset? profileInitialPos,
      Gradient? postGradient,
      String? userName,
      String? dateFormate,
      String? dateBGTagImage,
      String? blankPostBgImage,
      String? tagColor,
      Color? profileBoundryColor,
      String? topTagPosition,
      String? profileShape,
      String? profilePos,
      String? networkImage,
      bool? isRishteyyVisible,
      bool? isDateTagVisible,
      bool? isShowMotionToastForProfileDrag,
      bool? isEmojiVisible,
      bool? isInteractiveBoxActive,
      bool? isAdvanceEditorMode,
      bool? isWhiteFrame,
      bool? isNumberVisible,
      bool? isNameVisible,
      bool? isProfileVisible,
      bool? isFrameVisible,
      bool? isOccupationVisible,
      Color? nameColor,
      Color? numberColor,
      Color? occupationColor,
      Color? customFrameColor,
      DateTime? editedDate,
      List<String>? listOfCustomText,
      List<TextStyle>? listOfCustomTextStyles

      // bool? isThirdStickerVisible,
      // bool? isFourthStickerVisible,
      }) {
    return PostEditorState(
      emojiTopPos: emojiTopPos ?? this.emojiTopPos,
      isInteractiveBoxActive:
          isInteractiveBoxActive ?? this.isInteractiveBoxActive,
      editedDate: editedDate ?? this.editedDate,
      dateFormate: dateFormate ?? this.dateFormate,
      listOfCustomText: listOfCustomText ?? this.listOfCustomText,
      nameColor: nameColor ?? this.nameColor,

      numberColor: numberColor ?? this.numberColor,
      occupationColor: occupationColor ?? this.occupationColor,

      customFrameColor: customFrameColor ?? this.customFrameColor,
      currentFrame: currentFrame ?? this.currentFrame,
      profileInitialPos: profileInitialPos ?? this.profileInitialPos,
      // emojiTopPos: emojiTopPos ?? this.emojiLeftPos,
      profileBoundryColor: profileBoundryColor ?? this.profileBoundryColor,
      // isThirdStickerVisible:
      //     isThirdStickerVisible ?? this.isThirdStickerVisible,
      // isFourthStickerVisible:
      //     isFourthStickerVisible ?? this.isFourthStickerVisible,
      profileSize: profileSize ?? this.profileSize,
      emojiLeftPos: emojiLeftPos ?? this.emojiTopPos,
      // emojiLeftPos: emojiLeftPos ?? this.emojiTopPos,
      status: status ?? this.status,

      datePosition: datePosition ?? this.datePosition,
      isEmojiVisible: isEmojiVisible ?? this.isEmojiVisible,

      isAdvanceEditorMode: isAdvanceEditorMode ?? this.isAdvanceEditorMode,

      isWhiteFrame: isWhiteFrame ?? this.isWhiteFrame,
      isProfileVisible: isProfileVisible ?? this.isProfileVisible,

      isFrameVisible: isFrameVisible ?? this.isFrameVisible,

      isOccupationVisible: isOccupationVisible ?? this.isOccupationVisible,
      isNumberVisible: isNumberVisible ?? this.isNumberVisible,
      isNameVisible: isNameVisible ?? this.isNameVisible,

      isRishteyyVisible: isRishteyyVisible ?? this.isRishteyyVisible,

      isDateTagVisible: isDateTagVisible ?? this.isDateTagVisible,

      isShowMotionToastForProfileDrag: isShowMotionToastForProfileDrag ??
          this.isShowMotionToastForProfileDrag,
      postGradient: postGradient ?? this.postGradient,
      userName: userName ?? this.userName,

      dateBGTagImage: dateBGTagImage ?? this.dateBGTagImage,

      blankPostBgImage: blankPostBgImage ?? this.blankPostBgImage,
      tagColor: tagColor ?? this.tagColor,
      rishteyyTagPosition: topTagPosition ?? rishteyyTagPosition,
      profileShape: profileShape ?? this.profileShape,
      profilePos: profilePos ?? this.profilePos,
      networkImage: networkImage ?? this.networkImage,
      listOfCustomTextStyles:
          listOfCustomTextStyles ?? this.listOfCustomTextStyles,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'isShowMotionToastForProfileDrag': isShowMotionToastForProfileDrag,
      'isNumberVisible': isNumberVisible,
      'isNameVisible': isNameVisible,
      'isOccupationVisible': isOccupationVisible,
    };
  }

  factory PostEditorState.fromMap(Map<String, dynamic> map) {
    return PostEditorState(
      isShowMotionToastForProfileDrag: map["isShowMotionToastForProfileDrag"],
      isNumberVisible: map["isNumberVisible"],
      isNameVisible: map["isNameVisible"],
      // dateFormate: map["dateFormate"],
      isOccupationVisible: map["isOccupationVisible"],
    );
  }

  String toJson() => json.encode(toMap());

  factory PostEditorState.fromJson(String source) =>
      PostEditorState.fromMap(json.decode(source));
}
