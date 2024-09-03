// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gita/Constants/enums.dart';
import 'package:gita/Data/model/ObjectModels/audio_file.dart';
import 'package:gita/Utility/next_screen.dart';
import 'package:video_player/video_player.dart';

import '../../../Logic/Cubit/VideoCubit/video_cubit.dart';

class VideoMakerScreen extends StatefulWidget {
  // const VideoMakerScreen({super.key});
  final AudioFile audioFile;
  final String imagePath;
  const VideoMakerScreen({
    Key? key,
    required this.audioFile,
    required this.imagePath,
  }) : super(key: key);

  @override
  State<VideoMakerScreen> createState() => _VideoMakerScreenState();
}

class _VideoMakerScreenState extends State<VideoMakerScreen> {
  late VideoPlayerController _controller;
  @override
  void initState() {
    BlocProvider.of<VideoCubit>(context).loadAllSongs();
    // BlocProvider.of<VideoCubit>(context).addSongInImage();
    _controller = VideoPlayerController.networkUrl(Uri.parse(
        'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4'))
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    return BlocBuilder<VideoCubit, VideoState>(builder: (context, vidState) {
      return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Video Maker',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ),
          body: Column(
            children: [
              Visibility(
                visible: true,
                child: _controller.value.isInitialized
                    ? AspectRatio(
                        aspectRatio: _controller.value.aspectRatio,
                        child: VideoPlayer(_controller),
                      )
                    : SizedBox(
                        child: Image.network(
                        'https://picsum.photos/200',
                        width: mq.width,
                        fit: BoxFit.cover,
                        height: mq.width,
                      )),
              ),
              AudioTileWidget(
                file: widget.audioFile,
                imagePath: widget.imagePath,
              ),
              // toBeginningOfSentenceCase(input)

              Text(
                'List of saved audios',
                style: const TextStyle(),
              ),
              ...List.generate(
                vidState.listOfAudiofiles.length,
                (index) {
                  AudioFile savedFile = vidState.listOfAudiofiles[index];
                  return AudioTileWidget(
                    file: savedFile,
                    showAddAudioButton: false,
                    imagePath: widget.imagePath,
                  );
                },
              )
            ],
          ));
    });
  }
}

class AudioTileWidget extends StatelessWidget {
  // const AudioTile({super.key});
  final AudioFile file;
  final bool showAddAudioButton;
  final String imagePath;
  const AudioTileWidget({
    Key? key,
    required this.file,
    required this.imagePath,
    this.showAddAudioButton = true,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VideoCubit, VideoState>(builder: (context, vidState) {
      return SizedBox(
        height: 70,
        child: Column(
          children: [
            Row(
              children: [
                Visibility(
                  // visible: vidState.audioPlayStatus != Status.loading,
                  replacement: CircularProgressIndicator(),
                  child: IconButton(
                      onPressed: () {
                        if (vidState.audioPlayStatus == Status.play) {
                          BlocProvider.of<VideoCubit>(context).pauseAudio();
                        } else {
                          BlocProvider.of<VideoCubit>(context).playAudio(file);
                        }
                      },
                      icon: Icon(
                        (vidState.audioPlayStatus == Status.play &&
                                vidState.currentlyPlayingSongId == file.id)
                            ? Icons.pause_circle
                            : Icons.play_arrow,
                        size: 20,
                      )),
                ),
                Column(
                  children: [
                    Text(
                      file.name,
                      style: const TextStyle(),
                    ),
                    Text(
                      file.duration.toString(),
                      style: const TextStyle(),
                    ),
                  ],
                ),
                Visibility(
                  visible: showAddAudioButton,
                  child: ElevatedButton(
                    onPressed: () {
                      BlocProvider.of<VideoCubit>(context)
                          .downloadAndStoreAudio(file.networkUrl, imagePath);

                      nextScreen(
                          context,
                          VideoMakerScreen(
                            audioFile: file,
                            imagePath: imagePath,
                          ));
                    },
                    child: Text(
                      'Add Song',
                      style: const TextStyle(),
                    ),
                  ),
                )
              ],
            ),
            Visibility(
                visible: vidState.audioPlayStatus == Status.loading &&
                    vidState.currentlyPlayingSongId == file.id,
                child: LinearProgressIndicator(
                  minHeight: 10,
                ))
          ],
        ),
      );
    });
  }
}
