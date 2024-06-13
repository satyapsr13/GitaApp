import 'dart:convert';

class PremiumPlanResponse {
  final bool? success;
  final int? statuscode;
  final String? message;
  final PremiumPlan? data;

  PremiumPlanResponse({
    this.success,
    this.statuscode,
    this.message,
    this.data,
  });

  PremiumPlanResponse copyWith({
    bool? success,
    int? statuscode,
    String? message,
    PremiumPlan? data,
  }) =>
      PremiumPlanResponse(
        success: success ?? this.success,
        statuscode: statuscode ?? this.statuscode,
        message: message ?? this.message,
        data: data ?? this.data,
      );

  factory PremiumPlanResponse.fromJson(String str) =>
      PremiumPlanResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory PremiumPlanResponse.fromMap(Map<String, dynamic> json) =>
      PremiumPlanResponse(
        success: json["success"],
        statuscode: json["statuscode"],
        message: json["message"],
        data: json["data"] == null ? null : PremiumPlan.fromMap(json["data"]),
      );

  Map<String, dynamic> toMap() => {
        "success": success,
        "statuscode": statuscode,
        "message": message,
        "data": data?.toMap(),
      };
}

class PremiumPlan {
  final String? image;
  final String? imageHindi;
  final String? offer;
  final String? offerHindi;
  final List<Plan>? plans;

  PremiumPlan({
    this.image,
    this.imageHindi,
    this.offer,
    this.offerHindi,
    this.plans,
  });

  PremiumPlan copyWith({
    String? image,
    String? imageHindi,
    String? offer,
    String? offerHindi,
    List<Plan>? plans,
  }) =>
      PremiumPlan(
        image: image ?? this.image,
        imageHindi: imageHindi ?? this.imageHindi,
        offer: offer ?? this.offer,
        offerHindi: offerHindi ?? this.offerHindi,
        plans: plans ?? this.plans,
      );

  factory PremiumPlan.fromJson(String str) =>
      PremiumPlan.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory PremiumPlan.fromMap(Map<String, dynamic> json) => PremiumPlan(
        image: json["image"],
        imageHindi: json["image_hindi"],
        offer: json["offer"],
        offerHindi: json["offer_hindi"],
        plans: json["plans"] == null
            ? []
            : List<Plan>.from(json["plans"]!.map((x) => Plan.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "image": image,
        "image_hindi": imageHindi,
        "offer": offer,
        "offer_hindi": offerHindi,
        "plans": plans == null
            ? []
            : List<dynamic>.from(plans!.map((x) => x.toMap())),
      };
}

class Plan {
  final int? id;
  final String? name;
  final int? mrp;
  final int? price;
  final String? offer;
  final String? offerHindi;
  final String? duration;
  final String? durationHindi;
  final String? daily;
  final String? dailyHindi;
  final int? days;
  final bool? active;

  Plan({
    this.id,
    this.name,
    this.mrp,
    this.price,
    this.offer,
    this.offerHindi,
    this.duration,
    this.durationHindi,
    this.daily,
    this.dailyHindi,
    this.days,
    this.active,
  });

  Plan copyWith({
    int? id,
    String? name,
    int? mrp,
    int? price,
    String? offer,
    String? offerHindi,
    String? duration,
    String? durationHindi,
    String? daily,
    String? dailyHindi,
    int? days,
    bool? active,
  }) =>
      Plan(
        id: id ?? this.id,
        name: name ?? this.name,
        mrp: mrp ?? this.mrp,
        price: price ?? this.price,
        offer: offer ?? this.offer,
        offerHindi: offerHindi ?? this.offerHindi,
        duration: duration ?? this.duration,
        durationHindi: durationHindi ?? this.durationHindi,
        daily: daily ?? this.daily,
        dailyHindi: dailyHindi ?? this.dailyHindi,
        days: days ?? this.days,
        active: active ?? this.active,
      );

  factory Plan.fromJson(String str) => Plan.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Plan.fromMap(Map<String, dynamic> json) => Plan(
        id: json["id"],
        name: json["name"],
        mrp: json["mrp"],
        price: json["price"],
        offer: json["offer"],
        offerHindi: json["offer_hindi"],
        duration: json["duration"],
        durationHindi: json["duration_hindi"],
        daily: json["daily"],
        dailyHindi: json["daily_hindi"],
        days: json["days"],
        active: json["active"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "mrp": mrp,
        "price": price,
        "offer": offer,
        "offer_hindi": offerHindi,
        "duration": duration,
        "duration_hindi": durationHindi,
        "daily": daily,
        "daily_hindi": dailyHindi,
        "days": days,
        "active": active,
      };
}
