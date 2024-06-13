import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart'; 
import 'package:url_launcher/url_launcher.dart';

import '../../Widgets/Buttons/primary_button.dart';
// import 'package:qr_flutter/qr_flutter.dart';

class DonateScreen extends StatelessWidget {
  const DonateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          tr('donate_us'),
          style: const TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Expanded(child: SizedBox()),
            // Placeholder for other donation information
            Text(
              tr("donation_text"),
              style: const TextStyle(fontSize: 20.0),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20.0),
            SizedBox(
                child: QrImage(
              data:
                  'upi://pay?pa=harshprogrammer782-1@oksbi&tn=Support Rishteyy',
              // data: '8085746780@paytm',
              // data: 'harshprogrammer782-1@oksbi',
              version: QrVersions.auto,
              size: 300,
              gapless: true,
              
            )),
            const Expanded(child: SizedBox()),
            PrimaryButton(
                // mq: mq,
                isLoading: false,
                onPressed: () async {
                  await launchUrl(Uri.parse(
                      'upi://pay?pa=harshprogrammer782-1@oksbi&tn=Support Rishteyy'));
                },
                buttonText: tr("donate_us")),

            const Expanded(child: SizedBox()),
          ],
        ),
      ),
    );
  }
}
