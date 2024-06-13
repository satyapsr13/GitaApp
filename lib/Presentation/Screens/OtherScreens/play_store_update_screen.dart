// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';

class PlayStoreUpdateScreen extends StatelessWidget {
  const PlayStoreUpdateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Rishteyy:- Update'),
        ),
        body: Column(
          children: [
            Text(
              'Please update your app',
              style: const TextStyle(),
            ),
          ],
        ));
  }
}
