import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Constants/locations.dart';
import '../../Data/model/api/frames_response.dart';
import '../../Logic/Cubit/PostEditorCubit/post_editor_cubit.dart';
import '../../Logic/Cubit/StickerCubit/sticker_cubit.dart';
import '../../Logic/Cubit/user_cubit/user_cubit.dart';
import '../../Utility/next_screen.dart';
import '../Screens/PremiumPlanScreens/premium_plan_screen.dart';
import '../Screens/Tools/premium_wrapper.dart';
import 'Dialogue/dialogue.dart';       

class FramesListWidget extends StatelessWidget {
  const FramesListWidget({
    Key? key,
    required this.mq,
    this.showWhiteFrame = false,
    this.showSelectedFrames = false,
  }) : super(key: key);

  final Size mq;
  final bool showWhiteFrame;
  final bool showSelectedFrames;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 90,
      width: mq.width,
      child: BlocBuilder<StickerCubit, StickerState>(
          builder: (context, stickerState) {
        return ListView(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            children: [
              ...List.generate(stickerState.listOfFrames.length, (index) {
                final Frame frame = stickerState.listOfFrames[index];
                return (showSelectedFrames &&
                        (frame.isActive == false || frame.isActive == null))
                    ? const SizedBox()
                    : Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: () {
                            {
                              if (frame.isActive!) {
                                BlocProvider.of<StickerCubit>(context)
                                    .frameActiveInactiveOperations(
                                        frameId: frame.id ?? 0,
                                        isInActiveOperation: true);
                              } else {
                                if (stickerState.listOfActiveFrames.length >=
                                    4) {
                                  AwesomeDialog(
                                    context: context,
                                    showCloseIcon: true,
                                    dialogType: DialogType.infoReverse,
                                    animType: AnimType.bottomSlide,
                                    title: tr('sticker_select_text'),
                                    btnOkText: 'Ok',
                                    btnOkColor: Theme.of(context).primaryColor,
                                    btnOkOnPress: () {},
                                  ).show();
                                } else {
                                  BlocProvider.of<StickerCubit>(context)
                                      .frameActiveInactiveOperations(
                                          frameId: frame.id ?? 0,
                                          isActiveOperation: true);
                                }
                              }
                            }
                          },
                          child: Stack(
                            alignment: Alignment.topCenter,
                            clipBehavior: Clip.none,
                            children: [
                              Container(
                                height: 75,
                                width: 150,
                                decoration: BoxDecoration(
                                  color: const Color(0xffdddddd),
                                  borderRadius: BorderRadius.circular(10),
                                  // decoration: BoxDecoration(
                                  // borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    width: frame.isActive == true ? 2 : 1,
                                    color: frame.isActive == true
                                        ? Colors.orange
                                        : Colors.grey,
                                  ),
                                  // ),
                                ),
                                child: Column(
                                  children: [
                                    const Expanded(child: SizedBox()),
                                    ClipRRect(
                                      borderRadius: const BorderRadius.only(
                                        bottomLeft: Radius.circular(10),
                                        bottomRight: Radius.circular(10),
                                      ),
                                      child: SizedBox(
                                          // height: 50,
                                          width: 150,
                                          child: CachedNetworkImage(
                                            imageUrl:
                                                frame.profile?.image ?? "",
                                            fit: BoxFit.fitWidth,
                                          )),
                                    )
                                  ],
                                ),
                              ),
                              Visibility(
                                visible: frame.isActive == true,
                                child: Positioned(
                                  top: -10,
                                  child: SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: Image.asset(AppImages.selectedBadge),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
              }),
            ]);
      }),
    );
  }
}

class FramesListWidgetForEditor extends StatelessWidget {
  const FramesListWidgetForEditor({
    Key? key,
    required this.mq,
    this.showWhiteFrame = false,
  }) : super(key: key);

