import 'dart:io';

// // import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:overlay_support/overlay_support.dart';

import '../../../../../Constants/colors.dart';
import '../../../../../Constants/enums.dart';
import '../../../../../Data/model/api/sticker_model.dart';
import '../../../../../Logic/Cubit/StickerCubit/sticker_cubit.dart';
import '../../../../../Logic/Cubit/user_cubit/user_cubit.dart';
import '../../../../../Utility/next_screen.dart';
import '../../../../Widgets/BottomSheet/image_picker_bottom_sheet.dart';
import '../../../../Widgets/Dialogue/dialogue.dart';
import '../../../../Widgets/ShimmerLoader/shimmer_widgets.dart';
import '../../../../Widgets/snackbar.dart';
import '../../../PremiumPlanScreens/premium_plan_screen.dart';
import '../../../Tools/premium_wrapper.dart';

class EditorStickerWidget extends StatefulWidget {
  final int stickerLen;
  const EditorStickerWidget({
    Key? key,
    required this.stickerLen,
  }) : super(key: key);

  @override
  State<EditorStickerWidget> createState() => _EditorStickerWidgetState();
}

class _EditorStickerWidgetState extends State<EditorStickerWidget>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedIndex = 1;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
        initialIndex: 1, length: widget.stickerLen + 1, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _selectedIndex = _tabController.index;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final stickerCubit = BlocProvider.of<StickerCubit>(context);
    final mq = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 32,
        vertical: 8,
      ),
      width: mq.width,
      height: mq.height * 0.55,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24), topRight: Radius.circular(24)),
        color: Colors.white,
      ),
      child: BlocConsumer<StickerCubit, StickerState>(
        listener: ((context, state) {
          if (state.removeBgStatus == Status.failure) {
            showSnackBar(context, Colors.red, "Please try again");

            BlocProvider.of<UserCubit>(context).sendRatingFeedback(
                message: "Error during removing BG:- ${state.errorMessage}");
          }
          if (state.removeBgStatus == Status.success) {
            toast(tr("bg_removed_successfully"));
          }
        }),
        builder: (context, state) {
          if (state.status == Status.failure &&
              state.stickerTopicList.isEmpty) {
            return Center(
                child: TextButton(
              onPressed: () {
                stickerCubit.fetchStickers();
              },
              child: const Text(
                'Reload',
              ),
            ));
          }
          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                      onPressed: () {
                        stickerCubit.updateStateVariables(
                            editorWidgets: EditorWidgets.none);
                      },
                      icon: const Icon(
                        Icons.close,
                        size: 30,
                      )),
                ],
              ),
              state.status == Status.loading
                  ? _buildStickerLoadingWidget(mq)
                  : Expanded(
                      child: Column(
                        children: [
                          SizedBox(
                            child: TabBar(
                              labelColor: Colors.black,
                              controller: _tabController,
                              isScrollable: true,
                              unselectedLabelStyle: const TextStyle(
                                  fontSize: 12, color: Colors.white),
                              indicator: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.circular(10),
                                  color:
                                      AppColors.primaryColor.withOpacity(0.2)),
                              labelStyle: const TextStyle(
                                  fontSize: 15,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700),
                              tabs: [
                                Tab(text: tr("your_stickers")),
                                ...state.stickerTopicList.map((e) {
                                  return Tab(
                                      text:
                                          tr("_a_") == "A" ? e.name : e.hindi);
                                }).toList()
                              ],
                            ),
                          ),
                          Expanded(
                            child: state.stickerTopicList.isEmpty
                                ? IconButton(
                                    onPressed: () {
                                      stickerCubit.fetchStickers();
                                    },
                                    icon: const Icon(
                                      Icons.refresh,
                                      size: 20,
                                      color: Colors.blue,
                                    ))
                                : TabBarView(
                                    controller: _tabController,
                                    children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: SizedBox(
                                            height: 350,
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                state.listOfUserStickers.isEmpty
                                                    ? InkWell(
                                                        onTap: () {
                                                          showModalBottomSheet(
                                                              context: context,
                                                              shape:
                                                                  const RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .only(
                                                                  topLeft: Radius
                                                                      .circular(
                                                                          20),
                                                                  topRight: Radius
                                                                      .circular(
                                                                          20),
                                                                ),
                                                              ),
                                                              builder:
                                                                  (context) {
                                                                return ImagePickerModalBottomSheet(
                                                                  whereToSave:
                                                                      "UserCustomSticker",
                                                                );
                                                              });
                                                        },
                                                        child: SizedBox(
                                                            height: 100,
                                                            width: mq.width,
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: const [
                                                                Icon(
                                                                  Icons.add,
                                                                  size: 50,
                                                                ),
                                                                FittedBox(
                                                                  child: Text(
                                                                    'Upload your sticker',
                                                                    maxLines: 2,
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            )),
                                                      )
                                                    : Expanded(
                                                        child: GridView.builder(
                                                          physics:
                                                              const NeverScrollableScrollPhysics(),
                                                          itemCount: state
                                                                  .listOfUserStickers
                                                                  .length +
                                                              1,
                                                          itemBuilder:
                                                              (ctx, index) {
                                                            if (index >=
                                                                state
                                                                    .listOfUserStickers
                                                                    .length) {
                                                              return InkWell(
                                                                onTap: () {
                                                                  final isPremiumUser = BlocProvider.of<
                                                                              UserCubit>(
                                                                          context,
                                                                          listen:
                                                                              false)
                                                                      .state
                                                                      .isPremiumUser;
                                                                  if (state
                                                                          .listOfUserStickers
                                                                          .length >=
                                                                      (isPremiumUser
                                                                          ? 10
                                                                          : 5)) {
                                                                    // AwesomeDialog(
                                                                    //   context:
                                                                    //       context,
                                                                    //   showCloseIcon:
                                                                    //       true,
                                                                    //   dialogType:
                                                                    //       DialogType
                                                                    //           .infoReverse,
                                                                    //   animType:
                                                                    //       AnimType
                                                                    //           .bottomSlide,
                                                                    //   title: tr(
                                                                    //       "user_sticker_add_warning"),
                                                                    //   btnOkText:
                                                                    //       'Ok',
                                                                    //   btnOkColor:
                                                                    //       Theme.of(context)
                                                                    //           .primaryColor,
                                                                    //   btnOkOnPress:
                                                                    //       () {},
                                                                    // ).show();
                                                                  } else {
                                                                    showModalBottomSheet(
                                                                        context:
                                                                            context,
                                                                        shape:
                                                                            const RoundedRectangleBorder(
                                                                          borderRadius:
                                                                              BorderRadius.only(
                                                                            topLeft:
                                                                                Radius.circular(20),
                                                                            topRight:
                                                                                Radius.circular(20),
                                                                          ),
                                                                        ),
                                                                        builder:
                                                                            (context) {
                                                                          return ImagePickerModalBottomSheet(
                                                                            whereToSave:
                                                                                "UserCustomSticker",
                                                                          );
                                                                        });
                                                                  }
                                                                },
                                                                child: SizedBox(
                                                                  height: 100,
                                                                  width: 100,
                                                                  child: Column(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .center,
                                                                    children: const [
                                                                      Icon(
                                                                        Icons
                                                                            .add,
                                                                        size:
                                                                            20,
                                                                      ),
                                                                      FittedBox(
                                                                        child:
                                                                            Text(
                                                                          'Upload your sticker',
                                                                          maxLines:
                                                                              2,
                                                                          style:
                                                                              TextStyle(
                                                                            color:
                                                                                Colors.black,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              );
                                                            }

                                                            final StickerFromAssets
                                                                sticker =
                                                                state.listOfUserStickers[
                                                                    index];
                                                            return InkWell(
                                                                onTap: () {
                                                                  final isPremiumUser = BlocProvider.of<
                                                                              UserCubit>(
                                                                          context,
                                                                          listen:
                                                                              false)
                                                                      .state
                                                                      .isPremiumUser;
                                                                  if (state
                                                                          .listOfActiveUserStickers
                                                                          .length >=
                                                                      (isPremiumUser
                                                                          ? 10
                                                                          : 2)) {
                                                                    // AwesomeDialog(
                                                                    //   context:
                                                                    //       context,
                                                                    //   showCloseIcon:
                                                                    //       true,
                                                                    //   dialogType:
                                                                    //       DialogType
                                                                    //           .infoReverse,
                                                                    //   animType:
                                                                    //       AnimType
                                                                    //           .bottomSlide, //awesome_dialog: ^2.1.1
                                                                    //   title:
                                                                    //       'You can not use more than 2 stickers.',

                                                                    //   btnOkText:
                                                                    //       'Ok',
                                                                    //   btnOkColor:
                                                                    //       Theme.of(context)
                                                                    //           .primaryColor,
                                                                    //   btnOkOnPress:
                                                                    //       () {},
                                                                    // ).show();
                                                                  } else {
                                                                    BlocProvider.of<StickerCubit>(
                                                                            context)
                                                                        .userStickerOperations(
                                                                      imageUrl:
                                                                          sticker
                                                                              .imageLink,
                                                                      isOperationForAddingInEditor:
                                                                          true,
                                                                    );
                                                                    toast(tr(
                                                                        "sticker_added"));
                                                                  }
                                                                },
                                                                child: Stack(
                                                                  clipBehavior:
                                                                      Clip.none,
                                                                  alignment:
                                                                      Alignment
                                                                          .topRight,
                                                                  children: [
                                                                    Container(
                                                                      height:
                                                                          100,
                                                                      width:
                                                                          100,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: Colors
                                                                            .transparent,
                                                                        borderRadius:
                                                                            BorderRadius.circular(10),
                                                                      ),
                                                                      child:
                                                                          PremiumWrapper(
                                                                        isPremiumContent:
                                                                            sticker.isPremium ==
                                                                                true,
                                                                        isBottomCenter:
                                                                            true,
                                                                        child: Image
                                                                            .file(
                                                                          File(sticker
                                                                              .imageLink),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Positioned(
                                                                        top: 0,
                                                                        right:
                                                                            0,
                                                                        child:
                                                                            InkWell(
                                                                          onTap:
                                                                              () {
                                                                            // AwesomeDialog(
                                                                            //   context: context,
                                                                            //   showCloseIcon: true,
                                                                            //   dialogType: DialogType.warning,
                                                                            //   animType: AnimType.scale,
                                                                            //   title: tr("delete_warning"),
                                                                            //   btnOkText: 'Ok',
                                                                            //   btnCancelText: "Cancel",
                                                                            //   btnCancelOnPress: () {},
                                                                            //   btnOkColor: Theme.of(context).primaryColor,
                                                                            //   btnOkOnPress: () {
                                                                            //     BlocProvider.of<StickerCubit>(context).userStickerOperations(imageUrl: sticker.imageLink, isDelete: true);
                                                                            //   },
                                                                            // ).show();
                                                                          },
                                                                          child:
                                                                              Container(
                                                                            height:
                                                                                20,
                                                                            width:
                                                                                20,
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              border: Border.all(
                                                                                width: 1,
                                                                                color: const Color(0xFFF5F5F5),
                                                                              ),
                                                                              color: Colors.white,
                                                                              shape: BoxShape.circle,
                                                                            ),
                                                                            child:
                                                                                const Icon(
                                                                              color: Colors.black,
                                                                              Icons.close,
                                                                              size: 15,
                                                                            ),
                                                                          ),
                                                                        )),
                                                                  ],
                                                                ));
                                                          },
                                                          gridDelegate:
                                                              const SliverGridDelegateWithFixedCrossAxisCount(
                                                                  crossAxisCount:
                                                                      4,
                                                                  childAspectRatio:
                                                                      3 / 3,
                                                                  crossAxisSpacing:
                                                                      10,
                                                                  mainAxisSpacing:
                                                                      10),
                                                        ),
                                                      ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        ...state.stickerTopicList.map((e) {
                                          return SizedBox(
                                            height: 350,
                                            child: GridView.builder(
                                              itemCount: e.stickers.length,
                                              itemBuilder: (ctx, index) {
                                                final Sticker sticker =
                                                    e.stickers[index];
                                                return InkWell(
                                                    onTap: () {
                                                      bool isPremiumUser =
                                                          BlocProvider.of<
                                                                      UserCubit>(
                                                                  context)
                                                              .state
                                                              .isPremiumUser;
                                                      if (sticker.isPremium ==
                                                              1 &&
                                                          (isPremiumUser ==
                                                              false)) {
                                                        showPremiumCustomDialogue(
                                                            context: context,
                                                            title: tr(
                                                                "premium_warning",
                                                                namedArgs: {
                                                                  "title": tr(
                                                                      "sticker")
                                                                }),
                                                            image: sticker.path,
                                                            onTap: (() {
                                                              nextScreenWithFadeAnimation(
                                                                  context,
                                                                  const PremiumPlanScreen());
                                                            }),
                                                            mq: mq);
                                                      } else {
                                                        BlocProvider.of<
                                                                    StickerCubit>(
                                                                context)
                                                            .updateStateVariables(
                                                                hideCancelButton:
                                                                    false);

                                                        if (stickerCubit
                                                                    .state
                                                                    .stickerDList
                                                                    .length >=
                                                                2 &&
                                                            (isPremiumUser ==
                                                                false)) {
                                                          // AwesomeDialog(
                                                          //   context: context,
                                                          //   showCloseIcon: true,
                                                          //   dialogType:
                                                          //       DialogType
                                                          //           .infoReverse,
                                                          //   animType: AnimType
                                                          //       .bottomSlide, //awesome_dialog: ^2.1.1
                                                          //   title:
                                                          //       'You can use only 2 stickers',
                                                          //   btnOkText: 'Ok',
                                                          //   btnOkColor: Theme
                                                          //           .of(context)
                                                          //       .primaryColor,
                                                          // ).show();
                                                        } else {
                                                          BlocProvider.of<StickerCubit>(
                                                                  context)
                                                              .stickerOperation(
                                                                  isAddSticker:
                                                                      true,
                                                                  imageLink: e
                                                                      .stickers[
                                                                          index]
                                                                      .path,
                                                                  index: index);
                                                          toast(tr(
                                                              "sticker_added"));
                                                        }
                                                      }
                                                    },
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        color: e.stickers[index]
                                                                    .isPremium ==
                                                                1
                                                            ? Colors.orange
                                                                .withOpacity(
                                                                    0.3)
                                                            : Colors
                                                                .transparent,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      ),
                                                      child: PremiumWrapper(
                                                        isBottomCenter: true,
                                                        isPremiumContent: e
                                                                .stickers[index]
                                                                .isPremium ==
                                                            1,
                                                        child:
                                                            CachedNetworkImage(
                                                          imageUrl: e
                                                              .stickers[index]
                                                              .path,
                                                          imageBuilder: (context,
                                                              imageProvider) {
                                                            return Container(
                                                                decoration:
                                                                    BoxDecoration(
                                                                        image:
                                                                            DecorationImage(
                                                              image:
                                                                  imageProvider,
                                                              fit: BoxFit.fill,
                                                            )));
                                                          },
                                                          placeholder: (context,
                                                                  url) =>
                                                              const Center(
                                                                  child:
                                                                      CircularProgressIndicator()),
                                                          errorWidget: (context,
                                                                  url, error) =>
                                                              const Icon(
                                                                  Icons.error),
                                                        ),
                                                      ),
                                                    ));
                                              },
                                              gridDelegate:
                                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                                      crossAxisCount: 4,
                                                      childAspectRatio: 3 / 3,
                                                      crossAxisSpacing: 10,
                                                      mainAxisSpacing: 10),
                                            ),
                                          );
                                        }).toList()
                                      ]),
                          ),
                        ],
                      ),
                    ),
            ],
          );
        },
      ),
    );
  }

  Expanded _buildStickerLoadingWidget(Size mq) {
    return Expanded(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CShimmerContainer(height: 35, width: mq.width * 0.25),
              CShimmerContainer(height: 35, width: mq.width * 0.25),
              CShimmerContainer(height: 35, width: mq.width * 0.25),
            ],
          ),
          const SizedBox(height: 15),
          Expanded(
            child: GridView.builder(
              itemCount: 12,
              itemBuilder: (ctx, index) => CShimmerContainer(
                  height: mq.width * 0.25, width: mq.width * 0.25),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  childAspectRatio: 1,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10),
            ),
          ),
        ],
      ),
    );
  }
}
