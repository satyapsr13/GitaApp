import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:screenshot/screenshot.dart';
import 'package:stroke_text/stroke_text.dart';

import '../../../../Constants/constants.dart';
import '../../../../Constants/enums.dart';
import '../../../../Logic/Cubit/PostEditorCubit/post_editor_cubit.dart';
import '../../../../Logic/Cubit/StickerCubit/sticker_cubit.dart';
import '../../../../Logic/Cubit/locale_cubit/locale_cubit.dart';
import '../../../Widgets/Buttons/buttons.dart';
import '../../../Widgets/Buttons/circular_color.button.dart';
import '../../../Widgets/frame_to_frame_details.dart';
import '../../../Widgets/post_widget.dart';
import '../PostFrames/post_frames.dart';
import '../StickerComponents/sticker_dragger.dart';
import '../post_edit_screen.dart';
import 'EditorButtonsWidget/editor_multiple_text_widgets.dart';
import 'dotted_border.widget.dart';
import 'edit_screen_show_hide_button_widget.dart';
import 'editor_date_tag_widget.dart';
import 'font_dropdown.widget.dart';
import 'image_tag_for_editor.dart';
import 'positions_helper_function.dart';

class BlankPostPreviewWidget extends StatefulWidget {
  const BlankPostPreviewWidget({
    Key? key,
    required this.screenshotController,
    required this.outerBorderRadius,
    required this.postSize,
    // required this.userPickedImage,
    this.makePostFromGallery,
    required this.userNameColor,
  }) : super(key: key);

  final ScreenshotController screenshotController;
  final double outerBorderRadius;
  final double postSize;
  final bool? makePostFromGallery;
  // final File? userPickedImage;
  final Color userNameColor;

  @override
  State<BlankPostPreviewWidget> createState() => _BlankPostPreviewWidgetState();
}

class _BlankPostPreviewWidgetState extends State<BlankPostPreviewWidget> {
  bool showMore = false;

  final TextEditingController _controller = TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double extendedHeight = 40;
  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    double maxWid = mq.width - 30;

