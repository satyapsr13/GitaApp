import 'package:flutter/material.dart';

class DottedBorder extends StatelessWidget {
  final Widget child;
  final Color color;
  final double strokeWidth;
  final double radius;

  DottedBorder({
    required this.child,
    this.color = Colors.black,
    this.strokeWidth = 1.0,
    this.radius = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: DottedBorderPainter(
          color: color, strokeWidth: strokeWidth, radius: radius),
      child: child,
    );
  }
}

class DottedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double radius;

  DottedBorderPainter({
    required this.color,
    required this.strokeWidth,
    required this.radius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final double space = 4.0;
    final Path path = Path();

    for (double i = 0; i < size.width; i += space * 2) {
      path.moveTo(i, 0);
      path.lineTo(i + space, 0);
    }

    for (double i = 0; i < size.height; i += space * 2) {
      path.moveTo(0, i);
      path.lineTo(0, i + space);
    }

    for (double i = size.width; i > 0; i -= space * 2) {
      path.moveTo(i, size.height);
      path.lineTo(i - space, size.height);
    }

    for (double i = size.height; i > 0; i -= space * 2) {
      path.moveTo(size.width, i);
      path.lineTo(size.width, i - space);
    }

    if (radius > 0) {
      path.addRRect(RRect.fromRectAndRadius(
          Rect.fromPoints(Offset(0, 0), Offset(size.width, size.height)),
          Radius.circular(radius)));
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

// void main() {
//   runApp(
//     MaterialApp(
//       home: Scaffold(
//         body: Center(
//           child: DottedBorder(
//             child: Container(
//               width: 200,
//               height: 100,
//               color: Colors.blue,
//             ),
//           ),
//         ),
//       ),
//     ),
//   );
// }

// import 'package:flutter/material.dart';

// class ResizableDottedBorder extends StatelessWidget {
//   final Widget child;
//   final Color color;
//   final double strokeWidth;
//   final double radius;

//   ResizableDottedBorder({
//     required this.child,
//     this.color = Colors.black,
//     this.strokeWidth = 1.0,
//     this.radius = 0.0,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         CustomPaint(
//           painter: DottedBorderPainter(
//               color: color, strokeWidth: strokeWidth, radius: radius),
//           child: child,
//         ),
//         Positioned(
//             top: 0, left: 0, child: ResizeButton(onPressed: () {})), // Top-left
//         Positioned(
//             top: 0,
//             right: 0,
//             child: ResizeButton(onPressed: () {})), // Top-right
//         Positioned(
//             bottom: 0,
//             left: 0,
//             child: ResizeButton(onPressed: () {})), // Bottom-left
//         Positioned(
//             bottom: 0,
//             right: 0,
//             child: ResizeButton(onPressed: () {})), // Bottom-right
//       ],
//     );
//   }
// }

// class DottedBorderPainter extends CustomPainter {
//   final Color color;
//   final double strokeWidth;
//   final double radius;

//   DottedBorderPainter({
//     required this.color,
//     required this.strokeWidth,
//     required this.radius,
//   });

//   @override
//   void paint(Canvas canvas, Size size) {
//     final Paint paint = Paint()
//       ..color = color
//       ..strokeWidth = strokeWidth
//       ..style = PaintingStyle.stroke;

//     final double space = 4.0;
//     final Path path = Path();

//     for (double i = 0; i < size.width; i += space * 2) {
//       path.moveTo(i, 0);
//       path.lineTo(i + space, 0);
//     }

//     for (double i = 0; i < size.height; i += space * 2) {
//       path.moveTo(0, i);
//       path.lineTo(0, i + space);
//     }

//     for (double i = size.width; i > 0; i -= space * 2) {
//       path.moveTo(i, size.height);
//       path.lineTo(i - space, size.height);
//     }

//     for (double i = size.height; i > 0; i -= space * 2) {
//       path.moveTo(size.width, i);
//       path.lineTo(size.width, i - space);
//     }

//     if (radius > 0) {
//       path.addRRect(RRect.fromRectAndRadius(
//           Rect.fromPoints(Offset(0, 0), Offset(size.width, size.height)),
//           Radius.circular(radius)));
//     }

//     canvas.drawPath(path, paint);
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) {
//     return false;
//   }
// }

// class ResizeButton extends StatelessWidget {
//   final VoidCallback onPressed;

//   ResizeButton({required this.onPressed});

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onPressed,
//       child: Container(
//         width: 16,
//         height: 16,
//         decoration: BoxDecoration(
//           color: Colors.blue,
//           borderRadius: BorderRadius.circular(8),
//         ),
//         child: Icon(
//           Icons.aspect_ratio,
//           color: Colors.white,
//         ),
//       ),
//     );
//   }
// }
