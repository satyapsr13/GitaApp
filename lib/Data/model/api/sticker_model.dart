// ignore_for_file: public_member_api_docs, sort_constructors_first
// To parse this JSON data, do
//
//     final welcome = welcomeFromMap(jsonString);

import 'dart:convert';

import 'package:meta/meta.dart';

List<StickerResponse> stickerResponseFromMap(String str) =>
    List<StickerResponse>.from(
        json.decode(str).map((x) => StickerResponse.fromMap(x)));

String stickerResponseToMap(List<StickerResponse> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

class StickerResponse {
  final int id;
  final String name;
  final String hindi;
  final String keyword;
  final int active;
  final List<Sticker> stickers;

  StickerResponse({
    required this.id,
    required this.name,
    required this.hindi,
    required this.keyword,
    required this.active,
    required this.stickers,
  });

  factory StickerResponse.fromMap(Map<String, dynamic> json) => StickerResponse(
        id: json["id"] ?? 1,
        name: json["name"] ?? "",
        hindi: json["hindi"] ?? "",
        keyword: json["keyword"] ?? "",
        active: json["active"] ?? 1,
        stickers: json["stickers"] == null
            ? []
            : List<Sticker>.from(
                json["stickers"].map((x) => Sticker.fromMap(x))),
      );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'hindi': hindi,
      'keyword': keyword,
      'active': active,
      'stickers': stickers.map((x) => x.toMap()).toList(),
    };
  }

  String toJson() => json.encode(toMap());

  factory StickerResponse.fromJson(String source) =>
      StickerResponse.fromMap(json.decode(source));

  @override
  String toString() {
    return 'StickerResponse(id: $id, name: $name, hindi: $hindi, keyword: $keyword, active: $active, stickers: $stickers)';
  }
}

class Sticker {
  final int id;
  final String path;
  final String language;
  final int categoryId;
  final int active;
  final int isPremium;

  Sticker({
    required this.id,
    required this.path,
    required this.language,
    required this.categoryId,
    required this.active,
    required this.isPremium,
  });

  factory Sticker.fromMap(Map<String, dynamic> json) => Sticker(
        id: json["id"] ?? 1,
        path: json["path"] ?? "",
        language: json["language"] ?? "",
        categoryId: json["category_id"] ?? 1,
        active: json["active"] ?? 1,
        isPremium: json["is_premium"] ?? 0,
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "path": path,
        "language": language,
        "category_id": categoryId,
        "active": active,
        "is_premium": isPremium,
      };

  @override
  String toString() {
    return 'Sticker(id: $id, path: $path, language: $language, categoryId: $categoryId, active: $active, isPremium: $isPremium)';
  }
}
