// To parse this JSON data, do
//
//     final welcome = tagModelFromMap(jsonString);

import 'dart:convert';

List<TagsModel> tagModelFromMap(String str) =>
    List<TagsModel>.from(json.decode(str).map((x) => TagsModel.fromMap(x)));

String tagsModelToMap(List<TagsModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

class TagsModel {
  TagsModel({
    required this.id,
    required this.name,
    required this.hindi,
    required this.keyword,
    required this.active,
    // this.date,
  });

  final int id;
  final String name;
  final String hindi;
  final String keyword;
  final int active;
  // final DateTime? date;

  factory TagsModel.fromMap(Map<String, dynamic> json) {
    return TagsModel(
      id: json["id"],
      name: json["name"],
      hindi: json["hindi"],
      keyword: json["keyword"],
      active: json["active"],
      // date: json["date"] == null ? null : DateTime.parse(json["date"]),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'hindi': hindi,
      'keyword': keyword,
      'active': active,
      // 'date': date?.millisecondsSinceEpoch,
    };
  }

  String toJson() => json.encode(toMap());

  factory TagsModel.fromJson(String source) =>
      TagsModel.fromMap(json.decode(source));
}