  final Size mq;
  final bool showWhiteFrame;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 90,
      width: mq.width,
      child: BlocBuilder<UserCubit, UserState>(builder: (context, userState) {
        return BlocBuilder<PostEditorCubit, PostEditorState>(
            builder: (context, postEditState) {
          return BlocBuilder<StickerCubit, StickerState>(
              builder: (context, stickerState) {
            return ListView(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () {
                        BlocProvider.of<PostEditorCubit>(context)
                            .updateStateVariables(
                          isWhiteFrame: true,
                          customFrameColor: Colors.white,
                          nameColor: Colors.black,
                          numberColor: Colors.black,
                          occupationColor: Colors.black,
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Stack(
                          alignment: Alignment.topCenter,
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              height: 85,
                              width: 150,
                              clipBehavior: Clip.hardEdge,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: const Color(0xffcccccc),
                                border: Border.all(
                                  width: postEditState.isWhiteFrame ? 2 : 1,
                                  color: postEditState.isWhiteFrame
                                      ? Colors.orange
                                      : Colors.grey,
                                ),
                              ),
                              child: Column(
                                children: [
                                  const Expanded(child: SizedBox()),
                                  ClipRRect(
                                    borderRadius: const BorderRadius.only(
                                      bottomLeft: Radius.circular(10),
                                      bottomRight: Radius.circular(10),
                                    ),
                                    child: Container(
                                      width: 150,
                                      height: 30,
                                      decoration: BoxDecoration(
                                          color: postEditState.customFrameColor,
                                          border: Border.all(
                                            width: 0.5,
                                            color: Colors.grey,
                                          )),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Visibility(
                              visible: postEditState.isWhiteFrame,
                              child: Positioned(
                                top: -10,
                                child: SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: Image.asset(AppImages.selectedBadge),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  ...List.generate(stickerState.listOfFrames.length, (index) {
                    final Frame frame = stickerState.listOfFrames[index];
                    bool isActive =
                        (frame.id == postEditState.currentFrame?.id) &&
                            !postEditState.isWhiteFrame;
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () {
                          final isPremiumUser =
                              BlocProvider.of<UserCubit>(context, listen: false)
                                  .state
                                  .isPremiumUser;
                          if (frame.isPremium == true &&
                              (isPremiumUser == false)) {
                            showPremiumCustomDialogue(
                              context: context,
                              title: tr("premium_warning",
                                  namedArgs: {"title": tr("frame")}),
                              image: frame.profile?.image ?? "",
                              onTap: (() {
                                nextScreenWithFadeAnimation(
                                    context, PremiumPlanScreen());
                              }),
                              mq: mq,
                            );
                          } else {
                            BlocProvider.of<PostEditorCubit>(context)
                                .updateStateVariables(
                                    currentFrame: frame, isWhiteFrame: false);
                          }
                        },
                        child: PremiumWrapper(
                          isPremiumContent: frame.isPremium == true,
                          isPremiumUser: userState.isPremiumUser,
                          child: Stack(
                            alignment: Alignment.topCenter,
                            clipBehavior: Clip.none,
                            children: [
                              Container(
                                height: 75,
                                width: 150,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: const Color(0xffcccccc),
                                  border: Border.all(
                                    width: isActive == true ? 2 : 1,
                                    color: isActive == true
                                        ? Colors.orange
                                        : Colors.grey,
                                  ),
                                  // ),
                                ),
                                child: Column(
                                  children: [
                                    const Expanded(child: SizedBox()),
                                    ClipRRect(
                                      borderRadius: const BorderRadius.only(
                                        bottomLeft: Radius.circular(10),
                                        bottomRight: Radius.circular(10),
                                      ),
                                      child: SizedBox(
                                          // height: 50,
                                          width: 150,
                                          child: CachedNetworkImage(
                                            imageUrl:
                                                frame.profile?.image ?? "",
                                            fit: BoxFit.fitWidth,
                                          )),
                                    )
                                  ],
                                ),
                              ),
                              Visibility(
                                visible: isActive == true,
                                child: Positioned(
                                  top: -10,
                                  child: SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: Image.asset(AppImages.selectedBadge),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ]);
          });
        });
      }),
    );
  }
}
