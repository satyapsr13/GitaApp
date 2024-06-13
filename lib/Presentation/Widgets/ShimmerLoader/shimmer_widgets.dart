import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CShimmerContainer extends StatelessWidget {
  final double height;
  final double width;
  final double borderRadius;

  const CShimmerContainer({
    required this.height,
    required this.width,
    this.borderRadius = 10.0,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Container(
            height: height,
            width: width,
            decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(borderRadius))));
  }
}

class CShimmerCircle extends StatelessWidget {
  // final double height;
  final double radius;

  const CShimmerCircle({
    // required this.height,
    this.radius = 10.0,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        height: radius,
        width: radius,
        decoration: const BoxDecoration(
            color: Colors.grey, // Base color for shimmer effect
            shape: BoxShape.circle),
      ),
    );
  }
}
