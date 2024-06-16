import 'dart:io';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gita/Logic/Cubit/DpMakerCubit/dpmaker_cubit.dart';
import 'package:gita/Logic/Cubit/PostEditorCubit/post_editor_cubit.dart';
import 'package:logger/logger.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

import '../../../Constants/colors.dart';
import '../../../Constants/enums.dart';
import '../../../Constants/locations.dart';
import '../../../Data/model/api/dpframes_response.dart';
import '../../../Logic/Cubit/StickerCubit/sticker_cubit.dart';
import '../../../Logic/Cubit/user_cubit/user_cubit.dart';
import '../../Widgets/multiple_profile_photo_widget.dart';
import '../../Widgets/post_widget.dart';

class DPMakerScreen extends StatefulWidget {
  const DPMakerScreen({super.key});

  @override
  State<DPMakerScreen> createState() => _DPMakerScreenState();
}

enum DPMode { camera, photo }

class _DPMakerScreenState extends State<DPMakerScreen> {
  CameraController? controller;
  List<CameraDescription> _cameras = [];

  getCameras() async {
    _cameras = await availableCameras();
    if (true) {}
  }

  @override
  void initState() {
    // TODO: implement initState
    getCameras();
    BlocProvider.of<StickerCubit>(context).fetchDpFrames(isTestFrame: true);
    setFrame();
    super.initState();
  }

