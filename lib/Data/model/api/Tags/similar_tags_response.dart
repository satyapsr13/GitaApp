import 'dart:convert';

class SimilarTagsResponse {
  final int? id;
  final String? name;
  final String? hindi;
  final String? keyword;
  final String? active;
  final dynamic date;
  final String? tags;
  final dynamic hasvideos;
  final List<SimilarTag>? similarTags;

  SimilarTagsResponse({
    this.id,
    this.name,
    this.hindi,
    this.keyword,
    this.active,
    this.date,
    this.tags,
    this.hasvideos,
    this.similarTags,
  });

  SimilarTagsResponse copyWith({
    int? id,
    String? name,
    String? hindi,
    String? keyword,
    String? active,
    dynamic date,
    String? tags,
    dynamic hasvideos,
    List<SimilarTag>? similarTags,
  }) =>
      SimilarTagsResponse(
        id: id ?? this.id,
        name: name ?? this.name,
        hindi: hindi ?? this.hindi,
        keyword: keyword ?? this.keyword,
        active: active ?? this.active,
        date: date ?? this.date,
        tags: tags ?? this.tags,
        hasvideos: hasvideos ?? this.hasvideos,
        similarTags: similarTags ?? this.similarTags,
      );

  factory SimilarTagsResponse.fromJson(String str) =>
      SimilarTagsResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory SimilarTagsResponse.fromMap(Map<String, dynamic> json) =>
      SimilarTagsResponse(
        id: json["id"],
        name: json["name"],
        hindi: json["hindi"],
        keyword: json["keyword"],
        active: json["active"].toString(),
        date: json["date"],
        tags: json["tags"],
        hasvideos: json["hasvideos"],
        similarTags: json["similar_tags"] == null
            ? []
            : List<SimilarTag>.from(
                json["similar_tags"]!.map((x) => SimilarTag.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "hindi": hindi,
        "keyword": keyword,
        "active": active.toString(),
        "date": date,
        "tags": tags,
        "hasvideos": hasvideos,
        "similar_tags": similarTags == null
            ? []
            : List<dynamic>.from(similarTags!.map((x) => x.toMap())),
      };
}

class SimilarTag {
  final int? id;
  final String? name;
  final String? hindi;
  final String? keyword;
  final int? active;
  final dynamic date;
  final dynamic tags;
  final dynamic hasvideos;

  SimilarTag({
    this.id,
    this.name,
    this.hindi,
    this.keyword,
    this.active,
    this.date,
    this.tags,
    this.hasvideos,
  });

  SimilarTag copyWith({
    int? id,
    String? name,
    String? hindi,
    String? keyword,
    int? active,
    dynamic date,
    dynamic tags,
    dynamic hasvideos,
  }) =>
      SimilarTag(
        id: id ?? this.id,
        name: name ?? this.name,
        hindi: hindi ?? this.hindi,
        keyword: keyword ?? this.keyword,
        active: active ?? this.active,
        date: date ?? this.date,
        tags: tags ?? this.tags,
        hasvideos: hasvideos ?? this.hasvideos,
      );

  factory SimilarTag.fromJson(String str) =>
      SimilarTag.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory SimilarTag.fromMap(Map<String, dynamic> json) => SimilarTag(
        id: json["id"],
        name: json["name"],
        hindi: json["hindi"],
        keyword: json["keyword"],
        active: json["active"],
        date: json["date"],
        tags: json["tags"],
        hasvideos: json["hasvideos"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "hindi": hindi,
        "keyword": keyword,
        "active": active,
        "date": date,
        "tags": tags,
        "hasvideos": hasvideos,
      };
}
