import 'dart:convert';

List<SpecialOcassion> specialOcassionResponseFromMap(String str) =>
    json.decode(str) == null
        ? []
        : List<SpecialOcassion>.from(
            json.decode(str)!.map((x) => SpecialOcassion.fromMap(x)));

String specialOcassionResponseToMap(List<SpecialOcassion>? data) => json
    .encode(data == null ? [] : List<dynamic>.from(data.map((x) => x.toMap())));

class SpecialOcassion {
  SpecialOcassion(
      {this.id,
      this.name,
      this.active,
      this.date,
      this.version,
      this.image,
      this.imageHindi,
      this.description,
      // this.createdAt,
      // this.updatedAt,
      this.isPromotion,
      this.promotionUrl,
      this.type,
      this.youtubeAndUpdateModel});

  final int? id;
  final String? name;
  final int? active;
  final String? version;
  final DateTime? date;
  final String? image;
  final String? imageHindi;
  final dynamic description;
  // final DateTime? createdAt;
  // final DateTime? updatedAt;
  final int? isPromotion;
  final String? promotionUrl;
  final String? type;

  final List<YoutubeAndUpdateModel>? youtubeAndUpdateModel;

  factory SpecialOcassion.fromMap(Map<String, dynamic> json) => SpecialOcassion(
        id: json["id"],
        name: json["name"],
        version: json["version"],
        active: json["active"],
        date: DateTime.tryParse(json["date"]),
        image: json["image"],
        imageHindi: json["image_hindi"],
        description: json["description"],
        isPromotion: json["is_promotion"],
        promotionUrl: json["promotion_url"],
        type: json["type"],
        youtubeAndUpdateModel: json["data"] == null
            ? []
            : List<YoutubeAndUpdateModel>.from(
                json["data"]!.map((x) => YoutubeAndUpdateModel.fromMap(x))),

        // createdAt: DateTime.parse(json["created_at"]),
        // updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "version": version,
        "active": active,
        "date": date,
        "image": image,
        "image_hindi": imageHindi,
        "description": description,
        "is_promotion": isPromotion,
        "promotion_url": promotionUrl,
        "type": type,
        "data": youtubeAndUpdateModel == null
            ? []
            : List<dynamic>.from(youtubeAndUpdateModel!.map((x) => x.toMap())),

        // "created_at": createdAt,
        // "updated_at": updatedAt,
      };
}

class YoutubeAndUpdateModel {
  final String? text;
  final String? hindi;
  final String? image;
  final String? buttonType;
  final String? url;
  final String? buttonText;
  final String? youtube;
  final String? buttonTextHindi;

  YoutubeAndUpdateModel({
    this.text,
    this.hindi,
    this.image,
    this.buttonType,
    this.url,
    this.buttonText,
    this.youtube,
    this.buttonTextHindi,
  });

  YoutubeAndUpdateModel copyWith({
    String? text,
    String? hindi,
    String? image,
    String? buttonType,
    String? url,
    String? buttonText,
    String? youtube,
    String? buttonTextHindi,
  }) =>
      YoutubeAndUpdateModel(
        text: text ?? this.text,
        hindi: hindi ?? this.hindi,
        youtube: youtube ?? this.youtube,
        image: image ?? this.image,
        buttonType: buttonType ?? this.buttonType,
        url: url ?? this.url,
        buttonText: buttonText ?? this.buttonText,
        buttonTextHindi: buttonTextHindi ?? this.buttonTextHindi,
      );

  factory YoutubeAndUpdateModel.fromJson(String str) =>
      YoutubeAndUpdateModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory YoutubeAndUpdateModel.fromMap(Map<String, dynamic> json) =>
      YoutubeAndUpdateModel(
        text: json["text"],
        hindi: json["hindi"],
        image: json["image"],
        buttonType: json["button_type"],
        url: json["url"],
        youtube: json["youtube"],
        buttonText: json["button_text"],
        buttonTextHindi: json["button_text_hindi"],
      );

  Map<String, dynamic> toMap() => {
        "text": text,
        "hindi": hindi,
        "image": image,
        "youtube": youtube,
        "button_type": buttonType,
        "url": url,
        "button_text": buttonText,
        "button_text_hindi": buttonTextHindi,
      };
}
