// ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'dart:convert';

// class PostResponseData {
//   PostResponseData({
//     this.currentPage,
//     this.data,
//     this.firstPageUrl,
//     this.from,
//     this.lastPage,
//     this.lastPageUrl,
//     this.links,
//     this.nextPageUrl,
//     this.path,
//     this.perPage,
//     this.prevPageUrl,
//     this.to,
//     this.total,
//   });

//   final int? currentPage;
//   final List<PostModel>? data;
//   final String? firstPageUrl;
//   final int? from;
//   final int? lastPage;
//   final String? lastPageUrl;
//   final List<Link?>? links;
//   final String? nextPageUrl;
//   final String? path;
//   final int? perPage;
//   final dynamic prevPageUrl;
//   final int? to;
//   final int? total;

//   Map<String, dynamic> toMap() {
//     return {
//       'currentPage': currentPage,
//       'data': data?.map((x) => x.toMap()).toList(),
//       'firstPageUrl': firstPageUrl,
//       'from': from,
//       'lastPage': lastPage,
//       'lastPageUrl': lastPageUrl,
//       'links': links?.map((x) => x?.toMap()).toList(),
//       'nextPageUrl': nextPageUrl,
//       'path': path,
//       'perPage': perPage,
//       'prevPageUrl': prevPageUrl,
//       'to': to,
//       'total': total,
//     };
//   }

//   factory PostResponseData.fromMap(Map<String, dynamic> map) {
//     return PostResponseData(
//       currentPage: map['currentPage']?.toInt(),
//       data: map['data'] != null ? List<PostModel>.from(map['data']?.map((x) => PostModel.fromMap(x))) : null,
//       firstPageUrl: map['firstPageUrl'],
//       from: map['from']?.toInt(),
//       lastPage: map['lastPage']?.toInt(),
//       lastPageUrl: map['lastPageUrl'],
//       links: map['links'] != null ? List<Link?>.from(map['links']?.map((x) => Link?.fromMap(x))) : null,
//       nextPageUrl: map['nextPageUrl'],
//       path: map['path'],
//       perPage: map['perPage']?.toInt(),
//       prevPageUrl: map['prevPageUrl'] ?? null,
//       to: map['to']?.toInt(),
//       total: map['total']?.toInt(),
//     );
//   }

//   String toJson() => json.encode(toMap());

//   factory PostResponseData.fromJson(String source) => PostResponseData.fromMap(json.decode(source));
//   }

// class PostModel {
//   PostModel({
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
//   });

//   final int? id;
//   final String? image;
//   final FrameOptions? frameOptions;
//   final String? text;
//   final String? language;
//   final Category? category;
//   final List<String>? tags;
//   final String? occasion;
//   final int? active;
//   final DateTime? createdAt;
//   final DateTime? updatedAt;

//   Map<String, dynamic> toMap() {
//     return {
//       'id': id,
//       'image': image,
//       'frameOptions': frameOptions?.toMap(),
//       'text': text,
//       'language': language,
//       'category': category?.toMap(),
//       'tags': tags,
//       'occasion': occasion,
//       'active': active,
//       'createdAt': createdAt?.millisecondsSinceEpoch,
//       'updatedAt': updatedAt?.millisecondsSinceEpoch,
//     };
//   }

//   factory PostModel.fromMap(Map<String, dynamic> map) {
//     return PostModel(
//       id: map['id']?.toInt(),
//       image: map['image'],
//       frameOptions: map['frameOptions'] != null ? FrameOptions.fromMap(map['frameOptions']) : null,
//       text: map['text'],
//       language: map['language'],
//       category: map['category'] != null ? Category.fromMap(map['category']) : null,
//       tags: List<String>.from(map['tags']),
//       occasion: map['occasion'],
//       active: map['active']?.toInt(),
//       createdAt: map['createdAt'] != null ? DateTime.fromMillisecondsSinceEpoch(map['createdAt']) : null,
//       updatedAt: map['updatedAt'] != null ? DateTime.fromMillisecondsSinceEpoch(map['updatedAt']) : null,
//     );
//   }

