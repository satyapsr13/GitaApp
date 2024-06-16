// ignore_for_file: deprecated_member_use

import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:share_plus/share_plus.dart';

import '../../../Constants/enums.dart';
import '../../../Data/repositories/user_repository.dart';
import '../../../Presentation/Ads/admob_services.dart';
import '../user_cubit/user_cubit.dart';

part 'admob_ads_state.dart';

class AdmobCubit extends Cubit<AdmobState> {
  // FacebookAdsCubit(super.state);

  final UserRepository userRepository;
  final UserCubit userCubit;
  AdmobCubit({
    // required this.localeRepository,
    required this.userRepository,
    required this.userCubit,
  }) : super(AdmobState());
  Future<void> initializeAds() async {
    if (kDebugMode || userCubit.state.isPremiumUser == true) {
      return;
    }
    loadRewardedVideoAd();
    loadInterstitialAd();
  }

  Future<void> showAd() async {
    // if (kDebugMode ) {
    // if (kDebugMode || userCubit.state.isPremiumUser == true) {
    //   return;
    // }
    // if (state.rewardedAd != null) {
    //   state.rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
    //       onAdShowedFullScreenContent: (ad) {},
    //       onAdImpression: (ad) async {},
    //       onAdDismissedFullScreenContent: (ad) async {
    //         ad.dispose();
    //       },
    //       onAdClicked: (ad) async {},
    //       onAdFailedToShowFullScreenContent: (ad, error) async {},
    //       onAdWillDismissFullScreenContent: (ad) {});
    //   state.rewardedAd!.show(onUserEarnedReward: (ad, reward) {}).then((value) {
    //     emit(state.copyWith(rewardedAdStatus: AdStatus.videoComplete));
    //     loadRewardedVideoAd();
    //   });
    //   // rewardedAd = null;
    // } else {
    //   if (state.interstitialAd != null) {
    //     // log('Warning: attempt to show interstitial before loaded.');

    //     state.interstitialAd!.fullScreenContentCallback =
    //         FullScreenContentCallback(
    //       onAdDismissedFullScreenContent: (InterstitialAd ad) {
    //         // log('$ad onAdDismissedFullScreenContent.');
    //         ad.dispose();
    //         // loadInterstitialAd();
    //       },
    //       onAdFailedToShowFullScreenContent:
    //           (InterstitialAd ad, AdError error) {
    //         // log('$ad onAdFailedToShowFullScreenContent: $error');
    //         ad.dispose();
    //       },
    //     );
    //     state.interstitialAd!.show().then((value) {
    //       loadInterstitialAd();
    //     });
    //     // interstitialAd = null;
    //   }
    // }
  }

  Future<void> loadRewardedVideoAd() async {
    // if (state.status == AdStatus.loaded) {
    //   return;
    // }
    // await RewardedAd.load(
    //     adUnitId: AdmobServices.rewardedAdUnitId!,
    //     request: const AdRequest(),
    //     rewardedAdLoadCallback: RewardedAdLoadCallback(
    //       onAdLoaded: (ad) {
    //         emit(state.copyWith(
    //             rewardedAd: ad, rewardedAdStatus: AdStatus.loaded));
    //       },
    //       onAdFailedToLoad: (error) {
    //         state.rewardedAd = null;
    //         emit(state.copyWith(rewardedAdStatus: AdStatus.error));
    //       },
    //     ));
  }

  Future<void> loadInterstitialAd() async {
    // await InterstitialAd.load(
    //     adUnitId: AdmobServices.interstitialAdUnitId!,
    //     request: const AdRequest(),
    //     adLoadCallback: InterstitialAdLoadCallback(onAdFailedToLoad: (error) {
    //       state.interstitialAd = null;
    //     }, onAdLoaded: (ad) {
    //       emit(state.copyWith(interstitialAd: ad));
    //     }));
  }

  Future<void> shareImage() async {
    await Share.shareFiles([state.imagePath], text: tr('promotion_text'));
  }
}
