// To parse this JSON data, do
//
//     final todayPostsResponse = todayPostsResponseFromMap(jsonString);

import 'dart:convert';

import 'post_model.dart';
import 'tags_model.dart';
 

class TodayPostsResponse {
  final PostModel? post;
  final String? tithi;
  final String? hindiDate;
  final String? day;
  final List<TagsModel>? tags;
  final List<String>? texts;

  TodayPostsResponse({
    this.post,
    this.tithi,
    this.hindiDate,
    this.day,
    this.tags,
    this.texts,
  });

  factory TodayPostsResponse.fromMap(Map<String, dynamic> json) =>
      TodayPostsResponse(
        post: json["post"] == null ? null : PostModel.fromMap(json["post"]),
        tithi: json["tithi"],
        hindiDate: json["hindi_date"],
        day: json["day"],
        tags: json["tags"] == null
            ? []
            : List<TagsModel>.from(
                json["tags"]!.map((x) => TagsModel.fromMap(x))),
        texts: json["texts"] == null
            ? []
            : List<String>.from(json["texts"]!.map((x) => x)),
      );

  Map<String, dynamic> toMap() => {
        "post": post?.toMap(),
        "tithi": tithi,
        "day": day,
        "hindi_date": hindiDate,
        "tags":
            tags == null ? [] : List<dynamic>.from(tags!.map((x) => x.toMap())),
        "texts": texts == null ? [] : List<dynamic>.from(texts!.map((x) => x)),
      };
}

// class Post {
//   final int? id;
//   final String? image;
//   final FrameOptions? frameOptions;
//   final String? text;
//   final String? language;
//   final Category? category;
//   final dynamic tags;
//   final String? occasion;
//   final int? active;
//   final DateTime? createdAt;
//   final DateTime? updatedAt;
//   final DateTime? date;
//   final int? isSpecial;

//   Post({
//     this.id,
//     this.image,
//     this.frameOptions,
//     this.text,
//     this.language,
//     this.category,
//     this.tags,
//     this.occasion,
//     this.active,
//     this.createdAt,
//     this.updatedAt,
//     this.date,
//     this.isSpecial,
//   });

//   factory Post.fromMap(Map<String, dynamic> json) => Post(
//         id: json["id"],
//         image: json["image"],
//         frameOptions: json["frameOptions"] == null
//             ? null
//             : FrameOptions.fromMap(json["frameOptions"]),
//         text: json["text"],
//         language: json["language"],
//         category: json["category"] == null
//             ? null
//             : Category.fromMap(json["category"]),
//         tags: json["tags"],
//         occasion: json["occasion"],
//         active: json["active"],
//         createdAt: json["created_at"] == null
//             ? null
//             : DateTime.parse(json["created_at"]),
//         updatedAt: json["updated_at"] == null
//             ? null
//             : DateTime.parse(json["updated_at"]),
//         date: json["date"] == null ? null : DateTime.parse(json["date"]),
//         isSpecial: json["is_special"],
//       );

//   Map<String, dynamic> toMap() => {
//         "id": id,
//         "image": image,
//         "frameOptions": frameOptions?.toMap(),
//         "text": text,
//         "language": language,
//         "category": category?.toMap(),
//         "tags": tags,
//         "occasion": occasion,
//         "active": active,
//         "created_at": createdAt?.toIso8601String(),
//         "updated_at": updatedAt?.toIso8601String(),
//         "date":
//             "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
//         "is_special": isSpecial,
//       };
// }

// class Category {
//   final int? id;
//   final String? name;
//   final String? hindi;
//   final String? active;

//   Category({
//     this.id,
//     this.name,
//     this.hindi,
//     this.active,
//   });

//   factory Category.fromMap(Map<String, dynamic> json) => Category(
//         id: json["id"],
//         name: json["name"],
//         hindi: json["hindi"],
//         active: json["active"],
//       );

//   Map<String, dynamic> toMap() => {
//         "id": id,
//         "name": name,
//         "hindi": hindi,
//         "active": active,
//       };
// }

// class FrameOptions {
//   final String? top;
//   final String? color;
//   final String? border;
//   final String? bottom;

//   FrameOptions({
//     this.top,
//     this.color,
//     this.border,
//     this.bottom,
//   });

//   factory FrameOptions.fromMap(Map<String, dynamic> json) => FrameOptions(
//         top: json["top"],
//         color: json["color"],
//         border: json["border"],
//         bottom: json["bottom"],
//       );

//   Map<String, dynamic> toMap() => {
//         "top": top,
//         "color": color,
//         "border": border,
//         "bottom": bottom,
//       };
// }

// class Tag {
//   final int? id;
//   final String? name;
//   final String? hindi;
//   final String? keyword;
//   final int? active;
//   final DateTime? date;

//   Tag({
//     this.id,
//     this.name,
//     this.hindi,
//     this.keyword,
//     this.active,
//     this.date,
//   });

//   factory Tag.fromMap(Map<String, dynamic> json) => Tag(
//         id: json["id"],
//         name: json["name"],
//         hindi: json["hindi"],
//         keyword: json["keyword"],
//         active: json["active"],
//         date: json["date"] == null ? null : DateTime.parse(json["date"]),
//       );

//   Map<String, dynamic> toMap() => {
//         "id": id,
//         "name": name,
//         "hindi": hindi,
//         "keyword": keyword,
//         "active": active,
//         "date":
//             "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
//       };
// }
