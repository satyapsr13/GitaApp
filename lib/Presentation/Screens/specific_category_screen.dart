import 'dart:io';
import 'dart:typed_data';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../Constants/colors.dart';
import '../../Constants/constants.dart';
import '../../Constants/enums.dart';
import '../../Data/model/ObjectModels/post_widget_model.dart';
import '../../Data/services/secure_storage.dart';
import '../../Logic/Cubit/Posts/posts_cubit.dart';
import '../../Logic/Cubit/locale_cubit/locale_cubit.dart';
import '../../Utility/next_screen.dart';
import '../Ads/banner_admob.dart';
import '../Widgets/post_widget.dart';
import '../Widgets/style.dart';
import 'TagsScreen/specific_tags_screen.dart';

class SpecificCategoryScreen extends StatefulWidget {
  // const SpecificCategoryScreen({Key? key}) : super(key: key);
  final String categoryTitleHindi;
  final String categoryTitleEnglish;
  final String postId;

  const SpecificCategoryScreen({
    Key? key,
    required this.categoryTitleHindi,
    required this.categoryTitleEnglish,
    required this.postId,
  }) : super(key: key);
  @override
  State<SpecificCategoryScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<SpecificCategoryScreen> {
  Uint8List? image;
  String? photoUrl;
  Future<void> getImage() async {
    // Uint8List? image;
    SecureStorage secureStorage = SecureStorage();
    String imagePath = await secureStorage.readLocally('PHOTO_URL');
    if (imagePath.isNotEmpty) {
      image = await File(imagePath).readAsBytes();
    }
    // photoUrl = await secureStorage.readFromLocalStorage('PROFILE_IMAGE');

    setState(() {});
  }

  bool _showFab = false;
  int currentPage = 1;
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    pathTracker.add("specific_category_screen");
    super.initState();

    BlocProvider.of<PostCubit>(context)
        .fetchSimilarTags(tagsKeyword: widget.postId, isCategory: true);

    BlocProvider.of<PostCubit>(context)
        .fetchSpecificCategoryResponse(widget.postId, 0, false);

    _scrollController.addListener(_onScroll);
  }

  _onScroll() {
    if ((_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent)) {
      BlocProvider.of<PostCubit>(context)
          .fetchSpecificCategoryResponse(widget.postId, currentPage, false);
      // currentPage++;
      if (_scrollController.offset >=
              _scrollController.position.maxScrollExtent / 2 &&
          !_showFab) {
        setState(() {
          _showFab = true;
        });
      }
      if (_scrollController.offset <
              _scrollController.position.maxScrollExtent / 2 &&
          _showFab) {
        setState(() {
          _showFab = false;
        });
      }
    }
  }

  @override
  void dispose() {
    pathTracker.removeLast();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    return BlocBuilder<LocaleCubit, LocaleState>(builder: (context, state) {
      return Scaffold(
        // key: SpecificCategoryScreen.navigatorKey,
        drawerEdgeDragWidth: mq.width * 0.2, // drawerScrimColor: Colors.,
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.black),
          backgroundColor: Colors.white,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back_ios,
                size: 20,
                color: Colors.black,
              )),
          title: Text(
            state.locale == const Locale("en")
                ? widget.categoryTitleEnglish
                : widget.categoryTitleHindi,
            style: const TextStyle(color: Colors.black),
          ),
          elevation: 0,
          actions: [],
        ),

        body: BlocBuilder<PostCubit, PostState>(builder: (context, state) {
          if (state.status == Status.loading) {
            return SizedBox(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    RishteyyShimmerLoader(mq: mq),
                    Text(
                      tr('please_wait'),
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          if (state.status == Status.failure) {
            return TextButton(
              onPressed: () {
                // BlocProvider.of<PostCubit>(context)
                //     .fetchSpecificCategoryResponse(widget.postId, 0, false);
                nextScreenReplace(
                    context,
                    SpecificCategoryScreen(
                      categoryTitleEnglish: widget.categoryTitleEnglish,
                      categoryTitleHindi: widget.categoryTitleHindi,
                      postId: widget.postId,
                    ));
              },
              child: const Center(
                child: Text(
                  'Please try again!\n\n Click me!',
                  textAlign: TextAlign.center,
                  style: TextStyle(),
                ),
              ),
            );
          }
          currentPage = state.forYouPageNo + 1;
          return SingleChildScrollView(
            controller: _scrollController,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Wrap(
                      children: state.listOfSimilarTags.map((e) {
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
                                        categoryTitleEnglish: e.name ?? "",
                                        categoryTitleHindi: e.hindi ?? "",
                                        postKeyword: e.keyword ?? ""));
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
                                    (tr("_a_") == "A" ? e.name : e.hindi) ?? "",
                                    style: TextStyles.textStyle12,
                                  ),
                                ),
                              ),
                            ));
                      }).toList(),
                    ),
                  ),
                  SizedBox(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: state.categoryWisePostList.length,
                          itemBuilder: (ctx, index) {
                            PostWidgetModel postWidgetData = PostWidgetModel(
                              imageLink:
                                  state.categoryWisePostList[index].image ?? "",
                              postId: state.categoryWisePostList[index].id
                                  .toString(),
                              profilePos: state.categoryWisePostList[index]
                                  .frameOptions!.bottom
                                  .toString(),
                              profileShape: state.categoryWisePostList[index]
                                  .frameOptions!.border
                                  .toString(),
                              tagColor: state.categoryWisePostList[index]
                                  .frameOptions!.color
                                  .toString(),
                              playStoreBadgePos: state
                                  .categoryWisePostList[index].frameOptions!.top
                                  .toString(),
                              showName: state.isNameVisible,
                              showProfile: state.isProfileVisible,
                            );
                            return (index + 1) % 8 == 0
                                ? Column(
                                    children: [
                                      PostWidget(
                                        postWidgetData: postWidgetData,
                                        index: index,
                                      ),
                                      // BannerAd(size: size, adUnitId: adUnitId, listener: listener, request: request)
                                      const SizedBox(height: 10),
                                      BannerAdmob(),
                                    ],
                                  )
                                : PostWidget(
                                    postWidgetData: postWidgetData,
                                    index: index,
                                  );
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return Column(
                              children: const [
                                SizedBox(height: 25),
                                Divider(color: Colors.grey, thickness: 1),
                                SizedBox(height: 25),
                              ],
                            );
                          },
                        ),
                        Visibility(
                          // visible: (state.status == Status.loadingNextPage),
                          child: SizedBox(
                            height: 120,
                            child: Column(
                              children: [
                                const SizedBox(height: 50),
                                Row(
                                  children: const [
                                    Spacer(),
                                    Text(
                                      'Loading NextPage',
                                      style: TextStyle(),
                                    ),
                                    Spacer(),
                                    CircularProgressIndicator(
                                      color: AppColors.primaryColor,
                                    ),
                                    Spacer(),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }),

        //floatingActionButton: FloatingActionButton(onPressed: (){},),
      );
    });
  }

  Container searchBox(Size mq) {
    return Container(
      height: 35,
      width: mq.width * 0.5,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: const [
          SizedBox(
            width: 10,
          ),
          Icon(
            Icons.search,
            size: 20,
            color: Colors.grey,
          ),
          SizedBox(
            width: 10,
          ),
          Text(
            "Search",
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
