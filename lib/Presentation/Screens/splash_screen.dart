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
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return (widget.isLoggedIn != true)
            ? const GitagyanMainScreen()
            : const GitagyanMainScreen();
      })).then((value) {});
      // if (widget.notificationFromFirebase != null) {
      //   await MyApp.navigatorKey.currentState
      //       ?.pushReplacement(MaterialPageRoute(builder: (context) {
      //     String title =
      //         widget.notificationFromFirebase!.data['title'] ?? "Motivational";
      //     String id = widget.notificationFromFirebase!.data['id'] ?? "1";
      //     String keyWord = widget.notificationFromFirebase!.data['keyword'] ??
      //         "good-morning";

      //     if (keyWord.isEmpty) {
      //       return SpecificCategoryScreen(
      //         categoryTitleEnglish: title,
      //         categoryTitleHindi: title,
      //         postId: id,
      //       );
      //     } else {
      //       return SpecificTagsScreen(
      //         categoryTitleEnglish: title,
      //         categoryTitleHindi: title,
      //         postKeyword: keyWord,
      //       );
      //     }
      //     // }
      //   }));
      // } else {

      // }
    });
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    return Container(
      width: mq.width,
      height: mq.height,
      child: Image.asset(
        AppImages.splashsscreen,
        fit: BoxFit.cover,
      ),
    );
  }
}
