// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';

class ImageToVideoMainScreen extends StatefulWidget {
  const ImageToVideoMainScreen({super.key});

  @override
  State<ImageToVideoMainScreen> createState() => _ImageToVideoMainScreenState();
}

class _ImageToVideoMainScreenState extends State<ImageToVideoMainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Image To Video'),
        ),
        body: Column(
          children: [
            Text(
              'Coming  Soon',
              style: const TextStyle(),
            ),
          ],
        ));
  }
}
