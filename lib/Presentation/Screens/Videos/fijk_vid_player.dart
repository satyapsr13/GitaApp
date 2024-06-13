// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: prefer_const_constructors
import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';

class TestVid extends StatefulWidget {
  final String url;
  final BetterPlayerController betterPlayerController;
  const TestVid({
    Key? key,
    required this.url,
    required this.betterPlayerController,
  }) : super(key: key);
  @override
  State<TestVid> createState() => _TestVidState();
}

class _TestVidState extends State<TestVid> {
  // const TestVid({super.key});
  // var dataSource = BetterPlayerDataSource(
  //   BetterPlayerDataSourceType.network,
  //   widget.url,
  //   liveStream: true,
  //   useAsmsSubtitles: false,
  // );
  // late BetterPlayerController _betterPlayerController;
  @override
  void initState() {
    // TODO: implement initState
    // _betterPlayerController = BetterPlayerController(
    //     BetterPlayerConfiguration(
    //       looping: true,
    //       autoPlay: true,
    //     ),
    //     betterPlayerDataSource: BetterPlayerDataSource(
    //       BetterPlayerDataSourceType.network,
    //       widget.url,
    //       liveStream: true,
    //       useAsmsSubtitles: false,
    //     ));

    super.initState();
  }

  @override
  void dispose() {
    // _betterPlayerController.p
    // _betterPlayerController.pause();
    // _betterPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('appbar'),
      ),
      body: AspectRatio(
        aspectRatio: 9 / 21,
        child: BetterPlayer(
          controller: widget.betterPlayerController,
          // controller: _betterPlayerController,
        ),
      ),
    );
  }
}
