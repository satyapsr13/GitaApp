import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:camera/camera.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:lottie/lottie.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:screenshot/screenshot.dart';
import 'package:stroke_text/stroke_text.dart';

import '../../../Constants/colors.dart';
import '../../../Constants/constants.dart';
import '../../../Constants/enums.dart';
import '../../../Data/model/ObjectModels/post_widget_model.dart';
import '../../../Logic/Cubit/PostEditorCubit/post_editor_cubit.dart';
import '../../../Logic/Cubit/StickerCubit/sticker_cubit.dart';
import '../../../Logic/Cubit/user_cubit/user_cubit.dart';
import '../../Constants/locations.dart';
import '../../Data/model/api/dpframes_response.dart';
import '../../Logic/Cubit/DpMakerCubit/dpmaker_cubit.dart';
import '../../Logic/Cubit/Posts/posts_cubit.dart';
import '../../Utility/next_screen.dart';
import '../Widgets/Dialogue/dialogue.dart';
import '../Widgets/model_bottom_sheet.dart';
import '../Widgets/multiple_profile_photo_widget.dart';
import '../Widgets/post_widget.dart';
import 'DpMakerScreens/dp_maker_screens.dart';
import 'PostsScreens/PostEditScreenComponents/EditorButtonsWidget/animation_wrapper.dart';
import 'PostsScreens/PostEditScreenComponents/EditorButtonsWidget/editor_date_widget.dart';
import 'PostsScreens/PostEditScreenComponents/EditorButtonsWidget/editor_multiple_text_widgets.dart';
import 'PostsScreens/PostEditScreenComponents/EditorButtonsWidget/editor_sticker_widget.dart';
import 'PostsScreens/PostEditScreenComponents/dotted_border.widget.dart';
import 'PostsScreens/PostEditScreenComponents/post_edit_screen_components.dart';
import 'PostsScreens/StickerComponents/dragger_widget.dart';
import 'PostsScreens/StickerComponents/sticker_dragger.dart';
import 'PostsScreens/post_edit_screen.dart';
import 'PremiumPlanScreens/premium_plan_screen.dart';

class PostEditScreenForDpFrame extends StatefulWidget {
  // const PostEditScreen({super.key});
  final DpFrames currentSelectedFrame;
  const PostEditScreenForDpFrame({
    Key? key,
    required this.currentSelectedFrame,
  }) : super(key: key);

  @override
  State<PostEditScreenForDpFrame> createState() =>
      _PostEditScreenForDpFrameState();
}

class _PostEditScreenForDpFrameState extends State<PostEditScreenForDpFrame> {
  double postSize = 20;

  double outerBorderRadius = 10;
  ScreenshotController screenshotController = ScreenshotController();
  CameraController? controller;
  List<CameraDescription> _cameras = [];

  getCameras() async {
    _cameras = await availableCameras();
    if (true) {}
  }

  DPMode dpMode = DPMode.photo;
  DpFrames? currentSelectedFrame;
  bool isTestMode = false;
  double borderR = 1;
  setFrame() {
    if (BlocProvider.of<StickerCubit>(context)
        .state
        .listOfDpFrames
        .isNotEmpty) {
      currentSelectedFrame =
          BlocProvider.of<StickerCubit>(context).state.listOfDpFrames.first;
      setState(() {});
    }
  }

  @override
  void initState() {
    pathTracker.add("DP_Maker");
    BlocProvider.of<PostCubit>(context).setStateVariables(
        telegramChannelName: GlobalVariables.telCustomPostChannel);
    currentSelectedFrame = widget.currentSelectedFrame;
    getCameras();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    if (pathTracker.contains("DP_Maker")) {
      pathTracker.remove("DP_Maker");
    }
  }

  // final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final formKey = GlobalKey<FormBuilderState>();

