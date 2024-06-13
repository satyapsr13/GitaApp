
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../Constants/colors.dart';
import '../../../../Constants/locations.dart';
import '../../../../Logic/Cubit/PostEditorCubit/post_editor_cubit.dart';
import '../../../../Logic/Cubit/Posts/posts_cubit.dart';
import '../../../../Logic/Cubit/user_cubit/user_cubit.dart'; 

class ImageTagForEditor extends StatefulWidget {
  final String profileShape;
  final bool? isAlswaysShow;
  final bool? isControlledFromSwitch;
  final Color? profileBoundryColor;
  final void Function()? onImageTap;
  // void Function(TapUpDetails)? getCordinate;
  ImageTagForEditor({
    Key? key,
    required this.profileShape,
    this.isAlswaysShow,
    this.isControlledFromSwitch,
    // this.getCordinate,
    this.profileBoundryColor,
    this.onImageTap,
  }) : super(key: key);

  @override
  State<ImageTagForEditor> createState() => _ImageTagForEditorState();
}

class _ImageTagForEditorState extends State<ImageTagForEditor> {
  double borderRadius11(String shape) {
    switch (shape) {
      case "round":
        return 500;
      case "semi-round":
        return 20;
      case "square":
        return 2;

      default:
        return 2;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostEditorCubit, PostEditorState>(
        builder: (context, postEditorState) {
      return BlocBuilder<PostCubit, PostState>(builder: (context, postState) {
        return Visibility(
          visible: widget.isControlledFromSwitch == true
              ? (postState.isProfileVisible)
              : ((widget.isAlswaysShow == true) ||
                  postEditorState.isProfileVisible),
          child: InkWell(
            onTap: widget.onImageTap,
            child: ClipRRect(
              borderRadius:
                  BorderRadius.circular(borderRadius11(widget.profileShape)),
              child:
                  BlocBuilder<UserCubit, UserState>(builder: (context, state) {
                return Container(
                  height: widget.isAlswaysShow == true
                      ? 75
                      : postEditorState.profileSize +
                          min(postEditorState.profileSize * 0.1, 10),
                  width: widget.isAlswaysShow == true
                      ? 75
                      : postEditorState.profileSize +
                          min(postEditorState.profileSize * 0.1, 10),
                  decoration: BoxDecoration(
                    color: widget.isAlswaysShow == true
                        ? widget.profileBoundryColor
                        : postEditorState.profileBoundryColor,
                  ),
                  child: Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(
                          borderRadius11(widget.profileShape)),
                      child: Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.rotationY(
                            postEditorState.currentFrame?.profile?.position ==
                                    "left"
                                ? pi
                                : 0),
                        child: Container(
                            height: widget.isAlswaysShow == true
                                ? 65
                                : postEditorState.profileSize,
                            width: widget.isAlswaysShow == true
                                ? 65
                                : postEditorState.profileSize,
                            decoration: BoxDecoration(
                              color: state.fileImagePath.isEmpty
                                  ? stringToColor["blue"]
                                  : Colors.transparent,
                            ),
                            child: state.fileImagePath.isEmpty
                                ? Image.asset(AppImages.addImageIcon,
                                    fit: BoxFit.cover)
                                : Image.file(File(state.fileImagePath),
                                    fit: BoxFit.cover)),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        );
      });
    });
  }
} 