import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:gita/Presentation/Widgets/post_widget.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';

import '../../../Constants/colors.dart';
import '../../../Constants/constants.dart';
import '../../../Constants/enums.dart';
import '../../../Constants/locations.dart';
import '../../../Data/model/ObjectModels/post_widget_model.dart';
import '../../../Data/services/secure_storage.dart';
import '../../../Logic/Cubit/PostEditorCubit/post_editor_cubit.dart';
import '../../../Logic/Cubit/Posts/posts_cubit.dart';
import '../../../Logic/Cubit/StickerCubit/sticker_cubit.dart';
import '../../../Logic/Cubit/user_cubit/user_cubit.dart';
import '../../../Utility/common.dart';
import '../../../Utility/next_screen.dart';
import '../../Widgets/Buttons/circular_color.button.dart';
import '../../Widgets/Dialogue/dialogue.dart';
import '../../Widgets/model_bottom_sheet.dart';
import '../../Widgets/multiple_profile_photo_widget.dart';
import '../../Widgets/snackbar.dart';
import '../PremiumPlanScreens/premium_plan_screen.dart';
import 'PostEditScreenComponents/EditorButtonsWidget/animation_wrapper.dart';
import 'PostEditScreenComponents/EditorButtonsWidget/editor_color_widget.dart';
import 'PostEditScreenComponents/EditorButtonsWidget/editor_date_widget.dart';
import 'PostEditScreenComponents/EditorButtonsWidget/editor_play_store_widget.dart';
import 'PostEditScreenComponents/EditorButtonsWidget/editor_profile_position_editor.dart';
import 'PostEditScreenComponents/EditorButtonsWidget/editor_profile_shape_and_size_widget.dart';
import 'PostEditScreenComponents/EditorButtonsWidget/editor_sticker_widget.dart';
import 'PostEditScreenComponents/blank_gradient_post_preview.dart';
import 'PostEditScreenComponents/edit_screen_show_hide_button_widget.dart';
import 'PostEditScreenComponents/post_edit_screen_components.dart';
import 'PostEditScreenComponents/post_preview_widget.dart';

class PostEditScreen extends StatefulWidget {
  // const PostEditScreen({super.key});
  PostWidgetModel postWidgetData;
  bool? makePostFromGallery;
  bool? isGradientPost;
  final String? parentScreenName;

  /// This is for panchang edit setup
  File? userPickedImage;
  PostEditScreen({
    Key? key,
    required this.postWidgetData,
    this.makePostFromGallery,
    this.isGradientPost,
    this.parentScreenName,
    this.userPickedImage,
  }) : super(key: key);

  @override
  State<PostEditScreen> createState() => _PostEditScreenState();
}

class _PostEditScreenState extends State<PostEditScreen> {
  double postSize = 20;

  Uint8List? _imageFile;
  Uint8List? image;
  Future<void> getImage() async {
    SecureStorage secureStorage = SecureStorage();
    String imagePath = await secureStorage.readLocally('PHOTO_URL');
    if (imagePath.isNotEmpty) {
      image = await File(imagePath).readAsBytes();
      setState(() {});
    }
  }

  double outerBorderRadius = 10;
  ScreenshotController screenshotController = ScreenshotController();
  // TextEditingController userNameController = TextEditingController();
  Future<void> loadName() async {
    SecureStorage storage = SecureStorage();
    String userName = "";
    userName = await storage.getFirstName() ?? "";
    userName += " ";
    userName += await storage.getLastName() ?? "";
  }

  setPostEditorCubitData() {
    BlocProvider.of<PostEditorCubit>(context).updateStateVariables(
      tagColor: widget.postWidgetData.tagColor,
      topTagPosition: widget.postWidgetData.playStoreBadgePos,
      profileShape: widget.postWidgetData.profileShape,
      profilePos: widget.postWidgetData.profilePos,
      networkImage: widget.postWidgetData.imageLink,
    );
  }

  // Future<void> secureScreen() async {
  //   if (BlocProvider.of<UserCubit>(context).state.isAdmin == true) {
  //     return;
  //   }
  //   await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  // }

  // Future<void> clearSecureScreen() async {
  //   // if (BlocProvider.of<UserCubit>(context).state.isPremiumUser == true) {
  //   //   return;
  //   // }
  //   if (BlocProvider.of<UserCubit>(context).state.isAdmin == true) {
  //     return;
  //   }
  //   await FlutterWindowManager.clearFlags(FlutterWindowManager.FLAG_SECURE);
  // }

