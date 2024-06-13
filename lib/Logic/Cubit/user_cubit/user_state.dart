part of 'user_cubit.dart';

class UserState extends Equatable {
  // enum
  final Status status;
  final Status leaderboardStatus;
  final Status messageStatus;
  final Status sendMessageStatus;
  final Status userProfileStatus;
  final Status subscriptionPlansStatus;
  final Status paymentStatus;
  final Status getProfileStatus;
  final Status premiumPlanStatus;
  // final int coins;
  final String userName;
  final String loginError;
  final String userOccupation;
  final String userNumber;
  final bool againUpdateProfileUrlInServer;
  final bool isLoggedIn;
  final bool isPremiumUser;
  final bool isAdmin;
  final bool isAddLinkDuringShare;
  final bool isAuthenticatedUser;
  final int appVersion;
  final int userId;
  final int lastMessageId;
  final double userAppRating;
  final String editedName;
  final String uploadedImage;
  final String fileImagePath;
  final PremiumPlan? premiumPlan;
  final LeaderboardData? leaderboardData;
  final Plan? selectedPlan;
  final DateTime? varifiedTill;
  final int lastTimeRenewNotificationShown;
  final List<Categories> categoriesList;
  final List<SavedPost> savedPostList;
  final List<ProfilePhotos> profileImagesList;
  final List<String> listOfInvalidBlockedNumbers;
  final List<SubscribePlanList> listOfSubscribePlans;
  final MessageData? messageData;
  const UserState({
    this.status = Status.initial,
    this.leaderboardStatus = Status.initial,
    this.messageStatus = Status.initial,
    this.sendMessageStatus = Status.initial,
    this.userProfileStatus = Status.initial,
    this.subscriptionPlansStatus = Status.initial,
    this.paymentStatus = Status.initial,
    this.getProfileStatus = Status.initial,
    this.premiumPlanStatus = Status.initial,
    this.userName = "",
    this.userOccupation = "",
    this.loginError = "",
    this.userNumber = "",
    this.lastTimeRenewNotificationShown = 44200000,
    this.againUpdateProfileUrlInServer = true,
    this.isLoggedIn = false,
    this.isAdmin = false,
    this.lastMessageId = -1,
    this.isAuthenticatedUser = false,
    this.isPremiumUser = true,
    this.isAddLinkDuringShare = true,
    this.appVersion = 28,
    this.userId = -1,
    this.userAppRating = 0,
    this.editedName = "",
    this.uploadedImage = "",
    this.fileImagePath = "",
    this.premiumPlan,
    this.leaderboardData,
    this.selectedPlan,
    this.messageData,
    this.varifiedTill,
    this.categoriesList = const [],
    this.listOfSubscribePlans = const [],
    this.listOfInvalidBlockedNumbers = const [],
    this.savedPostList = const [],
    this.profileImagesList = const [],
  });

  @override
  List<Object?> get props => [
        status,
        leaderboardStatus,
        messageData,
        leaderboardData,
        lastMessageId,
        messageStatus,
        sendMessageStatus,
        selectedPlan,
        lastTimeRenewNotificationShown,
        varifiedTill,
        listOfSubscribePlans,
        loginError,
        userProfileStatus,
        subscriptionPlansStatus,
        paymentStatus,
        getProfileStatus,
        premiumPlanStatus,
        premiumPlan,
        isPremiumUser,
        isAddLinkDuringShare,
        userName,
        userOccupation,
        isAdmin,
        userNumber,
        againUpdateProfileUrlInServer,
        isLoggedIn,
        isAuthenticatedUser,
        appVersion,
        userId,
        userAppRating,
        editedName,
        uploadedImage,
        fileImagePath,
        categoriesList,
        savedPostList,
        profileImagesList,
        listOfInvalidBlockedNumbers,
      ];

