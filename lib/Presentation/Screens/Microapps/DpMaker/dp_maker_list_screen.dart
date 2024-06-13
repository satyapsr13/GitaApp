// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: prefer_const_constructors
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rishteyy/Presentation/Screens/Tools/premium_wrapper.dart';
import 'package:rishteyy/Presentation/Screens/post_edit_screen_for_dpframe.dart';
import 'package:rishteyy/Presentation/Widgets/Dialogue/dialogue.dart';
import 'package:rishteyy/Utility/next_screen.dart';

import '../../../../Constants/locations.dart';
import '../../../../Data/model/api/dpframes_response.dart';
import '../../../../Logic/Cubit/StickerCubit/sticker_cubit.dart';
import '../../../../Logic/Cubit/user_cubit/user_cubit.dart';
import '../../DpMakerScreens/dp_maker_screens.dart';
import '../../PremiumPlanScreens/premium_plan_screen.dart';

class DpMakerListScreen extends StatefulWidget {
  // const DpMakerListScreen({super.key});
  final String? keyword;
  const DpMakerListScreen({
    Key? key,
    this.keyword,
  }) : super(key: key);

  @override
  State<DpMakerListScreen> createState() => _DpMakerListScreenState();
}

class _DpMakerListScreenState extends State<DpMakerListScreen> {
  @override
  void initState() {
    BlocProvider.of<StickerCubit>(context)
        .fetchDpFrames(keyword: widget.keyword);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Dp Maker',
          style: const TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      body: BlocBuilder<UserCubit, UserState>(builder: (context, userState) {
        return BlocBuilder<StickerCubit, StickerState>(
            builder: (context, state) {
          return Container(
            width: mq.width,
            height: mq.height,
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: GridView.builder(
              itemCount: state.listOfDpFrames.length,
              itemBuilder: (ctx, index) {
                final DpFrames frames = state.listOfDpFrames[index];
                return InkWell(
                    onTap: () {
                      final userState =
                          BlocProvider.of<UserCubit>(context).state;
                      if ((frames.isPremium == true) &&
                          (userState.isPremiumUser == false)) {
                        showPremiumCustomDialogue(
                          context: context,
                          title: tr("premium_warning",
                              namedArgs: {"title": tr("frame")}),
                          onTap: (() {
                            nextScreenWithFadeAnimation(
                                context, PremiumPlanScreen());
                          }),
                          mq: mq,
                        );
                      } else {
                        nextScreenWithFadeAnimation(
                            context,
                            PostEditScreenForDpFrame(
                              currentSelectedFrame: frames,
                            ));
                      }
                    },
                    child: Container(
                      height: mq.width * 0.4,
                      width: mq.width * 0.4,
                      decoration: BoxDecoration(border: Border.all()),
                      child: LayoutBuilder(builder: (context, constraints) {
                        final double x1 = (frames.customPosition![0] / 100) *
                            constraints.maxWidth;

                        final double y1 = (frames.customPosition![1] / 100) *
                            constraints.maxHeight;

                        final double widthI = (frames.customPosition![2] -
                                frames.customPosition![0]) /
                            100 *
                            constraints.maxWidth;
                        final double heightI = (frames.customPosition![3] -
                                frames.customPosition![1]) /
                            100 *
                            constraints.maxHeight;
                        return Stack(
                          clipBehavior: Clip.none,
                          children: [
                            DpFrameWidget(
                              posX: x1,
                              posY: y1,
                              width: widthI,
                              height: heightI,
                              frameImagePath: frames.path ?? "",
                              userProfileImage: userState.fileImagePath,
                              mq: mq,
                              dpMode: DPMode.photo,
                            ),
                            Visibility(
                              visible: frames.isPremium == true,
                              child: Positioned(
                                  top: -10,
                                  right: 10,
                                  child: SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: Image.asset(
                                        AppImages.nonPremiumUserIcon,
                                        fit: BoxFit.cover,
                                      ))),
                            ),
                          ],
                        );
                      }),
                    ));
              },
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 2 / 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10),
            ),
          );
        });
      }),
    );
  }
}
