// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class DraggerWidget extends StatefulWidget {
  final Widget body;
  final bool? isDragEnable;
  final double? xPos;
  final double? yPos;
  final double? maxYPos;
  final double centerX;
  final double centerY;
  final void Function(double, double)? onDrag;
  const DraggerWidget({
    Key? key,
    required this.body,
    this.isDragEnable,
    this.xPos,
    this.yPos,
    this.maxYPos,
    this.onDrag,
    this.centerX = 0,
    this.centerY = 0,
  }) : super(key: key);

  @override
  State<DraggerWidget> createState() => _DraggerWidgetState();
}

class _DraggerWidgetState extends State<DraggerWidget> {
  double xPos = 150;
  double yPos = 150;

  @override
  void didChangeDependencies() {
    xPos = widget.xPos ?? MediaQuery.of(context).size.width / 2;
    yPos = widget.yPos ?? MediaQuery.of(context).size.width / 2;
    super.didChangeDependencies();
  }

  bool isDragging = false;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: xPos - 65,
      top: yPos - 65,
      child: Draggable(
          feedback: const SizedBox(),
          onDragStarted: () {
            setState(() {
              isDragging = true;
            });
          },
          onDragEnd: (details) {
            setState(() {
              isDragging = false;
            });
          },
          onDragUpdate: widget.isDragEnable == false
              ? null
              : (details) {
                  Logger().i(
                      "--------${details.localPosition.dx}--------${details.globalPosition.dx}------------");
                  setState(() {
                    xPos = (details.localPosition.dx - widget.centerX);
                    if (details.localPosition.dy > 25) {
                      if (widget.maxYPos != null) {
                        if (details.localPosition.dy < (widget.maxYPos!)) {
                          yPos = (details.localPosition.dy - widget.centerY);
                        }
                      } else {
                        yPos = (details.localPosition.dy - widget.centerY);
                      }
                    }
                    // print("------xPost $xPos yPos $yPos--maxYPos----${widget.maxYPos}---------------");
                  });
                },
          child: widget.body
          // ),
          ),
    );
  }
}
