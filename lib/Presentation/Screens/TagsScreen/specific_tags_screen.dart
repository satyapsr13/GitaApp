import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

import '../../../Constants/colors.dart';
import '../../../Constants/constants.dart';
import '../../../Constants/enums.dart';
import '../../../Constants/locations.dart';
import '../../../Data/model/ObjectModels/post_widget_model.dart';
import '../../../Data/services/secure_storage.dart';
import '../../../Logic/Cubit/AdmobCubit/admob_ads_cubit.dart';
import '../../../Logic/Cubit/Posts/posts_cubit.dart';
import '../../../Logic/Cubit/locale_cubit/locale_cubit.dart';
import '../../../Logic/Cubit/user_cubit/user_cubit.dart';
import '../../../Utility/next_screen.dart';
import '../../Ads/banner_admob.dart';
import '../../Widgets/post_widget.dart';
import '../../Widgets/style.dart';
import '../home_screen_with_navigation.dart';
import '../profile.screen.dart'; 
class SpecificTagsScreen extends StatefulWidget {
  // const SpecificTagsScreen({Key? key}) : super(key: key);
  final String categoryTitleHindi;
  final String categoryTitleEnglish;
  final String postKeyword;

  const SpecificTagsScreen({
    Key? key,
    required this.categoryTitleHindi,
    required this.categoryTitleEnglish,
    required this.postKeyword,
  }) : super(key: key);
  @override
  State<SpecificTagsScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<SpecificTagsScreen> {
  Uint8List? image;
  String? photoUrl;
  // Future<void> getImage() async {
  //   // Uint8List? image;
  //   SecureStorage secureStorage = SecureStorage();
  //   String imagePath = await secureStorage.readLocally('PHOTO_URL');
  //   if (imagePath.isNotEmpty) {
  //     image = await File(imagePath).readAsBytes();
  //   }
  //   // photoUrl = await secureStorage.readFromLocalStorage('PROFILE_IMAGE');

  //   setState(() {});
  // }

  int currentPage = 1;
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    pathTracker.add("specific_tags_screen");
    super.initState();
    // checkNotificationPermission();
    // getImage();
    // BlocProvider.of<PostCubit>(context).fetchNextPagePosts(0);
    BlocProvider.of<PostCubit>(context)
        .fetchSimilarTags(tagsKeyword: widget.postKeyword);
    BlocProvider.of<PostCubit>(context).fetchSpecificTagsResponse(
        postKeyword: widget.postKeyword,
        currentPage: 0,
        isNews: widget.postKeyword == "news");
    BlocProvider.of<AdmobCubit>(context).initializeAds();
    _scrollController.addListener(_onScroll);
    // AwesomeNotifications().actionStream.listen((event) {});
  }

  _onScroll() {
    if ((_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent)) {
      Logger().i("fetchSpecificTagsResponse");
      // BlocProvider.of<PostCubit>(context).fetchNextPagePosts(currentPage);
      BlocProvider.of<PostCubit>(context).fetchSpecificTagsResponse(
          postKeyword: widget.postKeyword,
          currentPage: currentPage,
          isNews: widget.postKeyword == "news");

      // currentPage++;
    }
    // show facebook ads when screen is half scroll
  }

  static bool canPop(BuildContext context) {
    final NavigatorState? navigator = Navigator.maybeOf(context);
    return navigator != null && navigator.canPop();
  }

  // _createRewardedVideoAd() {
  //   RewardedAd.load(
  //       adUnitId: AdmobServices.rewardedAdUnitId!,
  //       request: const AdRequest(),
  //       rewardedAdLoadCallback: RewardedAdLoadCallback(
  //         onAdLoaded: (ad) {
  //           rewardedAd = ad;
  //         },
  //         onAdFailedToLoad: (error) {
  //           rewardedAd = null;
  //         },
  //       ));
  // }

  // _createInterstitialVideoAd() {
  //   InterstitialAd.load(
  //       adUnitId: AdmobServices.interstitialAdUnitId!,
  //       request: const AdRequest(),
  //       adLoadCallback: InterstitialAdLoadCallback(onAdFailedToLoad: (error) {
  //         interstitialAd = null;
  //       }, onAdLoaded: (ad) {
  //         interstitialAd = ad;
  //       }));
  // }

