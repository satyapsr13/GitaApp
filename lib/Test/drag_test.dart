// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';

class DragTest extends StatefulWidget {
  const DragTest({super.key});

  @override
  State<DragTest> createState() => _DragTestState();
}

class _DragTestState extends State<DragTest> {
  double? dragx;
  double? dragy;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Scaffold(
          //     appBar: AppBar(
          //       title: const Text('appbar'),
          //     ),
          //     body: Column(
          //       children: [],
          //     )),
          Positioned(
            top: dragy,
            left: dragx,
            child: GestureDetector(
                onPanUpdate: ((details) {
                  setState(() {
                    dragx = details.globalPosition.dx-100;
                    dragy = details.globalPosition.dy-100;
                  });
                }),
                child: Container(
                  height: 200,
                  width: 200,
                   color:  Colors.red,
                )),
          )
        ],
      ),
    );
  }
}
