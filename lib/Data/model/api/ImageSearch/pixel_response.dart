import 'dart:convert';

class PixcelImgResponse {
  final int? totalResults;
  final int? page;
  final int? perPage;
  final List<PixelPhoto>? photos;
  final String? nextPage;

  PixcelImgResponse({
    this.totalResults,
    this.page,
    this.perPage,
    this.photos,
    this.nextPage,
  });

  PixcelImgResponse copyWith({
    int? totalResults,
    int? page,
    int? perPage,
    List<PixelPhoto>? photos,
    String? nextPage,
  }) =>
      PixcelImgResponse(
        totalResults: totalResults ?? this.totalResults,
        page: page ?? this.page,
        perPage: perPage ?? this.perPage,
        photos: photos ?? this.photos,
        nextPage: nextPage ?? this.nextPage,
      );

  factory PixcelImgResponse.fromJson(String str) =>
      PixcelImgResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory PixcelImgResponse.fromMap(Map<String, dynamic> json) =>
      PixcelImgResponse(
        totalResults: json["total_results"],
        page: json["page"],
        perPage: json["per_page"],
        photos: json["photos"] == null
            ? []
            : List<PixelPhoto>.from(json["photos"]!.map((x) => PixelPhoto.fromMap(x))),
        nextPage: json["next_page"],
      );

  Map<String, dynamic> toMap() => {
        "total_results": totalResults,
        "page": page,
        "per_page": perPage,
        "photos": photos == null
            ? []
            : List<dynamic>.from(photos!.map((x) => x.toMap())),
        "next_page": nextPage,
      };
}

class PixelPhoto {
  final int? id;
  final int? width;
  final int? height;
  final String? url;
  final String? photographer;
  final String? photographerUrl;
  final int? photographerId;
  final String? avgColor;
  final PixelSrc? src;
  final bool? liked;
  final String? alt;

  PixelPhoto({
    this.id,
    this.width,
    this.height,
    this.url,
    this.photographer,
    this.photographerUrl,
    this.photographerId,
    this.avgColor,
    this.src,
    this.liked,
    this.alt,
  });

  PixelPhoto copyWith({
    int? id,
    int? width,
    int? height,
    String? url,
    String? photographer,
    String? photographerUrl,
    int? photographerId,
    String? avgColor,
    PixelSrc? src,
    bool? liked,
    String? alt,
  }) =>
      PixelPhoto(
        id: id ?? this.id,
        width: width ?? this.width,
        height: height ?? this.height,
        url: url ?? this.url,
        photographer: photographer ?? this.photographer,
        photographerUrl: photographerUrl ?? this.photographerUrl,
        photographerId: photographerId ?? this.photographerId,
        avgColor: avgColor ?? this.avgColor,
        src: src ?? this.src,
        liked: liked ?? this.liked,
        alt: alt ?? this.alt,
      );

  factory PixelPhoto.fromJson(String str) => PixelPhoto.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory PixelPhoto.fromMap(Map<String, dynamic> json) => PixelPhoto(
        id: json["id"],
        width: json["width"],
        height: json["height"],
        url: json["url"],
        photographer: json["photographer"],
        photographerUrl: json["photographer_url"],
        photographerId: json["photographer_id"],
        avgColor: json["avg_color"],
        src: json["src"] == null ? null : PixelSrc.fromMap(json["src"]),
        liked: json["liked"],
        alt: json["alt"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "width": width,
        "height": height,
        "url": url,
        "photographer": photographer,
        "photographer_url": photographerUrl,
        "photographer_id": photographerId,
        "avg_color": avgColor,
        "src": src?.toMap(),
        "liked": liked,
        "alt": alt,
      };
}

class PixelSrc {
  final String? original;
  final String? large2X;
  final String? large;
  final String? medium;
  final String? small;
  final String? portrait;
  final String? landscape;
  final String? tiny;

  PixelSrc({
    this.original,
    this.large2X,
    this.large,
    this.medium,
    this.small,
    this.portrait,
    this.landscape,
    this.tiny,
  });

  PixelSrc copyWith({
    String? original,
    String? large2X,
    String? large,
    String? medium,
    String? small,
    String? portrait,
    String? landscape,
    String? tiny,
  }) =>
      PixelSrc(
        original: original ?? this.original,
        large2X: large2X ?? this.large2X,
        large: large ?? this.large,
        medium: medium ?? this.medium,
        small: small ?? this.small,
        portrait: portrait ?? this.portrait,
        landscape: landscape ?? this.landscape,
        tiny: tiny ?? this.tiny,
      );

  factory PixelSrc.fromJson(String str) => PixelSrc.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory PixelSrc.fromMap(Map<String, dynamic> json) => PixelSrc(
        original: json["original"],
        large2X: json["large2x"],
        large: json["large"],
        medium: json["medium"],
        small: json["small"],
        portrait: json["portrait"],
        landscape: json["landscape"],
        tiny: json["tiny"],
      );

  Map<String, dynamic> toMap() => {
        "original": original,
        "large2x": large2X,
        "large": large,
        "medium": medium,
        "small": small,
        "portrait": portrait,
        "landscape": landscape,
        "tiny": tiny,
      };
}
