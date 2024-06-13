import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../Constants/constants.dart';
import '../../../../Constants/enums.dart';
import '../../../../Logic/Cubit/PostEditorCubit/post_editor_cubit.dart';
import '../../../../Logic/Cubit/StickerCubit/sticker_cubit.dart';

class EditorDateTagWidget extends StatelessWidget {
  const EditorDateTagWidget({
    Key? key,
    this.isDisableTapping = false,
    this.isChangeBGImage = false,
    this.isDateEditable = false,
    this.getRandomDateBG = false,
    this.height = 40,
    this.width = 80,
    this.fontSize = 10,
    this.cImageUrl,
    this.dateColor,
  }) : super(key: key);
  final bool isDisableTapping;
  final bool isChangeBGImage;
  final bool getRandomDateBG;
  final bool isDateEditable;
  final double height;
  final double width;
  final double fontSize;
  final String? cImageUrl;
  final Color? dateColor;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostEditorCubit, PostEditorState>(
        builder: (context, state) {
      return InkWell(
        onTap: isDisableTapping == true
            ? null
            : () {
                if (isChangeBGImage == true) {
                  if (state.dateBGTagImage != cImageUrl) {
                    BlocProvider.of<PostEditorCubit>(context)
                        .updateStateVariables(
                            dateBGTagImage: cImageUrl, isDateTagVisible: true);
                  }
                } else {
                  BlocProvider.of<PostEditorCubit>(context)
                      .updateStateVariables(
                    datePosition: state.datePosition == DatePos.dragging
                        ? DatePos.topLeft
                        : DatePos.dragging,
                  );
                }

                BlocProvider.of<StickerCubit>(context)
                    .updateStateVariables(hideCancelButton: false);
              },
        child: Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            image: DecorationImage(
                opacity: 0.8,
                image: AssetImage(getRandomDateBG
                    ? "assets/images/banners/${Random().nextInt(6) + 1}.png"
                    : (cImageUrl ?? state.dateBGTagImage)),
                fit: BoxFit.contain),
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Container(
              color: Colors.transparent,
              height: height - 20,
              width: width - 30,
              child: Center(
                child: FittedBox(
                  child: Text(
                    DateFormat(isDateEditable ? state.dateFormate : "E,d MMM",
                            getLocale())
                        .format(isDateEditable
                            ? (state.editedDate ?? DateTime.now())
                            : DateTime.now()),
                    textScaleFactor: 1,
                    style: TextStyle(
                        color: dateColor ?? Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: fontSize),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
