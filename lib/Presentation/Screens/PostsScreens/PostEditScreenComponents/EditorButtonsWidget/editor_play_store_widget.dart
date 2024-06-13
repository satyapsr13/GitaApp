import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../Constants/colors.dart';
import '../../../../../Constants/constants.dart';
import '../../../../../Constants/enums.dart';
import '../../../../../Logic/Cubit/PostEditorCubit/post_editor_cubit.dart';
import '../../../../../Logic/Cubit/StickerCubit/sticker_cubit.dart';
import '../editor_date_tag_widget.dart';
import '../post_edit_screen_components.dart';

class EditorPlayStoreWidget extends StatelessWidget {
  const EditorPlayStoreWidget({
    Key? key,
  }) : super(key: key);
  static const List<String> dateFormatList = [
    // "d",
    // "E",
    // "EEEE",
    // "LLL",
    // "LLLL",
    // // "M",
    // "Md",
    // "MEd",
    // "MMM",
    // "MMMd",
    "yMd",
    "yMMMd",
    "MMMEd",
    // "MMMM",
    // "MMMMd",
    "MMMMEEEEd",
    // "QQQ",
    // "QQQQ",
    // "y",
    // "yM",
    "yMEd",
    // "yMMM",
    "yMMMEd",
    // "yMMMM",
    // "yMMMMd",
    "yMMMMEEEEd",
    // "yQQQ",
    // "yQQQQ",
    // "H",
    // "Hm",
    // "Hms",
    // "j",
    // "jm",
    // "jms",
  ];

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
            bottomLeft: Radius.circular(0),
            bottomRight: Radius.circular(0),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5), // Shadow color
              spreadRadius: 1, // How far the shadow should spread
              blurRadius: 4, // Soften the shadow
              offset: const Offset(
                  0, -4), // Move the shadow vertically (negative value for top)
            ),
          ],
        ),
        // height: mq.height * 0.25,
        child: BlocBuilder<PostEditorCubit, PostEditorState>(
            builder: (context, postEditorState) {
          return Column(
            children: [
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(
                    flex: 10,
                  ),
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
                  const Spacer(
                    flex: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: TextButton(
                      onPressed: () {
                        BlocProvider.of<PostEditorCubit>(context)
                            .updateStateVariables(
                          // isRishteyyVisible: true,
                          isDateTagVisible: false,
                          datePosition: DatePos.topLeft,
                        );
                      },
                      child: Text(
                        tr("remove_date"),
                        style: const TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () async {
                      // showBottomSheet(context: context, builder: ((context) {}));
                      await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1500),
                        locale: tr("_a_") == "A"
                            ? const Locale("en")
                            : const Locale("hi"),
                        lastDate: DateTime(2050),
                        builder: (BuildContext context, Widget? child) {
                          return Theme(
                            data: ThemeData.light().copyWith(
                              colorScheme: const ColorScheme.light(
                                // Change background color here
                                surface: AppColors.primaryColor,
                                primary: AppColors.primaryColor,
                              ),
                            ),
                            child: child!,
                          );
                        },
                      ).then((value) {
                        if (value != null) {
                          BlocProvider.of<PostEditorCubit>(context)
                              .updateStateVariables(editedDate: value);
                        }
                      });
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.calendar_month_sharp,
                            color: AppColors.primaryColor),
                        Text(
                          'Change Date',
                          style: TextStyle(
                            color: AppColors.primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.transparent,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 0),
                      child: DropdownButton(
                        focusColor: Colors.white,
                        // value: _chosenValue,
                        //elevation: 5,
                        style: const TextStyle(color: Colors.white),
                        items: dateFormatList
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              DateFormat(value, getLocale()).format(
                                  postEditorState.editedDate ?? DateTime.now()),
                              style: const TextStyle(color: Colors.black),
                            ),
                          );
                        }).toList(),
                        hint: Text(
                          DateFormat(postEditorState.dateFormate, getLocale())
                              .format(
                                  postEditorState.editedDate ?? DateTime.now()),
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w500),
                        ),
                        onChanged: (value) {
                          BlocProvider.of<PostEditorCubit>(context)
                              .updateStateVariables(
                                  dateFormate: value.toString());
                        },
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                      onTap: () {
                        BlocProvider.of<PostEditorCubit>(context)
                            .updateStateVariables(
                          // isRishteyyVisible: true,
                          isDateTagVisible: true,
                          datePosition: DatePos.topLeft,
                        );
                      },
                      child: Container(
                        height: mq.width * 0.2,
                        width: mq.width * 0.4,
                        decoration: 1 == 1
                            ? BoxDecoration(
                                color: Theme.of(context)
                                    .backgroundColor, // Match the background color
                                borderRadius: BorderRadius.circular(15.0),
                                boxShadow: [
                                  // Inner shadow (top-right and bottom-left)
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.4),
                                    offset: const Offset(1.0, 1.0),
                                    blurRadius: 8.0,
                                  ),
                                  // Outer shadow (top-left and bottom-right)
                                  BoxShadow(
                                    color: Colors.white.withOpacity(0.7),
                                    offset: const Offset(-1.0, -1.0),
                                    blurRadius: 8.0,
                                  ),
                                ],
                              )
                            : topTagPosEditorBoxDecoration(),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: EditorDateTagWidget(
                                isDisableTapping: true,
                                isDateEditable: true,
                              ),
                            ),
                            Spacer(),
                          ],
                        ),
                      )),
                  InkWell(
                      onTap: () {
                        BlocProvider.of<PostEditorCubit>(context)
                            .updateStateVariables(
                          isDateTagVisible: true,
                          datePosition: DatePos.topRight,
                        );
                      },
                      child: Container(
                        height: mq.width * 0.2,
                        width: mq.width * 0.4,
                        decoration: 1 == 1
                            ? BoxDecoration(
                                color: Theme.of(context)
                                    .backgroundColor, // Match the background color
                                borderRadius: BorderRadius.circular(15.0),
                                boxShadow: [
                                  // Inner shadow (top-right and bottom-left)
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.4),
                                    offset: const Offset(1.0, 1.0),
                                    blurRadius: 8.0,
                                  ),
                                  // Outer shadow (top-left and bottom-right)
                                  BoxShadow(
                                    color: Colors.white.withOpacity(0.7),
                                    offset: const Offset(-1.0, -1.0),
                                    blurRadius: 8.0,
                                  ),
                                ],
                              )
                            : topTagPosEditorBoxDecoration(),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Spacer(),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: EditorDateTagWidget(
                                isDateEditable: true,
                                isDisableTapping: true,
                              ),
                            ),
                          ],
                        ),
                      )),
                ],
              ),
              Wrap(children: [
                Visibility(
                  visible: kDebugMode,
                  child: Padding(
                    padding: const EdgeInsets.all(7.0),
                    child: EditorDateTagWidget(
                      dateColor: Colors.white,
                      height: 60,
                      width: 140,
                      isDateEditable: true,
                      fontSize: 15,
                      isChangeBGImage: true,
                      cImageUrl: "assets/images/banners/test1.jpg",
                    ),
                  ),
                ),
                ...List.generate(6, (index) {
                  return Padding(
                    padding: const EdgeInsets.all(7.0),
                    child: EditorDateTagWidget(
                      height: 60,
                      width: 140,
                      isDateEditable: true,
                      fontSize: 15,
                      isChangeBGImage: true,
                      cImageUrl: "assets/images/banners/${index + 1}.png",
                    ),
                  );
                })
              ]),
              SizedBox(height: mq.height * 0.2),
            ],
          );
        }));
  }
}