  UserState copyWith({
    Status? status,
    Status? leaderboardStatus,
    Status? messageStatus,
    Status? sendMessageStatus,
    Status? userProfileStatus,
    Status? subscriptionPlansStatus,
    Status? paymentStatus,
    Status? getProfileStatus,
    MessageData? messageData,
    LeaderboardData? leaderboardData,
    PremiumPlan? premiumPlan,
    Plan? selectedPlan,
    Status? premiumPlanStatus,
    String? userName,
    String? loginError,
    String? userOccupation,
    String? userNumber,
    bool? againUpdateProfileUrlInServer,
    bool? isLoggedIn,
    int? lastTimeRenewNotificationShown,
    int? lastMessageId,
    bool? isAdmin,
    DateTime? varifiedTill,
    bool? isAuthenticatedUser,
    bool? isAddLinkDuringShare,
    bool? isPremiumUser,
    int? appVersion,
    int? userId,
    double? userAppRating,
    String? editedName,
    String? uploadedImage,
    String? fileImagePath,
    List<Categories>? categoriesList,
    List<SavedPost>? savedPostList,
    List<ProfilePhotos>? profileImagesList,
    List<String>? listOfInvalidBlockedNumbers,
    List<SubscribePlanList>? listOfSubscribePlans,
  }) {
    return UserState(
      status: status ?? this.status,
      leaderboardStatus: leaderboardStatus ?? this.leaderboardStatus,
      leaderboardData: leaderboardData ?? this.leaderboardData,
      lastMessageId: lastMessageId ?? this.lastMessageId,
      messageData: messageData ?? this.messageData,
      messageStatus: messageStatus ?? this.messageStatus,
      sendMessageStatus: sendMessageStatus ?? this.sendMessageStatus,
      loginError: loginError ?? this.loginError,
      varifiedTill: varifiedTill ?? this.varifiedTill,
      selectedPlan: selectedPlan ?? this.selectedPlan,
      isAdmin: isAdmin ?? this.isAdmin,
      isAddLinkDuringShare: isAddLinkDuringShare ?? this.isAddLinkDuringShare,
      premiumPlan: premiumPlan ?? this.premiumPlan,
      isPremiumUser: isPremiumUser ?? this.isPremiumUser,
      userProfileStatus: userProfileStatus ?? this.userProfileStatus,
      subscriptionPlansStatus:
          subscriptionPlansStatus ?? this.subscriptionPlansStatus,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      getProfileStatus: getProfileStatus ?? this.getProfileStatus,
      premiumPlanStatus: premiumPlanStatus ?? this.premiumPlanStatus,
      userName: userName ?? this.userName,
      userOccupation: userOccupation ?? this.userOccupation,
      userNumber: userNumber ?? this.userNumber,
      againUpdateProfileUrlInServer:
          againUpdateProfileUrlInServer ?? this.againUpdateProfileUrlInServer,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      isAuthenticatedUser: isAuthenticatedUser ?? this.isAuthenticatedUser,
      appVersion: appVersion ?? this.appVersion,
      userId: userId ?? this.userId,
      userAppRating: userAppRating ?? this.userAppRating,
      editedName: editedName ?? this.editedName,
      uploadedImage: uploadedImage ?? this.uploadedImage,
      fileImagePath: fileImagePath ?? this.fileImagePath,
      categoriesList: categoriesList ?? this.categoriesList,
      savedPostList: savedPostList ?? this.savedPostList,
      profileImagesList: profileImagesList ?? this.profileImagesList,
      listOfSubscribePlans: listOfSubscribePlans ?? this.listOfSubscribePlans,
      lastTimeRenewNotificationShown:
          lastTimeRenewNotificationShown ?? this.lastTimeRenewNotificationShown,
      listOfInvalidBlockedNumbers:
          listOfInvalidBlockedNumbers ?? this.listOfInvalidBlockedNumbers,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'profileImagesList': profileImagesList.map((e) => e.toMap()).toList(),
      'savedPostList': savedPostList.map((e) => e.toMap()).toList(),
      "isLoggedIn": isLoggedIn,
      "userName": userName,
      "lastMessageId": lastMessageId,
      "userOccupation": userOccupation,
      "userNumber": userNumber,
      "uploadedImage": uploadedImage,
      "againUpdateProfileUrlInServer": againUpdateProfileUrlInServer,
      "isAuthenticatedUser": isAuthenticatedUser,
      "appVersion": appVersion,
      "isPremiumUser": isPremiumUser,
      "isAdmin": isAdmin,
      "userId": userId,
      "userAppRating": userAppRating,
      'listOfInvalidBlockedNumbers': listOfInvalidBlockedNumbers,
      'lastTimeRenewNotificationShown': lastTimeRenewNotificationShown,
      'premiumPlan': premiumPlan?.toMap(),
    };
  }

  factory UserState.fromMap(Map<String, dynamic> map) {
    List<dynamic> t1 = map['profileImagesList'] ?? [];
    List<dynamic> t2 = map['savedPostList'] ?? [];
    List<ProfilePhotos> profileImages =
        t1.map((e) => ProfilePhotos.fromMap(e)).toList();
    List<SavedPost> savedPost = t2.map((e) => SavedPost.fromMap(e)).toList();
    return UserState(
      isLoggedIn: map["isLoggedIn"],
      userNumber: map["userNumber"],
      lastTimeRenewNotificationShown: map["lastTimeRenewNotificationShown"],
      againUpdateProfileUrlInServer: map["againUpdateProfileUrlInServer"],
      userName: map["userName"],
      isPremiumUser: map["isPremiumUser"],
      isAdmin: map["isAdmin"],
      userOccupation: map["userOccupation"],
      uploadedImage: map["uploadedImage"],
      profileImagesList: profileImages,
      savedPostList: savedPost,
      isAuthenticatedUser: map["isAuthenticatedUser"],
      lastMessageId: map["lastMessageId"],
      appVersion: map["appVersion"],
      userId: map["userId"],
      userAppRating: map["userAppRating"],
      listOfInvalidBlockedNumbers: map['listOfInvalidBlockedNumbers'] != null
          ? List<String>.from(map['listOfInvalidBlockedNumbers'])
          : [],
      premiumPlan: map['premiumPlan'] != null
          ? PremiumPlan.fromMap(map['premiumPlan'])
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserState.fromJson(String source) =>
      UserState.fromMap(json.decode(source));

  int getUniquePhotoId() {
    int mx = 0;
    for (final e in profileImagesList) {
      mx = max(e.id, mx);
    }
    return mx + 1;
  }
}
