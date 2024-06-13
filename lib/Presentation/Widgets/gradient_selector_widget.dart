import 'package:flutter/material.dart';

import '../../Constants/constants.dart';
import '../Screens/PostsScreens/post_edit_screen.dart'; 

class GradientSelectorWidget extends StatelessWidget {
  GradientSelectorWidget({
    Key? key,
    required this.mq,
  }) : super(key: key);

  final Size mq;
  final List<Gradient> _gradients = [
    Gradients.greenGradient,
    Gradients.redGradient,
    Gradients.blueGradient,
    Gradients.gradient1,
    Gradients.gradient4,
    Gradients.gradient2,
    Gradients.gradient3,
  ];
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: mq.width * 0.25,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: 1 == 1
            ? _gradients.map((e) {
                return GradientChangeBox(
                  isNavigateToPostEditScreen: true,
                  gradient: e,
                );
              }).toList()
            : const [
                GradientChangeBox(
                  gradient: Gradients.greenGradient,
                ),
                GradientChangeBox(
                  gradient: Gradients.redGradient,
                ),
                GradientChangeBox(
                  gradient: Gradients.blueGradient,
                ),
                GradientChangeBox(
                  gradient: Gradients.gradient1,
                ),
                GradientChangeBox(
                  gradient: Gradients.gradient4,
                ),
                GradientChangeBox(
                  gradient: Gradients.gradient2,
                ),
                GradientChangeBox(
                  gradient: Gradients.gradient3,
                ),
              ],
      ),
    );
  }
}