//   String toJson() => json.encode(toMap());

//   factory PostModel.fromJson(String source) => PostModel.fromMap(json.decode(source));
// }

// class Category {
//   Category({
//     this.id,
//     this.name,
//     this.hindi,
//     this.active,
//   });

//   final int? id;
//   final String? name;
//   final String? hindi;
//   final String? active;

//   Map<String, dynamic> toMap() {
//     return {
//       'id': id,
//       'name': name,
//       'hindi': hindi,
//       'active': active,
//     };
//   }

//   factory Category.fromMap(Map<String, dynamic> map) {
//     return Category(
//       id: map['id']?.toInt(),
//       name: map['name'],
//       hindi: map['hindi'],
//       active: map['active'],
//     );
//   }

//   String toJson() => json.encode(toMap());

//   factory Category.fromJson(String source) => Category.fromMap(json.decode(source));
// }

// class FrameOptions {
//   FrameOptions({
//     this.color,
//     this.top,
//     this.bottom,
//     this.border,
//   });

//   final String? color;
//   final String? top;
//   final String? bottom;
//   final String? border;

//   Map<String, dynamic> toMap() {
//     return {
//       'color': color,
//       'top': top,
//       'bottom': bottom,
//       'border': border,
//     };
//   }

//   factory FrameOptions.fromMap(Map<String, dynamic> map) {
//     return FrameOptions(
//       color: map['color'],
//       top: map['top'],
//       bottom: map['bottom'],
//       border: map['border'],
//     );
//   }

//   String toJson() => json.encode(toMap());

//   factory FrameOptions.fromJson(String source) => FrameOptions.fromMap(json.decode(source));
// }

// class Link {
//   Link({
//     this.url,
//     this.label,
//     this.active,
//   });

//   final String? url;
//   final String? label;
//   final bool? active;

//   Map<String, dynamic> toMap() {
//     return {
//       'url': url,
//       'label': label,
//       'active': active,
//     };
//   }

//   factory Link.fromMap(Map<String, dynamic> map) {
//     return Link(
//       url: map['url'],
//       label: map['label'],
//       active: map['active'],
//     );
//   }

//   String toJson() => json.encode(toMap());

//   factory Link.fromJson(String source) => Link.fromMap(json.decode(source));
// }

// To parse this JSON data, do
//
//     final welcome = welcomeFromMap(jsonString);

import 'dart:convert';
import 'dart:developer';

import 'package:logger/logger.dart';

// PostResponseData? welcomeFromMap(String str) => PostResponseData.fromMap(json.decode(str));

// String welcomeToMap(PostResponseData? data) => json.encode(data!.toMap());

class PostResponseData {
  PostResponseData({
    this.currentPage,
    this.data,
    this.firstPageUrl,
    this.from,
    this.lastPage,
    this.lastPageUrl,
    this.nextPageUrl,
    this.path,
    this.perPage,
    this.prevPageUrl,
    this.to,
    this.total,
  });

  final int? currentPage;
  final List<PostModel?>? data;
  final String? firstPageUrl;
  final int? from;
  final int? lastPage;
  final String? lastPageUrl;
  final String? nextPageUrl;
  final String? path;
  final int? perPage;
  final dynamic prevPageUrl;
  final int? to;
  final int? total;

  factory PostResponseData.fromMap(Map<String, dynamic> json) =>
      PostResponseData(
        currentPage: json["current_page"],
        data: json["data"] == null
            ? []
            : json["data"] == null
                ? []
                : List<PostModel?>.from(
                    json["data"]!.map((x) => PostModel.fromMap(x))),
        firstPageUrl: json["first_page_url"],
        from: json["from"],
        lastPage: json["last_page"],
        lastPageUrl: json["last_page_url"],
        nextPageUrl: json["next_page_url"],
        path: json["path"],
        perPage: json["per_page"],
        prevPageUrl: json["prev_page_url"],
        to: json["to"],
        total: json["total"],
      );