  int activeIndex = 1;
  DPMode dpMode = DPMode.photo;
  XFile? imageFile;
  ScreenshotController screenshotController = ScreenshotController();
  double xpos = 100, ypos = 100;
  double x1 = 30, y1 = 30, x2 = 80, y2 = 80;
  double minv = 0, maxv = 100;
  double formateDouble(double t) {
    return t.toPrecision(2);
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

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

  double? dragx;
  double? dragy;
  bool isDragging = false;
  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    x1 = formateDouble(x1);
    x2 = formateDouble(x2);
    y1 = formateDouble(y1);
    y2 = formateDouble(y2);
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Scaffold(
            appBar: AppBar(
              title: const Text('Dp Maker'),
              actions: [
                IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.switch_access_shortcut,
                      size: 20,
                    )),
                IconButton(
                    onPressed: () {
                      BlocProvider.of<StickerCubit>(context).fetchDpFrames();
                    },
                    icon: const Icon(
                      Icons.person,
                      size: 20,
                    )),
                IconButton(
                    onPressed: () {
                      controller!.setZoomLevel(1);
                    },
                    icon: const Icon(
                      Icons.person,
                      size: 20,
                    )),
              ],
            ),
            body: BlocBuilder<UserCubit, UserState>(
                builder: (context, userState) {
              return BlocBuilder<StickerCubit, StickerState>(
                  builder: (context, stickerState) {
                if (stickerState.dpFramesStatus == Status.loading &&
                    stickerState.listOfDpFrames.isEmpty) {
                  return const Center(
                      child: CircularProgressIndicator(
                    color: AppColors.primaryColor,
                  ));
                }
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      currentSelectedFrame == null
                          ? const Text(
                              'Please select frame',
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            )
                          : Screenshot(
                              controller: screenshotController,
                              child: Container(
                                width: mq.width * 0.9,
                                height: mq.width * 0.9,
                                clipBehavior: Clip.antiAlias,
                                decoration: const BoxDecoration(),
                                child:
                                    LayoutBuilder(builder: ((p0, constraints) {
                                  double _x1 =
                                      (x1 / 100) * constraints.maxWidth;
                                  double _x2 =
                                      (x2 / 100) * constraints.maxWidth;

                                  double _y1 =
                                      (y1 / 100) * constraints.maxHeight;
                                  double _y2 =
                                      (y2 / 100) * constraints.maxHeight;

                                  double widthI =
                                      (x2 - x1) / 100 * constraints.maxWidth;
                                  double heightI =
                                      (y2 - y1) / 100 * constraints.maxHeight;
                                  // Logger().i("");
                                  Logger().i(
                                      " $_x1 $_x2 $_y1 $_y2 \n $x1 $x2 $y1 $y2 \n $widthI $heightI \n ${constraints.maxWidth} ${constraints.maxHeight}");
                                  return DpFrameWidget(
                                    controller: controller,
                                    posX: _x1,
                                    posY: _y1,
                                    isDragEnable: true,
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
                            ),
                      Visibility(
                        visible: true,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  'x1 -> $x1',
                                  style: const TextStyle(),
                                ),
                                Expanded(
                                  child: Slider(
                                      value: x1,
                                      min: minv,
                                      max: maxv,
                                      onChanged: ((value) {
                                        if (x1 < x2 + 0.5) {
                                          setState(() {
                                            x1 = value;
                                            // Logger().i("");
                                            toast("$x1");
                                          });
                                        }
                                      })),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  'y1 -> $y1',
                                  style: const TextStyle(),
                                ),
                                Expanded(
                                  child: Slider(
                                      value: y1,
                                      min: minv,
                                      max: maxv,
                                      onChanged: ((value) {
                                        if (y1 < y2 + 0.5) {
                                          setState(() {
                                            y1 = value;
                                            toast("$y1");
                                          });
                                        }
                                      })),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  'x2 -> $x2',
                                  style: const TextStyle(),
                                ),
                                Expanded(
                                  child: Slider(
                                      value: x2,
                                      min: minv,
                                      max: maxv,
                                      onChanged: ((value) {
                                        if (value > x1 - 0.5) {
                                          // toast("", duration: Toast.LENGTH_LONG);
                                          setState(() {
                                            x2 = value;
                                            toast("$x2");
                                          });
                                        }
                                      })),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  'y2 -> $y2',
                                  style: const TextStyle(),
                                ),
                                Expanded(
                                  child: Slider(
                                      value: y2,
                                      min: minv,
                                      max: maxv,
                                      onChanged: ((value) {
                                        if (value > y1 - 0.5) {
                                          // toast("", duration: Toast.LENGTH_LONG);
                                          setState(() {
                                            toast("$y2");
                                            y2 = value;
                                          });
                                        }
                                      })),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Text(
                        'Current Frame Id:- ${currentSelectedFrame?.id}',
                        style: const TextStyle(
                          fontSize: 25,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        ' ${currentSelectedFrame?.path}',
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.black,
                        ),
                      ),
                      Visibility(
                        visible: dpMode == DPMode.camera,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            TextButton(
                              onPressed: () async {
                                await controller!.takePicture().then((value) {
                                  setState(() {
                                    imageFile = value;
                                  });
                                });
                              },
                              child: const Text(
                                'Take Picture',
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
                                'cancel',
                                style: TextStyle(),
                              ),
                            ),
                          ],
                        ),
                      ),
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
                                mq: mq,
                                onSelect: (_) {
                                  setState(() {
                                    dragx = null;
                                    dragy = null;
                                  });
                                },
                              )
                            ],
                          )),
                      const SizedBox(height: 40),
                      SizedBox(
                        height: 75,
                        width: mq.width,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            ...List.generate(stickerState.listOfDpFrames.length,
                                (index) {
                              DpFrames frames =
                                  stickerState.listOfDpFrames[index];
                              return InkWell(
                                  onTap: (() {
                                    setState(() {
                                      dragx = null;
                                      dragy = null;

                                      currentSelectedFrame = frames;
                                    });
                                  }),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: currentSelectedFrame?.id ==
                                                    frames.id
                                                ? AppColors.primaryColor
                                                : Colors.transparent)),
                                    child: CachedNetworkImage(
                                      imageUrl: frames.path ?? "",
                                      progressIndicatorBuilder:
                                          (context, url, progress) {
                                        return CircularProgressIndicator(
                                          value: progress.progress,
                                        );
                                      },
                                    ),
                                  ));
                            })
                          ],
                        ),
                      ),
                      const SizedBox(height: 150),
                    ],
                  ),
                );
              });
            })),
      ],
    );
  }
}

/// just pass frame x,y , width and height

class DpFrameWidget extends StatefulWidget {
  // const DpFrame({super.key});
  CameraController? controller;
  final DPMode dpMode;
  double posX;
  double posY;
  final double height;
  final double width;
  final String frameImagePath;
  final String? userProfileImage;
  final Size mq;
  final bool isDragEnable;

