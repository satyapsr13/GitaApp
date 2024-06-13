// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart'; 
// import 'package:video_player/video_player.dart';

// class VideoPage extends StatelessWidget {
//   const VideoPage({super.key});

//   // const VideoPage();

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: BlocBuilder<VideoCubit, VideoState>(
//         builder: (context, state) {
//           return state.lastInitializedIndex == -1
//               ? Center(
//                   child: Text(
//                     'Initializing 1st video',
//                     style: const TextStyle(),
//                   ),
//                 )
//               : PageView.builder(
//                   itemCount: state.lastInitializedIndex + 1,
//                   scrollDirection: Axis.vertical,
//                   onPageChanged: (index) {
//                     BlocProvider.of<VideoCubit>(context).onIndexChanged(index);
//                     // BlocProvider.of<PreloadBloc>(context, listen: false)
//                     //     .add(PreloadEvent.onVideoIndexChanged(index));
//                   },
//                   itemBuilder: (context, index) {
//                     // Is at end and isLoading
//                     if (index >= state.videoUrls.length) {
//                       return const Center(
//                         child: Text(
//                           'This is last video ',
//                           // style: const TextStyle(),
//                         ),
//                       );
//                     }
//                     final bool _isLoading = (state.status == Status.loading &&
//                         (index == state.videoUrls.length - 1));

//                     // if (state.status == Status.loading) {
//                     //   return const Center(child: CircularProgressIndicator());
//                     // }
//                     // if (state.status == Status.failure) {
//                     //   return const Center(
//                     //     child: Text(
//                     //       'Error',
//                     //       // style: const TextStyle(),
//                     //     ),
//                     //   );
//                     // }
//                     // if (index >= state.lastInitializedIndex) {
//                     //   return const Center(child: CircularProgressIndicator());
//                     // }

//                     return (state.focusIndex == index)
//                         ? VideoWidget(
//                             index: index,
//                             isLoading: index == (state.lastInitializedIndex),
//                             controller: state.controllers[index]!,
//                           )
//                         : const SizedBox();
//                   },
//                 );
//         },
//       ),
//     );
//   }
// }

// /// Custom Feed Widget consisting video
// class VideoWidget extends StatelessWidget {
//   const VideoWidget({
//     Key? key,
//     required this.index,
//     required this.isLoading,
//     required this.controller,
//   });

//   final bool isLoading;
//   final int index;
//   final VideoPlayerController controller;

//   @override
//   Widget build(BuildContext context) {
//     final mq = MediaQuery.of(context).size;
//     return Stack(
//       children: [
//         Column(
//           children: [
//             Expanded(
//                 child: controller.value.isInitialized
//                     ? VideoPlayer(controller)
//                     : Center(child: RishteyyShimmerLoader(mq: mq))),
//             AnimatedCrossFade(
//               alignment: Alignment.bottomCenter,
//               sizeCurve: Curves.decelerate,
//               duration: const Duration(milliseconds: 400),
//               firstChild: const Padding(
//                 padding: EdgeInsets.all(10.0),
//                 child: CupertinoActivityIndicator(
//                   color: Colors.black,
//                   radius: 15,
//                 ),
//               ),
//               secondChild: const SizedBox(),
//               crossFadeState: isLoading
//                   ? CrossFadeState.showFirst
//                   : CrossFadeState.showSecond,
//             ),
//           ],
//         ),
//         BlocBuilder<VideoCubit, VideoState>(builder: (context, state) {
//           bool isPlaying = state.controllers[index]!.value.isPlaying;
//           return Positioned(
//             bottom: 10,
//             right: 0,
//             child: Column(
//               children: [
//                 Container(
//                   color: Colors.white,
//                   child: Text(
//                     'Current Playing $index-> Initialized ${state.lastInitializedIndex}  ',
//                     style: const TextStyle(
//                       // backgroundColor: ,
//                       color: Colors.pink,
//                     ),
//                   ),
//                 ),
//                 // Padding(
//                 //   padding: const EdgeInsets.all(15.0),
//                 //   child: FloatingActionButton(
//                 //     backgroundColor: const Color.fromARGB(255, 18, 3, 216),
//                 //     shape: RoundedRectangleBorder(
//                 //       borderRadius: BorderRadius.circular(
//                 //           100.0), // Adjust the radius as needed
//                 //     ),
//                 //     onPressed: () {
//                 //       // BlocProvider.of<VideoCubit>(context)
//                 //       //     .stopCurrentPlayingVideo();
//                 //       // if (isPlaying) {}
//                 //       controller.setVolume(0);

//                 //       // isPlaying ? controller.pause() : controller.play();
//                 //     },
//                 //     child: Icon(
//                 //       Icons.south_america_rounded,
//                 //       size: 25,
//                 //       color: Colors.white,
//                 //     ),
//                 //   ),
//                 // ),
//                 Padding(
//                   padding: const EdgeInsets.all(15.0),
//                   child: FloatingActionButton(
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(
//                           100.0), // Adjust the radius as needed
//                     ),
//                     onPressed: () async {
//                       BlocProvider.of<VideoCubit>(context)
//                           .downloadVideo(state.videoUrls[index]);
//                       await showModalBottomSheet(
//                           barrierColor: Colors.black26,
//                           backgroundColor: Colors.transparent,
//                           isScrollControlled: true,
//                           context: context,
//                           builder: (context) {
//                             return VideoDownloaderBottomSheet(
//                               mq: mq,
//                             );
//                           });
//                     },
//                     backgroundColor: const Color.fromARGB(255, 18, 3, 216),
//                     child: const Icon(
//                       Icons.share,
//                       size: 25,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(15.0),
//                   child: FloatingActionButton(
//                     backgroundColor: const Color.fromARGB(255, 18, 3, 216),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(
//                           100.0), // Adjust the radius as needed
//                     ),
//                     onPressed: () {
//                       BlocProvider.of<VideoCubit>(context)
//                           .stopCurrentPlayingVideo(index);
//                       // if (isPlaying) {}

//                       // isPlaying ? controller.pause() : controller.play();
//                     },
//                     child: Icon(
//                       state.isPlaying ? Icons.pause : Icons.play_arrow_outlined,
//                       size: 25,
//                       color: Colors.white,
//                     ),
//                   ),
//                 )
//               ],
//             ),
//           );
//         }),
//       ],
//     );
//   }
// }
