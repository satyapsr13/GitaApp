// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:gita/Logic/Cubit/PostEditorCubit/post_editor_cubit.dart';
import 'package:gita/Logic/Cubit/StickerCubit/sticker_cubit.dart';
import 'package:gita/Presentation/Screens/PostsScreens/PostEditScreenComponents/font_dropdown.widget.dart';
import 'package:gita/Presentation/Screens/PostsScreens/post_edit_screen.dart';
import 'package:logger/logger.dart';

import '../../../../../Constants/constants.dart';
import '../../../../Widgets/Buttons/circular_color.button.dart';

class EditorMultiperTextWidgets extends StatefulWidget {
  // const EditorMultiperTextWidgets({super.key});
  final String text;
  final TextStyle textStyle;
  final int mainIndex;
  final bool isEditorLocked;
  const EditorMultiperTextWidgets(
      {Key? key,
      required this.text,
      required this.textStyle,
      required this.mainIndex,
      this.isEditorLocked = false})
      : super(key: key);

  @override
  State<EditorMultiperTextWidgets> createState() =>
      _EditorMultiperTextWidgetsState();
}

class _EditorMultiperTextWidgetsState extends State<EditorMultiperTextWidgets> {
  Color? fontColor;
  Color? borderColor;
  double fontsize = 18;
  @override
  void initState() {
    setInitial();
    super.initState();
  }

  double angle = 0;
  TextAlign textAlign = TextAlign.start;
  setInitial() {
    if (widget.mainIndex % 3 == 0) {
      fontColor = Colors.black;
      borderColor = const Color(0xff4cd8be);
      fontsize = 18;
    } else if (widget.mainIndex % 3 == 1) {
      fontColor = const Color(0xff000516);
      borderColor = const Color(0xffc63cc0);
      fontsize = 23;
    } else {
      fontColor = Colors.red;
      borderColor = Colors.blue;
      fontsize = 28;
    }
  }

