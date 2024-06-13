import 'dart:convert';

List<BgImagesCategory> bgResponseFromMap(String str) =>
    List<BgImagesCategory>.from(
        json.decode(str).map((x) => BgImagesCategory.fromMap(x)));

String bgResponseToMap(List<BgImagesCategory> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

class BgImagesCategory {
  final String? titleEn;
  final String? titleHn;
  final List<BgImage>? backgrounds;

  BgImagesCategory({
    this.titleEn,
    this.titleHn,
    this.backgrounds,
  });

  factory BgImagesCategory.fromJson(String str) =>
      BgImagesCategory.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory BgImagesCategory.fromMap(Map<String, dynamic> json) =>
      BgImagesCategory(
        titleEn: json["name"],
        titleHn: json["hindi"],
        backgrounds: json["backgrounds"] == null
            ? []
            : List<BgImage>.from(
                json["backgrounds"]!.map((x) => BgImage.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "name": titleEn,
        "hindi": titleHn,
        "backgrounds": backgrounds == null
            ? []
            : List<dynamic>.from(backgrounds!.map((x) => x.toMap())),
      };
}

class BgImage {
  final int? id;
  final int? isPremium;
  final String? path;
  final List<String>? tags;

  BgImage({
    this.id,
    this.path,
    this.tags,
    this.isPremium = 0,
  });

  factory BgImage.fromJson(String str) => BgImage.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory BgImage.fromMap(Map<String, dynamic> json) => BgImage(
        id: json["id"],
        path: json["path"],
        isPremium: json["is_premium"] ?? 0,
        tags: json["tags"] == null
            ? []
            : List<String>.from(json["tags"]!.map((x) => x)),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "is_premium": isPremium,
        "path": path,
        "tags": tags == null ? [] : List<dynamic>.from(tags!.map((x) => x)),
      };
}
