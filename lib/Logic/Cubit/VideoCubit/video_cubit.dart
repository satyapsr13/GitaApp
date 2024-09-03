import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:gita/Data/model/ObjectModels/audio_file.dart';
import 'package:gita/Data/model/ObjectModels/video_file.dart';
import 'package:gita/objectbox.g.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:logger/logger.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:path_provider/path_provider.dart';

import '../../../Constants/enums.dart';
import '../../../Data/model/api/frames_response.dart';
import '../../../Data/repositories/sticker_repository.dart';

part 'video_state.dart';

class VideoCubit extends Cubit<VideoState> {
  // final LocaleRepository localeRepository;
  // final ToolsRepository toolsRepository;
  // final UserRepository userRepository;
  final StickerRepository stickerRepository;
  final Store store;
  // final PostCubit postState;
  VideoCubit({
    // required this.localeRepository,
    // required this.toolsRepository,
    required this.stickerRepository,
    required this.store,
    // required this.userRepository,
    // required this.postState,
  }) : super(VideoState());
  bool isAudioAlreadyDownloaded(String networkUrl) {
    Box<AudioFile> audioBox = store.box<AudioFile>();

    final query =
        audioBox.query(AudioFile_.networkUrl.equals(networkUrl)).build();

    AudioFile? existingAudioFile = query.findFirst();
    if (existingAudioFile != null) {}
    // Close the query after using it
    query.close();

    return existingAudioFile != null;
  }

  void initiAudioPlayer() {
    emit(state.copyWith(player: AudioPlayer()));
  }

  Future<void> playAudio(AudioFile audioFile) async {
    emit(state.copyWith(
        audioPlayStatus: Status.loading, currentlyPlayingSongId: audioFile.id));
    if (state.player == null) {
      initiAudioPlayer();
    }
    pauseAudio();
    if (state.player!.playing) {
      state.player!.pause();
    }
    if (audioFile.path.startsWith("htt")) {
      state.player?.setAudioSource(AudioSource.uri(Uri.parse(audioFile.path)));
    } else {
      state.player?.setAudioSource(AudioSource.file(audioFile.path));
    }
    final duration = await state.player?.setUrl(// Load a URL
        audioFile.networkUrl); // Schemes: (https: | file: | asset: )
    emit(state.copyWith(audioPlayStatus: Status.plause));
    state.player?.play();
  }

  void pauseAudio() {
    if (state.player == null) {
      return;
    }
    if (state.player!.playing) {
      state.player!.pause();
      emit(state.copyWith(audioPlayStatus: Status.plause));
    }
  }

  loadAllSongs() {
    final box = store.box<AudioFile>();
    emit(state.copyWith(listOfAudiofiles: box.getAll()));
  }

  void addSongInImage(String imagePath, String audioPath, String outputPath) {
    final FlutterFFmpeg flutterFFmpeg = FlutterFFmpeg();
    final FlutterFFprobe flutterFFprobe = FlutterFFprobe();
    String command =
        '-loop 1 -i $imagePath -i $audioPath -c:v libx264 -c:a aac -b:a 192k -shortest -y $outputPath';

    flutterFFmpeg.execute(command).then((rc) {
      print("FFmpeg process exited with rc $rc");
      if (rc == 0) {
        flutterFFprobe.getMediaInformation(outputPath).then((info) {
          final Map<dynamic, dynamic> mediaInfo = info.getAllProperties();
          if (mediaInfo != null) {
            double duration = mediaInfo['duration'] ?? 0.0;
            int size = File(outputPath).lengthSync();

            // Store in the database
            Box<VideoFile> videoBox = store.box<VideoFile>();
            videoBox.put(VideoFile(
                title: "",
                path: outputPath,
                duration: duration.toInt(), // Convert to seconds
                size: size,
                networkUrl: ""));
            print("Video duration: $duration seconds");
            print("Video size: $size bytes");
          }
        }).catchError((error) {
          print("Error retrieving media info: $error");
        });
      } else {
        toast("Please try again");
        print("Error occurred while creating video");
      }
    });
  }

  Future<void> downloadAndStoreAudio(
      String url, String screenShotImagePath) async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    try {
      Logger().i("1");
      if (isAudioAlreadyDownloaded(url)) {
        return;
      }
      Logger().i("2");
      // Get the application's documents directory
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String appDocPath = appDocDir.path;

      // Define the path to save the audio file
      String filePath = '$appDocPath/$fileName';

      // Create Dio instance
      Dio dio = Dio();

      Logger().i("3");
      // Download the audio file
      try {
        final res = await dio.download(url, filePath).then((value) {
          Logger().e(value);
        });
        Logger().i(res);
      } catch (e) {
        Logger().i(e);
      }

      Logger().i("4");
      // Get file metadata
      File file = File(filePath);
      int fileSize = await file.length();
      Logger().i("5");
      String fileExtension = filePath.split('.').last;
      Logger().i(filePath);
      // Create an AudioFile object
      AudioFile audioFile = AudioFile(
        name: fileName,
        path: filePath,
        duration:
            0, // You can use a package like 'audioplayers' to get actual duration
        size: fileSize,
        format: fileExtension,
        artist: 'Unknown Artist', // Update this as needed
        isFavorite: false,
        searchTags: ['tag1', 'tag2'], networkUrl: url, album: '',
        genre: '', // Update with actual tags if available
      );

      // Save to ObjectBox
      final box = store.box<AudioFile>();
      box.put(audioFile);
      addSongInImage(screenShotImagePath, audioFile.path,
          DateTime.now().millisecondsSinceEpoch.toString());
      Logger().i("downloaded successfully");
      emit(state.copyWith(listOfAudiofiles: box.getAll()));
    } catch (_) {}
  }

  void updateStateVariable({Frame? currentFrame, List<String>? messages}) {
    List<String> tempMessages = [];
    if (messages != null) {
      tempMessages.addAll(messages);
    }
    tempMessages.addAll(state.messages);
    emit(state.copyWith(currentFrame: currentFrame, messages: tempMessages));
  }

  @override
  VideoState? fromJson(Map<String, dynamic> json) {
    return VideoState.fromMap(json);
  }

  @override
  Map<String, dynamic>? toJson(VideoState state) {
    return state.toMap();
  }
}
