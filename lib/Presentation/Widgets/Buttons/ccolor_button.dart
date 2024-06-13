import 'package:flutter/material.dart'; 

import '../../../Constants/colors.dart';
import '../../Screens/Tools/premium_wrapper.dart';

class CColorButton extends StatelessWidget {
  final String buttonText;
  final bool isPremium;
  final bool isBorderButton;
  final Widget? icon;
  final Color? buttonColor;
  final void Function() onTap;
  const CColorButton({
    Key? key,
    required this.buttonText,
    this.icon,
    this.buttonColor = Colors.green,
    required this.onTap,
    this.isPremium = false,
    this.isBorderButton = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: PremiumWrapper(
        isPremiumContent: isPremium,
        child: Container(
          height: 30,
          decoration: BoxDecoration(
            color: isBorderButton ? Colors.transparent : buttonColor,
            borderRadius: BorderRadius.circular(30),
            border: isBorderButton
                ? Border.all(
                    width: 1, color: buttonColor ?? AppColors.primaryColor)
                : null,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    buttonText,
                    style: TextStyle(
                      color: isBorderButton ? buttonColor : Colors.white,
                    ),
                  ),
                ),
                icon == null ? const SizedBox() : icon!,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
