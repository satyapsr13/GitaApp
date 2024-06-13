// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interactive_box/interactive_box.dart';
import 'package:screenshot/screenshot.dart';
import 'package:stroke_text/stroke_text.dart';

import '../../../../Constants/constants.dart';
import '../../../../Constants/enums.dart';
import '../../../../Constants/locations.dart';
import '../../../../Data/model/ObjectModels/post_widget_model.dart';
import '../../../../Logic/Cubit/PostEditorCubit/post_editor_cubit.dart';
import '../../../../Logic/Cubit/StickerCubit/sticker_cubit.dart';
import '../../../Widgets/frame_to_frame_details.dart';
import '../../../Widgets/post_widget.dart';
import '../PostFrames/post_frames.dart';
import '../StickerComponents/sticker_dragger.dart';
import 'dotted_border.widget.dart';
import 'editor_date_tag_widget.dart';
import 'image_tag_for_editor.dart';
import 'positions_helper_function.dart';

class PostPreviewWidget1 extends StatefulWidget {
  const PostPreviewWidget1({
    Key? key,
    required this.screenshotController,
    required this.outerBorderRadius,
    required this.postSize,
    required this.userPickedImage,
    this.makePostFromGallery,
    this.postWidgetModel,
    required this.userNameColor,
  }) : super(key: key);

  final ScreenshotController screenshotController;
  final double outerBorderRadius;
  final double postSize;
  final bool? makePostFromGallery;
  final File? userPickedImage;
  final PostWidgetModel? postWidgetModel;
  final Color userNameColor;

  @override
  State<PostPreviewWidget1> createState() => _PostPreviewWidget1State();
}

class _PostPreviewWidget1State extends State<PostPreviewWidget1> {
  final GlobalKey _imageKey = GlobalKey();
  // double _imageHeight = 200;
  // @override
  @override
  void initState() {
    // toast("message");
    // BlocProvider.of<PostCubit>(context).setStateVariables(
    //     telegramChannelName: (widget.makePostFromGallery == true ||
    //             widget.userPickedImage != null)
    //         ? GlobalVariables.telCustomPostChannel
    //         : GlobalVariables.telEditPostChannel);

    super.initState();
    // _getImageHeight();
  }

  double extendedHeight = 70;

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    double maxWid = mq.width - 30;

