import 'package:flutter/material.dart';

void showSnackBar(
  BuildContext context,
  Color color,
  String message, {
  int? second,
}) {
  ScaffoldMessenger.of(context).clearSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: color,
      behavior: SnackBarBehavior.fixed,
      dismissDirection: DismissDirection.down,
      duration: Duration(milliseconds: second ?? 1000),
    ),
  );
}
