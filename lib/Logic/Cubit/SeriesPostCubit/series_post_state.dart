// ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'dart:convert';

// import 'package:equatable/equatable.dart';

part of "series_post_cubit.dart";

class SeriesPostState extends Equatable {
  final Status status;
  final Status panditDataStatus;
  final Status imageSearchStatus;
  final String error;
  final String chapter;
  final int totalSloke;
  final PanditData? panditData;
  final List<GitaSloke> gitaSlokeList;
  final List<Miniapps> listOfMiniapps;
  final List<ImageSearch> listOfSearchImage;
  final List<String> listOfImgSearchKeys;

  SeriesPostState({
    this.status = Status.initial,
    this.panditDataStatus = Status.initial,
    this.imageSearchStatus = Status.initial,
    this.error = "",
    this.chapter = "",
    this.totalSloke = 0,
    this.panditData,
    this.gitaSlokeList = const [],
    this.listOfMiniapps = const [],
    this.listOfImgSearchKeys = const [],
    this.listOfSearchImage = const [],
  });

  @override
  List<Object?> get props => [
        status,
        panditDataStatus,
        imageSearchStatus,
        listOfSearchImage,
        listOfImgSearchKeys,
        error,
        chapter,
        totalSloke,
        gitaSlokeList,
        panditData,
        listOfMiniapps,
      ];

  SeriesPostState copyWith({
    Status? status,
    Status? panditDataStatus,
    Status? imageSearchStatus,
    String? error,
    PanditData? panditData,
    String? chapter,
    int? totalSloke,
    List<GitaSloke>? gitaSlokeList,
    List<Miniapps>? listOfMiniapps,
    List<ImageSearch>? listOfSearchImage,
    List<String>? listOfImgSearchKeys,
  }) {
    return SeriesPostState(
      status: status ?? this.status,
      panditDataStatus: panditDataStatus ?? this.panditDataStatus,
      imageSearchStatus: imageSearchStatus ?? this.imageSearchStatus,
      panditData: panditData ?? this.panditData,
      error: error ?? this.error,
      chapter: chapter ?? this.chapter,
      totalSloke: totalSloke ?? this.totalSloke,
      gitaSlokeList: gitaSlokeList ?? this.gitaSlokeList,
      listOfMiniapps: listOfMiniapps ?? this.listOfMiniapps,
      listOfSearchImage: listOfSearchImage ?? this.listOfSearchImage,
      listOfImgSearchKeys: listOfImgSearchKeys ?? this.listOfImgSearchKeys,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'error': error,
      'chapter': chapter,
      'totalSloke': totalSloke,
      'listOfImgSearchKeys': listOfImgSearchKeys,
      'listOfMiniapps': listOfMiniapps.map((e) => e.toMap()).toList(),
      'listOfSearchImage': listOfSearchImage.map((e) => e.toMap()).toList(),
    };
  }

  factory SeriesPostState.fromMap(Map<String, dynamic> map) {
    List<dynamic> t1 = map['listOfMiniapps'] ?? [];
    List<dynamic> t2 = map['listOfSearchImage'] ?? [];
    List<Miniapps> miniappList = t1.map((e) => Miniapps.fromMap(e)).toList();
    List<ImageSearch> searchImg =
        t2.map((e) => ImageSearch.fromMap(e)).toList();

    return SeriesPostState(
      error: map['error'],
      chapter: map['chapter'],
      listOfMiniapps: miniappList,
      listOfSearchImage: searchImg,
      listOfImgSearchKeys: map['listOfImgSearchKeys'] != null
          ? List<String>.from(map['listOfImgSearchKeys'])
          : [],
    );
  }

  String toJson() => json.encode(toMap());

  factory SeriesPostState.fromJson(String source) =>
      SeriesPostState.fromMap(json.decode(source));
}
