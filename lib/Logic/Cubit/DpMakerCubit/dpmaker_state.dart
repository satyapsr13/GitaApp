// ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'package:flutter/foundation.dart';

// import 'dart:convert';

part of 'dpmaker_cubit.dart';

class DpMakerState extends Equatable {
  // enum
  final Status status;

  final String imageWithRemovedBg;
  final double dpProfileSize;
  final double xPos;
  final double defaultXPos;
  final double yPos;
  final double defaultYPos;
  final bool isProfileDragging;

  List<double> listOfUserStickerSides;
  List<String> messages;
  List<Frame> listOfTestFrames;
  Frame? currentFrame;
  //-------------------------------------------

  DpMakerState({
    this.status = Status.initial,
    this.imageWithRemovedBg = "",
    this.dpProfileSize = 0,
    this.xPos = 0,
    this.defaultXPos = 0,
    this.yPos = 0,
    this.defaultYPos = 0,
    this.isProfileDragging = false,
    this.currentFrame,
    this.listOfUserStickerSides = const [],
    this.messages = const [],
    this.listOfTestFrames = const [],
  });

  @override
  List<Object?> get props => [
        status,
        imageWithRemovedBg,
        currentFrame,
        dpProfileSize,
        xPos,
        defaultXPos,
        yPos,
        defaultYPos,
        isProfileDragging,
        messages,
        listOfUserStickerSides,
        listOfTestFrames,
      ];

  DpMakerState copyWith({
    Status? status,
    String? imageWithRemovedBg,
    double? dpProfileSize,
    double? xPos,
    double? defaultXPos,
    double? yPos,
    double? defaultYPos,
    bool? isProfileDragging,
    Frame? currentFrame,
    List<Frame>? listOfTestFrames,
    List<String>? messages,
  }) {
    return DpMakerState(
      status: status ?? this.status,
      dpProfileSize: dpProfileSize ?? this.dpProfileSize,
      xPos: xPos ?? this.xPos,
      defaultXPos: defaultXPos ?? this.defaultXPos,
      yPos: yPos ?? this.yPos,
      defaultYPos: defaultYPos ?? this.defaultYPos,
      isProfileDragging: isProfileDragging ?? this.isProfileDragging,
      currentFrame: currentFrame ?? this.currentFrame,
      messages: messages ?? this.messages,
      imageWithRemovedBg: imageWithRemovedBg ?? this.imageWithRemovedBg,
      listOfTestFrames: listOfTestFrames ?? this.listOfTestFrames,
    );
  }

  Map<String, dynamic> toMap() {
    return {};
  }

  factory DpMakerState.fromMap(Map<String, dynamic> map) {
    return DpMakerState();
  }

  String toJson() => json.encode(toMap());

  factory DpMakerState.fromJson(String source) =>
      DpMakerState.fromMap(json.decode(source));
}