  Map<String, dynamic> toMap() => {
        "current_page": currentPage,
        "data": data == null
            ? []
            : data == null
                ? []
                : List<dynamic>.from(data!.map((x) => x!.toMap())),
        "first_page_url": firstPageUrl,
        "from": from,
        "last_page": lastPage,
        "last_page_url": lastPageUrl,
        "next_page_url": nextPageUrl,
        "path": path,
        "per_page": perPage,
        "prev_page_url": prevPageUrl,
        "to": to,
        "total": total,
      };
}

class PostModel {
  PostModel({
    this.id,
    this.image,
    this.frameOptions,
    this.text,
    this.language,
    this.category,
    this.tags,
    this.occasion,
    this.active,
    this.createdAt,
    this.updatedAt,
  });

  final int? id;
  final String? image;
  final FrameOptions? frameOptions;
  final String? text;
  final String? language;
  final Category? category;
  final List<String>? tags;
  final String? occasion;
  final int? active;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory PostModel.fromMap(Map<String, dynamic> json) {
    // Logger().i("fetchNextPagePosts 3  ${json["frameOptions"].runtimeType}");
    return PostModel(
      id: json["id"],
      image: json["image"],
      // frameOptions: FrameOptions.fromMap({}),
      frameOptions: FrameOptions.fromMap(json["frameOptions"]  ),
      text: json["text"],
      language: json["language"],
      // category: Category.fromMap({}),
      category: Category.fromMap(json["category"]),
      tags: json["tags"] ?? [],
      occasion: json["occasion"],
      active: json["active"],
    );
  }

  Map<String, dynamic> toMap() => {
        "id": id,
        "image": image,
        "frameOptions": frameOptions,
        "text": text,
        "language": language,
        "category": category,
        "tags": tags,
        "occasion": occasion,
        "active": active,
        // "created_at": createdAt,
        // "updated_at": updatedAt,
      };

  @override
  String toString() {
    return 'PostModel(id: $id, image: $image, frameOptions: $frameOptions, text: $text, language: $language, category: $category, tags: $tags, occasion: $occasion, active: $active, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

class Category {
  Category({
    this.id,
    this.name,
    this.hindi,
    this.active,
  });

  final int? id;
  final String? name;
  final String? hindi;
  final String? active;

  factory Category.fromMap(Map<String, dynamic> json) => Category(
        id: json["id"],
        name: json["name"],
        hindi: json["hindi"],
        active: json["active"],
      );

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'hindi': hindi,
      'active': active,
    };
  }

  String toJson() => json.encode(toMap());

  factory Category.fromJson(String source) =>
      Category.fromMap(json.decode(source) as Map<String, dynamic>);

  Category copyWith({
    int? id,
    String? name,
    String? hindi,
    String? active,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      hindi: hindi ?? this.hindi,
      active: active ?? this.active,
    );
  }

  @override
  String toString() {
    return 'Category(id: $id, name: $name, hindi: $hindi, active: $active)';
  }
}

class FrameOptions {
  FrameOptions({
    required this.top,
    required this.color,
    required this.border,
    required this.bottom,
  });

  final String top;
  final String color;
  final String border;
  final String bottom;

  factory FrameOptions.fromMap(Map<String, dynamic> json) => FrameOptions(
        top: json["top"],
        color: json["color"],
        border: json["border"],
        bottom: json["bottom"],
      );

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'top': top,
      'color': color,
      'border': border,
      'bottom': bottom,
    };
  }

  String toJson() => json.encode(toMap());

  factory FrameOptions.fromJson(String source) =>
      FrameOptions.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'FrameOptions(top: $top, color: $color, border: $border, bottom: $bottom)';
  }

  FrameOptions copyWith({
    String? top,
    String? color,
    String? border,
    String? bottom,
  }) {
    return FrameOptions(
      top: top ?? this.top,
      color: color ?? this.color,
      border: border ?? this.border,
      bottom: bottom ?? this.bottom,
    );
  }
}
