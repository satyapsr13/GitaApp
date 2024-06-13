import 'dart:convert';

class MiniAppsResponse {
  final bool? success;
  final int? statuscode;
  final String? message;
  final List<Miniapps>? data;

  MiniAppsResponse({
    this.success,
    this.statuscode,
    this.message,
    this.data,
  });

  MiniAppsResponse copyWith({
    bool? success,
    int? statuscode,
    String? message,
    List<Miniapps>? data,
  }) =>
      MiniAppsResponse(
        success: success ?? this.success,
        statuscode: statuscode ?? this.statuscode,
        message: message ?? this.message,
        data: data ?? this.data,
      );

  factory MiniAppsResponse.fromJson(String str) =>
      MiniAppsResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory MiniAppsResponse.fromMap(Map<String, dynamic> json) =>
      MiniAppsResponse(
        success: json["success"],
        statuscode: json["statuscode"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<Miniapps>.from(json["data"]!.map((x) => Miniapps.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "success": success,
        "statuscode": statuscode,
        "message": message,
        "data":
            data == null ? [] : List<dynamic>.from(data!.map((x) => x.toMap())),
      };
}

class Miniapps {
  final String? name;
  final String? image;
  final String? imageHindi;
  final String? keyword;
  final String? data;

  Miniapps({
    this.name,
    this.image,
    this.imageHindi,
    this.keyword,
    this.data,
  });

  Miniapps copyWith({
    String? name,
    String? image,
    String? imageHindi,
    String? keyword,
    String? data,
  }) =>
      Miniapps(
        name: name ?? this.name,
        image: image ?? this.image,
        imageHindi: imageHindi ?? this.imageHindi,
        keyword: keyword ?? this.keyword,
        data: data ?? this.data,
      );

  factory Miniapps.fromJson(String str) => Miniapps.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Miniapps.fromMap(Map<String, dynamic> json) => Miniapps(
        name: json["name"],
        image: json["image"],
        imageHindi: json["image_hindi"],
        keyword: json["keyword"],
        data: json["data"],
      );

  Map<String, dynamic> toMap() => {
        "name": name,
        "image": image,
        "image_hindi": imageHindi,
        "keyword": keyword,
        "data": data,
      };
}
