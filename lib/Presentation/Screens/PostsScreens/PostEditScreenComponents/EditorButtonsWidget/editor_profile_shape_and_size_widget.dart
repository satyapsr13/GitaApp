// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart'; 
import '../../../../../Constants/constants.dart';
import '../../../../../Constants/enums.dart';
import '../../../../../Logic/Cubit/PostEditorCubit/post_editor_cubit.dart';
import '../../../../../Logic/Cubit/StickerCubit/sticker_cubit.dart';
import '../../../../Widgets/Buttons/circular_color.button.dart';
import '../../../../Widgets/model_bottom_sheet.dart';
import '../../post_edit_screen.dart';
import '../image_tag_for_editor.dart';

class EditorProfileShapeAndSizeWidget extends StatelessWidget {
  const EditorProfileShapeAndSizeWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: BlocBuilder<PostEditorCubit, PostEditorState>(
          builder: (context, postEditorState) {
        return Padding(
          padding: const EdgeInsets.only(left: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // const Spacer(flex: 10),
                  SizedBox(width: mq.width * 0.45),
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
                  const Spacer(flex: 5),
                  TextButton(
                    onPressed: () {
                      BlocProvider.of<PostEditorCubit>(context)
                          .updateStateVariables(
                        isProfileVisible: false,
                      );
                    },
                    child: const Text(
                      'Remove Profile Photo',
                      style: TextStyle(color: Colors.black, fontSize: 10),
                    ),
                  ),
                ],
              ),
              // const SizedBox(height: 5),
              Text(
                'Size',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Slider(
                  min: 40,
                  max: 300,
                  value: postEditorState.profileSize,
                  onChanged: (val) {
                    BlocProvider.of<PostEditorCubit>(context)
                        .updateStateVariables(profileSize: val);
                  }),

              Text(
                'Shape',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 15),
              SizedBox(
                height: 100,
                child: ListView.builder(
                  // shrinkWrap: true,
                  // physics: const NeverScrollableScrollPhysics(),
                  itemCount: 1,
                  itemBuilder: (ctx, index) {
                    // if (index >= Constants.colorListProfileBg.length) {
                    //   return const SizedBox(height: 50);
                    // }
                    // Color bgColor = Constants.colorListProfileBg[index];
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(
                          onTap: () {
                            BlocProvider.of<PostEditorCubit>(context)
                                .updateStateVariables(
                              // isAdvanceEditorMode: false,
                              isProfileVisible: true,
                              profileShape: "square",
                            );
                          },
                          child: 1 == 0
                              ? Container(
                                  height: 75,
                                  width: 75,
                                  decoration: BoxDecoration(
                                    color: Colors.grey,
                                    // borderRadius: BorderRadius.circular(20),
                                  ),
                                )
                              : ImageTagForEditor(
                                  profileShape: "square",
                                  isAlswaysShow: true,
                                  profileBoundryColor:
                                      postEditorState.profileBoundryColor,
                                ),
                        ),
                        InkWell(
                          onTap: () {
                            BlocProvider.of<PostEditorCubit>(context)
                                .updateStateVariables(
                              isProfileVisible: true,
                              profileShape: "semi-round",
                            );
                          },
                          child: 1 == 0
                              ? Container(
                                  height: 75,
                                  width: 75,
                                  decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                )
                              : ImageTagForEditor(
                                  profileShape: "semi-round",
                                  isAlswaysShow: true,
                                  profileBoundryColor:
                                      postEditorState.profileBoundryColor,
                                ),
                        ),
                        InkWell(
                          onTap: () {
                            BlocProvider.of<PostEditorCubit>(context)
                                .updateStateVariables(
                              isProfileVisible: true,
                              profileShape: "round",
                            );
                          },
                          child: 1 == 0
                              ? Container(
                                  height: 75,
                                  width: 75,
                                  decoration: BoxDecoration(
                                      color: Colors.grey,
                                      // borderRadius: BorderRadius.circular(20),
                                      shape: BoxShape.circle),
                                )
                              : ImageTagForEditor(
                                  profileShape: "round",
                                  isAlswaysShow: true,
                                  profileBoundryColor:
                                      postEditorState.profileBoundryColor,
                                ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              Text(
                'Color',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 15),
              SizedBox(
                height: 75,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    InkWell(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Pick a color!'),
                                content: SingleChildScrollView(
                                  child: HueRingPicker(
                                    portraitOnly: true,
                                    pickerColor: Colors.lightGreen,
                                    onColorChanged: (color) {
                                      BlocProvider.of<PostEditorCubit>(context)
                                          .updateStateVariables(
                                              isProfileVisible: true,
                                              profileBoundryColor: color);
                                    },
                                  ),
                                ),
                                actions: <Widget>[
                                  ElevatedButton(
                                    child: const Text('Ok'),
                                    onPressed: () {
                                      // setState(() => currentColor = pickerColor);
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: ColorWheel(),
                        )),
                    InkWell(
                      onTap: () {
                        BlocProvider.of<PostEditorCubit>(context)
                            .updateStateVariables(
                                isProfileVisible: true,
                                profileBoundryColor: Colors.transparent);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            // color: bgColor,
                            // borderRadius: BorderRadius.circular(20),
                            shape: BoxShape.circle,
                            border: Border.all(
                              width: 2,
                              color: Colors.white,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 1,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.block,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ),
                    ...List.generate(Constants.colorListProfileBg.length,
                        (index) {
                      Color bgColor = Constants.colorListProfileBg[index];
                      return InkWell(
                        onTap: () {
                          BlocProvider.of<PostEditorCubit>(context)
                              .updateStateVariables(
                                  isProfileVisible: true,
                                  profileBoundryColor: bgColor);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              color: bgColor,
                              // borderRadius: BorderRadius.circular(20),
                              shape: BoxShape.circle,
                              border: Border.all(
                                width: 2,
                                color: Colors.white,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 1,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
              SizedBox(height: 30),
            ],
          ),
        );
      }),
    );
  }
}
