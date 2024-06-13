import 'package:flutter/material.dart';

class CCloseButton extends StatelessWidget {
  final void Function()? onTap;
  final bool isVisible;
  const CCloseButton({
    Key? key,
    this.onTap,
    this.isVisible = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: isVisible,
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 18,
          width: 18,
          decoration:
              const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
          child: const Center(
            child: Icon(Icons.close, color: Colors.black, size: 15),
          ),
        ),
      ),
    );
  }
}
