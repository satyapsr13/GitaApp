import 'dart:convert';

class MessageResponse {
  final bool? success;
  final int? statuscode;
  final String? message;
  final MessageData? data;

  MessageResponse({
    this.success,
    this.statuscode,
    this.message,
    this.data,
  });

  MessageResponse copyWith({
    bool? success,
    int? statuscode,
    String? message,
    MessageData? data,
  }) =>
      MessageResponse(
        success: success ?? this.success,
        statuscode: statuscode ?? this.statuscode,
        message: message ?? this.message,
        data: data ?? this.data,
      );

  factory MessageResponse.fromJson(String str) =>
      MessageResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory MessageResponse.fromMap(Map<String, dynamic> json) => MessageResponse(
        success: json["success"],
        statuscode: json["statuscode"],
        message: json["message"],
        data: json["data"] == null ? null : MessageData.fromMap(json["data"]),
      );

  Map<String, dynamic> toMap() => {
        "success": success,
        "statuscode": statuscode,
        "message": message,
        "data": data?.toMap(),
      };
}

class MessageData {
  final int? currentPage;
  final List<Message>? data;
  final String? firstPageUrl;
  final int? from;
  final int? lastPage;
  final String? lastPageUrl;
  final List<MessageLink>? links;
  final dynamic nextPageUrl;
  final String? path;
  final int? perPage;
  final dynamic prevPageUrl;
  final int? to;
  final int? total;

  MessageData({
    this.currentPage,
    this.data,
    this.firstPageUrl,
    this.from,
    this.lastPage,
    this.lastPageUrl,
    this.links,
    this.nextPageUrl,
    this.path,
    this.perPage,
    this.prevPageUrl,
    this.to,
    this.total,
  });

  MessageData copyWith({
    int? currentPage,
    List<Message>? data,
    String? firstPageUrl,
    int? from,
    int? lastPage,
    String? lastPageUrl,
    List<MessageLink>? links,
    dynamic nextPageUrl,
    String? path,
    int? perPage,
    dynamic prevPageUrl,
    int? to,
    int? total,
  }) =>
      MessageData(
        currentPage: currentPage ?? this.currentPage,
        data: data ?? this.data,
        firstPageUrl: firstPageUrl ?? this.firstPageUrl,
        from: from ?? this.from,
        lastPage: lastPage ?? this.lastPage,
        lastPageUrl: lastPageUrl ?? this.lastPageUrl,
        links: links ?? this.links,
        nextPageUrl: nextPageUrl ?? this.nextPageUrl,
        path: path ?? this.path,
        perPage: perPage ?? this.perPage,
        prevPageUrl: prevPageUrl ?? this.prevPageUrl,
        to: to ?? this.to,
        total: total ?? this.total,
      );

  factory MessageData.fromJson(String str) => MessageData.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory MessageData.fromMap(Map<String, dynamic> json) => MessageData(
        currentPage: json["current_page"],
        data: json["data"] == null
            ? []
            : List<Message>.from(json["data"]!.map((x) => Message.fromMap(x))),
        firstPageUrl: json["first_page_url"],
        from: json["from"],
        lastPage: json["last_page"],
        lastPageUrl: json["last_page_url"],
        links: json["links"] == null
            ? []
            : List<MessageLink>.from(json["links"]!.map((x) => MessageLink.fromMap(x))),
        nextPageUrl: json["next_page_url"],
        path: json["path"],
        perPage: json["per_page"],
        prevPageUrl: json["prev_page_url"],
        to: json["to"],
        total: json["total"],
      );

  Map<String, dynamic> toMap() => {
        "current_page": currentPage,
        "data":
            data == null ? [] : List<dynamic>.from(data!.map((x) => x.toMap())),
        "first_page_url": firstPageUrl,
        "from": from,
        "last_page": lastPage,
        "last_page_url": lastPageUrl,
        "links": links == null
            ? []
            : List<dynamic>.from(links!.map((x) => x.toMap())),
        "next_page_url": nextPageUrl,
        "path": path,
        "per_page": perPage,
        "prev_page_url": prevPageUrl,
        "to": to,
        "total": total,
      };
}

class Message {
  final int? id;
  final int? userId;
  final int? toUserId;
  final String? text;
  final String? link;
  final String? youtube;
  final String? image;
  final int? active;
  final MessageButtonInfo? buttonInfo;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Message({
    this.id,
    this.userId,
    this.toUserId,
    this.text,
    this.link,
    this.youtube,
    this.image,
    this.active,
    this.buttonInfo,
    this.createdAt,
    this.updatedAt,
  });

  Message copyWith({
    int? id,
    int? userId,
    int? toUserId,
    String? text,
    String? link,
    String? youtube,
    String? image,
    int? active,
    MessageButtonInfo? buttonInfo,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      Message(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        toUserId: toUserId ?? this.toUserId,
        text: text ?? this.text,
        link: link ?? this.link,
        youtube: youtube ?? this.youtube,
        image: image ?? this.image,
        active: active ?? this.active,
        buttonInfo: buttonInfo ?? this.buttonInfo,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  factory Message.fromJson(String str) => Message.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Message.fromMap(Map<String, dynamic> json) => Message(
        id: json["id"],
        userId: json["user_id"],
        toUserId: json["to_user_id"],
        text: json["text"],
        link: json["link"],
        youtube: json["youtube"],
        image: json["image"],
        active: json["active"],
        buttonInfo: json["button_info"] == null
            ? null
            : MessageButtonInfo.fromMap(json["button_info"]),
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "user_id": userId,
        "to_user_id": toUserId,
        "text": text,
        "link": link,
        "youtube": youtube,
        "image": image,
        "active": active,
        "button_info": buttonInfo?.toMap(),
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}

class MessageButtonInfo {
  final String? url;
  final String? buttonText;
  final String? buttonType;

  MessageButtonInfo({
    this.url,
    this.buttonText,
    this.buttonType,
  });

  MessageButtonInfo copyWith({
    String? url,
    String? buttonText,
    String? buttonType,
  }) =>
      MessageButtonInfo(
        url: url ?? this.url,
        buttonText: buttonText ?? this.buttonText,
        buttonType: buttonType ?? this.buttonType,
      );

  factory MessageButtonInfo.fromJson(String str) =>
      MessageButtonInfo.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory MessageButtonInfo.fromMap(Map<String, dynamic> json) => MessageButtonInfo(
        url: json["url"],
        buttonText: json["button_text"],
        buttonType: json["button_type"],
      );

  Map<String, dynamic> toMap() => {
        "url": url,
        "button_text": buttonText,
        "button_type": buttonType,
      };
}

class MessageLink {
  final String? url;
  final String? label;
  final bool? active;

  MessageLink({
    this.url,
    this.label,
    this.active,
  });

  MessageLink copyWith({
    String? url,
    String? label,
    bool? active,
  }) =>
      MessageLink(
        url: url ?? this.url,
        label: label ?? this.label,
        active: active ?? this.active,
      );

  factory MessageLink.fromJson(String str) => MessageLink.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory MessageLink.fromMap(Map<String, dynamic> json) => MessageLink(
        url: json["url"],
        label: json["label"],
        active: json["active"],
      );

  Map<String, dynamic> toMap() => {
        "url": url,
        "label": label,
        "active": active,
      };
}
