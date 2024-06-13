import 'dart:convert';

import 'premium_plan_response.dart';

class SubscribePlanListResponse {
  final bool? success;
  final int? statuscode;
  final String? message;
  final List<SubscribePlanList>? data;

  SubscribePlanListResponse({
    this.success,
    this.statuscode,
    this.message,
    this.data,
  });

  SubscribePlanListResponse copyWith({
    bool? success,
    int? statuscode,
    String? message,
    List<SubscribePlanList>? data,
  }) =>
      SubscribePlanListResponse(
        success: success ?? this.success,
        statuscode: statuscode ?? this.statuscode,
        message: message ?? this.message,
        data: data ?? this.data,
      );

  factory SubscribePlanListResponse.fromJson(String str) =>
      SubscribePlanListResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory SubscribePlanListResponse.fromMap(Map<String, dynamic> json) =>
      SubscribePlanListResponse(
        success: json["success"],
        statuscode: json["statuscode"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<SubscribePlanList>.from(json["data"]!.map((x) => SubscribePlanList.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "success": success,
        "statuscode": statuscode,
        "message": message,
        "data":
            data == null ? [] : List<dynamic>.from(data!.map((x) => x.toMap())),
      };
}

class SubscribePlanList {
  final int? id;
  final int? userId;
  final String? planId;
  final String? paymentId;
  final String? orderId;
  final String? signature;
  final String? status;
  final String? method;
  final String? currency;
  final String? amount;
  final JsonResponse? jsonResponse;
  final JsonUser? jsonUser;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final Plan? plan;

  SubscribePlanList({
    this.id,
    this.userId,
    this.planId,
    this.paymentId,
    this.orderId,
    this.signature,
    this.status,
    this.method,
    this.currency,
    this.amount,
    this.jsonResponse,
    this.jsonUser,
    this.createdAt,
    this.updatedAt,
    this.plan,
  });

  SubscribePlanList copyWith({
    int? id,
    int? userId,
    String? planId,
    String? paymentId,
    String? orderId,
    String? signature,
    String? status,
    String? method,
    String? currency,
    String? amount,
    JsonResponse? jsonResponse,
    JsonUser? jsonUser,
    DateTime? createdAt,
    DateTime? updatedAt,
    Plan? plan,
  }) =>
      SubscribePlanList(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        planId: planId ?? this.planId,
        paymentId: paymentId ?? this.paymentId,
        orderId: orderId ?? this.orderId,
        signature: signature ?? this.signature,
        status: status ?? this.status,
        method: method ?? this.method,
        currency: currency ?? this.currency,
        amount: amount ?? this.amount,
        jsonResponse: jsonResponse ?? this.jsonResponse,
        jsonUser: jsonUser ?? this.jsonUser,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        plan: plan ?? this.plan,
      );

  factory SubscribePlanList.fromJson(String str) => SubscribePlanList.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory SubscribePlanList.fromMap(Map<String, dynamic> json) => SubscribePlanList(
        id: json["id"],
        userId: json["user_id"],
        planId: json["plan_id"],
        paymentId: json["payment_id"],
        orderId: json["order_id"],
        signature: json["signature"],
        status: json["status"],
        method: json["method"],
        currency: json["currency"],
        amount: json["amount"],
        jsonResponse: json["json_response"] == null
            ? null
            : JsonResponse.fromMap(json["json_response"]),
        jsonUser: json["json_user"] == null
            ? null
            : JsonUser.fromMap(json["json_user"]),
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        plan: json["plan"] == null ? null : Plan.fromMap(json["plan"]),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "user_id": userId,
        "plan_id": planId,
        "payment_id": paymentId,
        "order_id": orderId,
        "signature": signature,
        "status": status,
        "method": method,
        "currency": currency,
        "amount": amount,
        "json_response": jsonResponse?.toMap(),
        "json_user": jsonUser?.toMap(),
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "plan": plan?.toMap(),
      };
}

class JsonResponse {
  final String? id;
  final String? entity;
  final int? amount;
  final String? currency;
  final String? status;
  final String? orderId;
  final dynamic invoiceId;
  final bool? international;
  final String? method;
  final int? amountRefunded;
  final dynamic refundStatus;
  final bool? captured;
  final String? description;
  final dynamic cardId;
  final String? bank;
  final dynamic wallet;
  final String? vpa;
  final String? email;
  final String? contact;
  // final Notes? notes;
  final int? fee;
  final int? tax;
  final dynamic errorCode;
  final dynamic errorDescription;
  final dynamic errorSource;
  final dynamic errorStep;
  final dynamic errorReason;
  // final AcquirerData? acquirerData;
  final int? createdAt;
  // final Upi? upi;
  final dynamic razorpayOrderId;
  final dynamic razorpayPaymentId;
  final dynamic razorpaySignature;
  final bool? isSuccess;
  final String? error;
  final int? planId;
  final dynamic provider;
  final dynamic reward;

  JsonResponse({
    this.id,
    this.entity,
    this.amount,
    this.currency,
    this.status,
    this.orderId,
    this.invoiceId,
    this.international,
    this.method,
    this.amountRefunded,
    this.refundStatus,
    this.captured,
    this.description,
    this.cardId,
    this.bank,
    this.wallet,
    this.vpa,
    this.email,
    this.contact,
    // this.notes,
    this.fee,
    this.tax,
    this.errorCode,
    this.errorDescription,
    this.errorSource,
    this.errorStep,
    this.errorReason,
    // this.acquirerData,
    this.createdAt,
    // this.upi,
    this.razorpayOrderId,
    this.razorpayPaymentId,
    this.razorpaySignature,
    this.isSuccess,
    this.error,
    this.planId,
    this.provider,
    this.reward,
  });

  JsonResponse copyWith({
    String? id,
    String? entity,
    int? amount,
    String? currency,
    String? status,
    String? orderId,
    dynamic invoiceId,
    bool? international,
    String? method,
    int? amountRefunded,
    dynamic refundStatus,
    bool? captured,
    String? description,
    dynamic cardId,
    String? bank,
    dynamic wallet,
    String? vpa,
    String? email,
    String? contact,
    // Notes? notes,
    int? fee,
    int? tax,
    dynamic errorCode,
    dynamic errorDescription,
    dynamic errorSource,
    dynamic errorStep,
    dynamic errorReason,
    // AcquirerData? acquirerData,
    int? createdAt,
    // Upi? upi,
    dynamic razorpayOrderId,
    dynamic razorpayPaymentId,
    dynamic razorpaySignature,
    bool? isSuccess,
    String? error,
    int? planId,
    dynamic provider,
    dynamic reward,
  }) =>
      JsonResponse(
        id: id ?? this.id,
        entity: entity ?? this.entity,
        amount: amount ?? this.amount,
        currency: currency ?? this.currency,
        status: status ?? this.status,
        orderId: orderId ?? this.orderId,
        invoiceId: invoiceId ?? this.invoiceId,
        international: international ?? this.international,
        method: method ?? this.method,
        amountRefunded: amountRefunded ?? this.amountRefunded,
        refundStatus: refundStatus ?? this.refundStatus,
        captured: captured ?? this.captured,
        description: description ?? this.description,
        cardId: cardId ?? this.cardId,
        bank: bank ?? this.bank,
        wallet: wallet ?? this.wallet,
        vpa: vpa ?? this.vpa,
        email: email ?? this.email,
        contact: contact ?? this.contact,
        // notes: notes ?? this.notes,
        fee: fee ?? this.fee,
        tax: tax ?? this.tax,
        errorCode: errorCode ?? this.errorCode,
        errorDescription: errorDescription ?? this.errorDescription,
        errorSource: errorSource ?? this.errorSource,
        errorStep: errorStep ?? this.errorStep,
        errorReason: errorReason ?? this.errorReason,
        // acquirerData: acquirerData ?? this.acquirerData,
        createdAt: createdAt ?? this.createdAt,
        // upi: upi ?? this.upi,
        razorpayOrderId: razorpayOrderId ?? this.razorpayOrderId,
        razorpayPaymentId: razorpayPaymentId ?? this.razorpayPaymentId,
        razorpaySignature: razorpaySignature ?? this.razorpaySignature,
        isSuccess: isSuccess ?? this.isSuccess,
        error: error ?? this.error,
        planId: planId ?? this.planId,
        provider: provider ?? this.provider,
        reward: reward ?? this.reward,
      );

  factory JsonResponse.fromJson(String str) =>
      JsonResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory JsonResponse.fromMap(Map<String, dynamic> json) => JsonResponse(
        id: json["id"],
        entity: json["entity"],
        amount: json["amount"],
        currency: json["currency"],
        status: json["status"],
        orderId: json["order_id"],
        invoiceId: json["invoice_id"],
        international: json["international"],
        method: json["method"],
        amountRefunded: json["amount_refunded"],
        refundStatus: json["refund_status"],
        captured: json["captured"],
        description: json["description"],
        cardId: json["card_id"],
        bank: json["bank"],
        wallet: json["wallet"],
        vpa: json["vpa"],
        email: json["email"],
        contact: json["contact"],
        // notes: json["notes"] == null ? null : Notes.fromMap(json["notes"]),
        fee: json["fee"],
        tax: json["tax"],
        errorCode: json["error_code"],
        errorDescription: json["error_description"],
        errorSource: json["error_source"],
        errorStep: json["error_step"],
        errorReason: json["error_reason"],
        // acquirerData: json["acquirer_data"] == null
        //     ? null
        //     : AcquirerData.fromMap(json["acquirer_data"]),
        createdAt: json["created_at"],
        // upi: json["upi"] == null ? null : Upi.fromMap(json["upi"]),
        razorpayOrderId: json["razorpay_order_id"],
        razorpayPaymentId: json["razorpay_payment_id"],
        razorpaySignature: json["razorpay_signature"],
        isSuccess: json["is_success"],
        error: json["error"],
        planId: json["plan_id"],
        provider: json["provider"],
        reward: json["reward"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "entity": entity,
        "amount": amount,
        "currency": currency,
        "status": status,
        "order_id": orderId,
        "invoice_id": invoiceId,
        "international": international,
        "method": method,
        "amount_refunded": amountRefunded,
        "refund_status": refundStatus,
        "captured": captured,
        "description": description,
        "card_id": cardId,
        "bank": bank,
        "wallet": wallet,
        "vpa": vpa,
        "email": email,
        "contact": contact,
        // "notes": notes?.toMap(),
        "fee": fee,
        "tax": tax,
        "error_code": errorCode,
        "error_description": errorDescription,
        "error_source": errorSource,
        "error_step": errorStep,
        "error_reason": errorReason,
        // "acquirer_data": acquirerData?.toMap(),
        "created_at": createdAt,
        // "upi": upi?.toMap(),
        "razorpay_order_id": razorpayOrderId,
        "razorpay_payment_id": razorpayPaymentId,
        "razorpay_signature": razorpaySignature,
        "is_success": isSuccess,
        "error": error,
        "plan_id": planId,
        "provider": provider,
        "reward": reward,
      };
}
class JsonUser {
  final int? id;
  final String? name;
  final dynamic email;
  final dynamic emailVerifiedAt;
  final dynamic twoFactorConfirmedAt;
  final String? role;
  final dynamic currentTeamId;
  final String? profilePhotoPath;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? contact;
  final int? trialUsed;
  final DateTime? verifiedTill;
  final dynamic socials;
  final dynamic username;
  final dynamic referralCode;
  final dynamic referralBy;
  final dynamic biodata;
  final dynamic cardinfo;
  final String? profilePhotoUrl;
  final bool? isPremium;

  JsonUser({
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

  JsonUser copyWith({
    int? id,
    String? name,
    dynamic email,
    dynamic emailVerifiedAt,
    dynamic twoFactorConfirmedAt,
    String? role,
    dynamic currentTeamId,
    String? profilePhotoPath,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? contact,
    int? trialUsed,
    DateTime? verifiedTill,
    dynamic socials,
    dynamic username,
    dynamic referralCode,
    dynamic referralBy,
    dynamic biodata,
    dynamic cardinfo,
    String? profilePhotoUrl,
    bool? isPremium,
  }) =>
      JsonUser(
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

  factory JsonUser.fromJson(String str) => JsonUser.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory JsonUser.fromMap(Map<String, dynamic> json) => JsonUser(
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
        verifiedTill: json["verified_till"] == null
            ? null
            : DateTime.parse(json["verified_till"]),
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
        "verified_till": verifiedTill?.toIso8601String(),
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
