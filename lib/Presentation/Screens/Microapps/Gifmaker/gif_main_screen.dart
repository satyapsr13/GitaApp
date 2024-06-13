// ignore_for_file: prefer_const_const
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gif/gif.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class GifMainScreen extends StatelessWidget {
  const GifMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Gif'),
        ),
        body: Column(
          children: [
            Gif(
              image: const NetworkImage(
                  "https://media1.tenor.com/m/BO1Cl_CsuBAAAAAC/gutmornink-gudmorning.gif"),
              autostart: Autostart.loop,
            ),
            TextButton(
              onPressed: () async {
                final filePath = await downloadGif(
                    "https://media1.tenor.com/m/BO1Cl_CsuBAAAAAC/gutmornink-gudmorning.gif");
                // Option 1: Open Share Sheet
                await shareGif(filePath);
              },
              child: Text(
                'Share',
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ));
  }

  Future<String> downloadGif(String gifUrl) async {
    final response = await Dio()
        .get(gifUrl, options: Options(responseType: ResponseType.bytes));
    final directory = await getApplicationDocumentsDirectory();
    final fileName = '${DateTime.now().millisecondsSinceEpoch}.gif';
    final filePath = '${directory.path}/$fileName';
    final file = File(filePath);
    await file.writeAsBytes(response.data);
    return filePath;
  }

  Future<void> shareGif(String filePath) async {
    await Share.shareFiles([filePath]);
  }
}
