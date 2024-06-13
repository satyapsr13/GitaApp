part of 'posts_cubit.dart';

class PostState extends Equatable {
  // enum
  final Status status;
  final Status forYouPostStatus;
  final List<PostModel> postModeList;
  List<String> dateEditorTextList;
  List<SavedPost> sharePostList;
  List<PostModel> todayPostList;
  List<PostModel> daySpecialPostList;
  List<PostModel> specificTagList;
  List<PostModel> categoryWisePostList;
  List<PostModel> ocassionWisePostList;
  List<String> backupImageLinks;
  final List<Categories> categoriesList;
  final List<FrameDetails> listOfFrames;
  final List<SimilarTag> listOfSimilarTags;
  final List<TagsModel> modalTagsList;
  final List<TagsModel> tagsList;
  final List<TagsModel> allTagsList;
  final List<SpecialOcassion> specialOcassionList;
  final int daySpecialPageNo;
  final int forYouPageNo;

  // final bool showNumber;
  final String hindiDate;
  final String errorMsg;
  final String hindiDay;
  final String hindiTithi;
  final String telegramChannelName;
  final int setTabNo;

  final bool isNameVisible;
  final bool isProfileVisible;
  final bool isNumberVisible;
  final bool isOccupationVisible;
  final bool isFrameVisible;
  final bool isDateVisible;
  final bool isSharedLinkVisible;
  // final bool showDaySpecial;
  PostState({
    //--------------------------
    this.isProfileVisible = true,
    this.isNumberVisible = true,
    this.isOccupationVisible = true,
    this.isFrameVisible = true,
    this.isDateVisible = true,
    this.isNameVisible = true,
    this.isSharedLinkVisible = true,

    //--------------------------
    this.status = Status.initial,
    this.forYouPostStatus = Status.initial,
    this.daySpecialPageNo = 0,
    this.forYouPageNo = 0,
    this.setTabNo = 0,
    this.hindiDate = "",
    this.hindiDay = "",
    this.errorMsg = "",
    this.hindiTithi = "",
    this.telegramChannelName = "@rishteyycustom",
    // this.showDaySpecial = false,
    this.dateEditorTextList = const [],
    this.listOfSimilarTags = const [],
    this.sharePostList = const [],
    this.backupImageLinks = const [],
    this.listOfFrames = const [],
    this.postModeList = const [],
    this.modalTagsList = const [],
    this.tagsList = const [],
    this.allTagsList = const [],
    this.todayPostList = const [],
    this.daySpecialPostList = const [],
    this.specificTagList = const [],
    this.categoriesList = const [],
    this.ocassionWisePostList = const [],
    this.specialOcassionList = const [],
    this.categoryWisePostList = const [],
  });

  @override
  List<Object?> get props => [
        status,
        forYouPostStatus,
        listOfSimilarTags,
        hindiDate,
        hindiDay,
        hindiTithi,
        telegramChannelName,
        listOfFrames,
        setTabNo,
        errorMsg,
        // showDaySpecial,
        postModeList,
        allTagsList,
        dateEditorTextList,
        backupImageLinks,
        sharePostList,

        todayPostList,
        daySpecialPostList,
        specificTagList,
        categoryWisePostList,
        ocassionWisePostList,
        modalTagsList,
        tagsList,
        specialOcassionList,
        categoriesList,
        daySpecialPageNo,
        forYouPageNo,
        //-------------
        isNameVisible,
        isProfileVisible,
        isSharedLinkVisible,
        isNumberVisible,
        isDateVisible,
        isFrameVisible,
        isSharedLinkVisible
      ];

