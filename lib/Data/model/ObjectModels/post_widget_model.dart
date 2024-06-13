 

import '../../../Presentation/Screens/PostsScreens/PostFrames/post_frames.dart';

class PostWidgetModel {
  int? index;
  String imageLink;
  String tagColor;
  String postId;
  String playStoreBadgePos;
  String profileShape;
  String profilePos;
  bool? showProfile;
  bool? showName;
  FrameDetails? frameDetails;
  PostWidgetModel({
    this.index,
    required this.imageLink,
    required this.tagColor,
    required this.postId,
    required this.playStoreBadgePos,
    required this.profileShape,
    this.profilePos = "right",
    this.showProfile,
    this.showName,
    this.frameDetails,
  });

  PostWidgetModel copyWith({
    int? index,
    String? imageLink,
    String? tagColor,
    String? postId,
    String? topTagPosition,
    String? profileShape,
    String? profilePos,
    bool? showProfile,
    bool? showName,
    FrameDetails? frameDetails,
  }) {
    return PostWidgetModel(
      index: index ?? this.index,
      frameDetails: frameDetails ?? this.frameDetails,
      imageLink: imageLink ?? this.imageLink,
      tagColor: tagColor ?? this.tagColor,
      postId: postId ?? this.postId,
      playStoreBadgePos: topTagPosition ?? playStoreBadgePos,
      profileShape: profileShape ?? this.profileShape,
      profilePos: 1 == 1 ? "right" : profilePos ?? this.profilePos,
      showProfile: showProfile ?? this.showProfile,
      showName: showName ?? this.showName,
    );
  }
}