  @override
  void initState() {
    super.initState();
    BlocProvider.of<PostCubit>(context).setStateVariables(
        telegramChannelName: (widget.makePostFromGallery == true ||
                widget.isGradientPost == true)
            ? GlobalVariables.telCustomPostChannel
            : GlobalVariables.telEditPostChannel);

    BlocProvider.of<StickerCubit>(context).updateStateVariables(
        isDateVisible: false,
        hideCancelButton: false,
        editorWidgets: EditorWidgets.none);
    try {
      BlocProvider.of<UserCubit>(context).updateStateVariables(
          editedName: BlocProvider.of<UserCubit>(context, listen: false)
              .state
              .userName);
    } catch (e) {}

    BlocProvider.of<PostEditorCubit>(context).updateStateVariables(
      isAdvanceEditorMode: false,
      datePosition: DatePos.topLeft,
      nameColor:
          hexToColor(widget.postWidgetData.frameDetails?.nameColor ?? ""),
      occupationColor:
          hexToColor(widget.postWidgetData.frameDetails?.occupationColor ?? ""),
      numberColor:
          hexToColor(widget.postWidgetData.frameDetails?.numberColor ?? ""),
    );
    BlocProvider.of<StickerCubit>(context).updateStickerVisibility(
        isFirstStickerVisible: false, isSecondStickerVisible: false);
    if (widget.makePostFromGallery == true || widget.isGradientPost == true) {
      pathTracker.add("user_create_own_post");
    } else {
      pathTracker.add("edit_screen");
    }
    // if (!kDebugMode) {
    //   secureScreen();
    // }
    setPostEditorCubitData();
  }

  TextEditingController usernameController = TextEditingController(text: "");

  @override
  void dispose() {
    super.dispose();
    pathTracker.removeLast();
    BlocProvider.of<PostEditorCubit>(context).updateStateVariables(
      customFrameColor: Colors.white,
      nameColor: Colors.black,
      numberColor: Colors.black,
      occupationColor: Colors.black,
      profileSize: 70,
      isRishteyyVisible: true,
    );
    usernameController.dispose();
    // if (!kDebugMode) {
    //   clearSecureScreen();
    // }
  }

  Uint8List? newImage;
  File? userPickedImage;

