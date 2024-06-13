 

import 'category_model.dart';
import 'special_ocassion_model.dart';
import 'tags_model.dart';

class TocResponse {
  final List<TagsModel>? tags;
  final List<Categories>? categories;
  final List<SpecialOcassion>? occasions;

  TocResponse({
    this.tags,
    this.categories,
    this.occasions,
  });

  factory TocResponse.fromMap(Map<String, dynamic> json) => TocResponse(
        tags: json["tags"] == null
            ? []
            : List<TagsModel>.from(
                json["tags"]!.map((x) => TagsModel.fromMap(x))),
        categories: json["categories"] == null
            ? []
            : List<Categories>.from(
                json["categories"]!.map((x) => Categories.fromMap(x))),
        occasions: json["occasions"] == null
            ? []
            : List<SpecialOcassion>.from(
                json["occasions"]!.map((x) => SpecialOcassion.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "tags":
            tags == null ? [] : List<dynamic>.from(tags!.map((x) => x.toMap())),
        "categories": categories == null
            ? []
            : List<dynamic>.from(categories!.map((x) => x.toMap())),
        "occasions": occasions == null
            ? []
            : List<dynamic>.from(occasions!.map((x) => x.toMap())),
      };
}