  PostState copyWith({
    Status? status,
    Status? forYouPostStatus,
    int? pageNo,
    int? daySpecialPageNo,
    // bool? showName,
    String? hindiDate,
    String? hindiDay,
    String? errorMsg,
    String? hindiTithi,
    String? telegramChannelName,
    int? setTabNo,
    // bool? showDaySpecial,
    List<String>? dateEditorTextList,
    List<String>? backupImageLinks,
    List<SavedPost>? sharePostList,
    List<SimilarTag>? listOfSimilarTags,
    List<FrameDetails>? listOfFrames,
    bool? isNameVisible,
    bool? isProfileVisible,
    bool? isNumberVisible,
    bool? isOccupationVisible,
    bool? isFrameVisible,
    bool? isDateVisible,
    bool? isSharedLinkVisible,
    List<PostModel>? postModeList,
    List<PostModel>? todayPostList,
    List<PostModel>? daySpecialPostList,
    List<PostModel>? specificTagList,
    List<PostModel>? ocassionWisePostList,
    List<PostModel>? categoryWisePostList,
    List<Categories>? categoriesList,
    List<TagsModel>? modalTagsList,
    List<TagsModel>? tagsList,
    List<TagsModel>? allTagsList,
    List<SpecialOcassion>? specialOcassionList,
  }) {
    return PostState(
      //----------------------------------------------------------
      isProfileVisible: isProfileVisible ?? this.isProfileVisible,
      backupImageLinks: backupImageLinks ?? this.backupImageLinks,
      isSharedLinkVisible: isSharedLinkVisible ?? this.isSharedLinkVisible,
      isNameVisible: isNameVisible ?? this.isNameVisible,
      isDateVisible: isDateVisible ?? this.isDateVisible,
      isNumberVisible: isNumberVisible ?? this.isNumberVisible,
      isFrameVisible: isFrameVisible ?? this.isFrameVisible,
      isOccupationVisible: isOccupationVisible ?? this.isOccupationVisible,
      //----------------------------------------------------------
      status: status ?? this.status,
      listOfFrames: listOfFrames ?? this.listOfFrames,
      listOfSimilarTags: listOfSimilarTags ?? this.listOfSimilarTags,

      forYouPostStatus: forYouPostStatus ?? this.forYouPostStatus,
      hindiDate: hindiDate ?? this.hindiDate,
      hindiDay: hindiDay ?? this.hindiDay,

      hindiTithi: hindiTithi ?? this.hindiTithi,

      telegramChannelName: telegramChannelName ?? this.telegramChannelName,
      setTabNo: setTabNo ?? this.setTabNo,

      // // // showDaySpecial: showDaySpecial ?? this.showDaySpecial,
      dateEditorTextList: dateEditorTextList ?? this.dateEditorTextList,
      sharePostList: sharePostList ?? this.sharePostList,
      errorMsg: errorMsg ?? this.errorMsg,

      postModeList: postModeList ?? this.postModeList,
      allTagsList: allTagsList ?? this.allTagsList,
      ocassionWisePostList: ocassionWisePostList ?? this.ocassionWisePostList,
      todayPostList: todayPostList ?? this.todayPostList,
      daySpecialPostList: daySpecialPostList ?? this.daySpecialPostList,

      specificTagList: specificTagList ?? this.specificTagList,

      modalTagsList: modalTagsList ?? this.modalTagsList,
      tagsList: tagsList ?? this.tagsList,
      specialOcassionList: specialOcassionList ?? this.specialOcassionList,
      categoryWisePostList: categoryWisePostList ?? this.categoryWisePostList,
      // postModeList: postModeList,
      categoriesList: categoriesList ?? this.categoriesList,
      daySpecialPageNo: daySpecialPageNo ?? 0,
      forYouPageNo: pageNo ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'categoriesList': categoriesList.map((e) => e.toMap()).toList(),
      'allTagsList': allTagsList.map((e) => e.toMap()).toList(),
      'listOfFrames': allTagsList.map((e) => e.toMap()).toList(),
      // 'postModeList': postModeList.map((e) => e.toMap()).toList(),
      'isOccupationVisible': isOccupationVisible,
      'backupImageLinks': backupImageLinks,
      'isFrameVisible': isFrameVisible,
      'isNumberVisible': isNumberVisible,
      'isDateVisible': isDateVisible,
      'isNameVisible': isNameVisible,
      'isProfileVisible': isProfileVisible,
      'isSharedLinkVisible': isSharedLinkVisible,
    };
  }

  factory PostState.fromMap(Map<String, dynamic> map) {
    List<dynamic> p1 = map['categoriesList'] ?? [];
    List<Categories> categories = p1.map((e) => Categories.fromMap(e)).toList();
    List<dynamic> p2 = map['allTagsList'] ?? [];
    // List<dynamic> p3 = map['listOfFrames'] ?? [];
    // List<dynamic> p3 = map['postModeList'] ?? [];
    List<TagsModel> allTags1 = p2.map((e) {
      // Logger().d(e);
      return TagsModel.fromMap(e);
    }).toList();
    // try {
    //   List<dynamic> p3 = map['postModeList'] ?? [];
    //   List<PostModel> mainScreenPost = p3.map((e) {
    //     // Logger().d(e);

    //     // Logger().i(" fetchNextPagePosts 0 ${e.runtimeType} ");
    //     return PostModel.fromMap(e);
    //   }).toList();
    //   // toast("success ${mainScreenPost.length} ", duration: Toast.LENGTH_LONG);
    //   Logger().i(" fetchNextPagePosts 1 success ");
    // } catch (e) {
    //   Logger().i(" fetchNextPagePosts 2 $e");
    // }

    return PostState(
      categoriesList: categories,
      allTagsList: allTags1,
      // postModeList: mainScreenPost,
      isOccupationVisible: map['isOccupationVisible'],
      backupImageLinks: map['backupImageLinks'] != null
          ? List<String>.from(map['backupImageLinks'])
          : [],
      isFrameVisible: map['isFrameVisible'],
      isNumberVisible: map['isNumberVisible'],
      isDateVisible: map['isDateVisible'],
      isNameVisible: map['isNameVisible'],
      isProfileVisible: map['isProfileVisible'],
      isSharedLinkVisible: map['isSharedLinkVisible'],
    );
  }

  String toJson() => json.encode(toMap());

  factory PostState.fromJson(String source) =>
      PostState.fromMap(json.decode(source));

  PostWidgetModel convertPostModelToPostWidgetModel(
    PostModel post, {
    int index = 0,
    bool? showName,
    bool? showProfile,
    bool? showOccupation,
    String? playStoreBadgePos,
  }) {
    return PostWidgetModel(
      index: index,
      imageLink: post.image ?? "",
      postId: post.id.toString(),
      profilePos: "right",
      // profilePos: post.frameOptions!.bottom.toString(),
      profileShape: post.frameOptions!.border.toString(),
      tagColor: post.frameOptions!.color.toString(),
      playStoreBadgePos: playStoreBadgePos ?? post.frameOptions!.top.toString(),
      showName: showName,
      showProfile: showProfile,
      // showProfile: showProfile,
      // showOccupation: showOccupation,
    );
  }
}
