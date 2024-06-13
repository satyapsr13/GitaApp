// ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'package:flutter/foundation.dart';

// import 'dart:convert';

part of 'tools_cubit.dart';

class ToolsState extends Equatable {
  // enum
  final Status status;

  final String imageWithRemovedBg;

  List<double> listOfUserStickerSides;
  //-------------------------------------------

  ToolsState({
    this.status = Status.initial,
    this.imageWithRemovedBg = "",
    this.listOfUserStickerSides = const [],
  });

  @override
  List<Object?> get props => [
        status,
        imageWithRemovedBg,
        listOfUserStickerSides,
      ];

  ToolsState copyWith({
    Status? status,
    String? imageWithRemovedBg,
  }) {
    return ToolsState(
      status: status ?? this.status,
      imageWithRemovedBg: imageWithRemovedBg ?? this.imageWithRemovedBg,
    );
  }

  Map<String, dynamic> toMap() {
    return {};
  }

  factory ToolsState.fromMap(Map<String, dynamic> map) {
    return ToolsState();
  }

  String toJson() => json.encode(toMap());

  factory ToolsState.fromJson(String source) =>
      ToolsState.fromMap(json.decode(source));
}
