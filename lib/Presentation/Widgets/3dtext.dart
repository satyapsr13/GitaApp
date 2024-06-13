// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:interactive_box/interactive_box.dart';
import 'package:zwidget/zwidget.dart';

import 'model_bottom_sheet.dart';

class ThreeDText extends StatefulWidget {
  const ThreeDText({super.key});

  @override
  State<ThreeDText> createState() => _ThreeDTextState();
}

class _ThreeDTextState extends State<ThreeDText> {
  double x = 50, y = 50;
  String text = "Rishteyy";
  int no = 1;
  TextEditingController tController = TextEditingController(text: "Satya");
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: 300,
      child: true
          ? InteractiveBox(
              onActionSelected: ((p0, p1) {
                if (p0 == ControlActionType.copy) {
                  showCBottomSheet(
                      context: context,
                      height: 200,
                      barrierColor: Colors.transparent,
                      child: Column(
                        children: [
                          Slider(
                              min: 0,
                              max: 200,
                              value: x,
                              onChanged: ((value) {
                                setState(() {
                                  x = value;
                                });
                              })),
                          Slider(
                              value: y,
                              min: 0,
                              max: 200,
                              onChanged: ((value) {
                                setState(() {
                                  y = value;
                                });
                              })),
                          TextFormField(
                            onChanged: (value) {
                              setState(() {
                                text = value;
                              });
                            },
                          ),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                no++;
                              });
                            },
                            child: Text(
                              'Add new text',
                              style: const TextStyle(
                                fontSize: 15,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ));
                }
              }),
              initialSize: Size(100, 100),
              child: ZWidget.builder(
                  // direction: ZD,
                  // debug:  ,
                  depth: 10,
                  layers: 4,
                  rotationX: 0,
                  rotationY: 0,
                  builder: (index) {
                    return Text(
                      text,
                      style: TextStyle(
                          color: Colors.amber.withGreen(index * 5),
                          fontSize: 75),
                    );
                  }),
            )
          : Stack(
              fit: StackFit.expand,
              children: [
                ...List.generate(
                  no,
                  (index) => InteractiveBox(
                    initialSize: Size(100, 100),
                    child: ZWidget.builder(
                        // direction: ZD,
                        // debug:  ,
                        depth: 10,
                        layers: 4,
                        rotationX: x * 0.1,
                        rotationY: y * 0.1,
                        builder: (index) {
                          return Text(
                            text,
                            style: TextStyle(
                                color: Colors.amber.withGreen(index * 5),
                                fontSize: 75),
                          );
                        }),
                  ),
                )
              ],
            ),
    );
  }
}
