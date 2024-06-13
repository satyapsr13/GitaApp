import 'dart:convert';

class DpFramesResponse {
  final bool? success;
  final int? statuscode;
  final String? message;
  final List<DpFrames>? data;

  DpFramesResponse({
    this.success,
    this.statuscode,
    this.message,
    this.data,
  });

  DpFramesResponse copyWith({
    bool? success,
    int? statuscode,
    String? message,
    List<DpFrames>? data,
  }) =>
      DpFramesResponse(
        success: success ?? this.success,
        statuscode: statuscode ?? this.statuscode,
        message: message ?? this.message,
        data: data ?? this.data,
      );

  factory DpFramesResponse.fromJson(String str) =>
      DpFramesResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory DpFramesResponse.fromMap(Map<String, dynamic> json) =>
      DpFramesResponse(
        success: json["success"],
        statuscode: json["statuscode"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<DpFrames>.from(json["data"]!.map((x) => DpFrames.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "success": success,
        "statuscode": statuscode,
        "message": message,
        "data":
            data == null ? [] : List<dynamic>.from(data!.map((x) => x.toMap())),
      };
}

class DpFrames {
  final int? id;
  final bool? isPremium;
  final String? path;
  final String? tags;
  final List<double>? customPosition;

  DpFrames({
    this.id,
    this.isPremium,
    this.path,
    this.tags,
    this.customPosition,
  });

  DpFrames copyWith({
    int? id,
    bool? isPremium,
    String? path,
    String? tags,
    List<double>? customPosition,
  }) =>
      DpFrames(
        id: id ?? this.id,
        isPremium: isPremium ?? this.isPremium,
        path: path ?? this.path,
        tags: tags ?? this.tags,
        customPosition: customPosition ?? this.customPosition,
      );

  factory DpFrames.fromJson(String str) => DpFrames.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory DpFrames.fromMap(Map<String, dynamic> json) => DpFrames(
        id: json["id"],
        isPremium: json["is_premium"],
        path: json["path"],
        tags: json["tags"],
        customPosition: json["custom_position"] == null
            ? []
            : List<double>.from(
                json["custom_position"]!.map((x) => x?.toDouble())),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "is_premium": isPremium,
        "path": path,
        "tags": tags,
        "custom_position": customPosition == null
            ? []
            : List<dynamic>.from(customPosition!.map((x) => x)),
      };
}
