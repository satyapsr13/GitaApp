// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../Logic/Cubit/PostEditorCubit/post_editor_cubit.dart';
import '../../../Logic/Cubit/StickerCubit/sticker_cubit.dart';
import '../PostsScreens/PostEditScreenComponents/dotted_border.widget.dart';
import '../PostsScreens/StickerComponents/sticker_dragger.dart';

class EditWrapper extends StatefulWidget {
  // const EditWrapper({super.key});
  final Widget body;
  const EditWrapper({
    Key? key,
    required this.body,
  }) : super(key: key);

  @override
  State<EditWrapper> createState() => _EditWrapperState();
}

class _EditWrapperState extends State<EditWrapper> {
  double scale = 1;
  double rotateAngle = 0;
  Offset startingRotationPoint = Offset.zero;
  double startingRotationAngle = 0.0;
  double currentRotationAngle = 0.0;
  bool isActive = true;
  double xPos = 150;
  double yPos = 150;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: xPos,
      top: yPos,
      child: Transform.scale(
        scale: max(scale, 0.5),
        child: Transform.rotate(
          angle: currentRotationAngle,
          child: BlocBuilder<StickerCubit, StickerState>(
              builder: (context, stickerState) {
            return BlocBuilder<PostEditorCubit, PostEditorState>(
                builder: (context, state) {
              return stickerState.lockEditor
                  ? widget.body
                  : Stack(
                      clipBehavior: Clip.none,
                      children: [
                        1 == 1
                            ? DottedBorder(
                                child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: StickerDraggingWidget(body: widget.body),
                              ))
                            : GestureDetector(
                                // feedback: SizedBox(),
                                onPanUpdate: (details) {
                                  setState(() {
                                    xPos = details.globalPosition.dx;
                                    if (details.globalPosition.dy > 25) {
                                      yPos = details.globalPosition.dy;
                                      // if (widget.maxYPos != null) {
                                      //   if (details.globalPosition.dy < (widget.maxYPos!)) {
                                      //   }
                                      // } else {
                                      //   yPos = details.globalPosition.dy;
                                      // }
                                    }
                                    // print("------xPost $xPos yPos $yPos--maxYPos----${widget.maxYPos}---------------");
                                  });
                                },
                                child: DottedBorder(
                                    child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child:
                                      StickerDraggingWidget(body: widget.body),
                                )),
                              ),
                        Positioned(
                          right: -5,
                          bottom: -5,
                          child: GestureDetector(
                            onPanUpdate: (details) {
                              setState(() {
                                // Update scale based on vertical drag
                                // scale += details.delta.dy / 100;
                                // Update rotation based on horizontal drag
                                currentRotationAngle = startingRotationAngle +
                                    details.localPosition.direction -
                                    startingRotationPoint.direction;
                                scale += details.delta.dy / 100;
                              });
                            },
                            child: Container(
                              color: Colors.white,
                              height: 25,
                              width: 25,
                              child: const Icon(
                                Icons.zoom_out_map,
                                size: 20,
                              ),
                            ),
                          ),
                        )
                      ],
                    );
            });
          }),
        ),
      ),
    );
  }
}