  DpFrameWidget({
    Key? key,
    this.controller,
    this.isDragEnable = false,
    this.userProfileImage,
    required this.dpMode,
    required this.posX,
    required this.posY,
    required this.width,
    required this.height,
    required this.frameImagePath,
    required this.mq,
    // this.controller,
  }) : super(key: key);
  @override
  State<DpFrameWidget> createState() => _DpFrameWidgetState();
}

class _DpFrameWidgetState extends State<DpFrameWidget> {
  bool isDragging = false;
  double? dragx;
  double? dragy;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: !widget.isDragEnable,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: widget.posX,
            top: widget.posY,
            child: (widget.dpMode == DPMode.photo)
                ? Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                            width: 1,
                            color: isDragging
                                ? AppColors.primaryColor
                                : Colors.transparent)),
                    width: widget.width,
                    height: widget.height,
                    child: (widget.userProfileImage?.length == 0)
                        ? Image.asset(AppImages.addImageIcon, fit: BoxFit.cover)
                        : Image.file(File(widget.userProfileImage!),
                            fit: BoxFit.cover))
                : widget.userProfileImage != null
                    ? Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.rotationY(pi),
                        child: SizedBox(
                            width: widget.width,
                            height: widget.height,
                            child: Image.file(
                              File(widget.userProfileImage!),
                              fit: BoxFit.cover,
                            )),
                      )
                    : widget.controller == null
                        ? Container()
                        : !widget.controller!.value.isInitialized
                            ? Container()
                            : SizedBox(
                                width: widget.width,
                                height: widget.height,
                                child: CameraPreview(widget.controller!),
                              ),
          ),
          !widget.isDragEnable
              ? SizedBox(
                  width: widget.mq.width,
                  height: widget.mq.width,
                  child: CachedNetworkImage(
                    imageUrl: widget.frameImagePath,
                    progressIndicatorBuilder: ((context, url, progress) {
                      return const Center(
                          child: SizedBox(
                        height: 100,
                        width: 100,
                        child: RishteyyShimmerLoader(mq: Size(200, 200)),
                      ));
                    }),
                  ))
              : GestureDetector(
                  child: SizedBox(
                      width: widget.mq.width,
                      height: widget.mq.width,
                      child: CachedNetworkImage(
                        imageUrl: widget.frameImagePath,
                      )),
                ),
          Positioned(
            left: widget.posX,
            top: widget.posY,
            child: GestureDetector(
              onPanStart: ((details) {
                setState(() {
                  isDragging = true;
                });
              }),
              onPanEnd: ((details) {
                setState(() {
                  isDragging = false;
                });
              }),
              onPanUpdate: ((details) {
                setState(() {
                  widget.posX = details.localPosition.dx - (widget.width / 2);
                  widget.posY = details.localPosition.dy - (widget.height / 2);
                });
              }),
              child: Padding(
                padding: const EdgeInsets.all(3.0),
                child: Container(
                  width: widget.width,
                  height: widget.height,
                  decoration: BoxDecoration(
                      border: Border.all(
                          width: 2,
                          color: isDragging
                              ? AppColors.primaryColor
                              : Colors.transparent)),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class DpFrameDynamicWidget extends StatefulWidget {
  // const DpFrame({super.key});
  CameraController? controller;
  final DPMode dpMode;
  double posX;
  double posY;
  final double height;
  final double width;
  final String frameImagePath;
  final String? userProfileImage;
  final Size mq;
  final bool isDragEnable;

  DpFrameDynamicWidget({
    Key? key,
    this.controller,
    this.isDragEnable = false,
    this.userProfileImage,
    required this.dpMode,
    required this.posX,
    required this.posY,
    required this.width,
    required this.height,
    required this.frameImagePath,
    required this.mq,
    // this.controller,
  }) : super(key: key);
  @override
  State<DpFrameDynamicWidget> createState() => _DpFrameDynamicWidgetState();
}

class _DpFrameDynamicWidgetState extends State<DpFrameDynamicWidget> {
  bool isDragging = false;

  @override
  void initState() {
    BlocProvider.of<StickerCubit>(context).fetchDpFrames(isTestFrame: true);
    Logger().i("Logger");
    BlocProvider.of<DpMakerCubit>(context).updateStateVariable(
      xPos: widget.posX,
      yPos: widget.posY,
      dpProfileSize: 0,
      defaultXPos: widget.posX,
      defaultYPos: widget.posY,
      isProfileDragging: false,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Logger().i("Logger");
    BlocProvider.of<StickerCubit>(context).fetchDpFrames(isTestFrame: true);
    return BlocBuilder<DpMakerCubit, DpMakerState>(
        builder: (context, dpmakerState) {
      Logger().i(dpmakerState.dpProfileSize);
      return AbsorbPointer(
        absorbing: widget.isDragEnable,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              left: dpmakerState.xPos,
              top: dpmakerState.yPos,
              child: (widget.dpMode == DPMode.photo)
                  ? SizedBox(
                      width: widget.width + dpmakerState.dpProfileSize,
                      height: widget.height + dpmakerState.dpProfileSize,
                      child: (widget.userProfileImage?.length == 0)
                          ? Image.asset(AppImages.addImageIcon,
                              fit: BoxFit.cover)
                          : Image.file(File(widget.userProfileImage!),
                              fit: BoxFit.cover))
                  : widget.userProfileImage != null
                      ? Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.rotationY(pi),
                          child: SizedBox(
                              width: widget.width + dpmakerState.dpProfileSize,
                              height:
                                  widget.height + dpmakerState.dpProfileSize,
                              child: Image.file(
                                File(widget.userProfileImage!),
                                fit: BoxFit.cover,
                              )),
                        )
                      : widget.controller == null
                          ? Container()
                          : !widget.controller!.value.isInitialized
                              ? Container()
                              : SizedBox(
                                  width:
                                      widget.width + dpmakerState.dpProfileSize,
                                  height: widget.height +
                                      dpmakerState.dpProfileSize,
                                  child: CameraPreview(widget.controller!),
                                ),
            ),
            Container(
                width: widget.mq.width,
                height: widget.mq.width,
                child: Column(
                  children: [
                    CachedNetworkImage(
                      imageUrl: widget.frameImagePath,
                      progressIndicatorBuilder: ((context, url, progress) {
                        return const Center(
                            child: SizedBox(
                          height: 100,
                          width: 100,
                          child: RishteyyShimmerLoader(mq: Size(200, 200)),
                        ));
                      }),
                    ),
                  ],
                )),
            Visibility(
              visible: dpmakerState.isProfileDragging,
              child: SizedBox(
                width: widget.mq.width,
                height: widget.mq.width,
                child: GridView.builder(
                  itemCount: 9,
                  itemBuilder: (ctx, index) => Container(
                    decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(color: Colors.white, width: 0.5)),
                  ),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 1,
                      crossAxisSpacing: 0,
                      mainAxisSpacing: 0),
                ),
              ),
            ),
            Positioned(
              left: dpmakerState.xPos,
              top: dpmakerState.yPos,
              child: GestureDetector(
                onPanStart: ((details) {
                  BlocProvider.of<DpMakerCubit>(context)
                      .updateStateVariable(isProfileDragging: true);
                }),
                onPanEnd: ((details) {
                  BlocProvider.of<DpMakerCubit>(context)
                      .updateStateVariable(isProfileDragging: false);
                }),
                onPanUpdate: ((details) {
                  BlocProvider.of<DpMakerCubit>(context).updateStateVariable(
                    xPos: details.localPosition.dx - (widget.width / 2),
                    yPos: details.localPosition.dy - (widget.height / 2),
                  );
                }),
                child: Container(
                  width: widget.width + dpmakerState.dpProfileSize,
                  height: widget.height + dpmakerState.dpProfileSize,
                  decoration: BoxDecoration(
                      border: Border.all(
                          width: 2,
                          color: dpmakerState.isProfileDragging
                              ? Colors.white
                              : Colors.transparent)),
                ),
              ),
            ),
            BlocBuilder<PostEditorCubit, PostEditorState>(
                builder: (context, postEditorState) {
              return Positioned(
                // top: 50,
                top: 200,

                right: -35,
                child: Visibility(
                  visible: postEditorState.isRishteyyVisible,
                  child: RishteyyTag(),
                ),
              );
            }),
          ],
        ),
      );
    });
  }
}
