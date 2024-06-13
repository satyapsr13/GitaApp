part of 'admob_ads_cubit.dart';
 

class AdmobState extends Equatable {
  // enum
  final Status status;
  final String imagePath;
  final AdStatus rewardedAdStatus;
  RewardedAd? rewardedAd;
  InterstitialAd? interstitialAd;

  AdmobState({
    this.status = Status.initial,
    this.imagePath = "",
    this.rewardedAdStatus = AdStatus.initial,
    this.rewardedAd,
    this.interstitialAd,
  });

  @override
  List<Object?> get props => [
        status,
        imagePath,
        rewardedAdStatus,
        rewardedAd,
        interstitialAd,
      ];

  AdmobState copyWith(
      {String? imagePath,
      Status? status,
      AdStatus? rewardedAdStatus,
      RewardedAd? rewardedAd,
      InterstitialAd? interstitialAd
      // int? coins,

      // List<Categories>? categoriesList,
      }) {
    return AdmobState(
      status: status ?? this.status,
      imagePath: imagePath ?? this.imagePath,
      rewardedAdStatus: rewardedAdStatus ?? this.rewardedAdStatus,
      rewardedAd: rewardedAd ?? this.rewardedAd,
      interstitialAd: interstitialAd ?? this.interstitialAd,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      // 'status': status.index,
      // 'postModeList': postModeList,
    };
  }

  factory AdmobState.fromMap(Map<String, dynamic> map) {
    return AdmobState();
  }

  String toJson() => json.encode(toMap());

  factory AdmobState.fromJson(String source) =>
      AdmobState.fromMap(json.decode(source));
}
