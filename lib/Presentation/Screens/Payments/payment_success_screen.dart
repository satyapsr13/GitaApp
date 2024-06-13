import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../Constants/locations.dart';
import '../../../Utility/next_screen.dart';
import '../../Widgets/Buttons/gradient_primary_button.dart';
import '../splash_screen.dart';

class PaymentSuccessScreen extends StatelessWidget {
  const PaymentSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Payment Success'),
        ),
        body: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 50),
            Text(tr("payment_success_title"),
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                )),
            Text(tr("congra"),
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                )),
            Text(tr("you_r_premium_user"),
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                )),
            Lottie.asset(
              AppImages.pamentSuccessLottie,
            ),
            PrimaryButtonGradient(
                // isGreenGradient: true,
                isLoading: false,
                onPressed: () {
                  nextScreenCloseOthers(
                      context, const SplashScreen(isLoggedIn: true));
                },
                buttonText: tr("go_to_home_screen")),
          ],
        ));
  }
}