  @override
  void dispose() {
    // TODO: implement dispose
    pathTracker.removeLast();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    return BlocBuilder<LocaleCubit, LocaleState>(builder: (context, state) {
      return Scaffold(
        drawerEdgeDragWidth: mq.width * 0.2,
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.black),
          backgroundColor: Colors.white,
          leading: IconButton(
              onPressed: () {
                if (canPop(context)) {
                  Navigator.pop(context);
                } else {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => NavigationWrapper()));
                }
              },
              icon: const Icon(
                Icons.arrow_back_ios,
                size: 20,
                color: Colors.black,
              )),
          title: Text(
            tr("_a_") == "A"
                ? widget.categoryTitleEnglish
                : widget.categoryTitleHindi,
            style: const TextStyle(color: Colors.black),
          ),
          elevation: 0,
          actions: [
            // profileButton(context),
          ],
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
            return SizedBox(
              width: mq.width,
              height: mq.height,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: mq.height * 0.3),
                  const Text(
                    'Please try again!\n\n',
                    style: TextStyle(),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      BlocProvider.of<PostCubit>(context)
                          .fetchSpecificTagsResponse(
                              postKeyword: widget.postKeyword,
                              currentPage: 0,
                              isNews: widget.categoryTitleEnglish == "News");
                    },
                    child: const Text(
                      'Reload',
                      textAlign: TextAlign.center,
                      style: TextStyle(),
                    ),
                  ),
                  const Expanded(child: SizedBox()),
                  BannerAdmob(),
                ],
              ),
            );
          }

          currentPage = state.forYouPageNo + 1;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
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
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: state.specificTagList.length + 1,
                      itemBuilder: (ctx, index) {
                        if (index >= state.specificTagList.length) {
                          return const NextPageLoader();
                        }

                        PostWidgetModel postWidgetData =
                            state.convertPostModelToPostWidgetModel(
                                state.specificTagList[index],
                                index: index,
                                showName: state.isNameVisible,
                                showProfile: state.isProfileVisible);
                        return (index + 1) % 8 == 0
                            ? Column(
                                children: [
                                  PostWidget(
                                    postWidgetData: postWidgetData,
                                    parentScreenName: tr("_a_") == "A"
                                        ? widget.categoryTitleEnglish
                                        : widget.categoryTitleHindi,
                                    index: index,
                                  ),
                                  // BannerAd(size: size, adUnitId: adUnitId, listener: listener, request: request)
                                  const SizedBox(height: 10),
                                  BannerAdmob(),
                                ],
                              )
                            : PostWidget(
                                postWidgetData: postWidgetData,
                                parentScreenName: tr("_a_") == "A"
                                    ? widget.categoryTitleEnglish
                                    : widget.categoryTitleHindi,
                                index: index,
                              );
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return Column(
                          children: [
                            const SizedBox(height: 20),
                            Divider(
                              color: Colors.grey.withOpacity(0.4),
                              thickness: 1,
                            ),
                            const SizedBox(height: 20),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      );
    });
  }

  Padding profileButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          nextScreen(context, const ProfileScreen());
        },
        child: SizedBox(
          height: 35,
          width: 35,
          child: CircleAvatar(
            radius: 50,
            backgroundColor: Colors.white,
            child: BlocBuilder<UserCubit, UserState>(builder: (context, state) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: state.fileImagePath.isEmpty
                    ? Image.asset(
                        AppImages.addImageIcon,
                        fit: BoxFit.cover,
                      )
                    : Image.file(File(state.fileImagePath)),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class NextPageLoader extends StatelessWidget {
  const NextPageLoader({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: Column(
        children: [
          const SizedBox(height: 50),
          Row(
            children: const [
              Spacer(),
              CircularProgressIndicator(
                color: AppColors.primaryColor,
              ),
              Spacer(),
            ],
          ),
        ],
      ),
    );
  }
}
