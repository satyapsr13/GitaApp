// ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'package:flutter/foundation.dart';

// import 'dart:convert';

part of 'video_cubit.dart';

class VideoState extends Equatable {
  // enum
  final Status status;
  final Status audioPlayStatus;

  final String imageWithRemovedBg;
  final AudioPlayer? player;

  List<double> listOfUserStickerSides;
  List<AudioFile> listOfAudiofiles;
  List<String> messages;
  List<Frame> listOfTestFrames;
  Frame? currentFrame;
  int currentlyPlayingSongId;
  //-------------------------------------------

  VideoState({
    this.status = Status.initial,
    this.audioPlayStatus = Status.initial,
    this.imageWithRemovedBg = "",
    this.currentlyPlayingSongId = -1,
    this.currentFrame,
    this.player,
    this.listOfUserStickerSides = const [],
    this.listOfAudiofiles = const [],
    this.messages = const [],
    this.listOfTestFrames = const [],
  });

  @override
  List<Object?> get props => [
        status,
        audioPlayStatus,
        imageWithRemovedBg,
        currentlyPlayingSongId,
        currentFrame,
        messages,
        player,
        listOfUserStickerSides,
        listOfAudiofiles,
        listOfTestFrames,
      ];

  VideoState copyWith({
    Status? status,
    Status? audioPlayStatus,
    String? imageWithRemovedBg,
    Frame? currentFrame,
    AudioPlayer? player,
    int? currentlyPlayingSongId,
    List<Frame>? listOfTestFrames,
    List<AudioFile>? listOfAudiofiles,
    List<String>? messages,
  }) {
    return VideoState(
      status: status ?? this.status,
      currentlyPlayingSongId: currentlyPlayingSongId ?? this.currentlyPlayingSongId,
      audioPlayStatus: audioPlayStatus ?? this.audioPlayStatus,
      player: player ?? this.player,
      listOfAudiofiles: listOfAudiofiles ?? this.listOfAudiofiles,
      currentFrame: currentFrame ?? this.currentFrame,
      messages: messages ?? this.messages,
      imageWithRemovedBg: imageWithRemovedBg ?? this.imageWithRemovedBg,
      listOfTestFrames: listOfTestFrames ?? this.listOfTestFrames,
    );
  }

  Map<String, dynamic> toMap() {
    return {};
  }

  factory VideoState.fromMap(Map<String, dynamic> map) {
    return VideoState();
  }

  String toJson() => json.encode(toMap());

  factory VideoState.fromJson(String source) =>
      VideoState.fromMap(json.decode(source));
}
