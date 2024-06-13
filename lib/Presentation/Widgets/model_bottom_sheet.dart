import 'package:flutter/material.dart';

Future<void> showCBottomSheet({
  required BuildContext context,
  required double height,
  required Widget child,
  Color? barrierColor,
}) async {
  await showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    barrierColor: barrierColor ?? Colors.grey.withOpacity(0.5),
    isScrollControlled: true,
    builder: (context) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(20),
            topLeft: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 1,
              // offset: const Offset(0, 3),
            ),
          ],
        ),
        height: height,
        child: child,
      );
    },
  );
}
