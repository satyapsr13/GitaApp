import 'dart:async';
import 'dart:io';

// import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:logger/logger.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shimmer/shimmer.dart';
import '../../Constants/colors.dart';
import '../../Constants/constants.dart';
import '../../Constants/locations.dart';
import '../../Data/model/ObjectModels/post_widget_model.dart';
import '../../Logic/Cubit/AdmobCubit/admob_ads_cubit.dart';
import '../../Logic/Cubit/PostEditorCubit/post_editor_cubit.dart';
import '../../Logic/Cubit/Posts/posts_cubit.dart';
import '../../Logic/Cubit/StickerCubit/sticker_cubit.dart';
import '../../Logic/Cubit/user_cubit/user_cubit.dart';
import '../../Utility/common.dart';
import '../../Utility/next_screen.dart';
import '../Screens/PostsScreens/PostEditScreenComponents/editor_date_tag_widget.dart';
import '../Screens/PostsScreens/PostEditScreenComponents/positions_helper_function.dart';
import '../Screens/PostsScreens/post_edit_screen.dart';
import '../Screens/PremiumPlanScreens/premium_plan_screen.dart';
import '../Screens/SeriesPosts/GitsGyanScreens/gita_sloke_specific_post_screen.dart';
import '../Screens/Tools/premium_wrapper.dart';
import 'Buttons/ccolor_button.dart';
import 'Dialogue/dialogue.dart';

class PostWidget extends StatefulWidget {
  final PostWidgetModel postWidgetData;
  final bool? showEditAndShare;
  final bool isModelFrame;
  final bool? centerShareEditButton;
  final bool isOnlyForControll;
  final String? parentScreenName;
  final int index;
  // final void Function()? showAds;
  const PostWidget({
    Key? key,
    required this.postWidgetData,
    this.showEditAndShare,
    this.index = 0,
    this.centerShareEditButton,
    this.parentScreenName,
    this.isModelFrame = false,
    this.isOnlyForControll = false,
    // this.showAds,
  }) : super(key: key);

  @override
  State<PostWidget> createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  double outerBorderRadius = 10;

  ScreenshotController screenshotController = ScreenshotController();

  double extendedHeight = 30;

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;

    double maxWid = mq.width - 40;
    try {
      extendedHeight =
          (maxWid / 3) - (widget.isModelFrame ? 27 : 17) - (maxWid / 9);
    } catch (_) {}

