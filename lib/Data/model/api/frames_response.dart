import 'dart:convert';

class FrameResponse {
  final bool? success;
  final num? statuscode;
  final String? message;
  final List<Frame>? data;

  FrameResponse({
    this.success,
    this.statuscode,
    this.message,
    this.data,
  });

  FrameResponse copyWith({
    bool? success,
    num? statuscode,
    String? message,
    List<Frame>? data,
  }) =>
      FrameResponse(
        success: success ?? this.success,
        statuscode: statuscode ?? this.statuscode,
        message: message ?? this.message,
        data: data ?? this.data,
      );

  factory FrameResponse.fromJson(String str) =>
      FrameResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory FrameResponse.fromMap(Map<String, dynamic> json) => FrameResponse(
        success: json["success"],
        statuscode: json["statuscode"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<Frame>.from(json["data"]!.map((x) => Frame.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "success": success,
        "statuscode": statuscode,
        "message": message,
        "data":
            data == null ? [] : List<dynamic>.from(data!.map((x) => x.toMap())),
      };
}

class Frame {
  final num? id;
  final bool? isPremium;
  final bool? isActive;
  final FrameProfile? profile;
  final FrameText? name;
  final FrameText? occupation;
  final FrameText? number;

  Frame({
    this.isPremium,
    this.isActive,
    this.id,
    this.profile,
    this.name,
    this.occupation,
    this.number,
  });

  Frame copyWith({
    bool? isPremium,
    bool? isActive,
    num? id,
    FrameProfile? profile,
    FrameText? name,
    FrameText? occupation,
    FrameText? number,
  }) =>
      Frame(
        isPremium: isPremium ?? this.isPremium,
        isActive: isActive ?? this.isActive,
        id: id ?? this.id,
        profile: profile ?? this.profile,
        name: name ?? this.name,
        occupation: occupation ?? this.occupation,
        number: number ?? this.number,
      );

  factory Frame.fromJson(String str) => Frame.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Frame.fromMap(Map<String, dynamic> json) => Frame(
        isPremium: json["is_premium"],
        isActive: json["isActive"],
        id: json["id"],
        profile: json["profile"] == null
            ? null
            : FrameProfile.fromMap(json["profile"]),
        name: json["name"] == null ? null : FrameText.fromMap(json["name"]),
        occupation: json["occupation"] == null
            ? null
            : FrameText.fromMap(json["occupation"]),
        number:
            json["number"] == null ? null : FrameText.fromMap(json["number"]),
      );

  Map<String, dynamic> toMap() => {
        "is_premium": isPremium,
        "isActive": isActive,
        "id": id,
        "profile": profile?.toMap(),
        "name": name?.toMap(),
        "occupation": occupation?.toMap(),
        "number": number?.toMap(),
      };
}

class FrameText {
  final String? color;
  final num? fontsize;
  final num? x;
  final num? y;

  FrameText({
    this.color,
    this.fontsize,
    this.x,
    this.y,
  });

  FrameText copyWith({
    String? color,
    num? fontsize,
    num? x,
    num? y,
  }) =>
      FrameText(
        color: color ?? this.color,
        fontsize: fontsize ?? this.fontsize,
        x: x ?? this.x,
        y: y ?? this.y,
      );

  factory FrameText.fromJson(String str) => FrameText.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory FrameText.fromMap(Map<String, dynamic> json) => FrameText(
        color: json["color"],
        fontsize: json["fontsize"],
        x: json["x"],
        y: json["y"],
      );

  Map<String, dynamic> toMap() => {
        "color": color,
        "fontsize": fontsize,
        "x": x,
        "y": y,
      };
}

class FrameProfile {
  final String? image;
  final String? shape;
  final String? position;
  final num? radius;
  final num? x;
  final num? y;

  FrameProfile({
    this.image,
    this.position="right",
    this.shape,
    this.radius,
    this.x,
    this.y,
  });

  FrameProfile copyWith({
    String? image,
    String? shape,
    String? position,
    num? radius,
    num? x,
    num? y,
  }) =>
      FrameProfile(
        image: image ?? this.image,
        position: position ?? this.position,
        shape: shape ?? this.shape,
        radius: radius ?? this.radius,
        x: x ?? this.x,
        y: y ?? this.y,
      );

  factory FrameProfile.fromJson(String str) =>
      FrameProfile.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory FrameProfile.fromMap(Map<String, dynamic> json) => FrameProfile(
        image: json["image"],
        shape: json["shape"],
        position: json["position"],
        radius: json["radius"],
        x: json["x"],
        y: json["y"],
      );

  Map<String, dynamic> toMap() => {
        "image": image,
        "shape": shape,
        "position": position,
        "radius": radius,
        "x": x,
        "y": y,
      };
}
