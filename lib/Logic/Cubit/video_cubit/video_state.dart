part of 'video_cubit.dart';

class VideoState extends Equatable {
  final Status videoDownloadStatus;
  final Status status;
  // final int coins;
  final String userName;
  final String userNumber;
  final String editedName;
  final String fileImagePath;
  //-----------------
  List<String> videoUrls;
  final Map<int, BetterPlayerController> controllers;

  int lastInitializedIndex;
  int focusIndex;
  // VideoPlayerController? videoPlayerController;
  int reloadCounter;
  bool isPlaying;
  bool isInitializing;
  bool isLoading;
  // enum

  VideoState({
    this.videoDownloadStatus = Status.initial,
    this.status = Status.initial,
    // this.coins = 0,
    // this.videoPlayerController,
    this.controllers = const {},
    this.videoUrls = const [],
    this.isPlaying = false,
    this.isInitializing = false,
    this.isLoading = false,
    this.lastInitializedIndex = -1,
    this.focusIndex = 0,
    this.reloadCounter = 0,
    // isPlaying = false,
    // isInitializing = false,
    // isLoading = false,
    this.userName = "",
    this.userNumber = "",
    this.editedName = "",
    this.fileImagePath = "",
  });

  @override
  List<Object?> get props => [
        videoDownloadStatus,
        status,
        // videoPlayerController,
        userName,
        userNumber,
        editedName,
        fileImagePath,
        videoUrls,
        controllers,
        lastInitializedIndex,
        focusIndex,
        reloadCounter,
        isPlaying,
        isInitializing,
        isLoading
      ];

  VideoState copyWith({
    Status? videoDownloadStatus,
    Status? status,
    String? userName,
    String? userNumber,
    // VideoPlayerController? videoPlayerController,
    String? editedName,
    String? fileImagePath,
    List<String>? videoUrls,
    Map<int, BetterPlayerController>? controllers,
    int? lastInitializedIndex,
    int? focusIndex,
    int? reloadCounter,
    bool? isPlaying,
    bool? isInitializing,
    bool? isLoading,
  }) {
    return VideoState(
      isPlaying: isPlaying ?? this.isPlaying,
      isInitializing: isInitializing ?? this.isInitializing,
      isLoading: isLoading ?? this.isLoading,
      

      controllers: controllers ?? this.controllers,
      // videoPlayerController:
          // // videoPlayerController ?? this.videoPlayerController,
      reloadCounter: reloadCounter ?? this.reloadCounter,
      lastInitializedIndex: lastInitializedIndex ?? this.lastInitializedIndex,
      focusIndex: focusIndex ?? this.focusIndex,
      // playingIndex: focusedIndex ?? this.playingIndex,
      videoUrls: videoUrls ?? this.videoUrls,
      videoDownloadStatus: videoDownloadStatus ?? this.videoDownloadStatus,
      status: status ?? this.status,

      userName: userName ?? this.userName,
      userNumber: userNumber ?? this.userNumber,
      editedName: editedName ?? this.editedName,
      fileImagePath: fileImagePath ?? this.fileImagePath,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      // 'videoDownloadStatus': videoDownloadStatus.index,
      // 'status': status.index,
      // 'status': status.index,
      // 'postModeList': postModeList,

      // "editedName": editedName,
    };
  }

  factory VideoState.fromMap(Map<String, dynamic> map) {
    return VideoState();
  }

  String toJson() => json.encode(toMap());

  factory VideoState.fromJson(String source) =>
      VideoState.fromMap(json.decode(source));
}
