import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; 
import '../../../../Constants/colors.dart';
import '../../../../Constants/constants.dart';
import '../../../../Constants/enums.dart';
import '../../../../Constants/locations.dart';
import '../../../../Logic/Cubit/PostEditorCubit/post_editor_cubit.dart';
import '../../../../Logic/Cubit/StickerCubit/sticker_cubit.dart';
import '../../../../Logic/Cubit/user_cubit/user_cubit.dart';
import '../../../../Utility/common.dart';
import 'editor_date_tag_widget.dart';
import 'image_tag_for_editor.dart';

class RishteyyTagForEditor extends StatelessWidget {
  final String tagColor;
  final String tagPosition;
  const RishteyyTagForEditor({
    Key? key,
    required this.tagColor,
    required this.tagPosition,
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
            borderRadius: rishteyTagStringToBorderRadius[tagPosition]),
        child: Padding(
          padding: const EdgeInsets.all(.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Image.asset(
                AppImages.playStore,
                height: 15,
                width: 15,
              ),
              SizedBox(
                height: 15,
                width: 40,
                child: FittedBox(
                  child: Text(
                    'Rishteyy App',
                    style: TextStyle(
                        color:
                            tagColor == "white" ? Colors.black : Colors.white,
                        fontSize: 8,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NameTagForEditor extends StatelessWidget {
  final String tagColor;
  final Size mq;
  final String name;
  final String profilePos;
  final double postSize;
  final Color textColor;
  const NameTagForEditor({
    Key? key,
    required this.tagColor,
    required this.textColor,
    required this.mq,
    required this.name,
    required this.profilePos,
    required this.postSize,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      width: postSize,
      decoration: BoxDecoration(
          color: stringToColor[tagColor],
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10),
          )),
      child: Row(
        children: [
          Visibility(
            visible: (profilePos.startsWith("left")),
            // visible: (profilePos.startsWith("left") == "left" || profilePos == "left-touched"),
            child: const Spacer(),
          ),
          const SizedBox(height: 5, width: 25),
          BlocBuilder<UserCubit, UserState>(builder: (context, state) {
            // log("---------------${state.editedName}----------------");
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  state.editedName.length > 25
                      ? "${state.editedName.substring(0, 25)}.."
                      : state.editedName,
                  maxLines: 1,
                  textScaleFactor: 1,
                  style: TextStyle(
                      color: textColor,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                ),
                BlocBuilder<PostEditorCubit, PostEditorState>(
                    builder: (context, postEditorState) {
                  return postEditorState.isNumberVisible
                      ? Visibility(
                          visible: postEditorState.isNumberVisible,
                          child: Text(
                            state.userNumber,
                            maxLines: 1,
                            textScaleFactor: 1,
                            style: TextStyle(
                                color: textColor,
                                fontSize: 10,
                                fontWeight: FontWeight.bold),
                          ),
                        )
                      : const SizedBox();
                })
              ],
            );
          }),
          const SizedBox(height: 5, width: 25),
          Visibility(
            visible: (profilePos.startsWith("right")),
            child: const Spacer(),
          ),
        ],
      ),
    );
  }
}

class ScaleAndStickerDraggingWidget extends StatefulWidget {
  final Widget body;
  const ScaleAndStickerDraggingWidget({
    Key? key,
    required this.body,
  }) : super(key: key);

  @override
  State<ScaleAndStickerDraggingWidget> createState() =>
      _ScaleAndStickerDraggingWidgetState();
}

class _ScaleAndStickerDraggingWidgetState
    extends State<ScaleAndStickerDraggingWidget> {
  double _scale = 1.0;
  Offset _position = const Offset(0.0, 0.0);
  Offset _startPosition = const Offset(0.0, 0.0);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onScaleStart: (details) {
        _startPosition = details.focalPoint - _position;
      },
      onScaleUpdate: (details) {
        setState(() {
          _scale = details.scale;
          _position = details.focalPoint - _startPosition;
        });
      },
      child: Transform(
          transform: Matrix4.identity()
            ..translate(_position.dx, _position.dy)
            ..scale(_scale),
          alignment: FractionalOffset.center,
          child: widget.body),
    );
  }
}

Container gradientMark() {
  return Container(
    height: 20,
    width: 60,
    decoration: BoxDecoration(
      gradient: Constants.linearGradient(),
      borderRadius: BorderRadius.circular(5),
    ),
  );
}

BoxDecoration topTagPosEditorBoxDecoration() {
  return BoxDecoration(
    borderRadius: BorderRadius.circular(10),
    color: Colors.grey.withOpacity(0.3),
  );
}

Widget bottomPositionMark(Size mq) {
  return Stack(
    clipBehavior: Clip.none,
    children: [
      BlocBuilder<PostEditorCubit, PostEditorState>(builder: (context, state) {
        return Container(
          height: 15,
          width: mq.width * 0.4,
          decoration: BoxDecoration(
            color: stringToColor[state.tagColor],
            // gradient: Constants.linearGradient(),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(30),
            ),
          ),
        );
      }),
    ],
  );
}

Widget bottomPositionMarkCenter(Size mq) {
  return BlocBuilder<PostEditorCubit, PostEditorState>(
      builder: (context, state) {
    return Container(
      height: 30,
      width: mq.width * 0.4,
      decoration: BoxDecoration(
        color: stringToColor[state.tagColor],
      ),
    );
  });
}

InkWell rishteyyTagPositionEditor(BuildContext context, Size mq) {
  return InkWell(
    onTap: () {
      BlocProvider.of<PostEditorCubit>(context).updateStateVariables(
          isDateTagVisible: true, datePosition: DatePos.dragging);
      BlocProvider.of<StickerCubit>(context)
          .updateStateVariables(editorWidgets: EditorWidgets.playStoreBadge);
    },
    child: Container(
      height: mq.height * 0.1,
      width: mq.width * 0.3,
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
            color: const Color(0xffD9D9D9),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Center(
            child:   EditorDateTagWidget(
                    isDisableTapping: true,
                    isDateEditable: true,
                  )
               
          ),
        ),
      ),
    ),
  );
}

