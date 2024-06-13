// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class SavedPostList {
  List<SavedPost> savedPostList;
  SavedPostList({
    required this.savedPostList,
  });

  Map<String, dynamic> toMap() {
    return {
      'savedPostList': savedPostList.map((x) => x.toMap()).toList(),
    };
  }

  factory SavedPostList.fromMap(Map<String, dynamic> map) {
    return SavedPostList(
      savedPostList: List<SavedPost>.from(
          map['savedPostList']?.map((x) => SavedPost.fromMap(x))),
    );
  }

  String toJson() {
    return json.encode(toMap());
  }

  factory SavedPostList.fromJson(String source) {
    return SavedPostList.fromMap(json.decode(source));
  }

  @override
  String toString() {
    return 'SavedPostList(savedPostList: $savedPostList)';
  }
}

class SavedPost {
  final int postId;
  final String imageLink;
  SavedPost({
    required this.postId,
    required this.imageLink,
  });

  Map<String, dynamic> toMap() {
    return {
      'postId': postId,
      'imageLink': imageLink,
    };
  }

  factory SavedPost.fromMap(Map<String, dynamic> map) {
    return SavedPost(
      postId: map['postId']?.toInt() ?? 0,
      imageLink: map['imageLink'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory SavedPost.fromJson(String source) =>
      SavedPost.fromMap(json.decode(source));

  @override
  String toString() => 'SavedPost(postId: $postId, imageLink: $imageLink)';
}