  XFile? imageFile;
  @override
  Widget build(BuildContext context) {
    double test = 100;
    final mq = MediaQuery.of(context).size;
    postSize = mq.width * 0.85;
    return BlocBuilder<StickerCubit, StickerState>(
        builder: (context, stickerState) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          scrolledUnderElevation: 0,
          backgroundColor: Colors.white,
          elevation: 1,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: AppIcons.backButtonIcon,
          ),
          actions: [
            IconButton(
              icon: Column(
                children: const [
                  Icon(
                    Icons.close,
                    color: Colors.black,
                  ),
                  Text(
                    'Reset',
                    style: TextStyle(fontSize: 10),
                  ),
                ],
              ),
              tooltip: 'Reset',
              iconSize: 18,
              color: Colors.black,
              onPressed: () {
                final dpmakerState =
                    BlocProvider.of<DpMakerCubit>(context).state;
                BlocProvider.of<DpMakerCubit>(context).updateStateVariable(
                  dpProfileSize: 0,
                  xPos: dpmakerState.defaultXPos,
                  yPos: dpmakerState.defaultYPos,
                  isProfileDragging: false,
                );
                toast("Reset");
              },
            ),
          ],
          title: const Text(
            'Dp Maker',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ),
        persistentFooterButtons: stickerState.removeBgStatus != Status.loading
            ? null
            : [
                SizedBox(
                  height: 70,
                  width: mq.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        width: mq.width * 0.7,
                        child: Text(
                          tr("remove_bg_text"),
                          maxLines: 2,
                          style: const TextStyle(),
                        ),
                      ),
                      stickerState.imageWithRemovedBg.isNotEmpty
                          ? Stack(
                              alignment: Alignment.center,
                              clipBehavior: Clip.none,
                              children: [
                                SizedBox(
                                  height: 50,
                                  width: 50,
                                  child: Image.file(
                                    File(stickerState.imageWithRemovedBg),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                SizedBox(
                                  height: 70,
                                  width: 70,
                                  child: Lottie.asset(
                                    "assets/images/scan.json",
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ],
                            )
                          : const CircularProgressIndicator(
                              color: AppColors.primaryColor,
                            ),
                    ],
                  ),
                ),
              ],
        body: FormBuilder(
          key: formKey,
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: BlocBuilder<DpMakerCubit, DpMakerState>(
                builder: (context, dpframeState) {
              return BlocBuilder<UserCubit, UserState>(
                  builder: (context, userState) {
                return BlocBuilder<PostEditorCubit, PostEditorState>(
                    builder: (context, stateEditor) {
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        Screenshot(
                          controller: screenshotController,
                          child: Stack(
                            children: [
                              Container(
                                width: mq.width * 0.95,
                                height: mq.width * 0.95,
                                clipBehavior: Clip.antiAlias,
                                decoration:
                                    const BoxDecoration(color: Colors.white),
                                child:
                                    LayoutBuilder(builder: ((p0, constraints) {
                                  double x1 = (currentSelectedFrame!
                                              .customPosition![0] /
                                          100) *
                                      constraints.maxWidth;

                                  double y1 = (currentSelectedFrame!
                                              .customPosition![1] /
                                          100) *
                                      constraints.maxHeight;

                                  double widthI = (currentSelectedFrame!
                                              .customPosition![2] -
                                          currentSelectedFrame!
                                              .customPosition![0]) /
                                      100 *
                                      constraints.maxWidth;
                                  double heightI = (currentSelectedFrame!
                                              .customPosition![3] -
                                          currentSelectedFrame!
                                              .customPosition![1]) /
                                      100 *
                                      constraints.maxHeight;

                                  return DpFrameDynamicWidget(
                                    controller: controller,
                                    posX: x1,
                                    posY: y1,
                                    isDragEnable: stickerState.lockEditor,
                                    width: widthI,
                                    height: heightI,
                                    frameImagePath:
                                        currentSelectedFrame?.path ?? "",
                                    userProfileImage: dpMode == DPMode.camera
                                        ? imageFile?.path
                                        : userState.fileImagePath,
                                    mq: mq,
                                    dpMode: dpMode,
                                  );
                                })),
                              ),
                              Visibility(
                                visible: stickerState.isDateStickerVisible,
                                child: StickerDraggingWidget(
                                  isDragEnable: !stickerState.lockEditor,
                                  body: Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                      DottedBorder(
                                        color: stickerState.lockEditor
                                            ? Colors.transparent
                                            : Colors.white,
                                        child: Padding(
                                          padding: const EdgeInsets.all(3.0),
                                          child: SizedBox(
                                              child: StrokeText(
                                            text: stickerState.dateStickerText,
                                            textStyle: Constants
                                                .googleFontStyles[
                                                    stickerState.fontIndex]
                                                .copyWith(
                                                    color:
                                                        stickerState.dateColor,
                                                    fontSize: stickerState
                                                        .dateFontSize,
                                                    fontWeight:
                                                        FontWeight.bold),
                                            strokeColor:
                                                stickerState.dateBorderColor,
                                            strokeWidth: 5,
                                          )),
                                        ),
                                      ),
                                      stickerState.lockEditor
                                          ? const SizedBox()
                                          : Positioned(
                                              top: -20,
                                              right: -20,
                                              child: IconButton(
                                                  onPressed: () {
                                                    BlocProvider.of<
                                                                StickerCubit>(
                                                            context)
                                                        .updateStateVariables(
                                                            isDateVisible:
                                                                false);
                                                  },
                                                  icon: const Icon(
                                                    Icons.cancel_outlined,
                                                    color: Colors.red,
                                                    size: 20,
                                                  )),
                                            ),
                                    ],
                                  ),
                                ),
                              ),
                              ...List.generate(
                                  stickerState.listOfActiveUserStickers.length,
                                  (index) {
                                final StickerFromAssets sticker = stickerState
                                    .listOfActiveUserStickers[index];
                                return StickerDraggingWidget(
                                  isDragEnable: !stickerState.lockEditor,
                                  body: Stack(
                                    children: [
                                      DottedBorder(
                                        color: stickerState.lockEditor
                                            ? Colors.transparent
                                            : Colors.white,
                                        child: SizedBox(
                                          height: stickerState
                                              .listOfUserStickerSides[index],
                                          width: stickerState
                                              .listOfUserStickerSides[index],
                                          child: Padding(
                                            padding: const EdgeInsets.all(3.0),
                                            child: Image.file(
                                              File(sticker.imageLink),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ),
                                      stickerState.lockEditor
                                          ? const SizedBox()
                                          : Positioned(
                                              top: -5,
                                              right: -5,
                                              child: IconButton(
                                                  onPressed: () {
                                                    BlocProvider.of<
                                                                StickerCubit>(
                                                            context)
                                                        .userStickerOperations(
                                                            imageUrl: sticker
                                                                .imageLink,
                                                            isDelete: true,
                                                            isOperationForAddingInEditor:
                                                                true);
                                                  },
                                                  icon: const Icon(
                                                    Icons.cancel_outlined,
                                                    color: Colors.red,
                                                    size: 20,
                                                  )),
                                            ),
                                    ],
                                  ),
                                );
                              }),
                              ...List.generate(stickerState.stickerDList.length,
                                  (index) {
                                final StickerFromNetwork sticker =
                                    stickerState.stickerDList[index];
                                return DraggerWidget(
                                  isDragEnable: !stickerState.lockEditor,
                                  centerX:
                                      stickerState.stickerDListSides[index] / 2,
                                  centerY:
                                      stickerState.stickerDListSides[index] / 2,
                                  body: Stack(
                                    children: [
                                      DottedBorder(
                                        color: stickerState.lockEditor
                                            ? Colors.transparent
                                            : Colors.white,
                                        child: SizedBox(
                                          height: stickerState
                                              .stickerDListSides[index],
                                          width: stickerState
                                              .stickerDListSides[index],
                                          child: CachedNetworkImage(
                                            imageUrl: sticker.imageLink,
                                            fit: BoxFit.cover,
                                            imageBuilder:
                                                (context, imageProvider) {
                                              return Container(
                                                  decoration: BoxDecoration(
                                                      image: DecorationImage(
                                                image: imageProvider,
                                                fit: BoxFit.fill,
                                              )));
                                            },
                                            placeholder: (context, url) =>
                                                const Center(
                                                    child:
                                                        CircularProgressIndicator()),
                                            errorWidget:
                                                (context, url, error) =>
                                                    const Icon(Icons.error),
                                          ),
                                        ),
                                      ),
                                      stickerState.lockEditor
                                          ? const SizedBox()
                                          : Positioned(
                                              top: -5,
                                              right: -5,
                                              child: IconButton(
                                                  onPressed: () {
                                                    BlocProvider.of<
                                                                StickerCubit>(
                                                            context)
                                                        .stickerOperation(
                                                            isRemoveSticker:
                                                                true,
                                                            stickerId:
                                                                sticker.id,
                                                            index: index);
                                                  },
                                                  icon: const Icon(
                                                    Icons.cancel_outlined,
                                                    color: Colors.red,
                                                    size: 20,
                                                  )),
                                            ),
                                    ],
                                  ),
                                );
                              }),
                              ...List.generate(
                                  stateEditor.listOfCustomTextStyles.length,
                                  (index) {
                                return StickerDraggingWidget(
                                  isDragEnable: !stickerState.lockEditor,
                                  body: Stack(
                                    children: [
                                      DottedBorder(
                                        color: stickerState.lockEditor
                                            ? Colors.transparent
                                            : Colors.white,
                                        child: EditorMultiperTextWidgets(
                                          isEditorLocked:
                                              stickerState.lockEditor,
                                          text: stateEditor
                                              .listOfCustomText[index],
                                          textStyle: stateEditor
                                              .listOfCustomTextStyles[index],
                                          mainIndex: index,
                                        ),
                                      ),
                                      Positioned(
                                        right: -15,
                                        top: -15,
                                        child: Visibility(
                                          visible: !stickerState.lockEditor,
                                          child: IconButton(
                                              onPressed: () {
                                                BlocProvider.of<
                                                            PostEditorCubit>(
                                                        context)
                                                    .customTextStylesOperations(
                                                        index: index,
                                                        isDeleteOperation:
                                                            true);
                                              },
                                              icon: const Icon(
                                                Icons.cancel,
                                                size: 20,
                                                color: Colors.red,
                                              )),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              })
                            ],
                          ),
                        ),
                        Visibility(
                            visible: dpMode == DPMode.camera,
                            child: SizedBox(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  TextButton(
                                    onPressed: () async {
                                      if (controller != null) {
                                        await controller!
                                            .takePicture()
                                            .then((value) {
                                          setState(() {
                                            imageFile = value;
                                          });
                                        });
                                      }
                                    },
                                    child: const Text(
                                      'Capture',
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      setState(() {
                                        imageFile = null;
                                      });
                                    },
                                    child: const Text(
                                      'Cancel',
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )),
                        SizedBox(
                            height: 150,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: [
                                InkWell(
                                  onTap: (() {
                                    if (dpMode == DPMode.photo) {
                                      controller = CameraController(
                                        _cameras.last,
                                        ResolutionPreset.high,
                                        enableAudio: false,
                                        imageFormatGroup: ImageFormatGroup.jpeg,
                                      );
                                      controller?.initialize().then((_) {
                                        if (!mounted) {
                                          return;
                                        }
                                        setState(() {
                                          dpMode = DPMode.camera;
                                        });
                                      }).catchError((Object e) {
                                        if (e is CameraException) {
                                          switch (e.code) {
                                            case 'CameraAccessDenied':
                                              break;
                                            default:
                                              break;
                                          }
                                        }
                                      });
                                    } else {
                                      setState(() {
                                        dpMode = DPMode.camera;
                                        if (controller != null) {
                                          controller!.dispose();
                                        }
                                        dpMode = DPMode.photo;
                                      });
                                    }
                                  }),
                                  child: SizedBox(
                                    height: 75,
                                    width: 75,
                                    child: Center(
                                      child: Icon(
                                        dpMode == DPMode.camera
                                            ? Icons.close
                                            : Icons.camera_alt_outlined,
                                        color: dpMode == DPMode.camera
                                            ? Colors.red
                                            : AppColors.primaryColor,
                                      ),
                                    ),
                                  ),
                                ),
                                MultiplePhotoSelector(
                                  onSelect: (p0) {
                                    setState(() {
                                      dpMode = DPMode.camera;
                                      if (controller != null) {
                                        controller!.dispose();
                                      }
                                      dpMode = DPMode.photo;
                                    });
                                  },
                                  isEnableScrolling: false,
                                  title: "",
                                  mq: mq,
                                )
                              ],
                            )),
                        const SizedBox(height: 15),
                        Visibility(
                          visible: !stickerState.lockEditor,
                          child: Row(
                            children: [
                              const Spacer(),
                              SizedBox(
                                  height: 50,
                                  width: 50,
                                  child: Image.file(
                                    File(userState.fileImagePath),
                                    fit: BoxFit.cover,
                                  )),
                              SizedBox(
                                width: mq.width * 0.7,
                                child: Slider(
                                  value: dpframeState.dpProfileSize,
                                  min: 0,
                                  max: 200,
                                  onChangeStart: (value) {
                                    BlocProvider.of<DpMakerCubit>(context)
                                        .updateStateVariable(
                                            dpProfileSize: value,
                                            isProfileDragging: true);
                                  },
                                  onChangeEnd: (value) {
                                    BlocProvider.of<DpMakerCubit>(context)
                                        .updateStateVariable(
                                            dpProfileSize: value,
                                            isProfileDragging: false);
                                  },
                                  onChanged: ((value) {
                                    BlocProvider.of<DpMakerCubit>(context)
                                        .updateStateVariable(
                                            dpProfileSize: value);
                                  }),
                                ),
                              ),
                              const Spacer(),
                            ],
                          ),
                        ),
                        const SizedBox(height: 15),
                        Visibility(
                          visible: stickerState.lockEditor,
                          replacement: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Row(
                                children: [
                                  Text(tr('show_rishteyy'),
                                      style: const TextStyle()),
                                  Switch.adaptive(
                                      value: stateEditor.isRishteyyVisible,
                                      activeTrackColor: const Color(0xFF01173D),
                                      activeThumbImage:
                                          const AssetImage(AppImages.appLogo),
                                      inactiveThumbImage:
                                          const AssetImage(AppImages.appLogo),
                                      onChanged: (val) {
                                        if (BlocProvider.of<UserCubit>(context)
                                                .state
                                                .isPremiumUser ==
                                            true) {
                                          BlocProvider.of<PostEditorCubit>(
                                                  context)
                                              .updateStateVariables(
                                                  isRishteyyVisible: val);
                                        } else {
                                          showPremiumCustomDialogue(
                                            context: context,
                                            title: tr("premium_warning",
                                                namedArgs: {
                                                  "title": tr("feature")
                                                }),
                                            onTap: (() {
                                              nextScreenWithFadeAnimation(
                                                  context,
                                                  const PremiumPlanScreen());
                                            }),
                                            mq: mq,
                                          );
                                        }
                                      }),
                                  const Spacer(),
                                  Visibility(
                                    visible: !stickerState.lockEditor,
                                    replacement: DownloadButton(
                                        screenshotController1:
                                            screenshotController,
                                        postId:
                                            "DP_FRAME_${widget.currentSelectedFrame.id}"),
                                    child: IconButton(
                                        onPressed: () {
                                          FocusScope.of(context).unfocus();
                                          BlocProvider.of<StickerCubit>(context)
                                              .updateStateVariables(
                                                  hideCancelButton: true);
                                        },
                                        icon: const Icon(
                                          Icons.done_outline,
                                          size: 30,
                                          color: Colors.green,
                                        )),
                                  ),
                                ],
                              )),
                          child: Row(
                            children: [
                              const Spacer(
                                flex: 3,
                              ),
                              IconButton(
                                  onPressed: () {
                                    BlocProvider.of<StickerCubit>(context)
                                        .hideCancelButton(false);
                                  },
                                  icon: Row(
                                    children: [
                                      const Icon(
                                        Icons.open_with,
                                        size: 25,
                                        color: Colors.black,
                                      ),
                                      Text(
                                        " ${tr('change_pos')}",
                                        style: const TextStyle(
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  )),
                              const Spacer(flex: 20),
                              DownloadButton(
                                  screenshotController1: screenshotController,
                                  postId: "Dp_FRAME"),
                            ],
                          ),
                        ),
                        const SizedBox(height: 15),
                        Container(
                          width: mq.width,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                                bottomLeft: Radius.circular(0),
                                bottomRight: Radius.circular(0)),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.grey,
                                  blurRadius: 2,
                                  spreadRadius: 1)
                            ],
                          ),
                          child: BlocBuilder<PostEditorCubit, PostEditorState>(
                              builder: (context, postEditorState) {
                            return BlocBuilder<StickerCubit, StickerState>(
                                builder: (context, state) {
                              return Column(
                                children: [
                                  state.editorWidget != EditorWidgets.none
                                      ? BottomAnimationWrapper(
                                          duration:
                                              const Duration(milliseconds: 500),
                                          child: getEditorOpenWidget(
                                              state.editorWidget))
                                      : Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Visibility(
                                                  visible: postEditorState
                                                      .isWhiteFrame,
                                                  child: Card(
                                                    elevation: 20,
                                                    child: InkWell(
                                                      onTap: () {
                                                        showCBottomSheet(
                                                          context: context,
                                                          height:
                                                              mq.height * 0.4,
                                                          child:
                                                              SingleChildScrollView(
                                                            child: Column(
                                                              children: [
                                                                CColorPicker(
                                                                  onColorTap:
                                                                      (color) {
                                                                    BlocProvider.of<PostEditorCubit>(
                                                                            context)
                                                                        .updateStateVariables(
                                                                      numberColor:
                                                                          color,
                                                                      occupationColor:
                                                                          color,
                                                                      nameColor:
                                                                          color,
                                                                    );
                                                                  },
                                                                ),
                                                                TextButton(
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                  child:
                                                                      const Text(
                                                                    'Ok',
                                                                    style:
                                                                        TextStyle(),
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                      child: Container(
                                                        height: 20,
                                                        width: 20,
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(3),
                                                          color: Colors.red,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            ...List.generate(
                                                state.listOfActiveUserStickers
                                                    .length,
                                                growable: false, (index) {
                                              StickerFromAssets sticker = state
                                                      .listOfActiveUserStickers[
                                                  index];
                                              return Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  SizedBox(
                                                      height: 40,
                                                      width: 40,
                                                      child: Image.file(
                                                        File(sticker.imageLink),
                                                        fit: BoxFit.contain,
                                                      )),
                                                  Slider(
                                                    min: 50,
                                                    max: 200,
                                                    // divisions: 30,
                                                    value: state
                                                            .listOfUserStickerSides[
                                                        index],
                                                    onChanged: (val) {
                                                      BlocProvider.of<
                                                                  StickerCubit>(
                                                              context)
                                                          .userStickerOperations(
                                                        imageUrl: "",
                                                        isIncreaseStickerSize:
                                                            true,
                                                        isOperationForAddingInEditor:
                                                            true,
                                                        index: index,
                                                        side: val,
                                                      );
                                                    },
                                                  ),
                                                  IconButton(
                                                      onPressed: () {
                                                        BlocProvider.of<
                                                                    StickerCubit>(
                                                                context)
                                                            .userStickerOperations(
                                                                imageUrl: sticker
                                                                    .imageLink,
                                                                isDelete: true,
                                                                isOperationForAddingInEditor:
                                                                    true);
                                                      },
                                                      icon: const Icon(
                                                        Icons.cancel,
                                                        color: Colors.red,
                                                        size: 20,
                                                      )),
                                                ],
                                              );
                                            }),
                                            ...List.generate(
                                                state.stickerDList.length,
                                                growable: false, (index) {
                                              StickerFromNetwork sticker =
                                                  state.stickerDList[index];
                                              return Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  SizedBox(
                                                      height: 40,
                                                      width: 40,
                                                      child: CachedNetworkImage(
                                                        imageUrl:
                                                            sticker.imageLink,
                                                        fit: BoxFit.contain,
                                                      )),
                                                  Slider(
                                                    min: 50,
                                                    max: 200,
                                                    value:
                                                        state.stickerDListSides[
                                                            index],
                                                    onChanged: (val) {
                                                      BlocProvider.of<
                                                                  StickerCubit>(
                                                              context)
                                                          .stickerOperation(
                                                              isUpdateStickerSize:
                                                                  true,
                                                              side: val,
                                                              stickerId:
                                                                  sticker.id,
                                                              index: index);
                                                    },
                                                  ),
                                                  IconButton(
                                                      onPressed: () {
                                                        BlocProvider.of<
                                                                    StickerCubit>(
                                                                context)
                                                            .stickerOperation(
                                                                isRemoveSticker:
                                                                    true,
                                                                stickerId:
                                                                    sticker.id,
                                                                index: index);
                                                      },
                                                      icon: const Icon(
                                                        Icons.cancel,
                                                        color: Colors.red,
                                                        size: 20,
                                                      )),
                                                ],
                                              );
                                            }),
                                            const SizedBox(height: 20),
                                            buildEditorFirstRow(context, mq),
                                            const SizedBox(height: 20),
                                            // const SizedBox(height: 20),
                                            // Visibility(
                                            //   visible: isEvenVersion(),
                                            //   child: TextButton(
                                            //     onPressed: () {
                                            //       BlocProvider.of<
                                            //                   PostEditorCubit>(
                                            //               context)
                                            //           .customTextStylesOperations(
                                            //               isAddOperation: true,
                                            //               index: 0);
                                            //     },
                                            //     child: const Text(
                                            //       'Add Text',
                                            //       style: TextStyle(
                                            //         fontSize: 15,
                                            //         color: Colors.black,
                                            //       ),
                                            //     ),
                                            //   ),
                                            // ),
                                          ],
                                        ),
                                ],
                              );
                            });
                          }),
                        ),
                      ],
                    ),
                  );
                });
              });
            }),
          ),
        ),
      );
    });
  }

  Widget getEditorOpenWidget(EditorWidgets editorWidgets) {
    // if (editorWidgets == EditorWidgets.profileSizeAndShape) {
    //   return const EditorProfileShapeAndSizeWidget();
    // }
    if (editorWidgets == EditorWidgets.dateText) {
      return EditorDateWidget(formKey: formKey);
    }
    // if (editorWidgets == EditorWidgets.colorWidget) {
    //   return const EditorColorWidget();
    // }
    // if (editorWidgets == EditorWidgets.profileStaticPos) {
    //   return const EditorProfilePositionEditor();
    // }
    // if (editorWidgets == EditorWidgets.playStoreBadge) {
    //   return const EditorPlayStoreWidget();
    // }
    if (editorWidgets == EditorWidgets.stickerWidget) {
      int stickerLen = BlocProvider.of<StickerCubit>(context, listen: false)
          .state
          .stickerTopicList
          .length;
      return EditorStickerWidget(
        stickerLen: stickerLen,
      );
    }
    return const SizedBox();
  }

  Row buildEditorFirstRow(BuildContext context, Size mq) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        InkWell(
          onTap: () {
            BlocProvider.of<StickerCubit>(context).updateStateVariables(
                editorWidgets: EditorWidgets.dateText, isDateVisible: true);
          },
          child: Container(
            height: mq.height * 0.1,
            width: mq.width * 0.3,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(3.0),
              child: Container(
                height: mq.height * 0.1,
                width: mq.width * 0.4,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Image.asset(
                    "assets/images/date_editor.png",
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
        ),
        openStickerModel(context, mq),
      ],
    );
  }

  Widget whatsAppShare(String postId, String imageLink, Size mq,
      {required PostWidgetModel postWidgetData}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
      child: InkWell(
        child: Row(
          children: [
            const Spacer(
              flex: 3,
            ),
            IconButton(
                onPressed: () {
                  BlocProvider.of<StickerCubit>(context)
                      .hideCancelButton(false);
                },
                icon: Row(
                  children: [
                    const Icon(
                      Icons.open_with,
                      size: 25,
                      color: Colors.black,
                    ),
                    Text(
                      " ${tr('change_pos')}",
                      style: const TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ],
                )),
            const Spacer(flex: 20),
            WhatsAppShareButton(
                screenshotController1: screenshotController,
                postId: postId,
                postWidgetData: postWidgetData

                // telegramChannelName: ,
                ),
          ],
        ),
      ),
    );
  }
}
