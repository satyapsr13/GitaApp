
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; 

import '../../../../../Constants/enums.dart';
import '../../../../../Constants/locations.dart';
import '../../../../../Logic/Cubit/PostEditorCubit/post_editor_cubit.dart';
import '../../../../../Logic/Cubit/StickerCubit/sticker_cubit.dart';
import '../../../../../Logic/Cubit/user_cubit/user_cubit.dart';
import '../post_edit_screen_components.dart';

class EditorProfilePositionEditor extends StatelessWidget {
  const EditorProfilePositionEditor({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: BlocBuilder<PostEditorCubit, PostEditorState>(
          builder: (context, postEditorState) {
        return BlocBuilder<UserCubit, UserState>(builder: (context, state) {
          return Column(
            children: [
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                      onPressed: () {
                        BlocProvider.of<StickerCubit>(context)
                            .updateStateVariables(
                                editorWidgets: EditorWidgets.none);
                      },
                      icon: const Icon(
                        Icons.close,
                        size: 30,
                      )),
                ],
              ),
              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: () {
                      BlocProvider.of<PostEditorCubit>(context)
                          .updateStateVariables(
                              isAdvanceEditorMode: false,
                              profilePos: "left",
                              currentFrame: postEditorState.currentFrame
                                  ?.copyWith(
                                      profile: postEditorState
                                          .currentFrame?.profile
                                          ?.copyWith(position: "left")));
                    },
                    child: Container(
                      height: mq.height * 0.1,
                      width: mq.width * 0.4,
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
                              color: const Color(0xffD9D9D9),
                            ),
                            child: Stack(
                              clipBehavior: Clip.hardEdge,
                              children: [
                                Positioned(
                                    bottom: 0, child: bottomPositionMark(mq)),
                                Positioned(
                                  bottom: 0,
                                  left: 0,
                                  child: CircleAvatar(
                                    radius: 25,
                                    backgroundImage: state.fileImagePath.isEmpty
                                        ? const AssetImage(
                                                AppImages.addImageIcon)
                                            as ImageProvider
                                        : FileImage(File(state.fileImagePath)),
                                    // backgroundColor: Colors.white,
                                  ),
                                ),
                              ],
                            )),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      BlocProvider.of<PostEditorCubit>(context)
                          .updateStateVariables(
                              isAdvanceEditorMode: false,
                              profilePos: "right",
                              currentFrame: postEditorState.currentFrame
                                  ?.copyWith(
                                      profile: postEditorState
                                          .currentFrame?.profile
                                          ?.copyWith(position: "right")));
                    },
                    child: Container(
                      height: mq.height * 0.1,
                      width: mq.width * 0.4,
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
                              color: const Color(0xffD9D9D9),
                            ),
                            child: Stack(
                              clipBehavior: Clip.hardEdge,
                              children: [
                                Positioned(
                                    bottom: 0, child: bottomPositionMark(mq)),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: CircleAvatar(
                                    radius: 25,
                                    backgroundImage: state.fileImagePath.isEmpty
                                        ? const AssetImage(
                                                AppImages.addImageIcon)
                                            as ImageProvider
                                        : FileImage(File(state.fileImagePath)),
                                    // backgroundColor: Colors.white,
                                  ),
                                ),
                              ],
                            )),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //   children: [
              //     InkWell(
              //       onTap: () {
              //         BlocProvider.of<PostEditorCubit>(context)
              //             .updateStateVariables(
              //                 isAdvanceEditorMode: false,
              //                 profilePos: "left-touched");
              //       },
              //       child: Container(
              //         height: mq.height * 0.1,
              //         width: mq.width * 0.4,
              //         decoration: BoxDecoration(
              //           borderRadius: BorderRadius.circular(20),
              //           color: Colors.white,
              //           boxShadow: [
              //             BoxShadow(
              //               color: Colors.grey.withOpacity(0.5),
              //               spreadRadius: 5,
              //               blurRadius: 7,
              //               offset: const Offset(0, 3),
              //             )
              //           ],
              //         ),
              //         child: Padding(
              //           padding: const EdgeInsets.all(3.0),
              //           child: Container(
              //               height: mq.height * 0.1,
              //               width: mq.width * 0.4,
              //               decoration: BoxDecoration(
              //                 borderRadius: BorderRadius.circular(20),
              //                 color: const Color(0xffD9D9D9),
              //               ),
              //               child: Stack(
              //                 clipBehavior: Clip.hardEdge,
              //                 children: [
              //                   Positioned(
              //                       bottom: 10,
              //                       child: bottomPositionMarkCenter(mq)),
              //                   Positioned(
              //                     bottom: 0,
              //                     left: 0,
              //                     child: CircleAvatar(
              //                       radius: 25,
              //                       backgroundImage: state.fileImagePath.isEmpty
              //                           ? const AssetImage(AppImages.addImageIcon)
              //                               as ImageProvider
              //                           : FileImage(File(state.fileImagePath)),
              //                     ),
              //                   ),
              //                 ],
              //               )),
              //         ),
              //       ),
              //     ),
              //     InkWell(
              //       onTap: () {
              //         BlocProvider.of<PostEditorCubit>(context)
              //             .updateStateVariables(
              //                 isAdvanceEditorMode: false,
              //                 profilePos: "right-touched");
              //       },
              //       child: Container(
              //         height: mq.height * 0.1,
              //         width: mq.width * 0.4,
              //         decoration: BoxDecoration(
              //           borderRadius: BorderRadius.circular(20),
              //           color: Colors.white,
              //           boxShadow: [
              //             BoxShadow(
              //               color: Colors.grey.withOpacity(0.5),
              //               spreadRadius: 5,
              //               blurRadius: 7,
              //               offset: const Offset(0, 3),
              //             ),
              //           ],
              //         ),
              //         child: Padding(
              //           padding: const EdgeInsets.all(3.0),
              //           child: Container(
              //               height: mq.height * 0.1,
              //               width: mq.width * 0.4,
              //               decoration: BoxDecoration(
              //                 borderRadius: BorderRadius.circular(20),
              //                 color: const Color(0xffD9D9D9),
              //               ),
              //               child: Stack(
              //                 children: [
              //                   Positioned(
              //                       bottom: 10,
              //                       child: bottomPositionMarkCenter(mq)),
              //                   Positioned(
              //                     bottom: 0,
              //                     right: 0,
              //                     child: CircleAvatar(
              //                       radius: 25,
              //                       backgroundImage: state.fileImagePath.isEmpty
              //                           ? const AssetImage(AppImages.addImageIcon)
              //                               as ImageProvider
              //                           : FileImage(File(state.fileImagePath)),
              //                       // backgroundColor: Colors.white,
              //                     ),
              //                   ),
              //                 ],
              //               )),
              //         ),
              //       ),
              //     ),
              //   ],
              // ),
              SizedBox(height: mq.height * 0.1),
            ],
          );
        });
      }),
    );
  }
}
