import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../Data/model/ObjectModels/post_widget_model.dart';
import '../../../Logic/Cubit/PostEditorCubit/post_editor_cubit.dart';
import '../../../Logic/Cubit/StickerCubit/sticker_cubit.dart';
import '../../../Logic/Cubit/locale_cubit/locale_cubit.dart';
import '../../../Logic/Cubit/user_cubit/user_cubit.dart';
import '../../../Utility/next_screen.dart';
import '../../Widgets/Dialogue/dialogue.dart';
import '../../Widgets/gradient_selector_widget.dart';
import '../../Widgets/post_widget.dart';
import '../PremiumPlanScreens/premium_plan_screen.dart';
import '../Tools/premium_wrapper.dart';
import 'post_edit_screen.dart';

class CreatePostScreen extends StatelessWidget {
  const CreatePostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: SizedBox(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 15),
            InkWell(
              onTap: () {
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
                      // isGradientPost: true,
                      makePostFromGallery: true,
                    ));
              },
              child: Container(
                width: mq.width * 0.8,
                // height: mq.height * 0.15,
                decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.image_rounded,
                        size: 75,
                        color: Colors.grey,
                      ),
                      Text(
                        tr('upload_your_quote'),
                        style: const TextStyle(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Container(
                    height: 1,
                    color: Colors.grey,
                  ),
                )),
                const Text(
                  'OR',
                  style: TextStyle(),
                ),
                Expanded(
                  child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Container(color: Colors.grey, height: 1)),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                // Opacity(
                //   opacity: 0,
                //   child: IconButton(
                //       onPressed: () {},
                //       icon: const Icon(
                //         Icons.search,
                //         size: 20,
                //       )),
                // ),
                const Spacer(),
                Text(tr('choose_bg'),
                    style: const TextStyle(color: Colors.black, fontSize: 20)),
                const Spacer(),
                // IconButton(
                //     onPressed: () {
                //       showSearch(context: context, delegate: ImageSearch());
                //     },
                //     icon: const Icon(
                //       Icons.search,
                //       size: 20,
                //     )),
              ],
            ),
            getBgImagesWidget(mq),
            Row(
              children: const [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Gradient",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Spacer(),
              ],
            ),
            GradientSelectorWidget(mq: mq),
            //  SizedBox(height: 515),
          ],
        ),
      ),
    );
  }

  Widget getBgImagesWidget(Size mq) {
    bool isHindi = (tr('_a_') != "A");
    return BlocBuilder<StickerCubit, StickerState>(builder: (context, state) {
      return SizedBox(
        // height: 75,
        child: ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: state.bgImagesCategories.length,
          itemBuilder: (ctx, index) => Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: BlocBuilder<LocaleCubit, LocaleState>(
                    builder: (context, localState) {
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
                    bool isPremium = (state.bgImagesCategories[index]
                            .backgrounds?[index1].isPremium ==
                        1);
                    // for (var e in state.bgImagesCategories) {
                    //   Logger().i(jsonEncode(e));
                    // }
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: mq.width * 0.25,
                        height: (mq.width * 0.25),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: InkWell(
                          onTap: () {
                            if (isPremium &&
                                (BlocProvider.of<UserCubit>(context)
                                        .state
                                        .isPremiumUser ==
                                    false)) {
                              showPremiumCustomDialogue(
                                  context: context,
                                  title: tr("premium_warning",
                                      namedArgs: {"title": tr("bg")}),
                                  image: img,
                                  onTap: (() {
                                    nextScreenWithFadeAnimation(
                                        context, const PremiumPlanScreen());
                                  }),
                                  mq: mq);
                              // AwesomeDialog(
                              //   context: context, showCloseIcon: true,
                              //   dialogType: DialogType.info,
                              //   animType:
                              //       AnimType.scale, //awesome_dialog: ^2.1.1
                              //   title: 'Please Buy Premium membership.',
                              //   btnOkText: 'Ok',
                              //   btnOkColor: Theme.of(context).primaryColor,
                              //   btnOkOnPress: () {

                              //   },
                              // ).show();
                            } else {
                              try {
                                BlocProvider.of<PostEditorCubit>(context)
                                    .updateStateVariables(
                                  blankPostBgImage: img,
                                );
                                final frames = BlocProvider.of<StickerCubit>(
                                        context,
                                        listen: false)
                                    .state
                                    .listOfFrames;
                                if (frames.isNotEmpty) {
                                  BlocProvider.of<PostEditorCubit>(context)
                                      .updateStateVariables(
                                          currentFrame: frames[0]);
                                }
                                BlocProvider.of<UserCubit>(context)
                                    .updateStateVariables(
                                        editedName: BlocProvider.of<UserCubit>(
                                                context,
                                                listen: false)
                                            .state
                                            .userName);
                              } catch (e) {
                                // Logger().e(e);
                              }
                              nextScreenWithFadeAnimation(
                                  context,
                                  PostEditScreen(
                                    postWidgetData: PostWidgetModel(
                                      imageLink: "",
                                      postId: '',
                                      profilePos: 'right',
                                      tagColor: 'white',
                                      profileShape: 'circle',
                                      playStoreBadgePos: 'center-touched',
                                    ),
                                    isGradientPost: true,
                                    // makePostFromGallery: true,
                                  ));
                            }
                          },
                          child: PremiumWrapper(
                            isPremiumContent: isPremium,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: CachedNetworkImage(
                                imageUrl: img,
                                fit: BoxFit.cover,
                                progressIndicatorBuilder: (BuildContext context,
                                    String _, DownloadProgress __) {
                                  // if (loadingProgress == null) return child;
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
