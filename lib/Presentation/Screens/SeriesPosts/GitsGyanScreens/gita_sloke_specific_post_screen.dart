import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gita/Utility/extensions.dart';
import 'package:overlay_support/overlay_support.dart';

import '../../../../Constants/enums.dart';
import '../../../../Constants/locations.dart';
import '../../../../Data/model/ObjectModels/post_widget_model.dart';
import '../../../../Data/model/api/SeriesPostResponse/gita_post_response.dart';
import '../../../../Logic/Cubit/SeriesPostCubit/series_post_cubit.dart';
import '../../../../Utility/next_screen.dart';
import '../../../Widgets/ShimmerLoader/shimmer_widgets.dart';
import '../../../Widgets/post_widget.dart';
import 'gita_sloke_main_screen.dart';

class GitaGyanSpecificSlokeScreen extends StatefulWidget {
  // const GitaGyanSpecificSlokeScreen({super.key});
  String chaperNo;
  GitaGyanSpecificSlokeScreen({
    Key? key,
    required this.chaperNo,
  }) : super(key: key);

  @override
  State<GitaGyanSpecificSlokeScreen> createState() =>
      _GitaGyanSpecificSlokeScreenState();
}

class _GitaGyanSpecificSlokeScreenState
    extends State<GitaGyanSpecificSlokeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<GitaAdhyay> gitaChapters = const [
    GitaAdhyay(
      chapterNo: 1,
      hindiTitle: "अध्याय 1",
      englishTitle: "Adhyay 1",
      hindiTopic: "अर्जुन विषाद योग",
      englishTopic: "Arjuna Vishada Yoga",
    ),
    GitaAdhyay(
      chapterNo: 2,
      hindiTitle: "अध्याय 2",
      englishTitle: "Adhyay 2",
      hindiTopic: "सांख्य योग",
      englishTopic: "Sankhya Yoga",
    ),
    GitaAdhyay(
      chapterNo: 3,
      hindiTitle: "अध्याय 3",
      englishTitle: "Adhyay 3",
      hindiTopic: "कर्म योग",
      englishTopic: "Karma Yoga",
    ),
    GitaAdhyay(
      chapterNo: 4,
      hindiTitle: "अध्याय 4",
      englishTitle: "Adhyay 4",
      hindiTopic: "ज्ञान कर्म संन्यास योग",
      englishTopic: "Jnana Karma Sanyasa Yoga",
    ),
    GitaAdhyay(
      chapterNo: 5,
      hindiTitle: "अध्याय 5",
      englishTitle: "Adhyay 5",
      hindiTopic: "कर्म संन्यास योग",
      englishTopic: "Karma Sanyasa Yoga",
    ),
    GitaAdhyay(
      chapterNo: 6,
      hindiTitle: "अध्याय 6",
      englishTitle: "Adhyay 6",
      hindiTopic: "आत्म संयम योग",
      englishTopic: "Atma Samyama Yoga",
    ),
    GitaAdhyay(
      chapterNo: 7,
      hindiTitle: "अध्याय 7",
      englishTitle: "Adhyay 7",
      hindiTopic: "ज्ञान विज्ञान योग",
      englishTopic: "Jnana Vijnana Yoga",
    ),
    GitaAdhyay(
      chapterNo: 8,
      hindiTitle: "अध्याय 8",
      englishTitle: "Adhyay 8",
      hindiTopic: "अक्षर परब्रह्म योग",
      englishTopic: "Aksara ParaBrahma Yoga",
    ),
    GitaAdhyay(
      chapterNo: 9,
      hindiTitle: "अध्याय 9",
      englishTitle: "Adhyay 9",
      hindiTopic: "राज विद्या राज गुह्य योग",
      englishTopic: "Raja Vidya Raja Guhya Yoga",
    ),
    GitaAdhyay(
      chapterNo: 10,
      hindiTitle: "अध्याय 10",
      englishTitle: "Adhyay 10",
      hindiTopic: "विभूति योग",
      englishTopic: "Vibhooti Yoga",
    ),
    GitaAdhyay(
      chapterNo: 11,
      hindiTitle: "अध्याय 11",
      englishTitle: "Adhyay 11",
      hindiTopic: "विश्वरूप दर्शन योग",
      englishTopic: "Vishwaroopa Darshana Yoga",
    ),
    GitaAdhyay(
      chapterNo: 12,
      hindiTitle: "अध्याय 12",
      englishTitle: "Adhyay 12",
      hindiTopic: "भक्ति योग",
      englishTopic: "Bhakti Yoga",
    ),
    GitaAdhyay(
      chapterNo: 13,
      hindiTitle: "अध्याय 13",
      englishTitle: "Adhyay 13",
      hindiTopic: "क्षेत्र-क्षेत्रज्ञ विभाग योग",
      englishTopic: "Ksetra Ksetrajna Vibhaaga Yoga",
    ),
    GitaAdhyay(
      chapterNo: 14,
      hindiTitle: "अध्याय 14",
      englishTitle: "Adhyay 14",
      hindiTopic: "गुणत्रय विभाग योग",
      englishTopic: "Gunatraya Vibhaga Yoga",
    ),
    GitaAdhyay(
      chapterNo: 15,
      hindiTitle: "अध्याय 15",
      englishTitle: "Adhyay 15",
      hindiTopic: "पुरुषोत्तम योग",
      englishTopic: "Purushottama Yoga",
    ),
    GitaAdhyay(
      chapterNo: 16,
      hindiTitle: "अध्याय 16",
      englishTitle: "Adhyay 16",
      hindiTopic: "दैवासुर सम्पद विभाग योग",
      englishTopic: "Daivasura Sampad Vibhaga Yoga",
    ),
    GitaAdhyay(
      chapterNo: 17,
      hindiTitle: "अध्याय 17",
      englishTitle: "Adhyay 17",
      hindiTopic: "श्रद्धात्रय विभाग योग",
      englishTopic: "Sraddhatraya Vibhaga Yoga",
    ),
    GitaAdhyay(
      chapterNo: 18,
      hindiTitle: "अध्याय 18",
      englishTitle: "Adhyay 18",
      hindiTopic: "मोक्ष सन्यास योग",
      englishTopic: "Moksha Sanyaasa Yoga",
    ),
  ];
  @override
  void initState() {
    BlocProvider.of<SeriesPostCubit>(context)
        .fetchGitaPosts(chapter: widget.chaperNo)
        .then((value) {
      _tabController = TabController(
          initialIndex: 0,
          length: BlocProvider.of<SeriesPostCubit>(context, listen: false)
              .state
              .gitaSlokeList
              .length,
          vsync: this);

      _tabController.addListener((() {
        setState(() {
          initialPostNo = -1;
        });
      }));
    });
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // void _handleTabChange() {
  //   setState(() {
  //     // initialPostNo = -1;

  //     Logger().i("initial post tab ${_tabController.index}");
  //   });
  // }

  String slokeImage = "";
  GitaAdhyay selectedChapter = const GitaAdhyay(
      chapterNo: 1,
      hindiTitle: "",
      englishTopic: "",
      hindiTopic: "",
      englishTitle: "");
  int initialPostNo = -1;
  int currentGitaInded = 0;
  bool isEnglish = false;
  @override
  Widget build(BuildContext context) {
    isEnglish = (tr("_a_") == "A");
    currentGitaInded = (int.tryParse(widget.chaperNo) ?? 1) - 1;
    if (selectedChapter.hindiTitle.isEmpty) {
      selectedChapter = gitaChapters[currentGitaInded];
    }
    final mq = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          // centerTitle: true,
          title: Text(
            tr("gita_title"),
            style: const TextStyle(
              color: Colors.black,
            ),
          ),
          backgroundColor: Colors.white,
          // actions: [],
        ),
        bottomNavigationBar: _gitaScreenNavBar(),
        body: BlocBuilder<SeriesPostCubit, SeriesPostState>(
            builder: (context, state) {
          if (state.status == Status.loading) {
            return _buildLoadingWidget(mq);
          }
          if (state.status == Status.failure) {
            return Center(
              child: Column(
                children: [
                  SizedBox(height: mq.height * 0.35),
                  TextButton.icon(
                    onPressed: () {
                      BlocProvider.of<SeriesPostCubit>(context)
                          .fetchGitaPosts(chapter: widget.chaperNo);
                    },
                    icon: const Icon(Icons.replay_outlined),
                    label: const Text(
                      'Reload',
                      style: TextStyle(),
                    ),
                  )
                ],
              ),
            );
          }
          if (initialPostNo == -1 && state.gitaSlokeList.isNotEmpty) {
            slokeImage = state.gitaSlokeList.first.shlokImage ?? "";
          }
          return DefaultTabController(
            length: state.gitaSlokeList.length,
            initialIndex: 0,
            child: NestedScrollView(
                // physics: BouncingScrollPhysics(),
                floatHeaderSlivers: true,
                headerSliverBuilder: (BuildContext context, bool _) {
                  return [
                    SliverAppBar(
                      stretch: true,
                      automaticallyImplyLeading: false,
                      expandedHeight: 70,
                      // expandedHeight: 250,
                      floating: false,
                      // automaticallyImplyLeading: true,
                      pinned: false,
                      flexibleSpace: FlexibleSpaceBar(
                        background: Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: Container(
                                // width: ,
                                // width: mq.width*0.4,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                      color: Colors.orange.withOpacity(0.4),
                                      width: 1),
                                  color: Colors.orange.withOpacity(0.1),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 0),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<GitaAdhyay>(
                                      focusColor: Colors.white,
                                      menuMaxHeight: mq.height * 0.5,
                                      // icon:  ,
                                      iconEnabledColor: Colors.orange,
                                      isExpanded: true,
                                      value: selectedChapter,
                                      style:
                                          const TextStyle(color: Colors.white),
                                      items: gitaChapters
                                          .map<DropdownMenuItem<GitaAdhyay>>(
                                              (GitaAdhyay value) {
                                        return DropdownMenuItem<GitaAdhyay>(
                                          value: value,
                                          child: Text(
                                            isEnglish
                                                ? "${value.englishTitle}:- ${value.englishTopic}"
                                                : "${value.hindiTitle}:- ${value.hindiTopic}",
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        );
                                      }).toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          selectedChapter = value!;
                                          widget.chaperNo = selectedChapter
                                              .chapterNo
                                              .toString();
                                        });

                                        if ((int.tryParse(widget.chaperNo) ??
                                                0) >
                                            0) {
                                          nextScreenReplace(
                                              context,
                                              GitaGyanSpecificSlokeScreen(
                                                  chaperNo: widget.chaperNo));
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ];
                },
                body: Column(
                  children: <Widget>[
                    TabBar(
                        isScrollable: true,
                        controller: _tabController,
                        onTap: ((value) {
                          setState(() {
                            initialPostNo = -1;
                            // Logger().i("initial post ------ $initialPostNo");
                          });
                        }),
                        labelColor: Colors.white,
                        splashFactory: NoSplash.splashFactory,
                        splashBorderRadius: BorderRadius.circular(500),
                        indicator: BoxDecoration(
                          color: const Color(0xfff5d075).withOpacity(0.5),
                          shape: BoxShape.circle,
                        ),
                        tabs: state.gitaSlokeList.map((e) {
                          return _buildTabBar(
                              index: (state.gitaSlokeList.indexOf(e) + 1)
                                  .toString());
                        }).toList()),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TabBarView(
                          controller: _tabController,
                          children: state.gitaSlokeList.mapIndexed((e, index) {
                            // Logger()
                            //     .i("initial post tab  at map $initialPostNo");
                            PostWidgetModel postWidgetData = PostWidgetModel(
                              index: 1,
                              imageLink: e.shlokImage ?? "",
                              postId: e.id.toString(),
                              profilePos: "right",
                              profileShape: "round",
                              tagColor: "white",
                              playStoreBadgePos: "right",
                              showName: true,
                              showProfile: true,
                            );
                            PostWidgetModel postWidgetDataForChange =
                                PostWidgetModel(
                              index: 1,
                              imageLink: slokeImage,
                              postId: e.id.toString(),
                              profilePos: "right",
                              profileShape: "round",
                              tagColor: "white",
                              playStoreBadgePos: "right",
                              showName: true,
                              showProfile: true,
                            );
                            return SingleChildScrollView(
                              physics: const NeverScrollableScrollPhysics(),
                              child: Container(
                                width: mq.width,
                                // height: mq.height * 1,
                                color: Colors.white,
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: PostWidget(
                                        postWidgetData: initialPostNo != -1
                                            ? postWidgetDataForChange
                                            : postWidgetData,
                                        index: index,
                                        // showEditAndShare: false,
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              initialPostNo = 0;
                                              slokeImage = e.images?[0] ?? "";
                                            });
                                          },
                                          child: _buildGitaSlokeImageTypes(
                                              mq: mq,
                                              image: e.images?[0] ?? ""),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              initialPostNo = 1;

                                              slokeImage = e.images?[1] ?? "";
                                            });
                                          },
                                          child: _buildGitaSlokeImageTypes(
                                              mq: mq,
                                              image: e.images?[1] ?? ""),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              initialPostNo = 0;
                                              slokeImage = e.images?[2] ?? "";
                                            });
                                          },
                                          child: _buildGitaSlokeImageTypes(
                                              mq: mq,
                                              image: e.images?[2] ?? ""),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              initialPostNo = 0;
                                              slokeImage = e.images?[3] ?? "";
                                            });
                                          },
                                          child: _buildGitaSlokeImageTypes(
                                              mq: mq,
                                              image: e.images?[3] ?? ""),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 25),
                                    SizedBox(
                                      width: mq.width,
                                      child: SelectableText(
                                        e.text ?? "",
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    IconButton(
                                        onPressed: () {
                                          Clipboard.setData(ClipboardData(
                                              text: e.text ?? ""));
                                          toast("Shlok Copied");
                                        },
                                        icon: const Icon(
                                          Icons.copy,
                                          size: 20,
                                        )),
                                    SizedBox(
                                      width: mq.width,
                                      child: SelectableText(
                                        e.meaning ?? "",
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    IconButton(
                                        onPressed: () {
                                          Clipboard.setData(ClipboardData(
                                              text: e.meaning ?? ""));
                                          toast("Meaning Copied");
                                        },
                                        icon: const Icon(
                                          Icons.copy,
                                          size: 20,
                                        )),
                                    const SizedBox(height: 40),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                )),
          );
        }));
  }

  Widget _gitaScreenNavBar() {
    return BlocBuilder<SeriesPostCubit, SeriesPostState>(
        builder: (context, state) {
      if (state.status != Status.success) {
        return const SizedBox();
      }
      int preChapter = (int.tryParse(widget.chaperNo) ?? 0) - 1;
      int nextChapter = (int.tryParse(widget.chaperNo) ?? 0) + 1;
      bool isLastSloke = (_tabController.index ==
          (BlocProvider.of<SeriesPostCubit>(context, listen: false)
                  .state
                  .gitaSlokeList
                  .length -
              1));
      return Container(
        height: 55,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Visibility(
                visible: !(_tabController.index == 0 && preChapter == 0),
                replacement: const SizedBox(),
                child: TextButton.icon(
                  onPressed: () {
                    if (_tabController.index != 0) {
                      // nextScreenReplaceSlideFromLeft(
                      //     context,
                      //     GitaGyanSpecificSlokeScreen(
                      //       chaperNo: (preChapter).toString(),
                      //     ));
                      _tabController.animateTo(_tabController.index - 1);
                      // setState(() {
                      // });
                    } else {
                      nextScreenReplaceSlideFromLeft(
                          context,
                          GitaGyanSpecificSlokeScreen(
                            chaperNo: (preChapter).toString(),
                          ));
                    }
                  },
                  icon: const Icon(Icons.arrow_back,
                      size: 20, color: Colors.black),
                  label: Text(
                    _tabController.index == 0
                        ? tr("pre_chapter")
                        : tr("pre_shlok"),
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: !(nextChapter == 19 && isLastSloke),
                replacement: const SizedBox(),
                child: TextButton.icon(
                  onPressed: () {
                    if (!isLastSloke) {
                      _tabController.animateTo(_tabController.index + 1);
                    } else {
                      nextScreenReplaceSlideFromLeft(
                          context,
                          GitaGyanSpecificSlokeScreen(
                            chaperNo: (nextChapter).toString(),
                          ));
                    }
                  },
                  icon: const SizedBox(),
                  label: Row(
                    children: [
                      Text(
                        "${isLastSloke ? tr("next_chapter") : tr("next_shlok")} ",
                        style: const TextStyle(
                          color: Colors.black,
                        ),
                      ),
                      const Icon(Icons.arrow_forward,
                          size: 20, color: Colors.black),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      );
    });
  }

  SingleChildScrollView _buildLoadingWidget(Size mq) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CShimmerContainer(height: 50, width: mq.width * 0.85),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: const [
              CShimmerCircle(radius: 50),
              CShimmerCircle(radius: 50),
              CShimmerCircle(radius: 50),
              CShimmerCircle(radius: 50),
            ],
          ),
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CShimmerContainer(
                    height: mq.width * 0.2, width: mq.width * 0.2),
                CShimmerContainer(
                    height: mq.width * 0.2, width: mq.width * 0.2),
                CShimmerContainer(
                    height: mq.width * 0.2, width: mq.width * 0.2),
                CShimmerContainer(
                    height: mq.width * 0.2, width: mq.width * 0.2),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPostWidget({required Size mq, required GitaSloke gitaSloke}) {
    slokeImage = gitaSloke.shlokImage ?? "";
    PostWidgetModel postWidgetData = PostWidgetModel(
      index: 1,
      imageLink: slokeImage,
      postId: gitaSloke.id.toString(),
      profilePos: "right",
      profileShape: "round",
      tagColor: "white",
      playStoreBadgePos: "right",
      showName: true,
      showProfile: true,
    );
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Container(
        width: mq.width,
        // height: mq.height * 1,
        color: Colors.white,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: PostWidget(
                postWidgetData: postWidgetData,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildGitaSlokeImageTypes(
                    mq: mq, image: gitaSloke.images?[0] ?? ""),
                _buildGitaSlokeImageTypes(
                    mq: mq, image: gitaSloke.images?[1] ?? ""),
                _buildGitaSlokeImageTypes(
                    mq: mq, image: gitaSloke.images?[2] ?? ""),
                _buildGitaSlokeImageTypes(
                    mq: mq, image: gitaSloke.images?[3] ?? ""),
              ],
            ),
            const SizedBox(height: 25),
          ],
        ),
      ),
    );
  }

  Card _buildGitaSlokeImageTypes({required Size mq, required String image}) {
    return Card(
      elevation: 5,
      child: Container(
        width: mq.width * 0.2,
        height: mq.width * 0.2,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            image:
                DecorationImage(image: NetworkImage(image), fit: BoxFit.fill)),
      ),
    );
  }

  Tab _buildTabBar({required String index}) {
    return Tab(
      child: Padding(
          padding: const EdgeInsets.all(0.0),
          child: Container(
            height: 50,
            width: 50,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(AppImages.circleBorder),
                    fit: BoxFit.contain),
                color: Colors.transparent,
                shape: BoxShape.circle),
            child: Center(
              child: Text(
                index,
                style: const TextStyle(
                    color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
          )),
    );
  }
}

class GitaBannerWidget extends StatelessWidget {
  final String title;
  // final double fontSize;
  const GitaBannerWidget({
    Key? key,
    required this.title,
    // this.fontSize=,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 50,
        width: 150,
        decoration: BoxDecoration(
          image: const DecorationImage(
              image: NetworkImage(
                  "https://i.pinimg.com/originals/b2/20/07/b22007530bf81daccc2f43ba9b0516e2.png"),
              fit: BoxFit.contain),
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Text(
              title,
              textScaleFactor: 1,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
