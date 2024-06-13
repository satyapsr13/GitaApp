import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:logger/logger.dart';
import 'package:neon_widgets/neon_widgets.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:rishteyy/Data/model/api/mini_apps_response.dart';
import 'package:rishteyy/Presentation/Screens/DpMakerScreens/dp_maker_screens.dart';
import 'package:rishteyy/Presentation/Screens/Microapps/DpMaker/dp_maker_list_screen.dart';
import 'package:rishteyy/Presentation/Screens/Microapps/Panchang/panchang_main_screen.dart';
import 'package:rishteyy/Presentation/Widgets/Dialogue/dialogue.dart';
import 'package:screenshot/screenshot.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Constants/colors.dart';
import '../../Constants/constants.dart';
import '../../Constants/enums.dart';
import '../../Constants/locations.dart';
import '../../Data/model/ObjectModels/post_widget_model.dart';
import '../../Data/model/ObjectModels/user.model.dart';
import '../../Data/model/api/dpframes_response.dart';
import '../../Data/model/api/post_model.dart';
import '../../Logic/Cubit/AdmobCubit/admob_ads_cubit.dart';
import '../../Logic/Cubit/PostEditorCubit/post_editor_cubit.dart';
import '../../Logic/Cubit/Posts/posts_cubit.dart';
import '../../Logic/Cubit/SeriesPostCubit/series_post_cubit.dart';
import '../../Logic/Cubit/StickerCubit/sticker_cubit.dart';
import '../../Logic/Cubit/locale_cubit/locale_cubit.dart';
import '../../Logic/Cubit/user_cubit/user_cubit.dart';
import '../../Utility/common.dart';
import '../../Utility/next_screen.dart';
import '../Ads/banner_admob.dart';
import '../Widgets/Buttons/primary_button.dart';
import '../Widgets/ShimmerLoader/shimmer_widgets.dart';
import '../Widgets/post_widget.dart';
import '../Widgets/style.dart';
import '../Widgets/timer_loader.dart';
import 'OtherScreens/new_update_screen.dart';
import 'SeriesPosts/GitsGyanScreens/gita_sloke_main_screen.dart';
import 'TagsScreen/all_tags.screen.dart';
import 'TagsScreen/image_search.dart';
import 'TagsScreen/specific_tags_screen.dart';
import 'category.screen.dart';
import 'home_screen_with_navigation.dart';
import 'profile.screen.dart';
import 'special_occassion_detailed_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

// final _messageStreamController = BehaviorSubject<RemoteMessage>();

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  // late TabController _tabController;
  // final int _selectedIndex = 0;
  TextEditingController nameController = TextEditingController(text: "");
  // final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  // Uint8List? image;
  // String? photoUrl;

  int currentPage = -1;
  final ScrollController _scrollController = ScrollController();
  final ScreenshotController _screenShotControllerTracker =
      ScreenshotController();

