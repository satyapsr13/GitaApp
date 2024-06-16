import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../Constants/enums.dart';
// import '../../../Logic/Cubit/video_cubit/video_cubit.dart';
import '../Buttons/primary_button.dart'; 

class VideoDownloaderBottomSheet extends StatelessWidget {
  final Size mq;
  const VideoDownloaderBottomSheet({
    Key? key,
    required this.mq,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 32,
        vertical: 8,
      ),
      width: 400,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        color: Colors.white,
      ),
      // child: SingleChildScrollView(
      //   child: BlocBuilder<VideoCubit, VideoState>(builder: (context, state) {
      //     return Column(
      //       children: [
      //         Container(
      //           height: 4,
      //           width: 32,
      //           decoration: BoxDecoration(
      //             borderRadius: BorderRadius.circular(40),
      //             color: Colors.grey[800],
      //           ),
      //         ),
      //         const SizedBox(height: 15),
      //         Text(
      //           state.videoDownloadStatus == Status.loading
      //               ? 'Downloading'
      //               : "Now you can share",
      //           style: const TextStyle(),
      //         ),
      //         const SizedBox(height: 70),
      //         PrimaryButton(
      //             onPressed: () {},
      //             isLoading: state.videoDownloadStatus == Status.loading,
      //             buttonText: "Share"),

      //         const SizedBox(height: 150),
      //       ],
      //     );
      //   }),
      // ),
  
  
    );
  }
}
