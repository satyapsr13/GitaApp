import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class ImageSearch {
  final String previewImgUrl;
  final String actualImgUrl;
  ImageSearch({
    required this.previewImgUrl,
    required this.actualImgUrl,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'previewImgUrl': previewImgUrl,
      'actualImgUrl': actualImgUrl,
    };
  }

  factory ImageSearch.fromMap(Map<String, dynamic> map) {
    return ImageSearch(
      previewImgUrl: map['previewImgUrl'] as String,
      actualImgUrl: map['actualImgUrl'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ImageSearch.fromJson(String source) => ImageSearch.fromMap(json.decode(source) as Map<String, dynamic>);
}
