// ignore_for_file: public_member_api_docs, sort_constructors_first, use_build_context_synchronously
// ignore_for_file: prefer_const_constructors
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';

import 'package:rishteyy/Constants/colors.dart';
import 'package:rishteyy/Constants/constants.dart';
import 'package:rishteyy/Constants/enums.dart';
import 'package:rishteyy/Data/model/ObjectModels/post_widget_model.dart';
import 'package:rishteyy/Data/model/api/SeriesPostResponse/panchang_response.dart';
import 'package:rishteyy/Logic/Cubit/SeriesPostCubit/series_post_cubit.dart';
import 'package:rishteyy/Presentation/Widgets/post_widget.dart';

import '../../../../Data/model/api/frames_response.dart';
import '../../../../Logic/Cubit/PostEditorCubit/post_editor_cubit.dart';
import '../../../../Logic/Cubit/Posts/posts_cubit.dart';
import '../../../../Logic/Cubit/StickerCubit/sticker_cubit.dart';
import '../../../../Logic/Cubit/user_cubit/user_cubit.dart';
import '../../../../Utility/common.dart';
import '../../../../Utility/next_screen.dart';
import '../../../Widgets/frame_to_frame_details.dart';
import '../../PostsScreens/PostFrames/post_frames.dart';
import '../../PostsScreens/post_edit_screen.dart';
import 'panchang_widgets.dart';

class PanchangMainScreen extends StatefulWidget {
  const PanchangMainScreen({super.key});

  @override
  State<PanchangMainScreen> createState() => _PanchangMainScreenState();
}

class _PanchangMainScreenState extends State<PanchangMainScreen> {
  @override
  void initState() {
    BlocProvider.of<SeriesPostCubit>(context).fetchPanditData();
    secureScreen();
    pathTracker.add("PanchangScreen");
    super.initState();
  }

  @override
  void dispose() {
    pathTracker.remove("PanchangScreen");
  }

  Future<void> secureScreen() async {
    try {
      bool isPremiumUser = BlocProvider.of<UserCubit>(context, listen: false)
          .state
          .isPremiumUser;
      if (isPremiumUser) {
        await FlutterWindowManager.clearFlags(FlutterWindowManager.FLAG_SECURE);
      }
    } catch (e) {}
  }