InkWell profileShapeEditor(BuildContext context, Size mq) {
  return InkWell(
    onTap: () {
      // showCBottomSheet(
      //   context: context,
      //   height: mq.height * 0.4,
      //   child: const ProfileShapeAndSizeEditorWidget(),
      // );
      BlocProvider.of<PostEditorCubit>(context)
          .updateStateVariables(isAdvanceEditorMode: true);
      BlocProvider.of<StickerCubit>(context).updateStateVariables(
        editorWidgets: EditorWidgets.profileSizeAndShape,
      );
    },
    child: Container(
      height: mq.height * 0.1,
      width: mq.width * 0.3,
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
          child: Center(
            child: BlocBuilder<PostEditorCubit, PostEditorState>(
                builder: (context, state) {
              return ImageTagForEditor(
                  profileShape: state.profileShape,
                  isAlswaysShow: true,
                  profileBoundryColor: state.profileBoundryColor);
            }),
          ),
        ),
      ),
    ),
  );
}

Widget colorEditor(BuildContext context, Size mq) {
  return InkWell(
    onTap: () {
     
      BlocProvider.of<StickerCubit>(context)
          .updateStateVariables(editorWidgets: EditorWidgets.colorWidget);
    },
    child: Container(
      height: mq.height * 0.1,
      width: mq.width * 0.3,
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
        child: BlocBuilder<PostEditorCubit, PostEditorState>(
            builder: (context, state) {
          return Container(
            height: mq.height * 0.1,
            width: mq.width * 0.4,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                // color: stringToColor[state.tagColor],
                color: Colors.white),
            child: Center(
              child: Text(
                tr('color'),
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ),
          );
        }),
      ),
    ),
  );
}

InkWell openStickerModel(BuildContext context, Size mq) {
  return InkWell(
    onTap: () {
      // BlocProvider.of(context)
      BlocProvider.of<StickerCubit>(context)
          .updateStateVariables(editorWidgets: EditorWidgets.stickerWidget);
      // int stickerLen = BlocProvider.of<StickerCubit>(context, listen: false)
      //     .state
      //     .stickerTopicList
      //     .length;
      // showModalBottomSheet(
      //     barrierColor: Colors.black26,
      //     backgroundColor: Colors.transparent,
      //     isScrollControlled: true,
      //     context: context,
      //     builder: (context) {
      //       return StickerModelBottomSheet(
      //         stickerLen: stickerLen,
      //       );
      //     });
    },
    child: Container(
      height: mq.height * 0.1,
      width: mq.width * 0.3,
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
      child: BlocBuilder<PostEditorCubit, PostEditorState>(
          builder: (context, state) {
        return Column(
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: mq.height * 0.1 - 20,
              width: mq.width * 0.4,
              decoration: BoxDecoration(
                //  color:  Colors.red,
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: mq.width * 0.15 - 10,
                    child: Image.asset(
                      getRandormSticker(id: 3),
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(
                    width: mq.width * 0.15 - 10,
                    child: Image.asset(
                      getRandormSticker(
                          id: DateTime.now().hour > 13 ? 7 : 5), //7,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
              child: FittedBox(
                child: Text(
                  'Stickers',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const Spacer(),
          ],
        );
      }),
    ),
  );
}

InkWell circularColorPicker(String color, BuildContext context) {
  return InkWell(
    onTap: () {
      BlocProvider.of<PostEditorCubit>(context)
          .updateStateVariables(tagColor: color);
    },
    child: Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: CircleAvatar(
          radius: 30,
          backgroundColor: Colors.white,
          child: CircleAvatar(
            radius: 25,
            backgroundColor: stringToColor[color],
          ),
        ),
      ),
    ),
  );
}
