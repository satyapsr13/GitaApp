import 'dart:convert';

class GetProfileResponse {
  final bool? success;
  final int? statuscode;
  final String? message;
  final GetProfileData? data;

  GetProfileResponse({
    this.success,
    this.statuscode,
    this.message,
    this.data,
  });

  GetProfileResponse copyWith({
    bool? success,
    int? statuscode,
    String? message,
    GetProfileData? data,
  }) =>
      GetProfileResponse(
        success: success ?? this.success,
        statuscode: statuscode ?? this.statuscode,
        message: message ?? this.message,
        data: data ?? this.data,
      );

  factory GetProfileResponse.fromJson(String str) {
    // print("--------------aa bhosdike btata hu tujhe---------------");
    return GetProfileResponse.fromMap(json.decode(str));
  }

  String toJson() => json.encode(toMap());

  factory GetProfileResponse.fromMap(Map<String, dynamic> json) {
    return GetProfileResponse(
      success: json["success"],
      statuscode: json["statuscode"],
      message: json["message"],
      data: json["data"] == null ? null : GetProfileData.fromMap(json["data"]),
    );
  }

  Map<String, dynamic> toMap() => {
        "success": success,
        "statuscode": statuscode,
        "message": message,
        "data": data?.toMap(),
      };
}

class GetProfileData {
  final int? id;
  final String? name;
  final dynamic email;
  final dynamic emailVerifiedAt;
  final dynamic twoFactorConfirmedAt;
  final String? role;
  final dynamic currentTeamId;
  final dynamic profilePhotoPath;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? contact;
  final int? trialUsed;
  final dynamic verifiedTill;
  final dynamic socials;
  final String? username;
  final dynamic referralCode;
  final dynamic referralBy;
  final dynamic biodata;
  final dynamic cardinfo;
  final String? profilePhotoUrl;
  final bool? isPremium;

  GetProfileData({
    this.id,
    this.name,
    this.email,
    this.emailVerifiedAt,
    this.twoFactorConfirmedAt,
    this.role,
    this.currentTeamId,
    this.profilePhotoPath,
    this.createdAt,
    this.updatedAt,
    this.contact,
    this.trialUsed,
    this.verifiedTill,
    this.socials,
    this.username,
    this.referralCode,
    this.referralBy,
    this.biodata,
    this.cardinfo,
    this.profilePhotoUrl,
    this.isPremium,
  });

  GetProfileData copyWith({
    int? id,
    String? name,
    dynamic email,
    dynamic emailVerifiedAt,
    dynamic twoFactorConfirmedAt,
    String? role,
    dynamic currentTeamId,
    dynamic profilePhotoPath,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? contact,
    int? trialUsed,
    dynamic verifiedTill,
    dynamic socials,
    String? username,
    dynamic referralCode,
    dynamic referralBy,
    dynamic biodata,
    dynamic cardinfo,
    String? profilePhotoUrl,
    bool? isPremium,
  }) =>
      GetProfileData(
        id: id ?? this.id,
        name: name ?? this.name,
        email: email ?? this.email,
        emailVerifiedAt: emailVerifiedAt ?? this.emailVerifiedAt,
        twoFactorConfirmedAt: twoFactorConfirmedAt ?? this.twoFactorConfirmedAt,
        role: role ?? this.role,
        currentTeamId: currentTeamId ?? this.currentTeamId,
        profilePhotoPath: profilePhotoPath ?? this.profilePhotoPath,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        contact: contact ?? this.contact,
        trialUsed: trialUsed ?? this.trialUsed,
        verifiedTill: verifiedTill ?? this.verifiedTill,
        socials: socials ?? this.socials,
        username: username ?? this.username,
        referralCode: referralCode ?? this.referralCode,
        referralBy: referralBy ?? this.referralBy,
        biodata: biodata ?? this.biodata,
        cardinfo: cardinfo ?? this.cardinfo,
        profilePhotoUrl: profilePhotoUrl ?? this.profilePhotoUrl,
        isPremium: isPremium ?? this.isPremium,
      );

  factory GetProfileData.fromJson(String str) =>
      GetProfileData.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory GetProfileData.fromMap(Map<String, dynamic> json) => GetProfileData(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        emailVerifiedAt: json["email_verified_at"],
        twoFactorConfirmedAt: json["two_factor_confirmed_at"],
        role: json["role"],
        currentTeamId: json["current_team_id"],
        profilePhotoPath: json["profile_photo_path"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        contact: json["contact"],
        trialUsed: json["trial_used"],
        verifiedTill: json["verified_till"],
        socials: json["socials"],
        username: json["username"],
        referralCode: json["referral_code"],
        referralBy: json["referral_by"],
        biodata: json["biodata"],
        cardinfo: json["cardinfo"],
        profilePhotoUrl: json["profile_photo_url"],
        isPremium: json["is_premium"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "email": email,
        "email_verified_at": emailVerifiedAt,
        "two_factor_confirmed_at": twoFactorConfirmedAt,
        "role": role,
        "current_team_id": currentTeamId,
        "profile_photo_path": profilePhotoPath,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "contact": contact,
        "trial_used": trialUsed,
        "verified_till": verifiedTill,
        "socials": socials,
        "username": username,
        "referral_code": referralCode,
        "referral_by": referralBy,
        "biodata": biodata,
        "cardinfo": cardinfo,
        "profile_photo_url": profilePhotoUrl,
        "is_premium": isPremium,
      };
}
