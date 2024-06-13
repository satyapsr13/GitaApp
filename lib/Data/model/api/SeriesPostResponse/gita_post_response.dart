import 'dart:convert';

class GitaPostResponse {
  final bool? success;
  final int? statuscode;
  final String? message;
  final GitaPostModel? data;

  GitaPostResponse({
    this.success,
    this.statuscode,
    this.message,
    this.data,
  });

  GitaPostResponse copyWith({
    bool? success,
    int? statuscode,
    String? message,
    GitaPostModel? data,
  }) =>
      GitaPostResponse(
        success: success ?? this.success,
        statuscode: statuscode ?? this.statuscode,
        message: message ?? this.message,
        data: data ?? this.data,
      );

  factory GitaPostResponse.fromJson(String str) =>
      GitaPostResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory GitaPostResponse.fromMap(Map<String, dynamic> json) =>
      GitaPostResponse(
        success: json["success"],
        statuscode: json["statuscode"],
        message: json["message"],
        data: json["data"] == null ? null : GitaPostModel.fromMap(json["data"]),
      );

  Map<String, dynamic> toMap() => {
        "success": success,
        "statuscode": statuscode,
        "message": message,
        "data": data?.toMap(),
      };
}

class GitaPostModel {
  final String? chapter;
  final int? totalShloks;
  final List<GitaSloke>? gitaSloks;

  GitaPostModel({
    this.chapter,
    this.totalShloks,
    this.gitaSloks,
  });

  GitaPostModel copyWith({
    String? chapter,
    int? totalShloks,
    List<GitaSloke>? shloks,
  }) =>
      GitaPostModel(
        chapter: chapter ?? this.chapter,
        totalShloks: totalShloks ?? this.totalShloks,
        gitaSloks: shloks ?? this.gitaSloks,
      );

  factory GitaPostModel.fromJson(String str) => GitaPostModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory GitaPostModel.fromMap(Map<String, dynamic> json) => GitaPostModel(
        chapter: json["chapter"],
        totalShloks: json["total_shloks"],
        gitaSloks: json["shloks"] == null
            ? []
            : List<GitaSloke>.from(json["shloks"]!.map((x) => GitaSloke.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "chapter": chapter,
        "total_shloks": totalShloks,
        "shloks": gitaSloks == null
            ? []
            : List<dynamic>.from(gitaSloks!.map((x) => x.toMap())),
      };
}

class GitaSloke {
  final int? id;
  final String? shlokId;
  final int? chapter;
  final int? verse;
  final String? text;
  final String? transliteration;
  final String? meaning;
  final String? shlokImage;
  final List<String>? images; 

  GitaSloke({
    this.id,
    this.shlokId,
    this.chapter,
    this.verse,
    this.text,
    this.transliteration,
    this.meaning,
    this.shlokImage,
    this.images,
   
  });

  GitaSloke copyWith({
    int? id,
    String? shlokId,
    int? chapter,
    int? verse,
    String? text,
    String? transliteration,
    String? meaning,
    String? shlokImage,
    List<String>? images, 
  }) =>
      GitaSloke(
        id: id ?? this.id,
        shlokId: shlokId ?? this.shlokId,
        chapter: chapter ?? this.chapter,
        verse: verse ?? this.verse,
        text: text ?? this.text,
        transliteration: transliteration ?? this.transliteration,
        meaning: meaning ?? this.meaning,
        shlokImage: shlokImage ?? this.shlokImage,
        images: images ?? this.images,
 
      );

  factory GitaSloke.fromJson(String str) => GitaSloke.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory GitaSloke.fromMap(Map<String, dynamic> json) => GitaSloke(
        id: json["id"],
        shlokId: json["shlok_id"],
        chapter: json["chapter"],
        verse: json["verse"],
        text: json["text"],
        transliteration: json["transliteration"],
        meaning: json["meaning"],
        shlokImage: json["shlok_image"],
        images: json["images"] == null
            ? []
            : List<String>.from(json["images"]!.map((x) => x)),
       
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "shlok_id": shlokId,
        "chapter": chapter,
        "verse": verse,
        "text": text,
        "transliteration": transliteration,
        "meaning": meaning,
        "shlok_image": shlokImage,
        "images":
            images == null ? [] : List<dynamic>.from(images!.map((x) => x)),
      
      };
}