    return GestureDetector(
      onLongPress: () {},
      child: BlocBuilder<PostCubit, PostState>(builder: (context, postState) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Card(
                color: Colors.white,
                elevation: 5,
                child: Screenshot(
                  controller: screenshotController,
                  child: Column(
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            constraints: BoxConstraints(
                              minWidth: mq.width - 30,
                            ),
                            child: Container(
                                constraints: const BoxConstraints(
                                  minHeight: 200,
                                ),
                                clipBehavior: Clip.hardEdge,
                                decoration: BoxDecoration(
                                  borderRadius: postState.isFrameVisible
                                      ? const BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          topRight: Radius.circular(10),
                                          bottomLeft: Radius.circular(10),
                                          bottomRight: Radius.circular(10),
                                        )
                                      : const BorderRadius.all(
                                          Radius.circular(10)),
                                ),
                                child: widget.postWidgetData.imageLink
                                        .startsWith("htt")
                                    ? CachedNetworkImage(
                                        imageUrl:
                                            widget.postWidgetData.imageLink,
                                      )
                                    : Image.asset(
                                        widget.postWidgetData.imageLink)),
                          ),
                          const Positioned(
                              top: 5,
                              left: 10,
                              child: EditorDateTagWidget(
                                isDisableTapping: true,
                                getRandomDateBG: true,
                              )),
                          Positioned(
                              top: 200,
                              left: rishteyyTagLeftPosition(
                                  widget.postWidgetData.playStoreBadgePos),
                              right: rishteyyTagRightPosition(
                                  widget.postWidgetData.playStoreBadgePos),
                              child: RishteyyTag(
                                tagColor: widget.postWidgetData.tagColor,
                                tagPosition:
                                    widget.postWidgetData.playStoreBadgePos,
                              ))
                        ],
                      ),
                      // widget.isOnlyForControll
                      //     ? const SizedBox()
                      //     : Visibility(
                      //         visible: postState.isFrameVisible,
                      //         child: Card(
                      //             elevation: 15,
                      //             child: SizedBox(height: extendedHeight - 4)),
                      //       ),
                    ],
                  ),
                ),
              ),
              BlocBuilder<StickerCubit, StickerState>(
                  builder: (context, stickerState) {
                return Visibility(
                  visible: widget.showEditAndShare != false,
                  child: whatsAppShare(widget.postWidgetData.postId,
                      widget.postWidgetData, mq, context, screenshotController,
                      frameId: stickerState.listOfActiveFrames.isEmpty
                          ? 0
                          : stickerState
                                  .listOfActiveFrames[(widget.index %
                                      (stickerState.listOfActiveFrames.length))]
                                  .id ??
                              0),
                );
              })
            ],
          ),
        );
      }),
    );
  }

  Widget whatsAppShare(String postId, PostWidgetModel postWidgetData, Size mq,
      BuildContext context, ScreenshotController screenshotController1,
      {int index = 0, num frameId = 0}) {
    return widget.centerShareEditButton != null
        ? Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            child: Row(
              children: [
                // removeAdsButton(context),
                TextButton(
                  onPressed: () async {
                    await screenshotController1
                        .capture(
                      delay: const Duration(milliseconds: 2),
                    )
                        .onError((error, stackTrace) {
                      return null;
                    }).then((capturedImage) async {
                      if (capturedImage != null) {
                        final directory =
                            await getApplicationDocumentsDirectory();
                        final imagePath = await File(
                                '${directory.path}/${DateTime.now().millisecondsSinceEpoch}.png')
                            .create();
                        await imagePath
                            .writeAsBytes(capturedImage)
                            .then((value) {
                          showSongBottomSheet(context, imagePath.path);
                        });
                      }
                    });
                  },
                  child: const Text(
                    'Add Song',
                    style: TextStyle(),
                  ),
                ),
                // const Spacer(flex: 5),
                // editPostButton(
                //     data: postWidgetData,
                //     frameId: frameId,
                //     parentScreenName: widget.parentScreenName,
                //     context: context),
                const Spacer(flex: 1),
                WhatsAppShareButton(
                  screenshotController1: screenshotController1,
                  postId: postWidgetData.postId,
                  postWidgetData: postWidgetData,
                  parentScreenName: widget.parentScreenName,
                ),
                const Spacer(flex: 5),
              ],
            ),
          )
        : Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            child: Row(
              children: [
                removeAdsButton(context),
                const Spacer(flex: 10),

                // // const Spacer(flex: 1),
                // editPostButton(
                //     data: postWidgetData,
                //     parentScreenName: widget.parentScreenName,
                //     context: context,
                //     frameId: frameId),
                // const Spacer(flex: 1),
                WhatsAppShareButton(
                  screenshotController1: screenshotController1,
                  postId: postWidgetData.postId,
                  postWidgetData: postWidgetData,
                  parentScreenName: widget.parentScreenName,
                )
              ],
            ),
          );
  }

  Widget removeAdsButton(BuildContext context) {
    return BlocBuilder<UserCubit, UserState>(builder: (context, state) {
      return Visibility(
        visible: !state.isPremiumUser,
        child: TextButton(
          onPressed: () {
            nextScreenWithFadeAnimation(context, const PremiumPlanScreen());
          },
          child: SizedBox(
            height: 25,
            child: Row(
              children: [
                Text(
                  tr("remove_ads"),
                  style: const TextStyle(
                    color: AppColors.primaryColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  InkWell editPostButton(
      {required PostWidgetModel data,
      String? parentScreenName,
      required BuildContext context,
      num frameId = 0}) {
    return InkWell(
      onTap: () {
        try {
          final frames = BlocProvider.of<StickerCubit>(context, listen: false)
              .state
              .listOfActiveFrames;
          if (frames.isNotEmpty) {
            BlocProvider.of<PostEditorCubit>(context).updateStateVariables(
                currentFrame: frames[
                    ((widget.index + DateTime.now().hour) % (frames.length))]);
          }
          BlocProvider.of<UserCubit>(context).updateStateVariables(
              editedName: BlocProvider.of<UserCubit>(context, listen: false)
                  .state
                  .userName);
        } catch (e) {}

        nextScreenWithFadeAnimation(
            context,
            PostEditScreen(
              postWidgetData: data,
              parentScreenName: parentScreenName,
            ));
      },
      child: Container(
        height: 35,
        width: 70,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: Gradients.blueGradient),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: const [
            Icon(
              Icons.edit,
              size: 15,
              color: Colors.white,
            ),
            Text(
              'Edit',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

class RishteyyShimmerLoader extends StatelessWidget {
  const RishteyyShimmerLoader({
    Key? key,
    required this.mq,
  }) : super(key: key);

  final Size mq;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        baseColor: const Color(0xffcccccc),
        highlightColor: const Color(0xffaaaaaa),
        child: SizedBox(
          width: mq.width * 0.4,
          child: Image.asset(AppImages.rishteyTag),
        ));
  }
}

class RishteyyTag extends StatelessWidget {
  final String tagColor;
  final String tagPosition;
  const RishteyyTag({
    Key? key,
    this.tagColor = "",
    this.tagPosition = "",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isLeft = tagPosition.startsWith("left");
    return Transform.rotate(
      angle: isLeft ? (270 * 3.1415926535 / 180) : (90 * 3.1415926535 / 180),
      child: Container(
        height: 13,
        width: 80,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: isLeft
              ? const BorderRadius.only(
                  topLeft: Radius.circular(0),
                  topRight: Radius.circular(0),
                  bottomLeft: Radius.circular(5),
                  bottomRight: Radius.circular(5),
                )
              : const BorderRadius.only(
                  topLeft: Radius.circular(0),
                  topRight: Radius.circular(0),
                  bottomLeft: Radius.circular(5),
                  bottomRight: Radius.circular(5),
                ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              height: 10,
              width: 10,
              child: Image.asset(
                AppImages.playStore,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(
              height: 20,
              width: 50,
              child: FittedBox(
                child: Text(
                  'Rishteyy App',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WhatsAppShareButton extends StatelessWidget {
  // const WhatsAppShareButton({super.key});
  final ScreenshotController screenshotController1;
  final String postId;
  final PostWidgetModel postWidgetData;
  final String? parentScreenName;
  final bool isEdited;
  // final PostWidgetModel;
  // Uint8List? _imageFile;
  const WhatsAppShareButton({
    Key? key,
    required this.screenshotController1,
    required this.postId,
    required this.postWidgetData,
    this.parentScreenName,
    this.isEdited = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    final userCubit = BlocProvider.of<UserCubit>(context);
    return InkWell(
      onTap: () async {
        Logger().i("message");
        try {
          final path = DateTime.now().microsecondsSinceEpoch.toString();
          await screenshotController1
              .capture(
            delay: const Duration(milliseconds: 15),
          )
              .onError((error, stackTrace) {
            return null;
          }).then((capturedImage) async {
            if (capturedImage != null) {
              final directory = await getApplicationDocumentsDirectory();
              final imagePath =
                  await File('${directory.path}/$path.png').create();
              await imagePath.writeAsBytes(capturedImage);
              if (userCubit.state.isPremiumUser == false) {
                BlocProvider.of<AdmobCubit>(context).showAd();
              }

              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      content: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              tr("your_post_is_ready"),
                              style: const TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 5),
                            SizedBox(child: Image.file(File(imagePath.path))),
                            const SizedBox(height: 15),

                            // const SizedBox(height: 15),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                PremiumWrapper(
                                  isPremiumContent: true,
                                  isPremiumUser: BlocProvider.of<UserCubit>(
                                          context,
                                          listen: false)
                                      .state
                                      .isPremiumUser,
                                  child: CColorButton(
                                    isPremium: false,
                                    buttonText: tr("download"),
                                    isBorderButton: true,
                                    icon: const Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 5),
                                      child: Icon(
                                        Icons.get_app_rounded,
                                        color: AppColors.primaryColor,
                                      ),
                                    ),
                                    onTap: () async {
                                      if (userCubit.state.isPremiumUser ==
                                          false) {
                                        showPremiumCustomDialogue(
                                          context: context,
                                          title: tr("premium_warning",
                                              namedArgs: {
                                                "title": tr("feature")
                                              }),
                                          onTap: (() {
                                            nextScreenWithFadeAnimation(context,
                                                const PremiumPlanScreen());
                                          }),
                                          mq: mq,
                                        );
                                      } else {
                                        String userName =
                                            userCubit.state.userName;
                                        String userNumber =
                                            userCubit.state.userNumber;
                                        String userId =
                                            userCubit.state.userId.toString();
                                        bool isAddLinkDuringShare = userCubit
                                            .state.isAddLinkDuringShare;
                                        String promotionLink = "";

                                        removeDownloadKeysInPathTracker();
                                        pathTracker.add("download");
                                        try {
                                          bool? res =
                                              await GallerySaver.saveImage(
                                            imagePath.path,
                                            albumName: "Gita",
                                          );

                                          toast(tr("downloaded_successfully"));
                                          if (res != true) {
                                            BlocProvider.of<UserCubit>(context)
                                                .sendRatingFeedback(
                                                    message:
                                                        'Download Error in home screen:- $res',
                                                    reason: GErrorVar
                                                        .errorHomeScreen);
                                          }
                                          if (isEdited) {
                                            BlocProvider.of<PostCubit>(context)
                                                .sendImageToTelegramEditGroup(
                                                    postId: postId,
                                                    isPremium: userCubit
                                                        .state.isPremiumUser,
                                                    imagePath: imagePath.path,
                                                    userName: userName,
                                                    number: userNumber,
                                                    promotionLink:
                                                        promotionLink,
                                                    withLinkShare:
                                                        isAddLinkDuringShare,
                                                    userId: userId);
                                          } else {
                                            BlocProvider.of<PostCubit>(context)
                                                .sendImageToTelegram(
                                                    postId: postId,
                                                    isPremium: userCubit
                                                        .state.isPremiumUser,
                                                    imagePath: imagePath.path,
                                                    userName: userName,
                                                    number: userNumber,
                                                    promotionLink:
                                                        promotionLink,
                                                    withLinkShare:
                                                        isAddLinkDuringShare,
                                                    userId: userId);
                                          }

                                          Navigator.pop(context);
                                        } catch (e) {
                                          toast(
                                              "${tr("downloaded_successfully")}.");
                                          BlocProvider.of<UserCubit>(context)
                                              .sendRatingFeedback(
                                            message:
                                                'Download Error in home screen:- $e',
                                            reason: GErrorVar.errorHomeScreen,
                                          );
                                        }
                                      }
                                    },
                                    buttonColor: AppColors.primaryColor,
                                  ),
                                ),
                                CColorButton(
                                  buttonText: tr("share_now"),
                                  icon: const Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 5),
                                    child: FaIcon(
                                      FontAwesomeIcons.share,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                  buttonColor: AppColors.primaryColor,
                                  onTap: () async {
                                    removeDownloadKeysInPathTracker();

                                    String userName = userCubit.state.userName;
                                    String userNumber =
                                        userCubit.state.userNumber;
                                    String userId =
                                        userCubit.state.userId.toString();
                                    bool isAddLinkDuringShare =
                                        userCubit.state.isAddLinkDuringShare;
                                    String promotionLink = "";
                                    if (parentScreenName != null) {
                                      promotionLink = getPromotionLinkForTags(
                                          userName: userName,
                                          tag: parentScreenName!,
                                          userId: userId,
                                          postId: postId);
                                    } else {
                                      promotionLink = getNewPromotionLink(
                                          userName: userName,
                                          date: BlocProvider.of<PostCubit>(
                                                  context,
                                                  listen: false)
                                              .state
                                              .hindiDate,
                                          userId: userId,
                                          postId: postId);
                                    }
                                    if (isAddLinkDuringShare == false) {
                                      promotionLink = "";
                                    }
                                    await Share.shareFiles([imagePath.path],
                                        text: promotionLink);

                                    if (postWidgetData.imageLink
                                        .startsWith("htt")) {
                                      BlocProvider.of<UserCubit>(context)
                                          .savedPostDbOperations(
                                              isAddOperation: true,
                                              postIdToAdd: int.tryParse(
                                                      postWidgetData.postId
                                                          .toString()) ??
                                                  0,
                                              postLinkToAdd:
                                                  postWidgetData.imageLink);
                                    }
                                    BlocProvider.of<PostCubit>(context)
                                        .sendShareResponseToBackendAdmin(postId,
                                            userId: userId,
                                            userName: userName,
                                            userNumber: userNumber);

                                    if (isEdited) {
                                      BlocProvider.of<PostCubit>(context)
                                          .sendImageToTelegramEditGroup(
                                              postId: postId,
                                              isPremium:
                                                  userCubit.state.isPremiumUser,
                                              imagePath: imagePath.path,
                                              userName: userName,
                                              number: userNumber,
                                              promotionLink: promotionLink,
                                              withLinkShare:
                                                  isAddLinkDuringShare,
                                              userId: userId);
                                    } else {
                                      BlocProvider.of<PostCubit>(context)
                                          .sendImageToTelegram(
                                              postId: postId,
                                              isPremium:
                                                  userCubit.state.isPremiumUser,
                                              imagePath: imagePath.path,
                                              userName: userName,
                                              number: userNumber,
                                              promotionLink: promotionLink,
                                              withLinkShare:
                                                  isAddLinkDuringShare,
                                              userId: userId);
                                    }
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 30),
                          ],
                        ),
                      ),
                    );
                  });
              // AwesomeDialog(
              //   context: context,
              //   animType: AnimType.bottomSlide,
              //   dialogType: DialogType.noHeader,
              //   dismissOnTouchOutside: false,
              //   showCloseIcon: true,
              //   title: tr("your_post_is_ready"),
              //   titleTextStyle: const TextStyle(
              //     fontSize: 20,
              //     color: Colors.black,
              //   ),
              //   body: Column(
              //     children: [
              //       Text(
              //         tr("your_post_is_ready"),
              //         style: const TextStyle(
              //             fontSize: 20,
              //             color: Colors.black,
              //             fontWeight: FontWeight.bold),
              //       ),
              //       const SizedBox(height: 5),
              //       SizedBox(child: Image.file(File(imagePath.path))),
              //       const SizedBox(height: 15),
              //       Row(
              //         mainAxisAlignment: MainAxisAlignment.spaceAround,
              //         children: [
              //           const Spacer(),
              //           Text(
              //             tr("add_your_profile_link"),
              //             style: const TextStyle(),
              //           ),
              //           CSwitch(
              //             onChange: (val) {
              //               BlocProvider.of<UserCubit>(context)
              //                   .updateStateVariables(
              //                       isAddLinkDuringShare: val);
              //             },
              //           ),
              //           const Spacer(),
              //         ],
              //       ),
              //       const SizedBox(height: 15),
              //       Row(
              //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //         children: [
              //           PremiumWrapper(
              //             isPremiumContent: true,
              //             isPremiumUser:
              //                 BlocProvider.of<UserCubit>(context, listen: false)
              //                     .state
              //                     .isPremiumUser,
              //             child: CColorButton(
              //               isPremium: false,
              //               buttonText: tr("download"),
              //               isBorderButton: true,
              //               icon: const Padding(
              //                 padding: EdgeInsets.symmetric(horizontal: 5),
              //                 child: Icon(
              //                   Icons.get_app_rounded,
              //                   color: AppColors.primaryColor,
              //                 ),
              //               ),
              //               onTap: () async {
              //                 if (userCubit.state.isPremiumUser == false) {
              //                   showPremiumCustomDialogue(
              //                     context: context,
              //                     title: tr("premium_warning",
              //                         namedArgs: {"title": tr("feature")}),
              //                     onTap: (() {
              //                       nextScreenWithFadeAnimation(
              //                           context, const PremiumPlanScreen());
              //                     }),
              //                     mq: mq,
              //                   );
              //                 } else {
              //                   String userName = userCubit.state.userName;
              //                   String userNumber = userCubit.state.userNumber;
              //                   String userId =
              //                       userCubit.state.userId.toString();
              //                   bool isAddLinkDuringShare =
              //                       userCubit.state.isAddLinkDuringShare;
              //                   String promotionLink = "";

              //                   removeDownloadKeysInPathTracker();
              //                   pathTracker.add("download");
              //                   try {
              //                     bool? res = await GallerySaver.saveImage(
              //                       imagePath.path,
              //                       albumName: "Rishteyy",
              //                     );

              //                     toast(tr("downloaded_successfully"));
              //                     if (res != true) {
              //                       BlocProvider.of<UserCubit>(context)
              //                           .sendRatingFeedback(
              //                               message:
              //                                   'Download Error in home screen:- $res',
              //                               reason: GErrorVar.errorHomeScreen);
              //                     }
              //                     if (isEdited) {
              //                       BlocProvider.of<PostCubit>(context)
              //                           .sendImageToTelegramEditGroup(
              //                               postId: postId,
              //                               isPremium:
              //                                   userCubit.state.isPremiumUser,
              //                               imagePath: imagePath.path,
              //                               userName: userName,
              //                               number: userNumber,
              //                               promotionLink: promotionLink,
              //                               withLinkShare: isAddLinkDuringShare,
              //                               userId: userId);
              //                     } else {
              //                       BlocProvider.of<PostCubit>(context)
              //                           .sendImageToTelegram(
              //                               postId: postId,
              //                               isPremium:
              //                                   userCubit.state.isPremiumUser,
              //                               imagePath: imagePath.path,
              //                               userName: userName,
              //                               number: userNumber,
              //                               promotionLink: promotionLink,
              //                               withLinkShare: isAddLinkDuringShare,
              //                               userId: userId);
              //                     }

              //                     Navigator.pop(context);
              //                   } catch (e) {
              //                     toast("${tr("downloaded_successfully")}.");
              //                     BlocProvider.of<UserCubit>(context)
              //                         .sendRatingFeedback(
              //                       message:
              //                           'Download Error in home screen:- $e',
              //                       reason: GErrorVar.errorHomeScreen,
              //                     );
              //                   }
              //                 }
              //               },
              //               buttonColor: AppColors.primaryColor,
              //             ),
              //           ),
              //           CColorButton(
              //             buttonText: tr("share_now"),
              //             icon: const Padding(
              //               padding: EdgeInsets.symmetric(horizontal: 5),
              //               child: FaIcon(
              //                 FontAwesomeIcons.share,
              //                 color: Colors.white,
              //                 size: 20,
              //               ),
              //             ),
              //             buttonColor: AppColors.primaryColor,
              //             onTap: () async {
              //               removeDownloadKeysInPathTracker();

              //               String userName = userCubit.state.userName;
              //               String userNumber = userCubit.state.userNumber;
              //               String userId = userCubit.state.userId.toString();
              //               bool isAddLinkDuringShare =
              //                   userCubit.state.isAddLinkDuringShare;
              //               String promotionLink = "";
              //               if (parentScreenName != null) {
              //                 promotionLink = getPromotionLinkForTags(
              //                     userName: userName,
              //                     tag: parentScreenName!,
              //                     userId: userId,
              //                     postId: postId);
              //               } else {
              //                 promotionLink = getNewPromotionLink(
              //                     userName: userName,
              //                     date: BlocProvider.of<PostCubit>(context,
              //                             listen: false)
              //                         .state
              //                         .hindiDate,
              //                     userId: userId,
              //                     postId: postId);
              //               }
              //               if (isAddLinkDuringShare == false) {
              //                 promotionLink = "";
              //               }
              //               await Share.shareFiles([imagePath.path],
              //                   text: promotionLink);

              //               if (postWidgetData.imageLink.startsWith("htt")) {
              //                 BlocProvider.of<UserCubit>(context)
              //                     .savedPostDbOperations(
              //                         isAddOperation: true,
              //                         postIdToAdd: int.tryParse(postWidgetData
              //                                 .postId
              //                                 .toString()) ??
              //                             0,
              //                         postLinkToAdd: postWidgetData.imageLink);
              //               }
              //               BlocProvider.of<PostCubit>(context)
              //                   .sendShareResponseToBackendAdmin(postId,
              //                       userId: userId,
              //                       userName: userName,
              //                       userNumber: userNumber);

              //               if (isEdited) {
              //                 BlocProvider.of<PostCubit>(context)
              //                     .sendImageToTelegramEditGroup(
              //                         postId: postId,
              //                         isPremium: userCubit.state.isPremiumUser,
              //                         imagePath: imagePath.path,
              //                         userName: userName,
              //                         number: userNumber,
              //                         promotionLink: promotionLink,
              //                         withLinkShare: isAddLinkDuringShare,
              //                         userId: userId);
              //               } else {
              //                 BlocProvider.of<PostCubit>(context)
              //                     .sendImageToTelegram(
              //                         postId: postId,
              //                         isPremium: userCubit.state.isPremiumUser,
              //                         imagePath: imagePath.path,
              //                         userName: userName,
              //                         number: userNumber,
              //                         promotionLink: promotionLink,
              //                         withLinkShare: isAddLinkDuringShare,
              //                         userId: userId);
              //               }
              //               Navigator.pop(context);
              //             },
              //           ),
              //         ],
              //       ),
              //       const SizedBox(height: 30),
              //     ],
              //   ),
              // ).show();

            } else {
              // Logg
            }
          }).onError((error, stackTrace) {
            BlocProvider.of<UserCubit>(context).sendRatingFeedback(
              message: 'Share Error in home screen:- $error',
              reason: GErrorVar.errorHomeScreen,
            );
          }).catchError((onError) {});
        } catch (e) {
          BlocProvider.of<UserCubit>(context).sendRatingFeedback(
            message: 'Share Error in home screen:- $e',
            reason: GErrorVar.errorHomeScreen,
          );
        }
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 10),
        child: Container(
          height: 35,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10), color: Colors.green),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const SizedBox(width: 10),
              SvgPicture.asset(AppImages.whatsapp,
                  color: Colors.white, height: 20, width: 20),
              const SizedBox(width: 10),
              Padding(
                padding: const EdgeInsets.only(right: 5),
                child: Text(
                  tr(userCubit.state.isPremiumUser
                      ? "share"
                      : 'watch_ad_share'),
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
              const SizedBox(width: 10),
            ],
          ),
        ),
      ),
    );
  }
}

class DownloadButton extends StatelessWidget {
  // const WhatsAppShareButton({super.key});
  final ScreenshotController screenshotController1;
  final String postId;
  final String? telChannelName;
  final bool isDownloadPremium;
  // final PostWidgetModel;
  // Uint8List? _imageFile;
  const DownloadButton({
    Key? key,
    required this.screenshotController1,
    required this.postId,
    this.telChannelName,
    this.isDownloadPremium = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    final userCubit = BlocProvider.of<UserCubit>(context, listen: false);
    return InkWell(
      onTap: () async {
        try {
          final path = DateTime.now().microsecondsSinceEpoch.toString();
          await screenshotController1
              .capture(
            delay: const Duration(milliseconds: 15),
          )
              .onError((error, stackTrace) {
            return null;
          }).then((capturedImage) async {
            if (capturedImage != null) {
              final directory = await getApplicationDocumentsDirectory();
              final imagePath =
                  await File('${directory.path}/$path.png').create();
              await imagePath.writeAsBytes(capturedImage);
              if (userCubit.state.isPremiumUser == false) {
                BlocProvider.of<AdmobCubit>(context).showAd();
              }
              // AwesomeDialog(
              //   context: context,
              //   animType: AnimType.bottomSlide,
              //   dialogType: DialogType.noHeader,
              //   dismissOnTouchOutside: false,
              //   showCloseIcon: true,
              //   title: tr("your_post_is_ready"),
              //   titleTextStyle: const TextStyle(
              //     fontSize: 20,
              //     color: Colors.black,
              //   ),
              //   body: Column(
              //     children: [
              //       Text(
              //         tr("your_post_is_ready"),
              //         style: const TextStyle(
              //             fontSize: 20,
              //             color: Colors.black,
              //             fontWeight: FontWeight.bold),
              //       ),
              //       const SizedBox(height: 5),
              //       SizedBox(child: Image.file(File(imagePath.path))),
              //       const SizedBox(height: 15),
              //       Row(
              //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //         children: [
              //           CColorButton(
              //             isPremium: isDownloadPremium,
              //             buttonText: tr("download"),
              //             isBorderButton: true,
              //             icon: const Padding(
              //               padding: EdgeInsets.symmetric(horizontal: 5),
              //               child: Icon(
              //                 Icons.get_app_rounded,
              //                 color: AppColors.primaryColor,
              //               ),
              //             ),
              //             onTap: () async {
              //               if (userCubit.state.isPremiumUser == false) {
              //                 showPremiumCustomDialogue(
              //                   context: context,
              //                   title: tr("premium_warning",
              //                       namedArgs: {"title": tr("feature")}),
              //                   onTap: (() {
              //                     nextScreenWithFadeAnimation(
              //                         context, const PremiumPlanScreen());
              //                   }),
              //                   mq: mq,
              //                 );
              //               } else {
              //                 String userName = userCubit.state.userName;
              //                 String userNumber = userCubit.state.userNumber;
              //                 String userId = userCubit.state.userId.toString();
              //                 bool isAddLinkDuringShare =
              //                     userCubit.state.isAddLinkDuringShare;
              //                 String promotionLink = "";

              //                 removeDownloadKeysInPathTracker();
              //                 pathTracker.add("download");
              //                 try {
              //                   bool? res = await GallerySaver.saveImage(
              //                     imagePath.path,
              //                     albumName: "Rishteyy",
              //                   );

              //                   toast(tr("downloaded_successfully"));
              //                   if (res != true) {
              //                     BlocProvider.of<UserCubit>(context)
              //                         .sendRatingFeedback(
              //                             message:
              //                                 'Download Error in home screen:- $res',
              //                             reason: GErrorVar.errorHomeScreen);
              //                   }
              //                   BlocProvider.of<PostCubit>(context)
              //                       .sendImageToTelegramEditGroup(
              //                           postId: postId,
              //                           isPremium:
              //                               userCubit.state.isPremiumUser,
              //                           imagePath: imagePath.path,
              //                           userName: userName,
              //                           number: userNumber,
              //                           channelName: telChannelName,
              //                           // promotionLink: promotionLink,
              //                           withLinkShare: isAddLinkDuringShare,
              //                           userId: userId);

              //                   Navigator.pop(context);
              //                 } catch (e) {
              //                   toast("${tr("downloaded_successfully")}.");
              //                   BlocProvider.of<UserCubit>(context)
              //                       .sendRatingFeedback(
              //                     message: 'Download Error in home screen:- $e',
              //                     reason: GErrorVar.errorHomeScreen,
              //                   );
              //                 }
              //               }
              //             },
              //             buttonColor: AppColors.primaryColor,
              //           ),
              //           CColorButton(
              //             buttonText: tr("share_now"),
              //             icon: const Padding(
              //               padding: EdgeInsets.symmetric(horizontal: 5),
              //               child: FaIcon(
              //                 FontAwesomeIcons.share,
              //                 color: Colors.white,
              //                 size: 20,
              //               ),
              //             ),
              //             buttonColor: AppColors.primaryColor,
              //             onTap: () async {
              //               removeDownloadKeysInPathTracker();

              //               String userName = userCubit.state.userName;
              //               String userNumber = userCubit.state.userNumber;
              //               String userId = userCubit.state.userId.toString();
              //               bool isAddLinkDuringShare =
              //                   userCubit.state.isAddLinkDuringShare;
              //               String promotionLink = "";
              //               {
              //                 promotionLink = getOldPromotionLink();
              //               }
              //               if (isAddLinkDuringShare == false) {
              //                 promotionLink = "";
              //               }
              //               await Share.shareFiles([imagePath.path],
              //                   text: promotionLink);

              //               BlocProvider.of<PostCubit>(context)
              //                   .sendShareResponseToBackendAdmin(postId,
              //                       userId: userId,
              //                       userName: userName,
              //                       userNumber: userNumber);

              //               BlocProvider.of<PostCubit>(context)
              //                   .sendImageToTelegramEditGroup(
              //                       postId: postId,
              //                       isPremium: userCubit.state.isPremiumUser,
              //                       imagePath: imagePath.path,
              //                       userName: userName,
              //                       channelName: telChannelName,
              //                       number: userNumber,
              //                       promotionLink: promotionLink,
              //                       withLinkShare: isAddLinkDuringShare,
              //                       userId: userId);
              //               Navigator.pop(context);
              //             },
              //           ),
              //         ],
              //       ),
              //       const SizedBox(height: 30),
              //     ],
              //   ),
              // ).show();

            } else {
              // Logg
            }
          }).onError((error, stackTrace) {
            BlocProvider.of<UserCubit>(context).sendRatingFeedback(
              message: 'Share Error in home screen:- $error',
              reason: GErrorVar.errorHomeScreen,
            );
          }).catchError((onError) {});
        } catch (e) {
          BlocProvider.of<UserCubit>(context).sendRatingFeedback(
            message: 'Share Error in home screen:- $e',
            reason: GErrorVar.errorHomeScreen,
          );
        }
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 10),
        child: Container(
          height: 35,
          // width: 150,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10), color: Colors.green),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const SizedBox(width: 10),
              SvgPicture.asset(AppImages.whatsapp,
                  color: Colors.white, height: 20, width: 20),
              const SizedBox(width: 10),
              Padding(
                  padding: const EdgeInsets.only(right: 5),
                  child: FittedBox(
                      child: Text(
                    tr(userCubit.state.isPremiumUser
                        ? "share"
                        : 'watch_ad_share'),
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ))),
              const SizedBox(width: 10),
            ],
          ),
        ),
      ),
    );
  }
}