  List<String> panchangTitles = [
    "आज का पंचांग",
    "सूर्योदय एवं पञ्चाङ्ग",
    "चन्द्रमास एवं राशि",
    "ऋतु तथा अयन",
    "अन्य कैलेण्डर एवं युग",
    "शुभ समय",
    "अशुभ समय",
    "पंचक रहित मुहूर्त",
    "उदय लग्न मुहूर्त"
  ];
  int activeIndex = 0;
  PanchangBg? selectedBg;
  String? mainPanchangImage;
  ScreenshotController screenshotController = ScreenshotController();
  ScreenshotController screenshotController2 = ScreenshotController();
  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          title: Text(
            tr('pachang'),
            style: TextStyle(
              fontSize: 20,
              color: Colors.black,
            ),
          ),
        ),
        body: BlocBuilder<SeriesPostCubit, SeriesPostState>(
            builder: (context, state) {
          if (state.panditDataStatus == Status.loading) {
            return Center(child: CircularProgressIndicator());
          }
          if (state.panditDataStatus == Status.failure ||
              state.panditData == null) {
            return Center(
              child: TextButton.icon(
                onPressed: () {
                  BlocProvider.of<SeriesPostCubit>(context).fetchPanditData();
                },
                icon: Icon(Icons.refresh),
                label: Text(
                  'Reload',
                  style: const TextStyle(
                    fontSize: 15,
                  ),
                ),
              ),
            );
          }
          if (selectedBg == null &&
              (state.panditData!.backgrounds?.isNotEmpty ?? false)) {
            selectedBg = state.panditData!.backgrounds!.first;
          }
          if (mainPanchangImage == null &&
              (state.panditData?.mainPanchang?.isNotEmpty ?? false)) {
            mainPanchangImage = state.panditData?.mainPanchang!.first;
          }
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
              child: Column(
                children: [
                  Center(
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      children: panchangTitles.map(
                        (e) {
                          int currentIndex = panchangTitles.indexOf(e);
                          final bool isActive = (activeIndex == currentIndex);
                          return InkWell(
                            onTap: () {
                              if (activeIndex == currentIndex) {
                              } else {
                                setState(() {
                                  activeIndex = currentIndex;
                                });
                              }
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 4),
                              margin: EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                  color: isActive
                                      ? AppColors.primaryColor.withOpacity(0.3)
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                      width: 1,
                                      color: isActive
                                          ? AppColors.primaryColor
                                          : Colors.grey)),
                              child: Text(
                                e,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight:
                                        isActive ? FontWeight.bold : null,
                                    fontSize: 12),
                              ),
                            ),
                          );
                        },
                      ).toList(),
                    ),
                  ),
                  SizedBox(height: 15),
                  Visibility(
                    visible: activeIndex == 0,
                    replacement: selectedBg == null
                        ? SizedBox()
                        : Screenshot(
                            controller: screenshotController,
                            child:
                                LayoutBuilder(builder: (context, constraints) {
                              return Column(
                                children: [
                                  Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                      Screenshot(
                                        controller: screenshotController2,
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(10),
                                            topRight: Radius.circular(10),
                                          ),
                                          child: PanchangGeneratedWidget(
                                            currentIndex: activeIndex,
                                            bgImage: selectedBg!,
                                            dateBgImage:
                                                "https://manage.connectup.in/rishteyy/assets/miniapps/panchang/label.png",
                                            mq: mq,
                                            title: panchangTitles[activeIndex],
                                            data: state.panditData!,
                                          ),
                                        ),
                                      ),
                                      BlocBuilder<StickerCubit, StickerState>(
                                          builder: (context, stickerState) {
                                        return (stickerState
                                                .listOfActiveFrames.isEmpty)
                                            ? FrameWidget(
                                                isNoFrame: true,
                                                frameDetails: FrameDetails(
                                                  imgLink:
                                                      'assets/images/frames/15.png',
                                                  nameX: 5,
                                                  nameY: 55,
                                                  numberX: 5,
                                                  numberY: 82,
                                                  profileX: 75,
                                                  profileY: 60,
                                                  occupationX: 5,
                                                  occupationY: 70,
                                                  width: constraints.maxWidth,
                                                  radius: 40,
                                                  side: 200.0,
                                                  nameColor: '#000000',
                                                  numberColor: '#000000',
                                                  occupationColor: '#000000',
                                                ))
                                            : (false)
                                                ? FrameWidget(
                                                    frameDetails: FrameDetails(
                                                    imgLink:
                                                        'assets/images/frames/4.png',
                                                    nameX: 5,
                                                    nameY: 38,
                                                    numberX: 5,
                                                    numberY: 78,
                                                    profileX: 75,
                                                    profileY: 60,
                                                    occupationX: 5,
                                                    occupationY: 68,
                                                    width: constraints.maxWidth,
                                                    radius: 40,
                                                    side: 200.0,
                                                    nameColor: '#ffffff',
                                                    numberColor: '#ffffff',
                                                    occupationColor: '#ffffff',
                                                  ))
                                                : BlocBuilder<PostCubit,
                                                        PostState>(
                                                    builder: (context, state) {
                                                    Frame? f;
                                                    if (stickerState
                                                        .listOfActiveFrames
                                                        .isNotEmpty) {
                                                      f = stickerState
                                                          .listOfActiveFrames[((0 +
                                                              DateTime.now()
                                                                  .hour) %
                                                          (stickerState
                                                              .listOfActiveFrames
                                                              .length))];
                                                    }
                                                    return FrameWidget(
                                                        frameDetails: f == null
                                                            ? FrameDetails(
                                                                imgLink:
                                                                    'assets/images/frames/15.png',
                                                                nameX: 5,
                                                                nameY: 55,
                                                                numberX: 5,
                                                                numberY: 82,
                                                                profileX: 75,
                                                                profileY: 60,
                                                                occupationX: 5,
                                                                occupationY: 70,
                                                                width: constraints
                                                                    .maxWidth,
                                                                radius: 40,
                                                                side: 200.0,
                                                                nameColor:
                                                                    '#ffffff',
                                                                numberColor:
                                                                    '#ffffff',
                                                                occupationColor:
                                                                    '#ffffff',
                                                              )
                                                            : frameToFrameDetails(
                                                                f,
                                                                constraints
                                                                    .maxWidth));
                                                  });
                                      })
                                    ],
                                  ),
                                  SizedBox(height: constraints.maxWidth * 0.2),
                                ],
                              );
                            }),
                          ),
                    child: state.panditData == null
                        ? SizedBox()
                        : TodayPanchangWidget(
                            data: state.panditData!,
                            mainPanchangImage: mainPanchangImage ?? "",
                          ),
                  ),
                  Visibility(
                    visible: activeIndex != 0,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          const Spacer(),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: EditButton(
                              onTap: () async {
                                try {
                                  final frames = BlocProvider.of<StickerCubit>(
                                          context,
                                          listen: false)
                                      .state
                                      .listOfActiveFrames;
                                  if (frames.isNotEmpty) {
                                    BlocProvider.of<PostEditorCubit>(context)
                                        .updateStateVariables(
                                            currentFrame: frames[
                                                ((0 + DateTime.now().hour) %
                                                    (frames.length))]);
                                  }
                                  BlocProvider.of<UserCubit>(context)
                                      .updateStateVariables(
                                          editedName:
                                              BlocProvider.of<UserCubit>(
                                                      context,
                                                      listen: false)
                                                  .state
                                                  .userName);
                                } catch (e) {}
                                await screenshotController2
                                    .capture()
                                    .onError((error, stackTrace) {
                                  return null;
                                }).then(
                                  (capturedImage) async {
                                    if (capturedImage != null) {
                                      final directory =
                                          await getApplicationDocumentsDirectory();
                                      final imagePath = await File(
                                              '${directory.path}/${DateTime.now().millisecondsSinceEpoch}.png')
                                          .create();
                                      await imagePath
                                          .writeAsBytes(capturedImage);
                                      nextScreenWithFadeAnimation(
                                          context,
                                          PostEditScreen(
                                            userPickedImage: imagePath,
                                            postWidgetData: PostWidgetModel(
                                              index: 1,
                                              imageLink: "",
                                              postId: "1",
                                              profilePos: "right",
                                              profileShape: "round",
                                              tagColor: "white",
                                              playStoreBadgePos: "right",
                                            ),
                                            // parentScreenName: parentScreenName,
                                          ));
                                    }
                                  },
                                );
                              },
                            ),
                          ),
                          SizedBox(
                            // width: 120,
                            child: DownloadButton(
                              screenshotController1: screenshotController,
                              postId: "Panchang",
                              telChannelName:
                                  GlobalVariables.telCustomPostChannel,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Visibility(
                    visible: activeIndex != 0,
                    replacement: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: SizedBox(
                        height: mq.height * 0.1,
                        width: mq.width,
                        child: Center(
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              ...List.generate(
                                  state.panditData?.mainPanchang?.length ?? 0,
                                  (index) {
                                return InkWell(
                                  onTap: () {
                                    setState(() {
                                      mainPanchangImage = state
                                          .panditData?.mainPanchang![index];
                                    });
                                  },
                                  child: SizedBox(
                                    height: mq.height * 0.1,
                                    width: mq.height * 0.1,
                                    child: CachedNetworkImage(
                                        imageUrl: state.panditData
                                                ?.mainPanchang![index] ??
                                            ""),
                                  ),
                                );
                              })
                            ],
                          ),
                        ),
                      ),
                    ),
                    child: SizedBox(
                      width: mq.width,
                      height: mq.width * 0.3,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        children: [
                          ...List.generate(
                              state.panditData?.backgrounds?.length ?? 0,
                              ((index) {
                            PanchangBg bg =
                                state.panditData!.backgrounds![index];
                            return Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    selectedBg = bg;
                                  });
                                },
                                child: SizedBox(
                                  width: mq.width * 0.2,
                                  height: mq.width * 0.2,
                                  child: Image.network(bg.image ?? ""),
                                ),
                              ),
                            );
                          }))
                        ],
                      ),
                    ),
                  ),
                  Visibility(
                    visible: activeIndex != 0,
                    child: IconButton(
                        onPressed: () {
                          Clipboard.setData(ClipboardData(
                            text: getSuryodayaText(
                                    state.panditData!, activeIndex) ??
                                "",
                          ));
                          toast("${panchangTitles[activeIndex]} Copied");
                        },
                        icon: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "${panchangTitles[activeIndex]} कॉपी करे",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Icon(
                              Icons.copy_all,
                              size: 20,
                            ),
                          ],
                        )),
                  ),
                  Visibility(
                    visible: activeIndex != 0,
                    child: Builder(builder: (context) {
                      return Container(
                        decoration: BoxDecoration(
                          // color: Colors.green,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          getSuryodayaTextForCopy(
                              state.panditData!, activeIndex),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      );
                    }),
                  ),
                  Divider(
                    color: Colors.black,
                    thickness: 1,
                  ),
                  IconButton(
                      onPressed: () {
                        String copiedText = "";
                        for (var i = 0; i < 9; i++) {
                          copiedText +=
                              "${getSuryodayaTextForCopy(state.panditData!, i)}\n";
                        }
                        copiedText += " \n";
                        copiedText += getOldPromotionLink();
                        Clipboard.setData(ClipboardData(
                          text: copiedText,
                        ));
                        toast("सम्पूर्ण पंचांग Copied");
                      },
                      icon: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Text(
                            "सम्पूर्ण पंचांग कॉपी करे ",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Icon(
                            Icons.copy_all,
                            size: 20,
                          ),
                        ],
                      )),
                  ...List.generate(
                    9,
                    (index) {
                      return Column(
                        children: [
                          Text(
                            getSuryodayaTextForCopy(state.panditData!, index),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  SizedBox(height: 50),
                ],
              ),
            ),
          );
        }));
  }
}

