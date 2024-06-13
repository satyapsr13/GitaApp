import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../Data/model/api/category_model.dart';
import '../../../Data/model/api/tags_model.dart';
import '../../../Logic/Cubit/Posts/posts_cubit.dart';
import '../../../Utility/next_screen.dart';
import '../../Widgets/style.dart';
import '../specific_category_screen.dart';
import 'specific_tags_screen.dart';

class TagsSearch extends SearchDelegate {
  List<TagsModel>? filteredTagsList = [];
  List<Categories>? filteredCategoriesList = [];

  void filterProducts(
    List<TagsModel>? tags,
    List<Categories>? categories,
  ) {
    filteredTagsList = tags?.where((p) {
      return (p.keyword.toLowerCase().contains(query.toLowerCase()) ||
          p.hindi.contains(query.toLowerCase()));
    }).toList();
    filteredCategoriesList = categories?.where((p) {
      return ((p.name?.toLowerCase() ?? "").contains(query.toLowerCase()) ||
          (p.hindi?.toLowerCase() ?? "").contains(query.toLowerCase()));
    }).toList();
  }

  void updateSuggestions(BuildContext context) {
    filterProducts(BlocProvider.of<PostCubit>(context).state.allTagsList,
        BlocProvider.of<PostCubit>(context).state.categoriesList);
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      IconButton(
        onPressed: () {
          query = "";
        },
        icon: const Icon(Icons.close),
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: const Icon(Icons.arrow_back_ios_new));
  }

  @override
  Widget buildResults(BuildContext context) {
    updateSuggestions(context);

    return Visibility(
      visible: !((filteredCategoriesList?.length == 0) &&
          (filteredTagsList?.length == 0)),
      replacement: Center(child: Text(tr("no_result_found"))),
      child: Padding(
        padding: const EdgeInsets.only(top: 15, right: 15, left: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            filteredCategoriesList?.length == 0
                ? const SizedBox()
                : const Text(
                    'Categories',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
            filteredCategoriesList?.length == 0
                ? const SizedBox()
                : SizedBox(
                    height: 75,
                    child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      // physics: const BouncingScrollPhysics(),
                      itemCount: filteredCategoriesList?.length,
                      itemBuilder: (ctx, index) {
                        final e = filteredCategoriesList![index];
                        String name = e.name ?? "";
                        String hindi = e.hindi ?? "";
                        String image = e.image ?? "";
                        String postId = e.id.toString();
                        return InkWell(
                          onTap: () {
                            BlocProvider.of<PostCubit>(context)
                                .state
                                .categoryWisePostList = [];
                            nextScreenWithFadeAnimation(
                                context,
                                SpecificCategoryScreen(
                                  categoryTitleEnglish: name,
                                  categoryTitleHindi: hindi,
                                  postId: postId,
                                ));
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: 70,
                              width: 90,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                      colorFilter: const ColorFilter.mode(
                                        Color(
                                            0x25000000), // Set the color you want to apply
                                        BlendMode.overlay, // Set the blend mode
                                      ),
                                      image: CachedNetworkImageProvider(
                                        image,
                                      ),
                                      fit: BoxFit.cover)),
                              child: Center(
                                  child: Text(
                                tr("_a_") == "A" ? name : hindi,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    shadows: [
                                      Shadow(
                                        color: Colors.black,
                                        blurRadius: 2,
                                      ),
                                    ],
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold),
                              )),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
            filteredTagsList?.length == 0
                ? const SizedBox()
                : const Text(
                    'Tags',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
            const SizedBox(height: 15),
            filteredTagsList?.length == 0
                ? const SizedBox()
                : Expanded(
                    child: SingleChildScrollView(
                    child: Wrap(
                      children: filteredTagsList!.map((e) {
                        return Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: InkWell(
                              onTap: () {
                                BlocProvider.of<PostCubit>(context)
                                    .state
                                    .specificTagList = [];
                                nextScreenWithFadeAnimation(
                                    context,
                                    SpecificTagsScreen(
                                      categoryTitleEnglish: e.name,
                                      categoryTitleHindi: e.hindi,
                                      postKeyword: e.keyword,
                                    ));
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      width: 1,
                                      color: Colors.black,
                                    )),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 4, vertical: 2),
                                  child: Text(
                                    tr("_a_") == "A" ? e.name : e.hindi,
                                    style: TextStyles.textStyle12,
                                  ),
                                ),
                              ),
                            ));
                      }).toList(),
                    ),
                  )),
          ],
        ),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    updateSuggestions(context);

    return Visibility(
      visible: !((filteredCategoriesList?.length == 0) &&
          (filteredTagsList?.length == 0)),
      replacement: Center(child: Text(tr("no_result_found"))),
      child: Padding(
        padding: const EdgeInsets.only(top: 15, right: 15, left: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            filteredCategoriesList?.length == 0
                ? const SizedBox()
                : const Text(
                    'Categories',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
            filteredCategoriesList?.length == 0
                ? const SizedBox()
                : SizedBox(
                    height: 75,
                    child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      // physics: const BouncingScrollPhysics(),
                      itemCount: filteredCategoriesList?.length,
                      itemBuilder: (ctx, index) {
                        final e = filteredCategoriesList![index];
                        String name = e.name ?? "";
                        String hindi = e.hindi ?? "";
                        String image = e.image ?? "";
                        String postId = e.id.toString();
                        return InkWell(
                          onTap: () {
                            BlocProvider.of<PostCubit>(context)
                                .state
                                .categoryWisePostList = [];
                            nextScreenWithFadeAnimation(
                                context,
                                SpecificCategoryScreen(
                                  categoryTitleEnglish: name,
                                  categoryTitleHindi: hindi,
                                  postId: postId,
                                ));
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: 70,
                              width: 90,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                      colorFilter: const ColorFilter.mode(
                                        Color(0x25000000),
                                        BlendMode.overlay,
                                      ),
                                      image: CachedNetworkImageProvider(
                                        image,
                                      ),
                                      fit: BoxFit.cover)),
                              child: Center(
                                  child: Text(
                                tr("_a_") == "A" ? name : hindi,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    shadows: [
                                      Shadow(
                                        color: Colors.black,
                                        blurRadius: 2,
                                      ),
                                    ],
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold),
                              )),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
            filteredTagsList?.length == 0
                ? const SizedBox()
                : const Text(
                    'Tags',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
            const SizedBox(height: 15),
            filteredTagsList?.length == 0
                ? const SizedBox()
                : Expanded(
                    child: SingleChildScrollView(
                    child: Wrap(
                      children: filteredTagsList!.map((e) {
                        return Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: InkWell(
                              onTap: () {
                                BlocProvider.of<PostCubit>(context)
                                    .state
                                    .specificTagList = [];
                                nextScreenWithFadeAnimation(
                                    context,
                                    SpecificTagsScreen(
                                      categoryTitleEnglish: e.name,
                                      categoryTitleHindi: e.hindi,
                                      postKeyword: e.keyword,
                                    ));
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      width: 1,
                                      color: Colors.black,
                                    )),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 4, vertical: 2),
                                  child: Text(
                                    tr("_a_") == "A" ? e.name : e.hindi,
                                    style: TextStyles.textStyle12,
                                  ),
                                ),
                              ),
                            ));
                      }).toList(),
                    ),
                  )),
          ],
        ),
      ),
    );
  }

  @override
  void showResults(BuildContext context) {
    // Clear the query and show results
    updateSuggestions(context);
    super.showResults(context);
  }
}
