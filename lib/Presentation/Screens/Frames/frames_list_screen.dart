import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; 

import '../../../Constants/locations.dart';
import '../../../Data/model/api/frames_response.dart';
import '../../../Logic/Cubit/PostEditorCubit/post_editor_cubit.dart';
import '../../../Logic/Cubit/StickerCubit/sticker_cubit.dart';
import '../../../Logic/Cubit/user_cubit/user_cubit.dart';
import '../../../Utility/next_screen.dart';
import '../../Widgets/Dialogue/dialogue.dart';
import '../PremiumPlanScreens/premium_plan_screen.dart';
import '../Tools/premium_wrapper.dart';

class FramesListScreen extends StatelessWidget {
  const FramesListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Frames',
            style: TextStyle(
              fontSize: 20,
              color: Colors.black,
            ),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: BlocBuilder<UserCubit, UserState>(
                  builder: (context, userState) {
                return BlocBuilder<PostEditorCubit, PostEditorState>(
                    builder: (context, postEditState) {
                  return BlocBuilder<StickerCubit, StickerState>(
                      builder: (context, stickerState) {
                    return GridView.builder(
                      itemCount: stickerState.listOfFrames.length,
                      itemBuilder: (ctx, index) {
                        final Frame frame = stickerState.listOfFrames[index];

                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: () {
                              final isPremiumUser = BlocProvider.of<UserCubit>(
                                      context,
                                      listen: false)
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
                                if (frame.isActive!) {
                                  BlocProvider.of<StickerCubit>(context)
                                      .frameActiveInactiveOperations(
                                          frameId: frame.id ?? 0,
                                          isInActiveOperation: true);
                                } else {
                                  if (stickerState.listOfActiveFrames.length >=
                                          4 &&
                                      (isPremiumUser == false)) {
                                    AwesomeDialog(
                                      context: context,
                                      showCloseIcon: true,
                                      dialogType: DialogType.info,
                                      animType: AnimType.bottomSlide,
                                      title: tr('sticker_select_text'),
                                      btnOkText: 'Ok',
                                      btnOkColor:
                                          Theme.of(context).primaryColor,
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
                                PremiumWrapper(
                                  isPremiumContent: frame.isPremium == true,
                                  isPremiumUser: userState.isPremiumUser,
                                  child: Container(
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
                                ),
                                Visibility(
                                  visible: frame.isActive == true,
                                  child: Positioned(
                                    top: -10,
                                    child: SizedBox(
                                      height: 20,
                                      width: 20,
                                      child:
                                          Image.asset(AppImages.selectedBadge),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 4 / 2,
                              crossAxisSpacing: 0,
                              mainAxisSpacing: 0),
                    );
                  });
                });
              }),
            ),
          ],
        ));
  }
}