  int alignCount = 1;
  int currentFontIndex = 0;
  bool isShaderMaskText = true;
  int fwCounter = 1;
  FontWeight getFontWeight() {
    switch (fwCounter) {
      case 0:
        return FontWeight.w100;
      case 1:
        return FontWeight.normal;

      case 2:
        return FontWeight.w900;

      default:
        return FontWeight.normal;
    }
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    return BlocBuilder<StickerCubit, StickerState>(builder: (context, state) {
      return InkWell(
        onTap: state.lockEditor
            ? null
            : () async {
                await showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.transparent,
                  barrierColor: Colors.transparent,
                  isScrollControlled: true,
                  // constraints: BoxConstraints(minHeight: 300),
                  builder: (context) {
                    return StatefulBuilder(
                        builder: (BuildContext context, StateSetter setState1) {
                      return SingleChildScrollView(
                        child: Container(
                          padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom -
                                  (MediaQuery.of(context).viewInsets.bottom /
                                      5)),

                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(20),
                              topLeft: Radius.circular(20),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 1,
                                // offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          // height: height,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                child: Stack(
                                  children: [
                                    TextFormField(
                                      decoration: const InputDecoration(
                                          filled: true,
                                          fillColor:
                                              Color.fromARGB(10, 0, 0, 0),
                                          border: OutlineInputBorder()),
                                      // textAlign: textAlign,
                                      maxLines: 4,
                                      style: const TextStyle(fontSize: 15),
                                      initialValue: widget.text,
                                      onChanged: ((value) {
                                        BlocProvider.of<PostEditorCubit>(
                                                context)
                                            .customTextStylesOperations(
                                          index: widget.mainIndex,
                                          isEditOperation: true,
                                          text: value,
                                        );
                                      }),
                                    ),
                                    Positioned(
                                      top: 0,
                                      right: 0,
                                      child: IconButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          icon: const Icon(
                                            Icons.check,
                                            size: 20,
                                            color: Colors.green,
                                          )),
                                    ),
                                    Positioned(
                                      bottom: 0,
                                      right: 0,
                                      child: IconButton(
                                          onPressed: () {
                                            BlocProvider.of<PostEditorCubit>(
                                                    context)
                                                .customTextStylesOperations(
                                              index: widget.mainIndex,
                                              isDeleteOperation: true,
                                            );
                                            Navigator.pop(context);
                                          },
                                          icon: const Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                            size: 20,
                                          )),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 5),
                              SizedBox(
                                  height: 50,
                                  child: Row(
                                    // scrollDirection: Axis.horizontal,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Expanded(
                                          flex: 10,
                                          child: Container(
                                              padding: const EdgeInsets.only(
                                                  left: 15, right: 15),
                                              // height: 45,
                                              // decoration: BoxDecoration(
                                              //     borderRadius:
                                              //         BorderRadius.circular(5),
                                              //     border: Border.all(
                                              //       width: 1,
                                              //       color: Colors.black,
                                              //     )),
                                              child: Row(
                                                children: [
                                                  const Text(
                                                    'A',
                                                    style:
                                                        TextStyle(fontSize: 10),
                                                  ),
                                                  Expanded(
                                                    child: Slider(
                                                        value: fontsize,
                                                        min: 5,
                                                        max: 100,
                                                        onChanged: ((value) {
                                                          setState(() {
                                                            fontsize = value;
                                                          });
                                                          setState1(() {});
                                                        })),
                                                  ),
                                                  const Text(
                                                    'A',
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  )
                                                ],
                                              ))),
                                      InkWell(
                                        onTap: () {
                                          showDialog(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                    title: Row(
                                                      children: [
                                                        const Spacer(),
                                                        IconButton(
                                                            onPressed: () =>
                                                                Navigator.pop(
                                                                    context),
                                                            icon: const Icon(
                                                              Icons.cancel,
                                                              size: 30,
                                                              color:
                                                                  Colors.black,
                                                            )),
                                                      ],
                                                    ),
                                                    content: SizedBox(
                                                        width: mq.width * 0.7,
                                                        height: mq.height * 0.4,
                                                        child: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            CColorPicker(
                                                                onColorTap:
                                                                    (color) {
                                                              setState(() {
                                                                fontColor =
                                                                    color;
                                                              });
                                                              setState1(() {
                                                                fontColor =
                                                                    color;
                                                              });
                                                            })
                                                          ],
                                                        )),
                                                    actions: [
                                                      ElevatedButton(
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child: const Text(
                                                            'Ok',
                                                          ))
                                                    ],
                                                  ));
                                        },
                                        child: Container(
                                          // height: 45,

                                          margin: const EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              border: Border.all(
                                                width: 1,
                                                color: Colors.black,
                                              )),
                                          child: Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Container(
                                                  width: 15,
                                                  height: 15,
                                                  decoration: BoxDecoration(
                                                      color: fontColor,
                                                      border: Border.all(
                                                          width: 0.1,
                                                          color: Colors.black)),
                                                ),
                                                const Text(
                                                  '  Text ',
                                                  style: TextStyle(fontSize: 8),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              title: Row(
                                                children: [
                                                  const Spacer(),
                                                  IconButton(
                                                      onPressed: () =>
                                                          Navigator.pop(
                                                              context),
                                                      icon: const Icon(
                                                        Icons.cancel,
                                                        size: 30,
                                                        color: Colors.black,
                                                      )),
                                                ],
                                              ),
                                              content: SizedBox(
                                                width: mq.width * 0.7,
                                                height: mq.height * 0.4,
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    CColorPicker(
                                                      isTransparentButton: true,
                                                      onColorTap: (color) {
                                                        setState(() {
                                                          borderColor = color;
                                                        });
                                                        setState1(() {
                                                          borderColor = color;
                                                        });
                                                      },
                                                    )
                                                  ],
                                                ),
                                              ),
                                              actions: [
                                                ElevatedButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text(
                                                    'Ok',
                                                  ),
                                                )
                                              ],
                                            ),
                                          );
                                        },
                                        child: Container(
                                          // height: 50,
                                          margin: const EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              border: Border.all(
                                                width: 1,
                                                color: Colors.black,
                                              )),
                                          child: Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Container(
                                                  width: 15,
                                                  height: 15,
                                                  decoration: BoxDecoration(
                                                      color: borderColor,
                                                      border: Border.all(
                                                          width: 0.1,
                                                          color: Colors.black)),
                                                ),
                                                const Text(
                                                  'Stroke ',
                                                  style: TextStyle(fontSize: 8),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 15),
                                    ],
                                  )),

                              const SizedBox(height: 10),
                              // _colorBand(context, setState),
                              SizedBox(
                                height: 50,
                                // width: 50,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: 50,
                                      width: 50,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          border: Border.all(
                                            width: 1,
                                            color: Colors.black,
                                          )),
                                      child: IconButton(
                                          onPressed: () {
                                            alignCount++;
                                            if (alignCount % 3 == 0) {
                                              setState(() {
                                                textAlign = TextAlign.start;
                                              });
                                              setState1(() {});
                                            } else if (alignCount % 3 == 1) {
                                              setState(() {
                                                textAlign = TextAlign.center;
                                              });
                                              setState1(() {});
                                            } else {
                                              setState(() {
                                                textAlign = TextAlign.end;
                                              });
                                              setState1(() {});
                                            }
                                          },
                                          icon: Icon(
                                            (alignCount % 3 == 0)
                                                ? Icons.format_align_left
                                                : (alignCount % 3 == 1)
                                                    ? Icons.format_align_center
                                                    : Icons.format_align_right,
                                            size: 20,
                                          )),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        fwCounter++;
                                        if (fwCounter > 2) {
                                          fwCounter = 0;
                                        }
                                        setState(() {});
                                        setState1(() {});
                                      },
                                      child: Container(
                                          height: 50,
                                          width: 50,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              border: Border.all(
                                                width: 1,
                                                color: Colors.black,
                                              )),
                                          child: Center(
                                            child: Text(
                                              'B',
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.black,
                                                  fontWeight: getFontWeight()),
                                            ),
                                          )),
                                    ),
                                    FontDropdownWidget(
                                      isDense: false,
                                      width: mq.width * 0.5,
                                      onChange: ((p0) {
                                        // setState(() {
                                        setState(() {
                                          currentFontIndex = p0;
                                        });
                                        // });
                                      }),
                                    )
                                  ],
                                ),
                              ),

                              const SizedBox(height: 5),
                              // SizedBox(
                              //   height: 25,
                              //   child: ListView(
                              //       scrollDirection: Axis.horizontal,
                              //       children: [
                              //         ...List.generate(
                              //             BlocProvider.of<StickerCubit>(context)
                              //                 .state
                              //                 .tagListFromBackend
                              //                 .length, (index) {
                              //           String text =
                              //               BlocProvider.of<StickerCubit>(context)
                              //                   .state
                              //                   .tagListFromBackend[index];
                              //           return Padding(
                              //             padding: const EdgeInsets.all(4.0),
                              //             child: InkWell(
                              //               onTap: () {
                              //                 setState(() {
                              //                   widget.text = text;
                              //                 });
                              //               },
                              //               child: Container(
                              //                 height: 14,
                              //                 child: Text(
                              //                   text,
                              //                   style: const TextStyle(),
                              //                 ),
                              //                 decoration: BoxDecoration(
                              //                   border: Border.all(
                              //                       width: 1,
                              //                       color:
                              //                           AppColors.primaryColor),
                              //                 ),
                              //               ),
                              //             ),
                              //           );
                              //         })
                              //       ]),
                              // ),
                              const SizedBox(height: 15),
                            ],
                          ),
                        ),
                      );
                    });
                  },
                );
              },
        child: Visibility(
            visible: !state.lockEditor,
            replacement: CStrokeText(
              textAlign: textAlign,
              text: widget.text,
              textColor: fontColor ?? Colors.white,
              strokeColor: borderColor ?? Colors.black,
              strokeWidth: 5,
              textStyle: Constants.googleFontStyles[currentFontIndex].copyWith(
                color: fontColor,
                fontSize: fontsize,
                fontWeight: getFontWeight(),
              ),
            ),
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.topRight,
              children: [
                CStrokeText(
                  textAlign: textAlign,
                  text: widget.text,
                  textColor: fontColor ?? Colors.white,
                  strokeColor: borderColor ?? Colors.black,
                  strokeWidth: 5,
                  textStyle:
                      Constants.googleFontStyles[currentFontIndex].copyWith(
                    color: fontColor,
                    fontSize: fontsize,
                    fontWeight: getFontWeight(),
                  ),
                ),
                Positioned(
                  top: -8,
                  right: -8,
                  child: Container(
                    width: 18,
                    height: 18,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.edit,
                        size: 12,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            )),
      );
    });
  }

  SizedBox _colorBand(BuildContext context, StateSetter setState1) {
    return SizedBox(
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
                            setState(() {
                              fontColor = color;
                              Logger().i(color);
                            });
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
          ...List.generate(Constants.colorListProfileBg.length, (index) {
            Color bgColor = Constants.colorListProfileBg[index];
            return InkWell(
              onTap: () {
                setState(() {
                  fontColor = bgColor;
                });
                setState1(() {
                  fontColor = bgColor;
                });
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
    );
  }

  Shadow generateShadows(
      {required double xOffset,
      required double yOffset,
      required double blur,
      required Color color}) {
    return Shadow(
      offset: Offset(xOffset, yOffset),
      blurRadius: blur,
      color: color.withOpacity(0.5),
    );
  }
}

class CircularWidget extends StatefulWidget {
  final Function(double angle) onAngleChanged;

  const CircularWidget({Key? key, required this.onAngleChanged})
      : super(key: key);

  @override
  _CircularWidgetState createState() => _CircularWidgetState();
}

class _CircularWidgetState extends State<CircularWidget> {
  double _angle = 0.0;

  void _updateAngle(Offset offset) {
    double angle = atan2(offset.dy, offset.dx);
    setState(() {
      _angle = angle;
    });
    widget.onAngleChanged(angle);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) {
        Offset offset = details.localPosition;
        _updateAngle(offset);
      },
      child: Container(
        width: 200,
        height: 200,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.black),
        ),
        child: Stack(
          children: [
            Positioned(
              left: 100 + 80 * cos(_angle),
              top: 100 + 80 * sin(_angle),
              child: GestureDetector(
                onPanUpdate: (details) {
                  Offset offset =
                      details.localPosition - const Offset(100, 100);
                  _updateAngle(offset);
                },
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blue,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CStrokeText extends StatelessWidget {
  final String text;
  final double strokeWidth;
  final Color textColor;
  final Color strokeColor;
  final TextStyle? textStyle;
  final TextAlign textAlign;

  const CStrokeText(
      {Key? key,
      required this.text,
      this.strokeWidth = 1,
      this.strokeColor = Colors.black,
      this.textColor = Colors.white,
      this.textAlign = TextAlign.center,
      this.textStyle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Text(
          text,
          textAlign: textAlign,
          style: TextStyle(
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = strokeWidth
              ..color = strokeColor,
          ).merge(textStyle),
        ),
        Text(
          text,
          textAlign: textAlign,
          style: TextStyle(color: textColor).merge(textStyle),
        ),
      ],
    );
  }
}
