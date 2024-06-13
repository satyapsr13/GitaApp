// ignore_for_file: prefer_const_constructors
import 'dart:math';

import 'package:flutter/material.dart';

import '../../Widgets/CustomClipper/custom_shape_clipper.dart'; 

class TestScreen extends StatelessWidget {
  // const TestScreen({super.key});
  List<String> occupationList = [
    "समाज सेवक",
    "शिक्षक",
    "डॉक्टर",
    "इंजीनियर",
    "वकील",
    "किसान",
    "नर्स",
    "पुलिस अधिकारी",
    "लेखाकार",
    "व्यापारी",
    "आईटी पेशेवर",
    "इलेक्ट्रीशियन",
  ];
  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          title: const Text('appbar'),
        ),
        body: 1 == 1
            ? ScaleWidget()
            : SingleChildScrollView(
                child: Column(
                  children: [
                    Wrap(
                      children: occupationList.map((e) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 15),
                          child: Stack(
                            clipBehavior: Clip.none,
                            alignment: Alignment.bottomCenter,
                            children: [
                              CircleAvatar(
                                radius: 50,
                                backgroundColor: Colors.amber,
                              ),
                              Positioned(
                                bottom: -15,
                                child: Container(
                                  height: 20,
                                  constraints: BoxConstraints(minWidth: 100),
                                  color: Colors.amber,
                                  // width: 45,
                                  child: Center(
                                    child: Text(
                                      ' $e  ',
                                      style: const TextStyle(),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Stack(
                        children: [
                          // Opacity(
                          //   //semi red clippath with more height and with 0.5 opacity
                          //   opacity: 0.5,
                          //   child: ClipPath(
                          //     clipper: WaveClipper(), //set our custom wave clipper
                          //     child: Container(
                          //       color: Colors.deepOrangeAccent,
                          //       height: 200,
                          //     ),
                          //   ),
                          // ),
                          ClipPath(
                            //upper clippath with less height
                            clipper: 1 == 1
                                ? StarClipper()
                                : CustomShapeClipper(
                                    borderRadius: 15,
                                    sides: 5), //set our custom wave clipper.
                            child: AnimatedContainer(
                                padding: EdgeInsets.only(bottom: 50),
                                color: Colors.red,
                                height: 175,
                                width: 175,
                                alignment: Alignment.center,
                                duration: Duration(seconds: 5),
                                child: Text(
                                  "Wave clipper",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                  ),
                                )),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ));
  }
}

class ScaleWidget extends StatefulWidget {
  @override
  _ScaleWidgetState createState() => _ScaleWidgetState();
}

class _ScaleWidgetState extends State<ScaleWidget> {
  double _scaleFactor = 1.0;
  double _rotationAngle = 0.0;
  Offset _startOffset = Offset.zero;
  Offset _currentOffset = Offset.zero;

  void _updateScale(double newScale) {
    setState(() {
      _scaleFactor = newScale;
    });
  }

  void _updateRotation(double newAngle) {
    setState(() {
      _rotationAngle = newAngle;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: (details) {
        _startOffset = details.localPosition;
      },
      onPanUpdate: (details) {
        _currentOffset = details.localPosition;
        double dx = _currentOffset.dx - _startOffset.dx;
        double dy = _currentOffset.dy - _startOffset.dy;
        double distance = dx * dx + dy * dy;
        double scaleDelta =
            distance / 10000; // Adjust this value to control scaling speed
        double newScale = _scaleFactor + (dx.isNegative ? -1 : 1) * scaleDelta;
        newScale =
            newScale.clamp(0.5, 2.0); // Limit scale factor between 0.5 and 2.0
        _updateScale(newScale);
      },
      child: Stack(
        children: [
          Center(
            child: Transform.rotate(
              angle: _rotationAngle,
              child: AnimatedContainer(
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                transform: Matrix4.identity()..scale(_scaleFactor),
                child: Container(
                  padding: EdgeInsets.all(20.0),
                  color: Colors.blue,
                  child: Text(
                    'Scale me!',
                    style: TextStyle(fontSize: 20.0, color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: GestureDetector(
              onPanUpdate: (details) {
                _currentOffset = details.localPosition;
                double dx = _currentOffset.dx - _startOffset.dx;
                double dy = _currentOffset.dy - _startOffset.dy;
                double distance = dx * dx + dy * dy;
                double scaleDelta = distance /
                    10000; // Adjust this value to control scaling speed
                double newScale =
                    _scaleFactor + (dx.isNegative ? -1 : 1) * scaleDelta;
                newScale = newScale.clamp(
                    0.5, 2.0); // Limit scale factor between 0.5 and 2.0
                _updateScale(newScale);
              },
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(25.0),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            child: GestureDetector(
              onPanUpdate: (details) {
                _currentOffset = details.localPosition;
                double dx = _currentOffset.dx - _startOffset.dx;
                double dy = _currentOffset.dy - _startOffset.dy;
                double angle = atan2(dy, dx);
                _updateRotation(angle);
              },
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(25.0),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
