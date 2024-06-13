 
import 'package:flutter/material.dart';
class BottomAnimationWrapper extends StatefulWidget {
  final Duration duration;
  final Widget child;

  BottomAnimationWrapper({
    required this.duration,
    required this.child,
  });

  @override
  _BottomAnimationWrapperState createState() => _BottomAnimationWrapperState();
}

class _BottomAnimationWrapperState extends State<BottomAnimationWrapper>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);
    _animation = Tween<double>(begin: 1, end: 0).animate(_controller);

    // Start the animation when the widget is first built
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: Tween<Offset>(begin: Offset(0, 1), end: Offset.zero)
          .animate(_controller),
      child: widget.child,
    );
  }
}