class EditButton extends StatelessWidget {
  final double height;
  final double width;
  void Function()? onTap;
  EditButton({
    Key? key,
    this.onTap,
    this.width = 90,
    this.height = 35,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          // color: Colors. ,
          gradient: Gradients.blueGradient,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: const [
            Icon(
              Icons.edit,
              color: Colors.white,
              size: 20,
            ),
            Text(
              'Edit',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TodayPanchangWidget extends StatelessWidget {
  final PanditData data;
  final String mainPanchangImage;
  const TodayPanchangWidget({
    Key? key,
    required this.data,
    required this.mainPanchangImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    PostWidgetModel postWidgetData = PostWidgetModel(
      index: 1,
      imageLink: mainPanchangImage,
      postId: "1",
      profilePos: "right",
      profileShape: "round",
      tagColor: "white",
      playStoreBadgePos: "right",
    );
    return Container(
      child: PostWidget(postWidgetData: postWidgetData),
    );
  }
}

class PanchangGeneratedWidget extends StatelessWidget {
  final PanchangBg bgImage;
  final PanditData data;
  final String dateBgImage;
  final String title;
  final Size mq;
  final int currentIndex;
  const PanchangGeneratedWidget({
    Key? key,
    required this.bgImage,
    required this.dateBgImage,
    required this.title,
    required this.data,
    required this.mq,
    required this.currentIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 8 / 9,
      child: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: CachedNetworkImageProvider(
          bgImage.image ?? "",
        ))),
        child: LayoutBuilder(builder: (context, constraints) {
          return Column(
            children: [
              SizedBox(height: constraints.maxHeight * 0.07),
              PanchangeDateWidget(
                height: constraints.maxHeight * 0.1,
                dateBgImage: dateBgImage,
                title: title,
                width: constraints.maxWidth * 0.5,
              ),
              SizedBox(height: 15),
              getWidget(currentIndex),
            ],
          );
        }),
      ),
    );
  }

  getWidget(int currentIndex) {
    switch (currentIndex) {
      case 1:
        return PanchangSurvodayaWidget(
          bgImage: bgImage,
          data: data,
        );

      case 2:
        return PanchangChandraMasWidget(
          bgImage: bgImage,
          data: data,
        );
      case 3:
        return PanchangRituAyanWidget(
          bgImage: bgImage,
          data: data,
        );
      case 4:
        return PanchangAnyaCalenderWidget(
          bgImage: bgImage,
          data: data,
        );
      case 5:
        return PanchangShubhSamayWidget(
          bgImage: bgImage,
          data: data,
        );
      case 6:
        return PanchangAshubhSamayWidget(
          bgImage: bgImage,
          data: data,
        );
      case 7:
        return PanchangPanchakRahitWidget(
          bgImage: bgImage,
          data: data,
        );
      case 8:
        return PanchangUdaylagnWidget(
          bgImage: bgImage,
          data: data,
        );

      default:
        return PanchangUdaylagnWidget(
          bgImage: bgImage,
          data: data,
        );
    }
  }
}

class PanchangeDateWidget extends StatelessWidget {
  const PanchangeDateWidget({
    Key? key,
    required this.height,
    required this.width,
    required this.dateBgImage,
    required this.title,
  }) : super(key: key);

  final double height;
  final double width;

  final String dateBgImage;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
            width: width,
            height: height,
            child: CachedNetworkImage(
              imageUrl: dateBgImage,
              fit: BoxFit.fitWidth,
            )),
        SizedBox(
          width: width * 0.6,
          height: height * 0.7,
          child: FittedBox(
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }
}
// http://filecr.com/windows/acrobat/