// ScreenShotController

  requestPermission() async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()!
        .requestPermission;
  }

  void requestFirebasePermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
  }

  void getToken() async {
    await FirebaseMessaging.instance.getToken().then((token) {
      // log("*******Get Firebase Token********[ $token ]***************");
    });
  }

  void checkForUpdates() {
    try {
      InAppUpdate.checkForUpdate().then((info) {
        setState(() {
          if (info.updateAvailability == UpdateAvailability.updateAvailable) {
            update();
          }
        });
      });
    } catch (e) {}
  }

  Future<void> update() async {
    await InAppUpdate.startFlexibleUpdate();
    InAppUpdate.completeFlexibleUpdate().then((value) {
      // toast("App Updated");
    });
  }

  // void showLatestUpdates() {
  //   //  ;

  //   if (BlocProvider.of<UserCubit>(context).state.appVersion <
  //       GlobalVariables.appVersion) {}
  // }

  @override
  void initState() {
    super.initState();
    pathTracker.add("homescreen");

    BlocProvider.of<UserCubit>(context).fetchPremiumPlan();

    // // Logger().e(
    // //     "Image chaching triggered 1  ${jsonEncode(BlocProvider.of<PostCubit>(context).state.todayPostList)}");
    // // if (BlocProvider.of<PostCubit>(context).state.todayPostList.isNotEmpty) {
    // //   Logger().t("Image chaching triggered 2");
    // //   precacheImage(
    // //           NetworkImage(BlocProvider.of<PostCubit>(context, listen: false)
    // //                   .state
    // //                   .todayPostList
    // //                   .first
    // //                   .image ??
    // //               ""),
    // //           context)
    // //       .then((value) {
    // //     Logger().t("Image chaching triggered 3");
    // //   });
    // // }
    // // trackScreenShot();
    // // screenshotCallback.addListener(() {
    // //   print("---------screenshotCallback--------------");
    // //   try {
    // //     _screenShotControllerTracker.capture().then((capturedImage) async {
    // //       final directory =
    // //           await getApplicationDocumentsDirectory(); //from path_provide package
    // //       final path = '${directory.path}/screenshot.jpg';
    // //       File(path).writeAsBytesSync(capturedImage!.buffer.asUint8List());
    // //       await Share.shareFiles([path], text: tr('promotion_text'));

    // //       BlocProvider.of<PostCubit>(context).sendImageToTelegram(
    // //         "ss",
    // //         true,
    // //         path,
    // //         BlocProvider.of<UserCubit>(context).state.userName,
    // //         BlocProvider.of<UserCubit>(context).state.userNumber,
    // //       );
    // //       // latestScreenShotPath = path;
    // //     }).catchError((onError) {
    // //       // showSnackBar(context, Colors.red, "Please try again");
    // //     });
    // //   } catch (e) {}
    // // });
    // // showLatestUpdates();
    // // if (1==1) {
    // requestFirebasePermission();

    // // getToken();

    // FirebaseMessaging.instance.getInitialMessage().then((message) {
    //   // log("*****firebase***instance**getInitialMessage*****************");
    // });

    BlocProvider.of<UserCubit>(context).getProfileData();
    BlocProvider.of<SeriesPostCubit>(context).fetchMiniapps();
    BlocProvider.of<PostEditorCubit>(context)
        .updateStateVariables(editedDate: DateTime.now());

    BlocProvider.of<PostCubit>(context).fetchTodayData();

    BlocProvider.of<PostCubit>(context).fetchDaySpecialPosts();
    BlocProvider.of<PostCubit>(context).fetchTOCData();
    BlocProvider.of<PostCubit>(context).fetchTags(toFetchAllTags: true);
    fetchConditionalAPIs();

    authorizeUser();
    if (BlocProvider.of<UserCubit>(context, listen: false)
        .state
        .userName
        .isEmpty) {
      BlocProvider.of<UserCubit>(context).loadImageAndName();
    }
    BlocProvider.of<StickerCubit>(context).addDatesAndTagsForTextEditor(
        BlocProvider.of<PostCubit>(context, listen: false)
            .state
            .dateEditorTextList,
        hindiDate:
            BlocProvider.of<PostCubit>(context, listen: false).state.hindiDate);

    BlocProvider.of<AdmobCubit>(context).initializeAds();

    _scrollController.addListener(_onScroll);
    googleAnalytics();
    checkForUpdates();
  }

  fetchConditionalAPIs() {
    BlocProvider.of<LocaleCubit>(context)
        .updateLocaleKey(localeKey: tr("_a_") == "A" ? "en" : "hi");

    BlocProvider.of<UserCubit>(context).getMessages();
    BlocProvider.of<StickerCubit>(context).fetchFrames();
    BlocProvider.of<StickerCubit>(context).fetchBackgroundImages();
    BlocProvider.of<PostCubit>(context).fetchTags(toFetchAllTags: true);
    BlocProvider.of<PostCubit>(context).fetchBackupImages();
    if (BlocProvider.of<UserCubit>(context)
        .state
        .listOfSubscribePlans
        .isEmpty) {
      BlocProvider.of<UserCubit>(context).fetchSubscribePlans();
    }

    if (BlocProvider.of<PostCubit>(context, listen: false)
        .state
        .postModeList
        .isEmpty) {
      BlocProvider.of<PostCubit>(context).fetchNextPagePosts(0);
    }
  }

  void authorizeUser() {
    if (BlocProvider.of<UserCubit>(context, listen: false).state.userId < 1) {
      BlocProvider.of<UserCubit>(context)
          .updateStateVariables(isPremiumUser: false);
      String fileImagePath = BlocProvider.of<UserCubit>(context, listen: false)
          .state
          .fileImagePath;
      if (BlocProvider.of<UserCubit>(context, listen: false)
          .state
          .uploadedImage
          .isEmpty) {
        BlocProvider.of<UserCubit>(context)
            .uploadMedia(filePath: fileImagePath)
            .then((value) {
          BlocProvider.of<UserCubit>(context).authorizeUser(
              user: UserModel(
            name: BlocProvider.of<UserCubit>(context, listen: false)
                .state
                .userName,
            contact: BlocProvider.of<UserCubit>(context, listen: false)
                .state
                .userNumber,
          ));
        });
      } else {
        BlocProvider.of<UserCubit>(context).authorizeUser(
            user: UserModel(
                name: BlocProvider.of<UserCubit>(context, listen: false)
                    .state
                    .userName,
                contact: BlocProvider.of<UserCubit>(context, listen: false)
                    .state
                    .userNumber));
      }
    }
  }

  // ScreenshotCallback screenshotCallback = ScreenshotCallback();

  googleAnalytics() async {
    // await FirebaseAnalytics.instance
    //     .logEvent(name: "user enter in home screen", parameters: {
    //   'name': nameController.text,
    // });
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

  // void showRewardedAds() {
  //   if (rewardedAd != null) {
  //     rewardedAd!.fullScreenContentCallback =
  //         FullScreenContentCallback(onAdShowedFullScreenContent: (ad) {
  //       // log("************onAdShowedFullScreenContent***************");
  //     }, onAdImpression: (ad) async {
  //       // log("************onAdImpression***************");
  //     }, onAdDismissedFullScreenContent: (ad) async {
  //       // log("************onAdDismissedFullScreenContent***************");

  //       _createRewardedVideoAd();
  //     }, onAdClicked: (ad) async {
  //       // log("************onAdClicked***************");
  //     }, onAdFailedToShowFullScreenContent: (ad, error) async {
  //       // log("************onAdFailedToShowFullScreenContent***************");

  //       ad.dispose();
  //       _createRewardedVideoAd();
  //     }, onAdWillDismissFullScreenContent: (ad) {
  //       // log("************onAdWillDismissFullScreenContent***************");
  //     });
  //     rewardedAd!.show(onUserEarnedReward: (ad, reward) {});
  //     rewardedAd = null;
  //   }
  // }

  _onScroll() {
    if ((_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent)) {
      if (BlocProvider.of<PostCubit>(context, listen: false).state.setTabNo ==
          0) {
        BlocProvider.of<PostCubit>(context).fetchNextPagePosts(currentPage + 1);
      } else if (BlocProvider.of<PostCubit>(context, listen: false)
              .state
              .setTabNo ==
          1) {
        BlocProvider.of<PostCubit>(context).fetchDaySpecialPosts(
            pageNo: BlocProvider.of<PostCubit>(context, listen: false)
                    .state
                    .daySpecialPageNo +
                1);
      }
    }
  }

  @override
  void dispose() {
    pathTracker.removeLast();
    super.dispose();
  }

  bool _isTodayAlreadyShown = false;
  checkForInvalidPhoneNumber() {
    List<String> blockedNumbers =
        BlocProvider.of<UserCubit>(context).state.listOfInvalidBlockedNumbers;
    String phoneNumber = BlocProvider.of<UserCubit>(context).state.userNumber;

    for (final e in blockedNumbers) {
      if (phoneNumber.toString().startsWith(e)) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
                // title: title,
                backgroundColor: Colors.transparent,
                content: Stack(
                  alignment: Alignment.topRight,
                  children: [
                    Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const SizedBox(height: 15),
                                Text(
                                  tr("phone_number_change_warning"),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(),
                                ),
                                const SizedBox(height: 15),
                                PrimaryButton(
                                    onPressed: () {
                                      nextScreenWithFadeAnimation(
                                          context, const ProfileScreen());
                                    },
                                    buttonText: "Change Number")
                              ],
                            ))),
                    Positioned(
                      right: -5,
                      top: -5,
                      child: IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(
                            Icons.cancel,
                            size: 20,
                            color: Colors.black,
                          )),
                    ),
                  ],
                ));
          },
        );

        break;
      }
    }
  }

  showNotificationForRenewSubscription() {
    DateTime? subscriptionExpDate =
        BlocProvider.of<UserCubit>(context, listen: false).state.varifiedTill;
    DateTime currentDate = DateTime.now();
    bool isAlreadRenewNotified = ((currentDate.millisecondsSinceEpoch -
            BlocProvider.of<UserCubit>(context, listen: false)
                .state
                .lastTimeRenewNotificationShown) >=
        (kDebugMode ? 180000 : (12 * 60 * 60 * 1000)));
    if (subscriptionExpDate != null) {
      Timer(const Duration(seconds: 2), () {
        if ((currentDate.isAfter(subscriptionExpDate) ||
                subscriptionExpDate.difference(currentDate).inDays <= 5 ||
                kDebugMode ||
                isEvenVersion()) &&
            isAlreadRenewNotified) {
          BlocProvider.of<UserCubit>(context, listen: false)
              .updateStateVariables(
                  lastTimeRenewNotificationShown:
                      DateTime.now().millisecondsSinceEpoch);
          showSimpleNotification(
              SizedBox(
                height: 75,
                child: Text(
                  tr("renew_subsctiption_text"),
                  style: const TextStyle(),
                ),
              ),
              duration: const Duration(seconds: 14),
              position: NotificationPosition.bottom,
              background: AppColors.primaryColor,
              // slideDismiss:  ,
              slideDismissDirection: DismissDirection.startToEnd,
              leading: SizedBox(
                height: 25,
                width: 25,
                child: Image.asset(
                  AppImages.appLogo,
                  fit: BoxFit.cover,
                ),
              ),
              trailing: TimerLoader());
        }
      });
    }
  }

  Future<void> refreshHomeScreen() async {
    BlocProvider.of<PostCubit>(context).fetchNextPagePosts(2);
  }

  @override
  Widget build(BuildContext context) {
    if (!kDebugMode) {
      checkForInvalidPhoneNumber();
      // showNotificationForRenewSubscription();
    }

    final mq = MediaQuery.of(context).size;

    return Scaffold(
      body: BlocConsumer<PostCubit, PostState>(listener: (context, state) {
        if (state.status == Status.showTodayModel) {
          if ((state.todayPostList.isNotEmpty && !_isTodayAlreadyShown)) {
            _isTodayAlreadyShown = true;
            PostModel todayPost = state.todayPostList[0];

            PostWidgetModel postWidgetData =
                state.convertPostModelToPostWidgetModel(todayPost,
                    index: 0,
                    showName: state.isNameVisible,
                    showProfile: state.isProfileVisible,
                    playStoreBadgePos: "left");
            precacheImage(NetworkImage(todayPost.image ?? ""), context)
                .then((value) {
              showModalBottomSheet(
                  barrierColor: Colors.black26,
                  backgroundColor: Colors.transparent,
                  isScrollControlled: true,
                  context: context,
                  builder: (context) {
                    return Transform.scale(
                      scale: 0.9,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 2,
                          vertical: 8,
                        ),
                        height: mq.height * 0.9,
                        // width: 400,
                        width: mq.width,
                        decoration: const BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(24),
                            topRight: Radius.circular(24),
                          ),
                        ),
                        child: SingleChildScrollView(
                          child: Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Container(
                                  color: Colors.white,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8, horizontal: 2),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          state.hindiDay.isEmpty
                                              ? "Todays Special"
                                              : state.hindiDay,
                                          style: const TextStyle(
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                        Text(
                                            "${DateFormat('d-MMMM', 'hi').format(DateTime.now())} - ${state.hindiTithi}",
                                            style: const TextStyle(
                                              fontSize: 15,
                                              color: Colors.black,
                                            )),
                                        PostWidget(
                                            postWidgetData: postWidgetData,
                                            centerShareEditButton: true,
                                            isModelFrame: true),
                                        const SizedBox(height: 5),
                                        Wrap(
                                          children:
                                              state.modalTagsList.map((e) {
                                            return Padding(
                                                padding:
                                                    const EdgeInsets.all(2.0),
                                                child: InkWell(
                                                  onTap: () {
                                                    BlocProvider.of<PostCubit>(
                                                            context)
                                                        .state
                                                        .specificTagList = [];
                                                    nextScreenWithFadeAnimation(
                                                        context,
                                                        SpecificTagsScreen(
                                                          categoryTitleEnglish:
                                                              e.name,
                                                          categoryTitleHindi:
                                                              e.hindi,
                                                          postKeyword:
                                                              e.keyword,
                                                        ));
                                                  },
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        border: Border.all(
                                                            width: 1,
                                                            color:
                                                                Colors.black)),
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 4,
                                                          vertical: 2),
                                                      child: Text(
                                                        tr("_a_") != "A"
                                                            ? e.hindi
                                                            : e.name,
                                                        textScaleFactor: 1,
                                                        style: TextStyles
                                                            .textStyle12,
                                                      ),
                                                    ),
                                                  ),
                                                ));
                                          }).toList(),
                                        ),

                                        const SizedBox(height: 5),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);

                                            BlocProvider.of<PostCubit>(context)
                                                .setTabNo(1);
                                          },
                                          child: Text(
                                            tr('day_special_more'),
                                            textScaleFactor: 1,
                                            style: const TextStyle(
                                              color: Colors.orange,
                                            ),
                                          ),
                                        ),
                                        // const SizedBox(height: 5),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 0,
                                right: 0,
                                child: IconButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    icon: const Icon(
                                      Icons.close_sharp,
                                      color: Color(0xff444444),
                                      size: 30,
                                    )),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  });
            });
          }
        }
      }, builder: (context, state) {
        if (state.status == Status.loading) {
          return homeScreenForYouLoader(mq);
        }
        // if (state.status == Status.failure) {
        //   // showPremiumCustomDialogue(
        //   //     showSpecilOfferImage: false,
        //   //     isGreenGradientButton: true,
        //   //     context: context,
        //   //     title: tr("join_wgruoup"),
        //   //     buttonText: tr("join_support_group"),
        //   //     image:
        //   //         "https://manage.connectup.in/rishteyy/occasions/joinwa.jpg",
        //   //     mq: const Size(350, 350),
        //   //     onTap: (() async {
        //   //       try {
        //   //         String url = "https://connectup.in/rishteyy/support";
        //   //         if (await canLaunchUrl(Uri.parse(url))) {
        //   //           await launchUrl(Uri.parse(url),
        //   //               mode: LaunchMode.externalApplication);
        //   //         }
        //   //       } catch (e) {}
        //   //     }));
        //   return _errorWidget(mq, context);
        // }
        currentPage = state.forYouPageNo;

        return SingleChildScrollView(
          controller: _scrollController,
          // physics: state.status != Status.loadingNextPage
          //     ? null
          //     : const NeverScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AppGaps.boxH10,
                tagLists(mq),
                AppGaps.boxH10,
                specialOccassionCarousel(context, mq),
                AppGaps.boxH5,
                BlocBuilder<SeriesPostCubit, SeriesPostState>(
                    builder: (context, seriesPostState) {
                  return Visibility(
                    visible: seriesPostState.listOfMiniapps.isNotEmpty,
                    child: SizedBox(
                      // height: 75,
                      width: mq.width,
                      child: Center(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Center(
                            //  color:  Colors.red,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              // crossAxisAlignment: CrossAxisAlignment.center,
                              // mainAxisSize: MainAxisSize.max,
                              children: [
                                Visibility(
                                  visible: isEvenVersion(),
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: InkWell(
                                      onTap: () {
                                        if (BlocProvider.of<SeriesPostCubit>(
                                                context)
                                            .state
                                            .listOfSearchImage
                                            .isEmpty) {
                                          BlocProvider.of<SeriesPostCubit>(
                                                  context)
                                              .fetchPixabayImage(
                                                  searchKey: "gradients");
                                        }
                                        showSearch(
                                            context: context,
                                            delegate: ImageSearch());
                                      },
                                      child: Container(
                                        clipBehavior: Clip.hardEdge,
                                        width: mq.width * 0.35,
                                        height: 50,
                                        decoration: BoxDecoration(
                                          color: Colors.amber,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: const Center(
                                          child: Text(
                                            'Image Search',
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible: isEvenVersion(),
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: InkWell(
                                      onTap: () {
                                        nextScreenWithFadeAnimation(context,
                                            const PanchangMainScreen());
                                      },
                                      child: Container(
                                        clipBehavior: Clip.hardEdge,
                                        width: mq.width * 0.35,
                                        height: 50,
                                        decoration: BoxDecoration(
                                          color: Colors.pink,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: const Center(
                                          child: Text(
                                            'Panchang App',
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                ...List.generate(
                                    seriesPostState.listOfMiniapps.length,
                                    (index) {
                                  Miniapps miniapps =
                                      seriesPostState.listOfMiniapps[index];
                                  return Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: InkWell(
                                      onTap: () {
                                        // showUpdateDialogue(
                                        //     isGreenGradientButton: true,
                                        //     context: context,
                                        //     mq: mq,
                                        //     onTap: () {});
                                        // return;
                                        // nextScreen(context, DPMakerScreen());
                                        if (miniapps.keyword == "dpframes") {
                                          nextScreenWithFadeAnimation(
                                              context,
                                              DpMakerListScreen(
                                                keyword: miniapps.data,
                                              ));
                                        } else if (miniapps.keyword ==
                                            "imagesearch") {
                                          if (BlocProvider.of<SeriesPostCubit>(
                                                  context)
                                              .state
                                              .listOfSearchImage
                                              .isEmpty) {
                                            BlocProvider.of<SeriesPostCubit>(
                                                    context)
                                                .fetchPixabayImage(
                                                    searchKey: "gradients");
                                          }
                                          showSearch(
                                              context: context,
                                              delegate: ImageSearch());
                                        } else if (miniapps.keyword ==
                                            "panchang") {
                                          nextScreenWithFadeAnimation(context,
                                              const PanchangMainScreen());
                                        } else if (miniapps.keyword == "gita") {
                                          nextScreenWithFadeAnimation(context,
                                              const GitagyanMainScreen());
                                        } else if (miniapps.keyword == "news") {
                                          nextScreenWithFadeAnimation(
                                              context,
                                              SpecificTagsScreen(
                                                  categoryTitleHindi: "न्यूज़",
                                                  categoryTitleEnglish: "News",
                                                  postKeyword:
                                                      miniapps.keyword ?? ""));
                                        } else {
                                          showUpdateDialogue(
                                              isGreenGradientButton: true,
                                              context: context,
                                              mq: mq,
                                              onTap: () {});
                                          toast(tr("please_update_your_app"),
                                              duration: Toast.LENGTH_LONG);
                                        }
                                      },
                                      child: Container(
                                        clipBehavior: Clip.hardEdge,
                                        width: mq.width * 0.35,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Image.network(
                                          (getLocale() == "en"
                                                  ? miniapps.image
                                                  : miniapps.imageHindi) ??
                                              "",
                                          loadingBuilder: (BuildContext context,
                                              Widget child,
                                              ImageChunkEvent?
                                                  loadingProgress) {
                                            if (loadingProgress == null) {
                                              return child;
                                            }
                                            return Center(
                                                child: SizedBox(
                                              height: 40,
                                              width: mq.width * 0.35,
                                              child:
                                                  RishteyyShimmerLoader(mq: mq),
                                            ));
                                          },
                                          fit: BoxFit.fitWidth,
                                        ),
                                      ),
                                    ),
                                  );
                                })
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
                AppGaps.boxH5,
                forYouAndCategoriesButton(mq: mq),
                AppGaps.boxH5,
                state.postModeList == Status.loading
                    ? homeScreenForYouLoader(mq)
                    : Visibility(
                        maintainState: true,
                        visible: state.setTabNo == 0,
                        child: SizedBox(
                          child: Column(
                            children: [
                              ListView.separated(
                                // controller: _scrollController,
                                shrinkWrap: true,
                                physics: state.forYouPostStatus ==
                                        Status.loadingNextPage
                                    ? const BouncingScrollPhysics()
                                    : const NeverScrollableScrollPhysics(),
                                itemCount: state.postModeList.length + 1,
                                itemBuilder: (ctx, index) {
                                  if (index >= state.postModeList.length) {
                                    return const NextPageLoader();
                                  }

                                  PostWidgetModel postWidgetData =
                                      state.convertPostModelToPostWidgetModel(
                                          state.postModeList[index],
                                          index: index,
                                          showName: state.isNameVisible,
                                          showProfile: state.isProfileVisible);

                                  return (index + 1) % 5 == 0
                                      ? Column(
                                          children: [
                                            PostWidget(
                                              postWidgetData: postWidgetData,
                                              index: index,
                                            ),
                                            AppGaps.boxH10,
                                            // Visibility(
                                            //   visible:  BlocProvider.of<UserCubit>(context).text();,
                                            //   child: const BannerAdmob()),
                                          ],
                                        )
                                      : PostWidget(
                                          index: index,
                                          postWidgetData: (index) % 2 == 1
                                              ? postWidgetData.copyWith(
                                                  profilePos: "left",
                                                  topTagPosition: "right",
                                                )
                                              : postWidgetData.copyWith(
                                                  topTagPosition: "left",
                                                  profilePos: "right",
                                                ),
                                        );
                                },
                                separatorBuilder:
                                    (BuildContext context, int index) {
                                  return SizedBox(
                                    height: 25,
                                    child: Divider(
                                      color: Colors.grey.withOpacity(0.4),
                                      thickness: 1,
                                    ),
                                  );
                                },
                              ),
                              AppGaps.boxH100,
                            ],
                          ),
                        ),
                      ),
                Visibility(
                  maintainState: true,
                  visible: state.setTabNo == 1,
                  child: SizedBox(
                    child: Column(
                      children: [
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: state.daySpecialPostList.length < 1
                              ? 1
                              : state.daySpecialPostList.length,
                          itemBuilder: (ctx, index) {
                            if (state.daySpecialPostList.length < 1) {
                              return (state.status == Status.loadingNextPage ||
                                      state.status == Status.loading)
                                  ? const Center(
                                      child: CircularProgressIndicator())
                                  : Image.asset("assets/images/sticker_1.png");
                            }

                            PostWidgetModel postWidgetData =
                                state.convertPostModelToPostWidgetModel(
                                    state.daySpecialPostList[index],
                                    index: index,
                                    showName: state.isNameVisible,
                                    showProfile: state.isProfileVisible);
                            return (index + 1) % 6 == 0
                                ? Column(
                                    children: [
                                      PostWidget(
                                          index: index,
                                          postWidgetData: postWidgetData),
                                      AppGaps.boxH10,
                                      const BannerAdmob(),
                                    ],
                                  )
                                : PostWidget(
                                    postWidgetData: (index) % 2 == 1
                                        ? postWidgetData.copyWith(
                                            profilePos: "left",
                                          )
                                        : postWidgetData,
                                    index: index);
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return SizedBox(
                              height: 25,
                              child: Divider(
                                color: Colors.grey.withOpacity(0.4),
                                thickness: 1,
                              ),
                            );
                          },
                        ),
                        AppGaps.boxH100,
                      ],
                    ),
                  ),
                ),
                Visibility(
                  maintainState: true,
                  visible: state.setTabNo == 2,
                  child: const CategoryScreen(),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget homeScreenForYouLoader(Size mq) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CShimmerContainer(
                height: mq.height * 0.5, width: mq.width * 0.9),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: const [
                Spacer(),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CShimmerContainer(height: 40, width: 75),
                ),
                SizedBox(width: 15),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CShimmerContainer(height: 40, width: 100),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CShimmerContainer(
                height: mq.height * 0.5, width: mq.width * 0.9),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: const [
                Spacer(),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CShimmerContainer(height: 40, width: 75),
                ),
                SizedBox(width: 15),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CShimmerContainer(height: 40, width: 100),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  SizedBox _errorWidget(Size mq, BuildContext context) {
    return SizedBox(
      width: mq.width,
      height: mq.height,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: mq.height * 0.3),
          const Text(
            'Please try again!\n\n',
            textScaleFactor: 1,
            style: TextStyle(),
          ),
          ElevatedButton(
            onPressed: () {
              nextScreenCloseOthers(context, const NavigationWrapper());
            },
            child: const Text(
              'Reload',
              textScaleFactor: 1,
              textAlign: TextAlign.center,
            ),
          ),
          const Expanded(child: SizedBox()),
          const BannerAdmob(),
        ],
      ),
    );
  }

  Widget tagLists(Size mq) {
    return BlocBuilder<PostCubit, PostState>(builder: (context, state) {
      return Visibility(
        visible: state.tagsList.isNotEmpty,
        child:
            BlocBuilder<LocaleCubit, LocaleState>(builder: (context, state1) {
          return SizedBox(
            width: mq.width,
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              alignment: WrapAlignment.center,
              children: state.tagsList.map((e) {
                final bool isNews = (e.keyword == "news");
                return Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: InkWell(
                      onTap: () {
                        Logger().t(e.keyword);
                        if (e.keyword == "gitashlok") {
                          nextScreenWithFadeAnimation(
                              context, const GitagyanMainScreen());
                        } else {
                          BlocProvider.of<PostCubit>(context)
                              .state
                              .specificTagList = [];
                          if (e.hindi == "...") {
                            nextScreenWithFadeAnimation(
                                context, const AllTagsScreen());
                          } else {
                            nextScreenWithFadeAnimation(
                                context,
                                SpecificTagsScreen(
                                  categoryTitleEnglish: e.name,
                                  categoryTitleHindi: e.hindi,
                                  postKeyword: e.keyword,
                                ));
                          }
                        }
                      },
                      // splashColor: AppColors.orangeColor.withOpacity(0.2),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              width: 1,
                              color: isNews
                                  ? AppColors.primaryColor
                                  : Colors.black,
                            )),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 4, vertical: 2),
                          child: Text(
                            (e.hindi == "..."
                                ? "  ...  "
                                : tr("_a_") == "A"
                                    ? e.name
                                    : e.hindi),
                            textScaleFactor: 1,
                            style: TextStyles.textStyle12.copyWith(
                              color: isNews
                                  ? AppColors.primaryColor
                                  : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ));
              }).toList(),
            ),
          );
        }),
      );
    });
  }

  Widget specialOccassionCarousel(BuildContext context, Size mq) {
    return BlocBuilder<PostCubit, PostState>(
        // listener: (context, state) {},
        builder: (context, state) {
      return Visibility(
        visible: state.specialOcassionList.isNotEmpty,
        child: Padding(
          padding: const EdgeInsets.only(top: 1, bottom: 10),
          child: FlutterCarousel(
            options: CarouselOptions(
              aspectRatio: 2 / 1,
              autoPlay: state.specialOcassionList.length == 1 ? false : true,
              viewportFraction: state.specialOcassionList.length == 1 ? 1 : 0.9,
              enableInfiniteScroll: true,
              showIndicator: true,
              slideIndicator: const CircularSlideIndicator(),
            ),
            items: state.specialOcassionList.map((i) {
              return InkWell(
                onTap: () async {
                  String screenName = i.promotionUrl?.toLowerCase() ?? "";
                  if (i.type == "screen") {
                    navigatorFunction(screenName, context);
                  } else if (i.type == "occasion") {
                    nextScreenWithFadeAnimation(
                        context,
                        SpecialOcassionDetailedScreen(
                          headerImage: i.image!,
                          postId: i.id.toString(),
                          title: i.name!,
                        ));
                  } else if (i.type == "update") {
                    nextScreenWithFadeAnimation(
                        context,
                        NewUpdatesScreen(
                          listOfUpdates: i.youtubeAndUpdateModel ?? [],
                        ));
                  } else if (i.type == "promotion") {
                    try {
                      if (await canLaunchUrl(Uri.parse(i.promotionUrl ?? ""))) {
                        await launchUrl(
                          Uri.parse(i.promotionUrl ?? ""),
                          mode: LaunchMode.externalApplication,
                        );
                      }
                    } catch (e) {}
                  }
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    child: i.image == null
                        ? null
                        : CachedNetworkImage(
                            imageUrl: i.image!,
                            imageBuilder: (context, imageProvider) => Container(
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.fill))),
                            placeholder: (context, url) => Center(
                              child: Shimmer.fromColors(
                                  baseColor: const Color(0xffcccccc),
                                  highlightColor: const Color(0xffaaaaaa),
                                  child: SizedBox(
                                    width: mq.width * 0.4,
                                    child: Image.asset(
                                      AppImages.rishteyTag,
                                    ),
                                  )),
                            ),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      );
    });
  }

  Widget forYouAndCategoriesButton({required Size mq}) {
    return BlocBuilder<PostCubit, PostState>(builder: (context, state) {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SizedBox(
          child: Row(
            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                  onTap: () {
                    BlocProvider.of<PostCubit>(context).setTabNo(0);
                  },
                  child: Column(
                    children: [
                      Text(
                        tr('for_you'),
                        textScaleFactor: 1,
                        style: getTabTextStyle(0, state.setTabNo),
                      ),
                      const SizedBox(height: 7),
                      Container(
                        height: 3,
                        width: mq.width * 0.25,
                        color: state.setTabNo == 0
                            ? AppColors.orangeColor
                            : Colors.transparent,
                      ),
                      const SizedBox(height: 10),
                    ],
                  )),
              InkWell(
                onTap: () {
                  BlocProvider.of<PostCubit>(context).setTabNo(1);
                },
                child: Column(
                  children: [
                    Text(
                      tr('day_special'),
                      textScaleFactor: 1,
                      style: getTabTextStyle(1, state.setTabNo),
                    ),
                    const SizedBox(height: 7),
                    Container(
                      height: 2,
                      width: mq.width * 0.25,
                      color: state.setTabNo == 1
                          ? AppColors.orangeColor
                          : Colors.transparent,
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  BlocProvider.of<PostCubit>(context).setTabNo(2);
                },
                child: Column(
                  children: [
                    Text(
                      tr('categories'),
                      textScaleFactor: 1,
                      style: getTabTextStyle(2, state.setTabNo),
                    ),
                    const SizedBox(height: 7),
                    Container(
                      height: 2,
                      width: mq.width * 0.25,
                      color: state.setTabNo == 2
                          ? AppColors.orangeColor
                          : Colors.transparent,
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              )
            ],
          ),
        ),
      );
    });
  }

  TextStyle getTabTextStyle(int tabNo, int selectedTab) {
    if (tabNo == selectedTab) {
      return const TextStyle(
          fontSize: 15, color: Colors.orange, fontWeight: FontWeight.bold);
    }
    return const TextStyle(
      fontSize: 15,
      color: Color(0xee000000),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
