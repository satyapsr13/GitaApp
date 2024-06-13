import 'dart:convert';

class LeaderboardResponse {
  final bool? success;
  final int? statuscode;
  final String? message;
  final LeaderboardData? data;

  LeaderboardResponse({
    this.success,
    this.statuscode,
    this.message,
    this.data,
  });

  LeaderboardResponse copyWith({
    bool? success,
    int? statuscode,
    String? message,
    LeaderboardData? data,
  }) =>
      LeaderboardResponse(
        success: success ?? this.success,
        statuscode: statuscode ?? this.statuscode,
        message: message ?? this.message,
        data: data ?? this.data,
      );

  factory LeaderboardResponse.fromJson(String str) =>
      LeaderboardResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory LeaderboardResponse.fromMap(Map<String, dynamic> json) =>
      LeaderboardResponse(
        success: json["success"],
        statuscode: json["statuscode"],
        message: json["message"],
        data:
            json["data"] == null ? null : LeaderboardData.fromMap(json["data"]),
      );

  Map<String, dynamic> toMap() => {
        "success": success,
        "statuscode": statuscode,
        "message": message,
        "data": data?.toMap(),
      };
}

class LeaderboardData {
  final List<Leaderboard>? leaderboard;
  final int? userScore;

  LeaderboardData({
    this.leaderboard,
    this.userScore,
  });

  LeaderboardData copyWith({
    List<Leaderboard>? leaderboard,
    int? userScore,
  }) =>
      LeaderboardData(
        leaderboard: leaderboard ?? this.leaderboard,
        userScore: userScore ?? this.userScore,
      );

  factory LeaderboardData.fromJson(String str) =>
      LeaderboardData.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory LeaderboardData.fromMap(Map<String, dynamic> json) => LeaderboardData(
        leaderboard: json["leaderboard"] == null
            ? []
            : List<Leaderboard>.from(
                json["leaderboard"]!.map((x) => Leaderboard.fromMap(x))),
        userScore: json["user_score"],
      );

  Map<String, dynamic> toMap() => {
        "leaderboard": leaderboard == null
            ? []
            : List<dynamic>.from(leaderboard!.map((x) => x.toMap())),
        "user_score": userScore,
      };
}

class Leaderboard {
  final int? id;
  final int? userId;
  final int? isPremium;
  final int? sharesCount;
  final int? refersCount;
  final int? points;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final User? user;

  Leaderboard({
    this.id,
    this.userId,
    this.isPremium,
    this.sharesCount,
    this.refersCount,
    this.points,
    this.createdAt,
    this.updatedAt,
    this.user,
  });

  Leaderboard copyWith({
    int? id,
    int? userId,
    int? isPremium,
    int? sharesCount,
    int? refersCount,
    int? points,
    DateTime? createdAt,
    DateTime? updatedAt,
    User? user,
  }) =>
      Leaderboard(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        isPremium: isPremium ?? this.isPremium,
        sharesCount: sharesCount ?? this.sharesCount,
        refersCount: refersCount ?? this.refersCount,
        points: points ?? this.points,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        user: user ?? this.user,
      );

  factory Leaderboard.fromJson(String str) =>
      Leaderboard.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Leaderboard.fromMap(Map<String, dynamic> json) => Leaderboard(
        id: json["id"],
        userId: json["user_id"],
        isPremium: json["is_premium"],
        sharesCount: json["shares_count"],
        refersCount: json["refers_count"],
        points: json["points"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        user: json["user"] == null ? null : User.fromMap(json["user"]),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "user_id": userId,
        "is_premium": isPremium,
        "shares_count": sharesCount,
        "refers_count": refersCount,
        "points": points,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "user": user?.toMap(),
      };
}

class User {
  final int? id;
  final String? name;
  final String? profilePhotoPath;
  final String? profilePhotoUrl;
  final bool? isPremium;

  User({
    this.id,
    this.name,
    this.profilePhotoPath,
    this.profilePhotoUrl,
    this.isPremium,
  });

  User copyWith({
    int? id,
    String? name,
    String? profilePhotoPath,
    String? profilePhotoUrl,
    bool? isPremium,
  }) =>
      User(
        id: id ?? this.id,
        name: name ?? this.name,
        profilePhotoPath: profilePhotoPath ?? this.profilePhotoPath,
        profilePhotoUrl: profilePhotoUrl ?? this.profilePhotoUrl,
        isPremium: isPremium ?? this.isPremium,
      );

  factory User.fromJson(String str) => User.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory User.fromMap(Map<String, dynamic> json) => User(
        id: json["id"],
        name: json["name"],
        profilePhotoPath: json["profile_photo_path"],
        profilePhotoUrl: json["profile_photo_url"],
        isPremium: json["is_premium"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "profile_photo_path": profilePhotoPath,
        "profile_photo_url": profilePhotoUrl,
        "is_premium": isPremium,
      };
}
