 
import 'package:flutter/material.dart';

class DraggableWidget extends StatefulWidget {
  final Widget child;
  const DraggableWidget({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  _DraggableWidgetState createState() => _DraggableWidgetState();
}

class _DraggableWidgetState extends State<DraggableWidget> {
  double _scale = 1.0;
  Offset _offset = Offset(100, 100);
  Offset _initialFocalPoint = Offset.zero;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onScaleStart: (details) {
        _initialFocalPoint = details.focalPoint;
      },

      onScaleUpdate: (details) {
        setState(() {
          _scale = details.scale;
          _offset = details.focalPoint - _initialFocalPoint;
        });
      },
      child: Stack(
        children: [
          Transform(
            transform: Matrix4.identity()
              ..translate(_offset.dx, _offset.dy)
              ..scale(_scale),
            child: widget.child,
          ),
        ],
      ),
    );
  }
}