    extendedHeight = (maxWid / 3) - 12 - (maxWid / 9);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: BlocBuilder<PostEditorCubit, PostEditorState>(
          builder: (context, postEditorState) {
        return Column(
          children: [
            Card(
              elevation: 5,
              child: Screenshot(
                  controller: widget.screenshotController,
                  child: BlocBuilder<StickerCubit, StickerState>(
                      builder: (context, stickerState) {
                    return Stack(
                      children: [
                        Column(
                          children: [
                            Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Container(
                                  width: mq.width - 30,
                                  decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          topRight: Radius.circular(10),
                                          bottomLeft: Radius.circular(0),
                                          bottomRight: Radius.circular(0))),
                                  child: LayoutBuilder(
                                      builder: (context, constraints) {
                                    return Stack(
                                      clipBehavior: Clip.none,
                                      children: [
                                        postEditorState
                                                    .blankPostBgImage.length >
                                                2
                                            ? Stack(
                                                children: [
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    child: CachedNetworkImage(
                                                        imageUrl: postEditorState
                                                            .blankPostBgImage,
                                                        progressIndicatorBuilder:
                                                            ((context, url,
                                                                progress) {
                                                          return Center(
                                                            child:
                                                                RishteyyShimmerLoader(
                                                              mq: mq,
                                                            ),
                                                          );
                                                        }),
                                                        fit: BoxFit.cover),
                                                  ),
                                                  Container(
                                                    width: mq.width - 30,
                                                    height: mq.width - 30,
                                                    alignment: Alignment.center,
                                                    child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                top: 15,
                                                                left: 5,
                                                                right: 5),
                                                        child: StrokeTextField(
                                                            controller:
                                                                _controller)),
                                                  )
                                                ],
                                              )
                                            : Container(
                                                width: mq.width - 30,
                                                height: mq.width - 30,
                                                alignment: Alignment.center,
                                                constraints:
                                                    const BoxConstraints(),
                                                decoration: BoxDecoration(
                                                  gradient: postEditorState
                                                      .postGradient,
                                                ),
                                                child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 15,
                                                            left: 5,
                                                            right: 5),
                                                    child: StrokeTextField(
                                                        controller:
                                                            _controller)),
                                              ),
                                        !postEditorState.isFrameVisible
                                            ? const SizedBox()
                                            : FrameWidgetForEditor(
                                                frameDetails: postEditorState
                                                            .currentFrame !=
                                                        null
                                                    ? frameToFrameDetails(
                                                        postEditorState
                                                            .currentFrame!,
                                                        constraints.maxWidth)
                                                    : FrameDetails(
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
                                                        nameColor: '#ffffff',
                                                        numberColor: '#ffffff',
                                                        occupationColor:
                                                            '#ffffff',
                                                      ),
                                              )
                                      ],
                                    );
                                  }),
                                ),
                                Positioned(
                                  top: rishteyyTagTopPosition(
                                      postEditorState.rishteyyTagPosition),
                                  left: rishteyyTagLeftPosition(
                                      postEditorState.rishteyyTagPosition),
                                  right: rishteyyTagRightPosition(
                                      postEditorState.rishteyyTagPosition),
                                  child: Visibility(
                                    visible: postEditorState.isRishteyyVisible,
                                    child: RishteyyTag(
                                      tagColor: postEditorState.tagColor,
                                      tagPosition:
                                          postEditorState.rishteyyTagPosition,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                                height: (postEditorState.isFrameVisible
                                    ? extendedHeight
                                    : 0)),
                          ],
                        ),
                        (postEditorState.isAdvanceEditorMode)
                            ? Visibility(
                                visible: true,
                                child: StickerDraggingWidget(
                                  isDragEnable: !stickerState.lockEditor,
                                  xPos: mq.width * 0.4,
                                  yPos: mq.width * 0.4,
                                  body: Stack(
                                    children: [
                                      stickerState.lockEditor == true
                                          ? Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: ImageTagForEditor(
                                                  onImageTap: () {
                                                    BlocProvider.of<
                                                                StickerCubit>(
                                                            context)
                                                        .updateStateVariables(
                                                            hideCancelButton:
                                                                false,
                                                            editorWidgets:
                                                                EditorWidgets
                                                                    .profileSizeAndShape);
                                                    BlocProvider.of<
                                                                PostEditorCubit>(
                                                            context)
                                                        .updateStateVariables(
                                                      isAdvanceEditorMode:
                                                          !postEditorState
                                                              .isAdvanceEditorMode,
                                                    );
                                                  },
                                                  profileShape: postEditorState
                                                      .profileShape),
                                            )
                                          : DottedBorder(
                                              color: Colors.white,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: ImageTagForEditor(
                                                  onImageTap: () {
                                                    BlocProvider.of<
                                                                StickerCubit>(
                                                            context)
                                                        .updateStateVariables(
                                                            hideCancelButton:
                                                                false,
                                                            editorWidgets:
                                                                EditorWidgets
                                                                    .profileSizeAndShape);
                                                    BlocProvider.of<
                                                                PostEditorCubit>(
                                                            context)
                                                        .updateStateVariables(
                                                      isAdvanceEditorMode:
                                                          !postEditorState
                                                              .isAdvanceEditorMode,
                                                    );
                                                  },
                                                  profileShape: postEditorState
                                                      .profileShape,
                                                ),
                                              ),
                                            ),
                                    ],
                                  ),
                                ),
                              )
                            : Positioned(
                                right: postEditorState.profilePos == "right"
                                    ? 10
                                    : postEditorState.profilePos ==
                                            "right-touched"
                                        ? 0
                                        : null,
                                left: postEditorState.profilePos == "left"
                                    ? 10
                                    : postEditorState.profilePos ==
                                            "left-touched"
                                        ? 0
                                        : null,
                                bottom: ((postEditorState.profilePos ==
                                            "right-touched") ||
                                        (postEditorState.profilePos ==
                                            "left-touched"))
                                    ? 0
                                    : 10,
                                child: ImageTagForEditor(
                                  onImageTap: () {
                                    BlocProvider.of<PostEditorCubit>(context)
                                        .updateStateVariables(
                                            isAdvanceEditorMode: true);
                                  },
                                  profileShape: postEditorState.profileShape,
                                )),
                        ...List.generate(
                            stickerState.listOfActiveUserStickers.length,
                            (index) {
                          final StickerFromAssets sticker =
                              stickerState.listOfActiveUserStickers[index];
                          return StickerDraggingWidget(
                            isDragEnable: !stickerState.lockEditor,
                            body: Stack(
                              alignment: Alignment.topRight,
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
                                true
                                    ? CCloseButton(
                                        isVisible: !stickerState.lockEditor,
                                        onTap: () {
                                          BlocProvider.of<StickerCubit>(context)
                                              .userStickerOperations(
                                                  imageUrl: sticker.imageLink,
                                                  isDelete: true,
                                                  isOperationForAddingInEditor:
                                                      true);
                                        },
                                      )
                                    : stickerState.lockEditor
                                        ? const SizedBox()
                                        : Positioned(
                                            top: -5,
                                            right: -5,
                                            child: IconButton(
                                                onPressed: () {
                                                  BlocProvider.of<StickerCubit>(
                                                          context)
                                                      .userStickerOperations(
                                                          imageUrl:
                                                              sticker.imageLink,
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
                          StickerFromNetwork sticker =
                              stickerState.stickerDList[index];
                          return StickerDraggingWidget(
                            isDragEnable: !stickerState.lockEditor,
                            body: Stack(
                              alignment: Alignment.topRight,
                              children: [
                                DottedBorder(
                                  color: stickerState.lockEditor
                                      ? Colors.transparent
                                      : Colors.white,
                                  child: SizedBox(
                                    height:
                                        stickerState.stickerDListSides[index],
                                    width:
                                        stickerState.stickerDListSides[index],
                                    child: CachedNetworkImage(
                                      imageUrl: sticker.imageLink,
                                      fit: BoxFit.cover,
                                      imageBuilder: (context, imageProvider) {
                                        return Container(
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: imageProvider,
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                        );
                                      },
                                      placeholder: (context, url) =>
                                          const Center(
                                              child: CircularProgressIndicator(
                                        color: Colors.orange,
                                      )),
                                      errorWidget: (context, url, error) =>
                                          const Icon(Icons.error),
                                    ),
                                  ),
                                ),
                                true
                                    ? CCloseButton(
                                        isVisible: !stickerState.lockEditor,
                                        onTap: () {
                                          BlocProvider.of<StickerCubit>(context)
                                              .stickerOperation(
                                                  isRemoveSticker: true,
                                                  stickerId: sticker.id,
                                                  index: index);
                                        },
                                      )
                                    : stickerState.lockEditor
                                        ? const SizedBox()
                                        : Positioned(
                                            top: -5,
                                            right: -5,
                                            child: IconButton(
                                                onPressed: () {
                                                  BlocProvider.of<StickerCubit>(
                                                          context)
                                                      .stickerOperation(
                                                          isRemoveSticker: true,
                                                          stickerId: sticker.id,
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
                        Visibility(
                          visible: stickerState.isDateStickerVisible,
                          child: StickerDraggingWidget(
                            isDragEnable: !stickerState.lockEditor,
                            body: Stack(
                              clipBehavior: Clip.none,
                              alignment: Alignment.topRight,
                              children: [
                                DottedBorder(
                                  color: stickerState.lockEditor
                                      ? Colors.transparent
                                      : Colors.white,
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: SizedBox(
                                        child: StrokeText(
                                      text: stickerState.dateStickerText,
                                      textStyle: Constants.googleFontStyles[
                                              stickerState.fontIndex]
                                          .copyWith(
                                              color: stickerState.dateColor,
                                              fontSize:
                                                  stickerState.dateFontSize,
                                              fontWeight: FontWeight.bold),
                                      strokeColor: stickerState.dateBorderColor,
                                      strokeWidth: 5,
                                    )),
                                  ),
                                ),
                                true
                                    ? CCloseButton(
                                        isVisible: !stickerState.lockEditor,
                                        onTap: () {
                                          BlocProvider.of<StickerCubit>(context)
                                              .updateStateVariables(
                                                  isDateVisible: false);
                                        },
                                      )
                                    : stickerState.lockEditor
                                        ? const SizedBox()
                                        : Positioned(
                                            top: -20,
                                            right: -20,
                                            child: IconButton(
                                                onPressed: () {
                                                  BlocProvider.of<StickerCubit>(
                                                          context)
                                                      .updateStateVariables(
                                                          isDateVisible: false);
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
                        Visibility(
                          visible: postEditorState.isDateTagVisible,
                          child: postEditorState.datePosition ==
                                  DatePos.dragging
                              ? StickerDraggingWidget(
                                  isDragEnable: !stickerState.lockEditor,
                                  body: Stack(
                                  alignment: Alignment.topRight,
                                    children: [
                                      !stickerState.lockEditor
                                          ? DottedBorder(
                                              color: Colors.white,
                                              child: const EditorDateTagWidget(
                                                isDateEditable: true,
                                              ),
                                            )
                                          : const EditorDateTagWidget(
                                              isDateEditable: true,
                                            ),
                                      true
                                          ? CCloseButton(
                                              isVisible:
                                                  !stickerState.lockEditor,
                                              onTap: () {
                                                BlocProvider.of<
                                                            PostEditorCubit>(
                                                        context)
                                                    .updateStateVariables(
                                                        isDateTagVisible:
                                                            false);
                                              },
                                            )
                                          : stickerState.lockEditor
                                              ? const SizedBox()
                                              : Positioned(
                                                  top: -15,
                                                  right: -15,
                                                  child: IconButton(
                                                      onPressed: () {
                                                        BlocProvider.of<
                                                                    PostEditorCubit>(
                                                                context)
                                                            .updateStateVariables(
                                                                isDateTagVisible:
                                                                    false);
                                                      },
                                                      icon: const Icon(
                                                        Icons.cancel_outlined,
                                                        color: Colors.red,
                                                        size: 20,
                                                      )),
                                                ),
                                    ],
                                  ))
                              : Positioned(
                                  top: 10,
                                  left: getDatePosition(
                                      datePosition:
                                          postEditorState.datePosition,
                                      isLeft: true),
                                  right: getDatePosition(
                                      datePosition:
                                          postEditorState.datePosition,
                                      isLeft: false),
                                  child: const EditorDateTagWidget(),
                                ),
                        ),
                        ...List.generate(
                            postEditorState.listOfCustomTextStyles.length,
                            (index) {
                          return StickerDraggingWidget(
                            isDragEnable: !stickerState.lockEditor,
                            body: Stack(
                              clipBehavior: Clip.none,
                              alignment: Alignment.topLeft,
                              children: [
                                DottedBorder(
                                  color: stickerState.lockEditor
                                      ? Colors.transparent
                                      : Colors.white,
                                  child: EditorMultiperTextWidgets(
                                    isEditorLocked: stickerState.lockEditor,
                                    text:
                                        postEditorState.listOfCustomText[index],
                                    textStyle: postEditorState
                                        .listOfCustomTextStyles[index],
                                    mainIndex: index,
                                  ),
                                ),
                                true
                                    ? CCloseButton(
                                        isVisible: !stickerState.lockEditor,
                                        onTap: () {
                                          BlocProvider.of<PostEditorCubit>(
                                                  context)
                                              .customTextStylesOperations(
                                                  index: index,
                                                  isDeleteOperation: true);
                                        },
                                      )
                                    : Positioned(
                                        left: -25,
                                        top: -25,
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
                                              icon: Container(
                                                height: 18,
                                                width: 18,
                                                decoration: const BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Colors.white,
                                                ),
                                                child: const Icon(
                                                  Icons.close,
                                                  size: 15,
                                                  color: Colors.black,
                                                ),
                                              )),
                                        ),
                                      ),
                              ],
                            ),
                          );
                        })
                      ],
                    );
                    // });
                  })),
            ),
            BlocBuilder<StickerCubit, StickerState>(builder: (context, state) {
              return Visibility(
                visible: !state.lockEditor,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: EditScreenShowHideAndFramesWidget(mq: mq),
                ),
              );
            }),
            BlocBuilder<StickerCubit, StickerState>(builder: (context, state) {
              return Column(
                // mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 5),
                  // BlocBuilder<StickerCubit, StickerState>(
                  //     builder: (context, state) {
                  //   return Slider(
                  //     value: state.blankPostTextFontSize,
                  //     thumbColor: const Color(0xFF01173D),
                  //     activeColor: const Color(0xFF022D77),
                  //     onChanged: (val) {
                  //       BlocProvider.of<StickerCubit>(context)
                  //           .updateStateVariables(blankPostTextFontSize: val);
                  //     },
                  //     min: 18,
                  //     max: 40,
                  //   );
                  // }),
                  Visibility(
                    visible: !state.lockEditor,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8, right: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const FontDropdownWidget(
                            isDense: false,
                            isBlankPostFont: true,
                            // width: mq.width * 0.25,
                          ),
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(
                                  width: 1,
                                  color: Colors.grey,
                                )),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                    tooltip: "Font Size",
                                    onPressed: () {
                                      BlocProvider.of<StickerCubit>(context)
                                          .updateStateVariables(
                                              blankPostTextFontSize:
                                                  state.blankPostTextFontSize -
                                                      1);
                                    },
                                    icon: const Icon(
                                      Icons.remove,
                                      color: Colors.grey,
                                      size: 30,
                                    )),
                                Text(
                                  (state.blankPostTextFontSize.toInt())
                                      .toString(),
                                  style: const TextStyle(),
                                ),
                                IconButton(
                                    tooltip: "Font Size",
                                    onPressed: () {
                                      BlocProvider.of<StickerCubit>(context)
                                          .updateStateVariables(
                                              blankPostTextFontSize:
                                                  state.blankPostTextFontSize +
                                                      1);
                                    },
                                    icon: const Icon(
                                      Icons.add,
                                      size: 30,
                                      color: Colors.grey,
                                    )),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: InkWell(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Row(
                                      children: [
                                        const Spacer(),
                                        IconButton(
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            icon: const Icon(
                                              Icons.cancel,
                                              size: 30,
                                              color: Colors.black,
                                            )),
                                      ],
                                    ),
                                    content: SizedBox(
                                      width: mq.width * 0.7,
                                      height: mq.height * 0.5,
                                      child: GridView.builder(
                                        itemCount: Constants.colorList.length,
                                        itemBuilder: (ctx, index) {
                                          Color color =
                                              Constants.colorList[index];

                                          return InkWell(
                                            onTap: () {
                                              FocusScope.of(context).unfocus();
                                              BlocProvider.of<StickerCubit>(
                                                      context)
                                                  .updateStateVariables(
                                                      blankPostTextColor:
                                                          color);
                                            },
                                            child: CircularColorButton(
                                              color: color,
                                            ),
                                          );
                                        },
                                        gridDelegate:
                                            const SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: 4,
                                                childAspectRatio: 1,
                                                crossAxisSpacing: 0,
                                                mainAxisSpacing: 0),
                                      ),
                                    ),
                                    actions: [
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text(
                                          'Ok',
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              },
                              child: Column(
                                children: [
                                  Container(
                                    height: 30,
                                    width: 30,
                                    decoration: BoxDecoration(
                                      // shape: BoxShape.circle,

                                      borderRadius: BorderRadius.circular(5),
                                      color: state.blankPostTextColor,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 5,
                                          blurRadius: 7,
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Text(
                                    'Text Color',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 10,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: InkWell(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Row(
                                      children: [
                                        const Spacer(),
                                        IconButton(
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            icon: const Icon(
                                              Icons.cancel,
                                              size: 30,
                                              color: Colors.black,
                                            )),
                                      ],
                                    ),
                                    content: SizedBox(
                                      width: mq.width * 0.7,
                                      height: mq.height * 0.5,
                                      child: GridView.builder(
                                        itemCount:
                                            Constants.colorList.length + 1,
                                        itemBuilder: (ctx, index) {
                                          Color color =
                                              Constants.colorList.length <=
                                                      index
                                                  ? Colors.transparent
                                                  : Constants.colorList[index];
                                          return InkWell(
                                            onTap: () {
                                              FocusScope.of(context).unfocus();
                                              BlocProvider.of<StickerCubit>(
                                                      context)
                                                  .updateStateVariables(
                                                      blankPostBorderColor:
                                                          color);
                                            },
                                            child: CircularColorButton(
                                              color: color,
                                              isTransparentColor:
                                                  Constants.colorList.length <=
                                                          index
                                                      ? true
                                                      : null,
                                            ),
                                          );
                                        },
                                        gridDelegate:
                                            const SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: 4,
                                                childAspectRatio: 1,
                                                crossAxisSpacing: 0,
                                                mainAxisSpacing: 0),
                                      ),
                                    ),
                                    actions: [
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text(
                                          'Ok',
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              },
                              child: Column(
                                children: [
                                  Container(
                                    height: 30,
                                    width: 30,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: state.blankPostBorderColor,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 5,
                                          blurRadius: 7,
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Text(
                                    'Border Color',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 10,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  getBgImagesWidget(mq, isSmallSize: true),
                  const SizedBox(height: 7),
                  !showMore
                      ? const SizedBox()
                      : const Padding(
                          padding: EdgeInsets.only(left: 8),
                          child: Text("Gradients",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ))),
                  !showMore
                      ? const SizedBox()
                      : SizedBox(
                          height: mq.width * 0.25,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: const [
                              GradientChangeBox(
                                  gradient: Gradients.greenGradient),
                              GradientChangeBox(
                                  gradient: Gradients.redGradient),
                              GradientChangeBox(
                                  gradient: Gradients.blueGradient),
                              GradientChangeBox(gradient: Gradients.gradient1),
                              GradientChangeBox(gradient: Gradients.gradient4),
                              GradientChangeBox(gradient: Gradients.gradient2),
                              GradientChangeBox(gradient: Gradients.gradient3),
                            ],
                          )),
                ],
              );
            }),
          ],
        );
      }),
    );
  }

  BlocBuilder<StickerCubit, StickerState> getBgImagesWidget(Size mq,
      {bool isSmallSize = false}) {
    return BlocBuilder<StickerCubit, StickerState>(builder: (context, state) {
      return SizedBox(
        child: ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: !showMore ? 1 : state.bgImagesCategories.length,
          itemBuilder: (ctx, index) => Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: BlocBuilder<LocaleCubit, LocaleState>(
                    builder: (context, localState) {
                  bool isHindi = tr('choose_bg') != "Choose Background";
                  return Row(
                    children: [
                      Text(
                        (isHindi
                                ? state.bgImagesCategories[index].titleHn
                                : state.bgImagesCategories[index].titleEn) ??
                            "",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      index != 0
                          ? const SizedBox()
                          : TextButton(
                              onPressed: () {
                                setState(() {
                                  showMore = !showMore;
                                });
                              },
                              child: Text(
                                showMore
                                    ? tr("show_less_bg")
                                    : tr("show_more_bg"),
                                style: const TextStyle(),
                              ),
                            )
                    ],
                  );
                }),
              ),
              SizedBox(
                height: mq.width * 0.25,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemCount:
                      state.bgImagesCategories[index].backgrounds?.length,
                  itemBuilder: (ctx, index1) {
                    String img = state.bgImagesCategories[index]
                            .backgrounds?[index1].path ??
                        "";
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: mq.width * (isSmallSize ? 0.15 : 0.25),
                        height: (mq.width * (isSmallSize ? 0.15 : 0.25)),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10)),
                        child: InkWell(
                          onTap: () {
                            final frames = BlocProvider.of<StickerCubit>(
                                    context,
                                    listen: false)
                                .state
                                .listOfFrames;
                            BlocProvider.of<PostEditorCubit>(context)
                                .updateStateVariables(
                                    blankPostBgImage: img,
                                    currentFrame:
                                        frames.isEmpty ? null : frames[0]);
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: CachedNetworkImage(
                              imageUrl: img,
                              fit: BoxFit.fitWidth,
                              progressIndicatorBuilder: (BuildContext context,
                                  String _, DownloadProgress __) {
                                return Center(
                                    child: SizedBox(
                                  height: 100,
                                  width: 100,
                                  child: RishteyyShimmerLoader(mq: mq * 0.5),
                                ));
                              },
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      );
    });
  }
}

class StrokeTextField extends StatelessWidget {
  const StrokeTextField({
    Key? key,
    required TextEditingController controller,
  })  : _controller = controller,
        super(key: key);

  final TextEditingController _controller;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StickerCubit, StickerState>(
        builder: (context, stickerState) {
      return Stack(
        children: [
          TextFormField(
            readOnly: true,
            // readOnly:  stickerState.hideCancelButton,
            maxLines: null,
            controller: _controller,
            keyboardType: TextInputType.multiline,
            textAlign: TextAlign.center,
            style: Constants
                .googleFontStyles[stickerState.blankPostTextFontIndex]
                .copyWith(
              fontSize: stickerState.blankPostTextFontSize,
              letterSpacing: 1.2,
              fontWeight: FontWeight.bold,
              foreground: Paint()
                ..style = PaintingStyle.stroke
                ..strokeWidth = 3
                ..color = stickerState.blankPostBorderColor,
            ),
            decoration: const InputDecoration(
              border: InputBorder.none,
            ),
          ),
          TextFormField(
            readOnly: stickerState.lockEditor,
            // readOnly: true,
            maxLines: null,
            controller: _controller,
            keyboardType: TextInputType.multiline,
            textAlign: TextAlign.center,
            style: Constants
                .googleFontStyles[stickerState.blankPostTextFontIndex]
                .copyWith(
              fontSize: stickerState.blankPostTextFontSize,
              color: stickerState.blankPostTextColor, // Stroked text color
              letterSpacing: 1.2,
              fontWeight: FontWeight.bold,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText:
                  stickerState.lockEditor ? "" : tr("write_something_here"),
              hintStyle: TextStyle(
                fontSize: 20,
                color: Colors.white.withOpacity(0.6),
              ),
            ),
          ),
        ],
      );
    });
  }
}

class StrokedTextPainter extends CustomPainter {
  final String text;

  StrokedTextPainter(this.text);

  @override
  void paint(Canvas canvas, Size size) {
    final textStyle = TextStyle(
      fontSize: 20,
      color: Colors.black, // Stroked text color
      fontWeight: FontWeight.bold,
      foreground: Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..color = Colors.white, // Outline color
    );

    final textSpan = TextSpan(text: text, style: textStyle);
    final textPainter = TextPainter(
      text: textSpan,
      // textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    textPainter.layout(minWidth: 0, maxWidth: size.width);
    final offset = Offset((size.width - textPainter.width) / 2,
        (size.height - textPainter.height) / 2);
    textPainter.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
