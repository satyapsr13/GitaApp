import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdmobServices {
  static String? get bannerAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-7811600246173013/9636026297";
    }
    return null;
  }

  static String? get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return kDebugMode
          ? "ca-app-pub-3940256099942544/1033173712"
          : "ca-app-pub-7811600246173013/5932940228";
    }
    return null;
  }

  static String? get rewardedAdUnitId {
    if (Platform.isAndroid) {
      return kDebugMode
          ? "ca-app-pub-3940256099942544/5224354917"
          : "ca-app-pub-7811600246173013/7825887656";
      // return "ca-app-pub-7811600246173013/7825887656";
    }
    // if (Platform.isIOS) {
    //   return "ca-app-pub-7313426275365718/7879894404";
    // }
    return null;
  }

  //  static final BannerAdListener bannerAdListener =
  //     BannerAdListener(onAdLoaded: (ad) {
  //   log("**********Banner Add Loaded successfully************");
  // }, onAdFailedToLoad: (ad, error) {
  //   log("**********Banner Add Loding error [$error]************");
  // }, onAdClicked: (ad) {
  //   log("**********Banner Add Clicked by user************");
  // });
}
