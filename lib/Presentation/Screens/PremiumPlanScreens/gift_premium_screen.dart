// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GiftPremiumScreen extends StatefulWidget {
  const GiftPremiumScreen({super.key});

  @override
  State<GiftPremiumScreen> createState() => _GiftPremiumScreenState();
}

class _GiftPremiumScreenState extends State<GiftPremiumScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Gift Premium',
            style: TextStyle(
              // fontSize: 20,
              color: Colors.black,
            ),
          ),
        ),
        body: Column(
          children: [
            TextFormField(
              maxLength: 10,
              decoration: InputDecoration(hintText: "Enter Number"),
              inputFormatters: [FilteringTextInputFormatter.digitsOnly]
          ),
            TextButton(
              onPressed: () {},
              child: Text(
                'Send Premium Gift',
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ));
  }
}
