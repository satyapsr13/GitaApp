import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; 

import '../../../Constants/colors.dart';
import '../../../Data/model/ObjectModels/post_widget_model.dart';
import '../../../Data/model/ObjectModels/saved_post_model.dart';
import '../../../Logic/Cubit/user_cubit/user_cubit.dart';
import '../../Widgets/post_widget.dart'; 

class SharedPostWidget extends StatelessWidget {
  const SharedPostWidget({
    Key? key,
    required this.mq,
  }) : super(key: key);

  final Size mq;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserState>(builder: (context, postState) {
      return postState.savedPostList.isEmpty
          ? const Center(
              child: TextButton(
                  onPressed: null,
                  child: Text('Please share some post',
                      style: TextStyle(
                        color: Colors.black,
                      ))))
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(children: [
                  SizedBox(
                    child: GridView.builder(
                      // reverse: true,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: postState.savedPostList.length,
                      itemBuilder: (ctx, index) {
                        final SavedPost savedPost =
                            postState.savedPostList[index];
                        return InkWell(
                          onTap: () {
                            PostWidgetModel postWidgetData = PostWidgetModel(
                                index: 1,
                                imageLink: savedPost.imageLink,
                                postId: savedPost.postId.toString(),
                                profilePos: "right",
                                profileShape: "round",
                                tagColor: "white",
                                playStoreBadgePos: "left",
                                showName: true,
                                showProfile: true);

                            showModalBottomSheet(
                                barrierColor: Colors.black26,
                                backgroundColor: Colors.transparent,
                                isScrollControlled: true,
                                context: context,
                                builder: (context) {
                                  return Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 32,
                                      vertical: 8,
                                    ),
                                    height: mq.height * 0.8,
                                    width: mq.width,
                                    decoration: const BoxDecoration(
                                      color: Colors.transparent,
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(24),
                                        topRight: Radius.circular(24),
                                      ),
                                    ),
                                    child: SingleChildScrollView(
                                      child: Stack(
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: Container(
                                              color: Colors.white,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    const SizedBox(height: 25),
                                                    PostWidget(
                                                      index: index,
                                                      postWidgetData:
                                                          postWidgetData.copyWith(
                                                              topTagPosition:
                                                                  "center-touched"),
                                                      centerShareEditButton:
                                                          true,
                                                      isModelFrame: true,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            top: 0,
                                            right: 0,
                                            child: IconButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                icon: const Icon(
                                                  Icons.close_sharp,
                                                  color: Color(0xff444444),
                                                  size: 30,
                                                )),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                });
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Stack(
                              children: [
                                CachedNetworkImage(
                                    imageUrl: savedPost.imageLink,
                                    fit: BoxFit.fill,
                                    progressIndicatorBuilder:
                                        (context, url, progress) {
                                      return progressIndicator(context);
                                    }),
                                Positioned(
                                  top: 0,
                                  right: 0,
                                  child: InkWell(
                                    onTap: () {
                                      AwesomeDialog(
                                        context: context,
                                        showCloseIcon: true,
                                        dialogType: DialogType.warning,
                                        animType: AnimType
                                            .scale, //awesome_dialog: ^2.1.1
                                        title: 'Delete Post',
                                        btnOkText: 'Delete',
                                        btnOkColor: Colors.red,
                                        btnOkOnPress: () {
                                          BlocProvider.of<UserCubit>(context)
                                              .savedPostDbOperations(
                                                  isDeleteOperation: true,
                                                  postLinkToDelete:
                                                      savedPost.imageLink);
                                        },
                                      ).show();
                                    },
                                    child: Container(
                                      width: 25,
                                      height: 25,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white,
                                      ),
                                      child: const Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                        size: 15,
                                      ),
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
                              crossAxisCount: 3,
                              childAspectRatio: 0.8,
                              crossAxisSpacing: 0,
                              mainAxisSpacing: 0),
                    ),
                  ),
                ]),
              ),
            );
    });
  }

  Center progressIndicator(BuildContext context) {
    return const Center(
        child: CircularProgressIndicator(
      color: AppColors.primaryColor,
    ));
  }
}
