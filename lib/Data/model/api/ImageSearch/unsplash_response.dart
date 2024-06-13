import 'dart:convert';

class UnsplashImgResponse {
  final int? total;
  final int? totalPages;
  final List<UnsplashResult>? results;

  UnsplashImgResponse({
    this.total,
    this.totalPages,
    this.results,
  });

  UnsplashImgResponse copyWith({
    int? total,
    int? totalPages,
    List<UnsplashResult>? results,
  }) =>
      UnsplashImgResponse(
        total: total ?? this.total,
        totalPages: totalPages ?? this.totalPages,
        results: results ?? this.results,
      );

  factory UnsplashImgResponse.fromJson(String str) =>
      UnsplashImgResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory UnsplashImgResponse.fromMap(Map<String, dynamic> json) =>
      UnsplashImgResponse(
        total: json["total"],
        totalPages: json["total_pages"],
        results: json["results"] == null
            ? []
            : List<UnsplashResult>.from(
                json["results"]!.map((x) => UnsplashResult.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "total": total,
        "total_pages": totalPages,
        "results": results == null
            ? []
            : List<dynamic>.from(results!.map((x) => x.toMap())),
      };
}

class UnsplashResult {
  final String? id;
  final int? width;
  final int? height;
  final String? color;
  final String? description;
  final UnsplashUrls? urls;

  UnsplashResult({
    this.id,
    this.width,
    this.height,
    this.color,
    this.description,
    this.urls,
  });

  UnsplashResult copyWith({
    String? id,
    int? width,
    int? height,
    String? color,
    String? description,
    UnsplashUrls? urls,
  }) =>
      UnsplashResult(
        id: id ?? this.id,
        width: width ?? this.width,
        height: height ?? this.height,
        color: color ?? this.color,
        description: description ?? this.description,
        urls: urls ?? this.urls,
      );

  factory UnsplashResult.fromJson(String str) =>
      UnsplashResult.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory UnsplashResult.fromMap(Map<String, dynamic> json) => UnsplashResult(
        id: json["id"],
        width: json["width"],
        height: json["height"],
        color: json["color"],
        description: json["description"],
        urls: json["urls"] == null ? null : UnsplashUrls.fromMap(json["urls"]),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "width": width,
        "height": height,
        "color": color,
        "description": description,
        "urls": urls?.toMap(),
      };
}

class UnsplashUrls {
  final String? raw;
  final String? full;
  final String? regular;
  final String? small;
  final String? thumb;

  UnsplashUrls({
    this.raw,
    this.full,
    this.regular,
    this.small,
    this.thumb,
  });

  UnsplashUrls copyWith({
    String? raw,
    String? full,
    String? regular,
    String? small,
    String? thumb,
  }) =>
      UnsplashUrls(
        raw: raw ?? this.raw,
        full: full ?? this.full,
        regular: regular ?? this.regular,
        small: small ?? this.small,
        thumb: thumb ?? this.thumb,
      );

  factory UnsplashUrls.fromJson(String str) =>
      UnsplashUrls.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory UnsplashUrls.fromMap(Map<String, dynamic> json) => UnsplashUrls(
        raw: json["raw"],
        full: json["full"],
        regular: json["regular"],
        small: json["small"],
        thumb: json["thumb"],
      );

  Map<String, dynamic> toMap() => {
        "raw": raw,
        "full": full,
        "regular": regular,
        "small": small,
        "thumb": thumb,
      };
}