    extendedHeight = (maxWid / 3) - 12 - (maxWid / 9);

    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Card(
        elevation: 5,
        child: Screenshot(
            controller: widget.screenshotController,
            child: BlocBuilder<StickerCubit, StickerState>(
                builder: (context, stickerState) {
              return BlocBuilder<PostEditorCubit, PostEditorState>(
                  builder: (context, postEditorState) {
                return FittedBox(
                  // width: mq.width,
                  // height: mq.height * 0.7,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Column(
                        children: [
                          Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Container(child: LayoutBuilder(
                                  builder: (context, constraints) {
                                return Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    Container(
                                      constraints: const BoxConstraints(
                                        minHeight: 250,
                                      ),
                                      clipBehavior: Clip.hardEdge,
                                      decoration: BoxDecoration(
                                        borderRadius: postEditorState
                                                .isFrameVisible
                                            ? const BorderRadius.only(
                                                topLeft: Radius.circular(10),
                                                topRight: Radius.circular(10),
                                              )
                                            : const BorderRadius.all(
                                                Radius.circular(10)),
                                      ),
                                      child: widget.userPickedImage != null
                                          ? Image.file(
                                              widget.userPickedImage!,
                                              fit: BoxFit.cover,
                                            )
                                          : (widget.makePostFromGallery == true)
                                              ? Image.asset(
                                                  AppImages.addImageIcon,
                                                  fit: BoxFit.cover,
                                                )
                                              : Image.network(
                                                  postEditorState.networkImage,
                                                  loadingBuilder:
                                                      (BuildContext context,
                                                          Widget child,
                                                          ImageChunkEvent?
                                                              loadingProgress) {
                                                    if (loadingProgress ==
                                                        null) {
                                                      return child;
                                                    }
                                                    return Center(
                                                        child: SizedBox(
                                                      height: 100,
                                                      width: 100,
                                                      child:
                                                          RishteyyShimmerLoader(
                                                              mq: mq),
                                                    ));
                                                  },
                                                  errorBuilder: (context, error,
                                                          stackTrace) =>
                                                      Center(
                                                        child: SizedBox(
                                                            height: 100,
                                                            width: 200,
                                                            child: Image.asset(
                                                              AppImages
                                                                  .rishteyTag,
                                                              fit: BoxFit
                                                                  .contain,
                                                            )),
                                                      )),
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
                                                    width: constraints.maxWidth,
                                                    radius: 40,
                                                    side: 200.0,
                                                    nameColor: '#ffffff',
                                                    numberColor: '#ffffff',
                                                    occupationColor: '#ffffff',
                                                  ),
                                          )
                                  ],
                                );
                              })),
                              Positioned(
                                // top: 50,
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
                              height: postEditorState.isFrameVisible
                                  ? extendedHeight
                                  : 0),
                        ],
                      ),
                      (postEditorState.isAdvanceEditorMode)
                          ? Visibility(
                              visible: true,
                              child: StickerDraggingWidget(
                                // maxYPos: _imageHeight+40,
                                isDragEnable: !stickerState.lockEditor,
                                xPos: postEditorState.profileInitialPos.dx,
                                yPos: postEditorState.profileInitialPos.dy,
                                body: Stack(
                                  children: [
                                    stickerState.lockEditor == true
                                        ? Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: ImageTagForEditor(
                                              onImageTap: () {
                                                BlocProvider.of<StickerCubit>(
                                                        context)
                                                    .updateStateVariables(
                                                        hideCancelButton: false,
                                                        editorWidgets: EditorWidgets
                                                            .profileSizeAndShape);
                                                BlocProvider.of<
                                                            PostEditorCubit>(
                                                        context)
                                                    .updateStateVariables(
                                                        profilePos: "right",
                                                        isAdvanceEditorMode:
                                                            !postEditorState
                                                                .isAdvanceEditorMode);
                                              },
                                              profileShape:
                                                  postEditorState.profileShape,
                                            ),
                                          )
                                        : DottedBorder(
                                            color:
                                                stickerState.lockEditor == true
                                                    ? Colors.transparent
                                                    : Colors.white,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: ImageTagForEditor(
                                                onImageTap: () {
                                                  BlocProvider.of<StickerCubit>(
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
                              right: postEditorState
                                          .currentFrame?.profile?.position !=
                                      "left"
                                  ? 10
                                  : null,
                              left: postEditorState
                                          .currentFrame?.profile?.position !=
                                      "left"
                                  ? null
                                  : 10,
                              bottom: 10,
                              child: ImageTagForEditor(
                                onImageTap: () {
                                  BlocProvider.of<StickerCubit>(context)
                                      .updateStateVariables(
                                          hideCancelButton: false,
                                          editorWidgets: EditorWidgets
                                              .profileSizeAndShape);
                                  BlocProvider.of<PostEditorCubit>(context)
                                      .updateStateVariables(
                                    isAdvanceEditorMode: true,
                                  );
                                },
                                profileShape: postEditorState.profileShape,
                              ),
                            ),
                      Visibility(
                        visible: stickerState.isDateStickerVisible,
                        child: StickerDraggingWidget(
                          // maxYPos: _imageHeight,
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
                                    textStyle: Constants.googleFontStyles[
                                            stickerState.fontIndex]
                                        .copyWith(
                                            color: stickerState.dateColor,
                                            fontSize: stickerState.dateFontSize,
                                            fontWeight: FontWeight.bold),
                                    strokeColor: stickerState.dateBorderColor,
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
                      ...List.generate(
                          stickerState.listOfActiveUserStickers.length,
                          (index) {
                        final StickerFromAssets sticker =
                            stickerState.listOfActiveUserStickers[index];
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
                                            BlocProvider.of<StickerCubit>(
                                                    context)
                                                .userStickerOperations(
                                                    imageUrl: sticker.imageLink,
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
                        return true
                            ? InteractiveBox(
                                initialRotateAngle: 0,
                                showOverscaleBorder: false,
                                iconSize: 30,
                                rotateIndicatorSpacing: 2,
                                initialPosition: const Offset(100.0, 100.0),
                                onActionSelected: (p0, p1) {
                                  if (p0 == ControlActionType.delete) {
                                    BlocProvider.of<StickerCubit>(context)
                                        .stickerOperation(
                                            isRemoveSticker: true,
                                            stickerId: sticker.id,
                                            index: index);
                                  }
                                },
                                includedActions: const [
                                  // ControlActionType.copy,
                                  ControlActionType.delete,
                                  ControlActionType.rotate,
                                  ControlActionType.scale,
                                  ControlActionType.move,
                                  ControlActionType.none
                                ],
                                initialSize: const Size(100, 100),
                                initialShowActionIcons: true,
                                child: SizedBox(
                                  height: stickerState.stickerDListSides[index],
                                  width: stickerState.stickerDListSides[index],
                                  child: CachedNetworkImage(
                                    imageUrl: sticker.imageLink,
                                    fit: BoxFit.cover,
                                    imageBuilder: (context, imageProvider) {
                                      return Container(
                                          decoration: BoxDecoration(
                                              image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.fill,
                                      )));
                                    },
                                    placeholder: (context, url) => const Center(
                                        child: CircularProgressIndicator(
                                      color: Colors.orange,
                                    )),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                  ),
                                ),
                              )
                            : StickerDraggingWidget(
                                isDragEnable: !stickerState.lockEditor,
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
                                                      CircularProgressIndicator(
                                            color: Colors.orange,
                                          )),
                                          errorWidget: (context, url, error) =>
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
                        visible: postEditorState.isDateTagVisible,
                        child: postEditorState.datePosition == DatePos.dragging
                            ? StickerDraggingWidget(
                                isDragEnable: !stickerState.lockEditor,
                                body: Stack(
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
                                    stickerState.lockEditor
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
                                    datePosition: postEditorState.datePosition,
                                    isLeft: true),
                                right: getDatePosition(
                                    datePosition: postEditorState.datePosition,
                                    isLeft: false),
                                child: const EditorDateTagWidget(),
                              ),
                      ),

                      // MyTransform(
                      //   child: Container(
                      //     child: ZWidget.builder(
                      //         // debug:  ,
                      //         depth: 10,
                      //         layers: 3,
                      //         // rotationX: 2,
                      //         // rotationY: 2,
                      //         builder: (index) {
                      //           return Text(
                      //             'Satya Prakash',
                      //             style: TextStyle(
                      //                 color: index == 0
                      //                     ? Colors.pink
                      //                     : index == 1
                      //                         ? Colors.green
                      //                         : Colors.white,
                      //                 fontSize: 75),
                      //           );
                      //         }),
                      //   ),
                      // )
                      // ZWidget.bothDirections(
                      //   // middle layer
                      //   midChild: Text(
                      //     'lorem',
                      //     style:
                      //         const TextStyle(color: Colors.white, fontSize: 25),
                      //   ),
                      //   midToBotChild: Text(
                      //     'lorem',
                      //     style:
                      //         const TextStyle(color: Colors.pink, fontSize: 25),
                      //   ),
                      //   // layers between mid and top child
                      //   midToTopChild: Text(
                      //     'lorem',
                      //     style: const TextStyle(color: Colors.red, fontSize: 25),
                      //   ),
                      //   // layer at the bottom of the Stack
                      //   botChild: Text(
                      //     'lorem',
                      //     style:
                      //         const TextStyle(color: Colors.black, fontSize: 25),
                      //   ),
                      //   // layer at the top of the Stack
                      //   topChild: Text(
                      //     'lorem',
                      //     style:
                      //         const TextStyle(color: Colors.amber, fontSize: 25),
                      //   ),
                      //   // rotation around X axis
                      //   rotationX: pi / 3,
                      //   // rotation around Y axis
                      //   // rotationY: -pi / 4,
                      //   // Number of layers. Always odd (increased if even)
                      //   layers: 5,
                      //   // Space between layers
                      //   depth: 5,
                      // )
                    ],
                  ),
                );
              });
            })),
      ),
    );
  }
}

class MyTransform extends StatefulWidget {
  final Widget child;
  const MyTransform({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  _MyTransformState createState() => _MyTransformState();
}

class _MyTransformState extends State<MyTransform> {
  double x = 0;
  double y = 0;
  double z = 0;
  double scale = 1.0;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Transform(
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.003) // depth perception in the Z direction
          ..rotateX(x)
          ..rotateY(y)
          ..rotateZ(z)
          ..scale(scale, scale, scale),
        alignment: FractionalOffset.center,
        child: GestureDetector(
          onPanUpdate: (details) {
            setState(() {
              x += details.delta.dx / 200; // Adjust for sensitivity
              y += details.delta.dy / 200;
              // z += details.delta.d / 100;
            });
          },
          child: widget.child,
        ),
      ),
    );
  }
}
