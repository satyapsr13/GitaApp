// ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'package:flutter/foundation.dart';

// import 'dart:convert';

part of 'test_cubit.dart';

class TestState extends Equatable {
  // enum
  final Status status;

  final String imageWithRemovedBg;

  List<double> listOfUserStickerSides;
  List<String> messages;
  List<Frame> listOfTestFrames;
  Frame? currentFrame;
  //-------------------------------------------

  TestState({
    this.status = Status.initial,
    this.imageWithRemovedBg = "",
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
        messages,
        listOfUserStickerSides,
        listOfTestFrames,
      ];

  TestState copyWith({
    Status? status,
    String? imageWithRemovedBg,
    Frame? currentFrame,
    List<Frame>? listOfTestFrames,
    List<String>? messages,
  }) {
    return TestState(
      status: status ?? this.status,
      currentFrame: currentFrame ?? this.currentFrame,
      messages: messages ?? this.messages,
      imageWithRemovedBg: imageWithRemovedBg ?? this.imageWithRemovedBg,
      listOfTestFrames: listOfTestFrames ?? this.listOfTestFrames,
    );
  }

  Map<String, dynamic> toMap() {
    return {};
  }

  factory TestState.fromMap(Map<String, dynamic> map) {
    return TestState();
  }

  String toJson() => json.encode(toMap());

  factory TestState.fromJson(String source) =>
      TestState.fromMap(json.decode(source));
}
