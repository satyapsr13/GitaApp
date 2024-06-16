import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gita/Presentation/Screens/SeriesPosts/GitsGyanScreens/gita_sloke_main_screen.dart';
import 'package:logger/logger.dart';

import '../../Constants/locations.dart';
import '../../Logic/Cubit/Posts/posts_cubit.dart';
import '../../Logic/Cubit/StickerCubit/sticker_cubit.dart';
import '../../Logic/Cubit/user_cubit/user_cubit.dart';
import '../app.dart';
import 'TagsScreen/specific_tags_screen.dart';
import 'home_screen_with_navigation.dart';
import 'language_selection_screen.dart';
import 'specific_category_screen.dart';

class SplashScreen extends StatefulWidget {
  final bool isLoggedIn;
  final RemoteMessage? notificationFromFirebase;
  const SplashScreen({
    Key? key,
    required this.isLoggedIn,
    this.notificationFromFirebase,
  }) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Logger().i(widget.isLoggedIn);
    // if (widget.isLoggedIn == true) {
    //    BlocProvider.of<PostCubit>(context).fetchNextPagePosts(0);
    // }

    // BlocProvider.of<StickerCubit>(context).syncActiveFrameById();
    // if (BlocProvider.of<StickerCubit>(context, listen: false)
    //     .state
    //     .listOfFrames
    //     .isEmpty) {
    //   BlocProvider.of<StickerCubit>(context).fetchFrames();
    // }

    Timer(const Duration(seconds: 2), () async {
      if (widget.notificationFromFirebase != null) {
        await MyApp.navigatorKey.currentState
            ?.pushReplacement(MaterialPageRoute(builder: (context) {
          String title =
              widget.notificationFromFirebase!.data['title'] ?? "Motivational";
          String id = widget.notificationFromFirebase!.data['id'] ?? "1";
          String keyWord = widget.notificationFromFirebase!.data['keyword'] ??
              "good-morning";

          if (keyWord.isEmpty) {
            return SpecificCategoryScreen(
              categoryTitleEnglish: title,
              categoryTitleHindi: title,
              postId: id,
            );
          } else {
            return SpecificTagsScreen(
              categoryTitleEnglish: title,
              categoryTitleHindi: title,
              postKeyword: keyWord,
            );
          }
          // }
        }));
      } else {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return (widget.isLoggedIn != true)
              ? const GitagyanMainScreen()
              : const GitagyanMainScreen();
        })).then((value) {});
      }
    });
    // BlocProvider.of<UserCubit>(context).recoverFromLocalStorage();
    // if (widget.isLoggedIn == true) {
    //   if ((BlocProvider.of<UserCubit>(context, listen: false).state.userId <
    //           1) ||
    //       (BlocProvider.of<UserCubit>(context, listen: false)
    //               .state
    //               .againUpdateProfileUrlInServer ==
    //           true)) {
    //     BlocProvider.of<UserCubit>(context).getProfileData();
    //   }
    //   BlocProvider.of<UserCubit>(context).loadImageAndName();
    //   if (BlocProvider.of<UserCubit>(context, listen: false)
    //       .state
    //       .savedPostList
    //       .isEmpty) {
    //     BlocProvider.of<UserCubit>(context).savedPostDbOperations();
    //   }
    // } 
    // BlocProvider.of<StickerCubit>(context).fetchStickers();
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    return Scaffold(
        body: Container(
      width: mq.width,
      height: mq.height,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xff233554),
            Color(0xff0a192f),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: [0, 1],
        ),
      ),
      child: SizedBox(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: mq.width * 0.26,
              height: mq.width * 0.26,
              child: Image.asset(
                AppImages.gradientLogo,
              ),
            ),
            SizedBox(
              width: mq.width * 0.45,
              height: mq.width * 0.45,
              child: Image.asset(AppImages.rishteyTag),
            ),
          ],
        ),
      ),
    ));
  }
}
