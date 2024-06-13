import 'package:flutter/material.dart';

class PrimaryButtonGradient extends StatelessWidget {
  // final Size mq;
  final bool isLoading;
  final bool isGreenGradient;
  final void Function() onPressed;
  final String buttonText;
  const PrimaryButtonGradient({
    Key? key,
    // required this.mq,
    required this.isLoading,
    required this.onPressed,
    this.isGreenGradient = false,
    required this.buttonText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    return InkWell(
      onTap: isLoading ? null : onPressed,
      child: Container(
        height: 50,
        width: mq.width * 0.85,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: isGreenGradient
                ? [
                    const Color(0xff24634E),
                    const Color(0xff91C766),
                  ]
                : [
                    const Color(0xffFD6018),
                    const Color(0xffF8B91C),
                  ],
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: isLoading
              ? const CircularProgressIndicator(
                  color: Colors.white,
                )
              : Text(
                  buttonText,
                  style: const TextStyle(color: Colors.white, fontSize: 20),
                ),
        ),
      ),
    );
  }
}
