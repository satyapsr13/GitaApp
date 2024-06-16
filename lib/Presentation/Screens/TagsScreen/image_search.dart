import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:gita/Constants/colors.dart';
import 'package:gita/Constants/enums.dart';
import 'package:gita/Logic/Cubit/SeriesPostCubit/series_post_cubit.dart';
import 'package:gita/Presentation/Widgets/loading_builder.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:path_provider/path_provider.dart';

import '../../../Data/model/ObjectModels/post_widget_model.dart';
import '../../../Logic/Cubit/PostEditorCubit/post_editor_cubit.dart';
import '../../../Logic/Cubit/StickerCubit/sticker_cubit.dart';
import '../../../Logic/Cubit/user_cubit/user_cubit.dart';
import '../../../Utility/next_screen.dart';
import '../PostsScreens/post_edit_screen.dart';

class ImageSearch extends SearchDelegate {
  // void filterProducts(BuildContext context) {}

  void updateSuggestions(BuildContext context) {
    // Define a list of keywords to filter

    // Check if the query contains any of the keywords
    // bool containsAdultContent = adultContentKeywords
    //     .any((keyword) => query.toLowerCase().contains(keyword));

    if (false) {
      toast("Please don't search adult content");
    } else {
      BlocProvider.of<SeriesPostCubit>(context)
          .fetchPixabayImage(searchKey: query.toString());
    }
    // filterProducts();
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

  List<String> keywords = [
    "hindu god",
    "gradients",
    "krishna",
    "hanumanji",
    "mahakal",
    "yoga",
    "technology",
    "engineer",
    "army",
    "nurse",
    "hindu pandit",
  ];
  @override
  Widget buildResults(BuildContext context) {
    if (query.isNotEmpty) {
      List<String> adultContentKeywords = [
        "sex",
        "porn",
        "xxx",
        "adult",
        "erotic",
        "nude",
        "explicit",
        "hardcore",
        "fetish",
        "kinky",
        "nsfw",
        "bdsm",
        "taboo",
        "incest",
        "escort",
        "hookup",
        "dating",
        "camgirl",
        "camsex",
        "milf",
        "jailbait",
        "teen",
        "loli",
        "hentai"
      ];
      if (adultContentKeywords.contains(query.toLowerCase())) {
        query = "gradient";
      } else {}
      updateSuggestions(context);
    }

    return BlocBuilder<SeriesPostCubit, SeriesPostState>(
        builder: (context, state) {
      if (state.imageSearchStatus == Status.loading) {
        return const Center(child: CircularProgressIndicator());
      }
      return Visibility(
        visible: state.listOfSearchImage.isNotEmpty,
        replacement: Center(
            child: Text(tr("No result found, Please try another keyword"))),
        child: Padding(
          padding: const EdgeInsets.only(top: 15, right: 15, left: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Visibility(
                visible: false,
                child: SizedBox(
                  // color: Colors.amber,
                  height: 50,
                  // width: 400,
                  child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: state.listOfImgSearchKeys.length,
                      itemBuilder: (ctx, index) => Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              onTap: (() {
                                query = state.listOfImgSearchKeys[index];
                                updateSuggestions(context);
                              }),
                              child: Container(
                                height: 20,
                                // width: 400,
                                decoration: BoxDecoration(
                                    color:
                                        AppColors.primaryColor.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: AppColors.primaryColor,
                                      width: 1,
                                    )),
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(4),
                                    child: Text(
                                      state.listOfImgSearchKeys[index],
                                      style: const TextStyle(
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )),
                ),
              ),
              Expanded(
                // height: 400,
                child: GridView.builder(
                  itemCount: state.listOfSearchImage.length,
                  itemBuilder: (ctx, index) {
                    return InkWell(
                      onTap: () {
                        BlocProvider.of<PostEditorCubit>(context)
                            .updateStateVariables(
                          blankPostBgImage:
                              state.listOfSearchImage[index].actualImgUrl,
                        );
                        final frames = BlocProvider.of<StickerCubit>(context,
                                listen: false)
                            .state
                            .listOfFrames;
                        if (frames.isNotEmpty) {
                          BlocProvider.of<PostEditorCubit>(context)
                              .updateStateVariables(currentFrame: frames[0]);
                        }
                        BlocProvider.of<UserCubit>(context)
                            .updateStateVariables(
                                editedName: BlocProvider.of<UserCubit>(context,
                                        listen: false)
                                    .state
                                    .userName);
                        nextScreenWithFadeAnimation(
                            context,
                            PostEditScreen(
                              postWidgetData: PostWidgetModel(
                                imageLink: "",
                                postId: '',
                                profilePos: 'right',
                                tagColor: 'white',
                                profileShape: 'circle',
                                playStoreBadgePos: 'center-touched',
                              ),
                              isGradientPost: true,
                              // makePostFromGallery: true,
                            ));
                      },
                      child: GestureDetector(
                        onLongPress: () {
                          // showGeneralDialog(context: context, pageBuilder: pageBuilder)
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Image.network(state.listOfSearchImage[index]
                                        .previewImgUrl),
                                    const SizedBox(height: 20),
                                    ElevatedButton(
                                      onPressed: () async {
                                        // Add your download functionality here
                                        // print('Download button pressed');
                                        var appDocDir =
                                            await getApplicationDocumentsDirectory();
                                        String savePath =
                                            '${appDocDir.path}/downloaded_image.jpg';

                                        // Download the image
                                        await Dio().download(
                                            state.listOfSearchImage[index]
                                                .previewImgUrl,
                                            savePath);
                                        bool? res =
                                            await GallerySaver.saveImage(
                                          savePath,
                                          albumName: "Rishteyy",
                                        );
                                        toast(tr("downloaded_successfully"));
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Download'),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                        child: Image.network(
                          state.listOfSearchImage[index].previewImgUrl,
                          loadingBuilder: (context, child, loadingProgress) =>
                              loadingBuilder(context, child, loadingProgress),
                        ),
                      ),
                    );
                  },
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 1,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // updateSuggestions(context);

    return BlocBuilder<SeriesPostCubit, SeriesPostState>(
        builder: (context, state) {
      if (state.imageSearchStatus == Status.loading) {
        return const Center(child: CircularProgressIndicator());
      }
      return Visibility(
        visible: state.listOfSearchImage.isNotEmpty,
        replacement: Center(child: Text(tr("Please Search"))),
        child: Padding(
          padding: const EdgeInsets.only(top: 15, right: 15, left: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'We are not responsible for search results. All images are coming from internet.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              Wrap(
                children: [
                  ...List.generate(keywords.length, (index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 4, vertical: 2),
                      child: InkWell(
                        onTap: () {
                          query = keywords[index];
                          updateSuggestions(context);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                width: 1,
                                color: AppColors.primaryColor,
                              )),
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Text(
                              keywords[index],
                              style: const TextStyle(),
                            ),
                          ),
                        ),
                      ),
                    );
                  })
                ],
              ),
              // Visibility(
              //   // visible: ,
              //   child: Container(
              //     // color: Colors.amber,
              //     height: 50,
              //     // width: 400,
              //     child: ListView.builder(
              //         shrinkWrap: true,
              //         scrollDirection: Axis.horizontal,
              //         itemCount: state.listOfImgSearchKeys.length,
              //         itemBuilder: (ctx, index) => Padding(
              //               padding: const EdgeInsets.all(8.0),
              //               child: InkWell(
              //                 onTap: (() {
              //                   query = state.listOfImgSearchKeys[index];
              //                   updateSuggestions(context);
              //                 }),
              //                 child: Container(
              //                   height: 20,
              //                   // width: 400,
              //                   decoration: BoxDecoration(
              //                       color:
              //                           AppColors.primaryColor.withOpacity(0.1),
              //                       borderRadius: BorderRadius.circular(10),
              //                       border: Border.all(
              //                         color: AppColors.primaryColor,
              //                         width: 1,
              //                       )),
              //                   child: Center(
              //                     child: Padding(
              //                       padding: const EdgeInsets.all(4),
              //                       child: Text(
              //                         state.listOfImgSearchKeys[index],
              //                         style: TextStyle(
              //                           color: Colors.black,
              //                         ),
              //                       ),
              //                     ),
              //                   ),
              //                 ),
              //               ),
              //             )),
              //   ),
              // ),
              Expanded(
                // height: 400,
                child: GridView.builder(
                  itemCount: state.listOfSearchImage.length,
                  itemBuilder: (ctx, index) {
                    return InkWell(
                      onTap: () {
                        BlocProvider.of<PostEditorCubit>(context)
                            .updateStateVariables(
                          blankPostBgImage:
                              state.listOfSearchImage[index].actualImgUrl,
                        );
                        final frames = BlocProvider.of<StickerCubit>(context,
                                listen: false)
                            .state
                            .listOfFrames;
                        if (frames.isNotEmpty) {
                          BlocProvider.of<PostEditorCubit>(context)
                              .updateStateVariables(currentFrame: frames[0]);
                        }
                        BlocProvider.of<UserCubit>(context)
                            .updateStateVariables(
                                editedName: BlocProvider.of<UserCubit>(context,
                                        listen: false)
                                    .state
                                    .userName);
                        nextScreenWithFadeAnimation(
                            context,
                            PostEditScreen(
                              postWidgetData: PostWidgetModel(
                                imageLink: "",
                                postId: '',
                                profilePos: 'right',
                                tagColor: 'white',
                                profileShape: 'circle',
                                playStoreBadgePos: 'center-touched',
                              ),
                              isGradientPost: true,
                              // makePostFromGallery: true,
                            ));
                      },
                      child: Image.network(
                          state.listOfSearchImage[index].previewImgUrl),
                    );
                  },
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 1,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  @override
  void showResults(BuildContext context) {
    // Clear the query and show results
    updateSuggestions(context);
    super.showResults(context);
  }
}
