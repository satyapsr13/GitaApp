import 'dart:convert';
import 'dart:developer';

List<Categories> categoriesFromMap(String str) {
  return List<Categories>.from(json.decode(str).map((x) {
    // log("*************${x.runtimeType}**********");
    return Categories.fromMap(x);
  }));
  // return [];
}

String categoriesToMap(List<Categories> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

class Categories {
  Categories({
    this.id,
    this.name,
    this.hindi,
    this.image,
  });

  final int? id;
  final String? name;
  final String? hindi;
  final String? image;

  factory Categories.fromMap(Map<String, dynamic> json) => Categories(
        id: json["id"],
        name: json["name"],
        hindi: json["hindi"],
        image: json["image"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "hindi": hindi,
        "image": image,
      };
}