  Future<void> _showChoiceDialog(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        builder: (context) {
          return SafeArea(
            child: SizedBox(
              height: 250,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 10),
                  Text(tr('choose_image_source'),
                      style:
                          const TextStyle(fontSize: 20, color: Colors.black)),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        onTap: () async {
                          _saveImages(ImageSource.camera);
                          setState(() {});
                          Navigator.of(context).pop();
                        },
                        child: Column(
                          children: [
                            const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Icon(
                                  Icons.camera,
                                  color: AppColors.primaryColor,
                                  size: 50,
                                )),
                            Text(
                              tr('camera'),
                              style: const TextStyle(),
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () async {
                          _saveImages(ImageSource.gallery);
                          Navigator.of(context).pop();
                        },
                        child: Column(
                          children: [
                            const Padding(
                                padding: EdgeInsets.all(15.0),
                                child: Icon(
                                  Icons.image,
                                  color: AppColors.primaryColor,
                                  size: 50,
                                )),
                            Text(
                              tr('gallery'),
                              style: const TextStyle(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  _saveImages(ImageSource source) async {
    try {
      final pickedImage = await ImagePicker().pickImage(source: source);
      if (pickedImage == null) return null;
      CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedImage.path,
        aspectRatioPresets: const [
          CropAspectRatioPreset.original,
        ],
        uiSettings: Constants.androidCropSetting,
      );

      if (croppedFile != null) {
        // return null;
        final directory = await getApplicationDocumentsDirectory();
        final date = DateTime.now().toUtc().toIso8601String();

        final fileName = "${directory.path}/$date.png";
        newImage = File(croppedFile.path).readAsBytesSync();

        final img = await File(croppedFile.path).copy(fileName);
        setState(() {
          userPickedImage = img;
        });
      }
    } catch (e) {
      showSnackBar(context, Colors.red, 'Error: $e');
    }
  }

  showMotionToast() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        elevation: 5,
        behavior: SnackBarBehavior.floating,
        content: CustomSnackBar(),
        duration: Duration(seconds: 5),
        backgroundColor: Colors.white,
      ),
    );
  }

  Color userNameColor = Colors.black;

  Color userNameTagColor = Colors.black;
  bool showImageUploadFloatingActionButton = false;
  final formKey = GlobalKey<FormBuilderState>();
  @override
  Widget build(BuildContext context) {
    if (widget.makePostFromGallery != null) {
      showImageUploadFloatingActionButton = widget.makePostFromGallery ?? false;
      widget.makePostFromGallery = null;
      Timer(const Duration(seconds: 1), () {
        _showChoiceDialog(context);
      });
    }
    if (widget.userPickedImage != null) {
      userPickedImage = widget.userPickedImage;
    }
    double test = 100;
    final mq = MediaQuery.of(context).size;
    postSize = mq.width * 0.85;
    return BlocBuilder<StickerCubit, StickerState>(
        builder: (context, stickerState) {
      return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
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
                  Icon(Icons.clear),
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
                BlocProvider.of<PostEditorCubit>(context)
                    .updateStateVariables(profileSize: 70);
                BlocProvider.of<PostEditorCubit>(context).updateStateVariables(
                  listOfCustomText: [],
                  listOfCustomTextStyles: [],
                );
                BlocProvider.of<StickerCubit>(context).hideCancelButton(false);
                if (widget.isGradientPost == true) {
                  nextScreenReplace(
                      context,
                      PostEditScreen(
                        postWidgetData: widget.postWidgetData,
                        makePostFromGallery: widget.makePostFromGallery,
                        isGradientPost: true,
                      ));
                } else {
                  nextScreenReplace(
                      context,
                      PostEditScreen(
                        postWidgetData: widget.postWidgetData,
                        makePostFromGallery: widget.makePostFromGallery,
                      ));
                }
              },
            ),
          ],
          title: const Text(
            'Edit Post',
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
        floatingActionButton: showImageUploadFloatingActionButton
            ? InkWell(
                onTap: () {
                  _showChoiceDialog(context);
                },
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: Gradients.blueGradient,
                  ),
                  child: const Icon(
                    Icons.camera_alt_outlined,
                    color: Colors.white,
                  ),
                ),
              )
            : null,
        body: FormBuilder(
          key: formKey,
          child: GestureDetector(
            onDoubleTap: (() {
              BlocProvider.of<StickerCubit>(context)
                  .updateStateVariables(hideCancelButton: false);
            }),
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: BlocBuilder<PostEditorCubit, PostEditorState>(
                builder: (context, stateEditor) {
              return SingleChildScrollView(
                physics: stateEditor.isInteractiveBoxActive
                    ? const NeverScrollableScrollPhysics()
                    : null,
                child: Column(
                  children: [
                    widget.isGradientPost == true
                        ? BlankPostPreviewWidget(
                            screenshotController: screenshotController,
                            outerBorderRadius: outerBorderRadius,
                            postSize: postSize,
                            // userPickedImage: userPickedImage,
                            userNameColor: userNameColor,
                            makePostFromGallery:
                                widget.makePostFromGallery ?? false,
                          )
                        : PostPreviewWidget(
                            postWidgetModel: widget.postWidgetData,
                            screenshotController: screenshotController,
                            outerBorderRadius: outerBorderRadius,
                            postSize: postSize,
                            userPickedImage: userPickedImage,
                            userNameColor: userNameColor,
                            makePostFromGallery:
                                widget.makePostFromGallery ?? false,
                          ),

                    // SizedBox(height: 200),
                    widget.isGradientPost == true
                        ? const SizedBox()
                        : EditScreenShowHideAndFramesWidget(mq: mq),
                    // SizedBox(height: 45),
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: BlocBuilder<StickerCubit, StickerState>(
                          builder: (context, state) {
                            return state.lockEditor == false
                                ? Row(
                                    children: [
                                      Text(tr('show_rishteyy'),
                                          style: const TextStyle()),
                                      Switch.adaptive(
                                          value: stateEditor.isRishteyyVisible,
                                          activeTrackColor:
                                              const Color(0xFF01173D),
                                          activeThumbImage: const AssetImage(
                                              AppImages.appLogo),
                                          inactiveThumbImage: const AssetImage(
                                              AppImages.appLogo),
                                          onChanged: (val) {
                                            if (BlocProvider.of<UserCubit>(
                                                        context)
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
                                                // image:
                                                //     frame.profile?.image ?? "",
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
                                      IconButton(
                                          onPressed: () {
                                            FocusScope.of(context).unfocus();
                                            BlocProvider.of<StickerCubit>(
                                                    context)
                                                .updateStateVariables(
                                                    hideCancelButton: true);
                                          },
                                          icon: const Icon(
                                            Icons.done_outline,
                                            size: 30,
                                            color: Colors.green,
                                          )),
                                    ],
                                  )
                                : whatsAppShare(widget.postWidgetData.postId,
                                    widget.postWidgetData.imageLink, mq,
                                    postWidgetData: widget.postWidgetData);
                          },
                        )),
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
                            spreadRadius: 1,
                          )
                        ],
                      ),
                      child: BlocBuilder<PostEditorCubit, PostEditorState>(
                          builder: (context, postEditorState) {
                        return BlocBuilder<StickerCubit, StickerState>(
                            builder: (context, state) {
                          return Column(
                            children: [
                              // const SizedBox(height: 20),
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
                                            SizedBox(
                                              width: mq.width * 0.6,
                                              child: TextFormField(
                                                readOnly: BlocProvider.of<
                                                            StickerCubit>(
                                                        context,
                                                        listen: false)
                                                    .state
                                                    .lockEditor,
                                                // focusNode: _focusNode2,
                                                initialValue:
                                                    BlocProvider.of<UserCubit>(
                                                            context)
                                                        .state
                                                        .editedName,
                                                // controller: usernameController,
                                                onChanged: (val) {
                                                  BlocProvider.of<UserCubit>(
                                                          context)
                                                      .setEditName(
                                                          val.toString());
                                                },
                                              ),
                                            ),
                                            Visibility(
                                              visible:
                                                  postEditorState.isWhiteFrame,
                                              child: Card(
                                                elevation: 20,
                                                child: InkWell(
                                                  onTap: () {
                                                    showCBottomSheet(
                                                      context: context,
                                                      height: mq.height * 0.4,
                                                      child:
                                                          SingleChildScrollView(
                                                        child: Column(
                                                          children: [
                                                            CColorPicker(
                                                              onColorTap:
                                                                  (color) {
                                                                BlocProvider.of<
                                                                            PostEditorCubit>(
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
                                                              onPressed: () {
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              child: const Text(
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
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              3),
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
                                              .listOfActiveUserStickers[index];
                                          return Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
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
                                                  BlocProvider.of<StickerCubit>(
                                                          context)
                                                      .userStickerOperations(
                                                    imageUrl: "",
                                                    isIncreaseStickerSize: true,
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
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              SizedBox(
                                                  height: 40,
                                                  width: 40,
                                                  child: CachedNetworkImage(
                                                    imageUrl: sticker.imageLink,
                                                    fit: BoxFit.contain,
                                                  )),
                                              Slider(
                                                min: 50,
                                                max: 200,
                                                // divisions: 30,
                                                value: state
                                                    .stickerDListSides[index],
                                                onChanged: (val) {
                                                  BlocProvider.of<StickerCubit>(
                                                          context)
                                                      .stickerOperation(
                                                          isUpdateStickerSize:
                                                              true,
                                                          side: val,
                                                          stickerId: sticker.id,
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
                                        buildEditorSecondRow(context, mq),
                                        const SizedBox(height: 20),
                                        MultiplePhotoSelector(
                                            mq: mq, radius: 50),
                                        const SizedBox(height: 150),
                                      ],
                                    ), // SizedBox(
                            ],
                          );
                        });
                      }),
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
      );
    });
  }

  Widget getEditorOpenWidget(EditorWidgets editorWidgets) {
    if (editorWidgets == EditorWidgets.profileSizeAndShape) {
      return const EditorProfileShapeAndSizeWidget();
    }
    if (editorWidgets == EditorWidgets.dateText) {
      return EditorDateWidget(formKey: formKey);
    }
    if (editorWidgets == EditorWidgets.colorWidget) {
      return const EditorColorWidget();
    }
    if (editorWidgets == EditorWidgets.profileStaticPos) {
      return const EditorProfilePositionEditor();
    }
    if (editorWidgets == EditorWidgets.playStoreBadge) {
      return const EditorPlayStoreWidget();
    }
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

  Row buildEditorSecondRow(BuildContext context, Size mq) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        bottomProfilePositionEditor(context, mq),
        rishteyyTagPositionEditor(context, mq),
        profileShapeEditor(context, mq),
      ],
    );
  }

  Row buildEditorFirstRow(BuildContext context, Size mq) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        InkWell(
          onTap: () {
            BlocProvider.of<StickerCubit>(context)
                .updateStateVariables(editorWidgets: EditorWidgets.dateText);
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
        colorEditor(context, mq),
      ],
    );
  }

  Widget bottomProfilePositionEditor(BuildContext context, Size mq) {
    return BlocBuilder<UserCubit, UserState>(builder: (context, state) {
      return InkWell(
        onTap: () {
          BlocProvider.of<StickerCubit>(context).updateStateVariables(
              editorWidgets: EditorWidgets.profileStaticPos);
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
                    borderRadius: BorderRadius.circular(20),
                    color: const Color(0xffD9D9D9)),
                child: Stack(
                  clipBehavior: Clip.hardEdge,
                  children: [
                    Positioned(bottom: 0, child: bottomPositionMark(mq)),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: CircleAvatar(
                        radius: 15,
                        backgroundImage: state.fileImagePath.isEmpty
                            ? const AssetImage(AppImages.addImageIcon)
                                as ImageProvider
                            : FileImage(File(state.fileImagePath)),
                      ),
                    ),
                  ],
                )),
          ),
        ),
      );
    });
  }

  Widget whatsAppShare(String postId, String imageLink, Size mq,
      {required PostWidgetModel postWidgetData}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
      child: Row(
        children: [
          const Spacer(
            flex: 3,
          ),
          IconButton(
              onPressed: () {
                BlocProvider.of<StickerCubit>(context).hideCancelButton(false);
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
            postWidgetData: postWidgetData,
            isEdited: true,
            // telegramChannelName: ,
          ),
        ],
      ),
    );
  }
}

class CustomSnackBar extends StatelessWidget {
  const CustomSnackBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'फ़ोटो की जगह बदले',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                Text(
                  'प्रोफ़ाइल फ़ोटो को ड्रैग करके उसकी जगह बदलने का फीचर जोड़ा गया है।',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
              onPressed: () {
                BlocProvider.of<PostEditorCubit>(context).updateStateVariables(
                    isShowMotionToastForProfileDrag: false);
                ScaffoldMessenger.of(context).clearSnackBars();
              },
              icon: const Icon(
                Icons.check,
                color: Colors.black,
                size: 20,
              )),
        ],
      ),
    );
  }
}

class GradientChangeBox extends StatelessWidget {
  final Gradient gradient;
  final bool? isNavigateToPostEditScreen;

  const GradientChangeBox({
    super.key,
    required this.gradient,
    this.isNavigateToPostEditScreen,
  });

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    return InkWell(
      onTap: () {
        BlocProvider.of<PostEditorCubit>(context).updateStateVariables(
          blankPostBgImage: "",
        );
        BlocProvider.of<PostEditorCubit>(context).changeEditorFields(
          gradient: gradient,
        );
        if (isNavigateToPostEditScreen == true) {
          nextScreenWithFadeAnimation(
              context,
              PostEditScreen(
                postWidgetData: PostWidgetModel(
                  imageLink: "",
                  postId: '',
                  profilePos: 'right',
                  tagColor: 'white',
                  profileShape: 'circle',
                  playStoreBadgePos: 'right',
                ),
                isGradientPost: true,
              ));
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: mq.width * 0.25,
          width: mq.width * 0.25,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            gradient: gradient,
          ),
        ),
      ),
    );
  }
}

class CColorPicker extends StatelessWidget {
  final Function(Color color) onColorTap;
  final bool isTransparentButton;

  const CColorPicker({
    Key? key,
    required this.onColorTap,
    this.isTransparentButton = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // height: 300,
      child: Padding(
        padding: const EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 5),
        child: Column(
          children: [
            SizedBox(
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount:
                    Constants.colorList.length + (isTransparentButton ? 1 : 0),
                itemBuilder: (ctx, index) {
                  if (index >= Constants.colorList.length) {
                    return InkWell(
                        onTap: () {
                          onColorTap(Colors.transparent);
                        },
                        child: const CircularColorButton(
                          color: Colors.white,
                          isTransparentColor: true,
                        ));
                  }
                  return InkWell(
                      onTap: () {
                        onColorTap(Constants.colorList[index]);
                      },
                      child: CircularColorButton(
                          color: Constants.colorList[index]));
                },
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  childAspectRatio: 3 / 2,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Pick a color!'),
                      content: SingleChildScrollView(
                        child: HueRingPicker(
                          portraitOnly: true,
                          pickerColor: Colors.lightGreen,
                          onColorChanged: (color) {
                            onColorTap(color);
                          },
                        ),
                      ),
                      actions: <Widget>[
                        ElevatedButton(
                          child: const Text('Ok'),
                          onPressed: () {
                            // setState(() => currentColor = pickerColor);
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              },
              child: const Text(
                'More colors',
                style: TextStyle(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
