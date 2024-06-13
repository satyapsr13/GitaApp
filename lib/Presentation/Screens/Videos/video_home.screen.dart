// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; 

import '../../../Logic/Cubit/video_cubit/video_cubit.dart';
import 'fijk_vid_player.dart';

class VideoHomeScreen extends StatefulWidget {
  const VideoHomeScreen({super.key});

  @override
  State<VideoHomeScreen> createState() => _VideoHomeScreenState();
}

class _VideoHomeScreenState extends State<VideoHomeScreen> {
  @override
  void initState() {
    BlocProvider.of<VideoCubit>(context).initializeAndLoadVideos();
    super.initState();
  }

  // List<String> vid = [
  //   "https://demo.unified-streaming.com/k8s/features/stable/video/tears-of-steel/tears-of-steel.ism/.m3u8",
  //   "https://d3rlna7iyyu8wu.cloudfront.net/skip_armstrong/skip_armstrong_multichannel_subs.m3u8",
  //   "https://demo.unified-streaming.com/k8s/features/stable/video/tears-of-steel/tears-of-steel.mp4/.m3u8"
  // ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // appBar: AppBar(
        //   title: const Text('appbar'),
        // ),
        // body: 1 == 1
        //     ? TestVid()
        //     : !kDebugMode
        //         ? Center(child: Text("Coming Soon"))
        //         : VideoPage(),
        body: BlocBuilder<VideoCubit, VideoState>(builder: (context, state) {
          return PageView.builder(
            scrollDirection: Axis.vertical,
            physics: BouncingScrollPhysics(),
            itemCount: state.videoUrls.length,
            itemBuilder: (ctx, index) => TestVid(
              url: "",
              betterPlayerController: state.controllers[index]!,
            ),
          );
        }),
      ),
    );
  }
}
