import 'package:flutter/material.dart';

import '../../../Constants/locations.dart';
 

class PremiumWrapper extends StatelessWidget {
  // const PremiumWrapper({super.key});
  final Widget child;
  final bool isPremiumUser;
  final bool isPremiumContent;
  final bool isBottomCenter;
  const PremiumWrapper({
    Key? key,
    required this.child,
    this.isPremiumUser = false,
    this.isPremiumContent = false,
    this.isBottomCenter = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return !isPremiumContent
        ? child
        : Stack(
            clipBehavior: Clip.none,
            alignment: isBottomCenter == true
                ? Alignment.bottomCenter
                : Alignment.center,
            children: [
              child,
              Visibility(
                replacement: SizedBox(
                    height: 20,
                    width: 20,
                    child: Image.asset(
                      isPremiumUser
                          ? AppImages.premiumUserIcon
                          : AppImages.nonPremiumUserIcon,
                      fit: BoxFit.cover,
                    )),
                visible: isBottomCenter == false,
                child: Positioned(
                    top: -10,
                    right: 10,
                    child: SizedBox(
                        height: 20,
                        width: 20,
                        child: Image.asset(
                          isPremiumUser
                              ? AppImages.premiumUserIcon
                              : AppImages.nonPremiumUserIcon,
                          fit: BoxFit.cover,
                        ))),
              ),
              // Visibility(
              //   visible: !isPremiumUser,
              //   child: IconButton(
              //       onPressed: () {},
              //       icon: const Icon(
              //         Icons.lock,
              //         size: 40,
              //       )),
              // ),
            ],
          );
  }
}
