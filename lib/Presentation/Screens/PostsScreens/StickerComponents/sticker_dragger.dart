// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';

class StickerDraggingWidget extends StatefulWidget {
  final Widget body;
  final bool? isDragEnable;
  final double? xPos;
  final double? yPos;
  final double? maxYPos;
  final void Function(double, double)? onDrag;
  const StickerDraggingWidget({
    Key? key,
    required this.body,
    this.isDragEnable,
    this.xPos,
    this.yPos,
    this.maxYPos,
    this.onDrag,
  }) : super(key: key);

  @override
  State<StickerDraggingWidget> createState() => _StickerDraggingWidgetState();
}

class _StickerDraggingWidgetState extends State<StickerDraggingWidget> {
  double xPos = 150;
  double yPos = 150;

  @override
  void didChangeDependencies() {
    xPos = widget.xPos ?? MediaQuery.of(context).size.width / 2;
    yPos = widget.yPos ?? MediaQuery.of(context).size.width / 2;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: xPos - 65,
      top: yPos - 65,
      child: Draggable(
          feedback: const SizedBox(),
          onDragUpdate: widget.isDragEnable == false
              ? null
              : (details) {
                  setState(() {
                    xPos = details.globalPosition.dx;
                    if (details.globalPosition.dy > 25) {
                      if (widget.maxYPos != null) {
                        if (details.globalPosition.dy < (widget.maxYPos!)) {
                          yPos = details.globalPosition.dy;
                        }
                      } else {
                        yPos = details.globalPosition.dy;
                      }
                    }
                    // print("------xPost $xPos yPos $yPos--maxYPos----${widget.maxYPos}---------------");
                  });
                  if (widget.onDrag != null) {
                    widget.onDrag!(xPos, yPos);
                  }
                },
          child: widget.body
          // ),
          ),
    );
  }
}
