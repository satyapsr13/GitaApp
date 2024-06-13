// ignore_for_file: deprecated_member_use

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:better_player/better_player.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart'; 
import 'package:video_player/video_player.dart';

import '../../../Constants/enums.dart';
import '../../../Data/repositories/localization.dart';

part 'video_state.dart';

class VideoCubit extends Cubit<VideoState> {
  final LocaleRepository localeRepository;
  // final UserRepository userRepository;
  VideoCubit({
    required this.localeRepository,
    // required this.userRepository,
  }) : super(VideoState());

  Future<void> initializeAndLoadVideos() async {
    emit(state.copyWith(status: Status.loading));

    final List<String> urls = (1 == 1)
        ? [
          "https://reelzstorage.blob.core.windows.net/waves/videos/m3u8/28dec/hanuman/10000000_2283895828466619_8606527751482611473_n.m3u8",
            "https://demo.unified-streaming.com/k8s/features/stable/video/tears-of-steel/tears-of-steel.ism/.m3u8",
            "https://devstreaming-cdn.apple.com/videos/streaming/examples/img_bipbop_adv_example_fmp4/master.m3u8",
          ]
        : list;
    // state.videoUrls.addAll(urls);
    // state.videoUrls.addAll(urls);
    // for (final e in url) {

    // }

    emit(state.copyWith(videoUrls: urls));

    /// Initialize 1st video
    await _initializeControllerAtIndex(0);

    // emit(state.copyWith(status: Status.success));

    /// Play 1st video

    /// Initialize 2nd video
    _playControllerAtIndex(0);
    emit(state.copyWith(reloadCounter: state.reloadCounter + 1));
    await _initializeControllerAtIndex(1);
    await _initializeControllerAtIndex(2);
    await _initializeControllerAtIndex(3);
    
  }

  void stopCurrentPlayingVideo(int index) {
    BetterPlayerController? c = state.controllers[index];
    // if (c != null) {
    //   if (c.value.isPlaying) {
    //     c.pause();
    //     emit(state.copyWith(focusIndex: state.focusIndex, isPlaying: false));
    //   } else {
    //     c.play();
    //     emit(state.copyWith(focusIndex: state.focusIndex, isPlaying: true));
    //   }
    // }
  }

  Future<void> downloadVideo(String url) async {
    emit(state.copyWith(videoDownloadStatus: Status.loading));
    Dio dio = Dio();

    // Save video information in the local database
    // VideoModel video = VideoModel(id: 1, title: 'Video Title', videoUrl: videoUrl);
    // DatabaseHelper databaseHelper = DatabaseHelper();
    // await databaseHelper.insertVideo(video);
    try {
      Response response = await dio.get(url,
          options: Options(
            responseType: ResponseType.bytes,
          ));
      if (response.data != null) {
        // Save video file to local storage
        Directory appDocDir = await getApplicationDocumentsDirectory();
        String filePath = '${appDocDir.path}/${DateTime.now()}.mp4';
        File file = File(filePath);
        await file.writeAsBytes(response.data);

        emit(state.copyWith(videoDownloadStatus: Status.success));
      }
    } catch (e) {
      emit(state.copyWith(videoDownloadStatus: Status.failure));
    }
  }

  Future _initializeControllerAtIndex(int index) async {
    // index = state.lastInitializedIndex + 1;
    if (state.videoUrls.length > index && index >= 0) {
      /// Create new controller
      ///
      ///
      // if (index <= state.lastInitializedIndex) {
      //   return;
      // }
      // emit(sta)
      // state.isInitializing = true;
      emit(state.copyWith(isInitializing: true));
        log("------------$index INITIALIZED   starging---------------------------");

      final BetterPlayerController controller = BetterPlayerController(
          const BetterPlayerConfiguration(
              looping: true, autoPlay: false, fit: BoxFit.fitWidth),
          betterPlayerDataSource: BetterPlayerDataSource(
            BetterPlayerDataSourceType.network,
            state.videoUrls[index],
            liveStream: true,
            useAsmsSubtitles: false,
            notificationConfiguration:
                const BetterPlayerNotificationConfiguration(
              showNotification: true,
            ),
          ));
      // await controller.setLooping(true);
      // controller.isVideoInitialized();

      Map<int, BetterPlayerController> updatedControllers =
          Map.from(state.controllers);
      updatedControllers[index] = controller;

      // Update the controller in the new map
      // print(
      //     "---------updatedControllers1--------${updatedControllers.toString()}----------------");
      if (controller.isVideoInitialized()==true) {
        
        log("------------$index INITIALIZED   initialized---------------------------");
      }
      // Emit a new state with the updated controllers
      emit(state.copyWith(controllers: updatedControllers,lastInitializedIndex: index));
      // emit(state.copyWith(isInitializing: false));

      // await controller.initialize();

      // state.isInitializing = false;
      // emit(state.copyWith(lastInitializedIndex: index));

      log('🚀🚀🚀 INITIALIZED $index');

      // print("-----------------${state.controllers}----------------");

      /// Initialize

      // emit(state.copyWith(lastInitializedIndex: index));
    }
  }

  void _playControllerAtIndex(int index) {
    if (state.videoUrls.length > index && index >= 0) {
      /// Get controller at [index]
      // final BetterPlayerController controller = state.controllers[index]!;
      // printController();
      // if (state.controllers[index] != null) {
      // emit(state.copyWith(status: Status.success));
      final BetterPlayerController controller = state.controllers[index]!;

      /// Play controller
      controller.play();
      emit(state.copyWith(isPlaying: true));
      // } else {
      // emit(state.copyWith(status: Status.failure));
      // }

      log('🚀🚀🚀 PLAYING $index');
    }
  }

  void onIndexChanged(int currentIndex) {
    //  final bool shouldFetch = (e.index + kPreloadLimit) % kNextLimit == 0 &&
    //       state.urls.length == e.index + kPreloadLimit;

    //   if (shouldFetch) {
    //     createIsolate(e.index);
    //   }

    /// Next / Prev video decider
    if (currentIndex > state.focusIndex) {
      _playNext(currentIndex);
    } else {
      _playPrevious(currentIndex);
    }

    emit(state.copyWith(focusIndex: currentIndex));
  }

  Future<void> _playNext(int index) async {
    /// Stop [index - 1] controller
    _stopControllerAtIndex(index - 1);

    /// Dispose [index - 2] controller
    // _disposeControllerAtIndex(index - 2);

    /// Play current video (already initialized)

    /// Initialize [index + 1] controller
    _playControllerAtIndex(index);

    plog("${state.isInitializing}", title: "state.isInitializing  ");
    if (state.isInitializing == false) {
      plog("${state.lastInitializedIndex + 1}",
          title: "Initializing Index no ");
      await _initializeControllerAtIndex(state.lastInitializedIndex + 1);
    }
    // await _initializeControllerAtIndex(index + 2);
    // await _initializeControllerAtIndex(index + 3);
    // await _initializeControllerAtIndex(index + 4);
    // await _initializeControllerAtIndex(index + 5);
  }

  void _playPrevious(int index) {
    /// Stop [index + 1] controller
    _stopControllerAtIndex(index + 1);

    /// Dispose [index + 2] controller
    // _disposeControllerAtIndex(index + 2);

    /// Play current video (already initialized)
    _playControllerAtIndex(index);

    /// Initialize [index - 1] controller
    // _initializeControllerAtIndex(index - 1);
  }

  void _stopControllerAtIndex(int index) {
    if (state.videoUrls.length > index && index >= 0) {
      /// Get controller at [index]
      // final BetterPlayerController controller = state.controllers[index]!;
      final BetterPlayerController controller = state.controllers[index]!;

      /// Pause
      controller.pause();

      /// Reset postiton to beginning
      controller.seekTo(const Duration());

      log('🚀🚀🚀 STOPPED $index');
    }
  }

  void _disposeControllerAtIndex(int index) {
    if (state.videoUrls.length > index && index >= 0) {
      /// Get controller at [index]
      final BetterPlayerController? controller = state.controllers[index];

      /// Dispose controller
      controller?.dispose();

      if (controller != null) {
        state.controllers.remove(controller);
      }

      log('🚀🚀🚀 DISPOSED $index');
    }
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

void plog(String val, {String? title}) {
  log("--------${title ?? ""}--------------$val---------------------------");
}

var list = [
  "https://reelzstorage.blob.core.windows.net/waves/videos/final/28dec/hanuman/admin_rambhakt_310719762_322048037298890_4181481611952751087_n.mp4",
  "https://reelzstorage.blob.core.windows.net/waves/videos/final/28dec/hanuman/10000000_2283895828466619_8606527751482611473_n.mp4",
  "https://reelzstorage.blob.core.windows.net/waves/videos/final/28dec/hanuman/its_ashutosh10_120723239_1036756157558166_7749509278019951700_n.mp4",
  "https://reelzstorage.blob.core.windows.net/waves/videos/final/28dec/hanuman/322930897_1155658405841240_6562317403944760002_n.mp4",
  "https://reelzstorage.blob.core.windows.net/waves/videos/final/28dec/hanuman/318166028_298169896411927_4439496895786206519_n.mp4",
  "https://reelzstorage.blob.core.windows.net/waves/videos/final/28dec/hanuman/kanha_ki_murli_3_10000000_1033779324592889_2765489029167300818_n.mp4",
  "https://reelzstorage.blob.core.windows.net/waves/videos/final/28dec/hanuman/admin_rambhakt_310719762_322048037298890_4181481611952751087_n.mp4",
  "https://reelzstorage.blob.core.windows.net/waves/videos/final/28dec/hanuman/10000000_2283895828466619_8606527751482611473_n.mp4",
  "https://reelzstorage.blob.core.windows.net/waves/videos/final/28dec/hanuman/its_ashutosh10_120723239_1036756157558166_7749509278019951700_n.mp4",
  "https://reelzstorage.blob.core.windows.net/waves/videos/final/28dec/hanuman/322930897_1155658405841240_6562317403944760002_n.mp4",
  "https://reelzstorage.blob.core.windows.net/waves/videos/final/28dec/hanuman/318166028_298169896411927_4439496895786206519_n.mp4",
  "https://reelzstorage.blob.core.windows.net/waves/videos/final/28dec/hanuman/kanha_ki_murli_3_10000000_1033779324592889_2765489029167300818_n.mp4",
  "https://reelzstorage.blob.core.windows.net/waves/videos/final/28dec/hanuman/admin_rambhakt_310719762_322048037298890_4181481611952751087_n.mp4",
  "https://reelzstorage.blob.core.windows.net/waves/videos/final/28dec/hanuman/10000000_2283895828466619_8606527751482611473_n.mp4",
  "https://reelzstorage.blob.core.windows.net/waves/videos/final/28dec/hanuman/its_ashutosh10_120723239_1036756157558166_7749509278019951700_n.mp4",
  "https://reelzstorage.blob.core.windows.net/waves/videos/final/28dec/hanuman/322930897_1155658405841240_6562317403944760002_n.mp4",
  "https://reelzstorage.blob.core.windows.net/waves/videos/final/28dec/hanuman/318166028_298169896411927_4439496895786206519_n.mp4",
  "https://reelzstorage.blob.core.windows.net/waves/videos/final/28dec/hanuman/kanha_ki_murli_3_10000000_1033779324592889_2765489029167300818_n.mp4",
  "https://reelzstorage.blob.core.windows.net/waves/videos/final/28dec/hanuman/admin_rambhakt_310719762_322048037298890_4181481611952751087_n.mp4",
  "https://reelzstorage.blob.core.windows.net/waves/videos/final/28dec/hanuman/10000000_2283895828466619_8606527751482611473_n.mp4",
  "https://reelzstorage.blob.core.windows.net/waves/videos/final/28dec/hanuman/its_ashutosh10_120723239_1036756157558166_7749509278019951700_n.mp4",
  "https://reelzstorage.blob.core.windows.net/waves/videos/final/28dec/hanuman/322930897_1155658405841240_6562317403944760002_n.mp4",
  "https://reelzstorage.blob.core.windows.net/waves/videos/final/28dec/hanuman/318166028_298169896411927_4439496895786206519_n.mp4",
  "https://reelzstorage.blob.core.windows.net/waves/videos/final/28dec/hanuman/kanha_ki_murli_3_10000000_1033779324592889_2765489029167300818_n.mp4",
  "https://reelzstorage.blob.core.windows.net/waves/videos/final/28dec/hanuman/admin_rambhakt_310719762_322048037298890_4181481611952751087_n.mp4",
  "https://reelzstorage.blob.core.windows.net/waves/videos/final/28dec/hanuman/10000000_2283895828466619_8606527751482611473_n.mp4",
  "https://reelzstorage.blob.core.windows.net/waves/videos/final/28dec/hanuman/its_ashutosh10_120723239_1036756157558166_7749509278019951700_n.mp4",
  "https://reelzstorage.blob.core.windows.net/waves/videos/final/28dec/hanuman/322930897_1155658405841240_6562317403944760002_n.mp4",
  "https://reelzstorage.blob.core.windows.net/waves/videos/final/28dec/hanuman/318166028_298169896411927_4439496895786206519_n.mp4",
  "https://reelzstorage.blob.core.windows.net/waves/videos/final/28dec/hanuman/kanha_ki_murli_3_10000000_1033779324592889_2765489029167300818_n.mp4",
  "https://reelzstorage.blob.core.windows.net/waves/videos/final/28dec/hanuman/admin_rambhakt_310719762_322048037298890_4181481611952751087_n.mp4",
  "https://reelzstorage.blob.core.windows.net/waves/videos/final/28dec/hanuman/10000000_2283895828466619_8606527751482611473_n.mp4",
  "https://reelzstorage.blob.core.windows.net/waves/videos/final/28dec/hanuman/its_ashutosh10_120723239_1036756157558166_7749509278019951700_n.mp4",
  "https://reelzstorage.blob.core.windows.net/waves/videos/final/28dec/hanuman/322930897_1155658405841240_6562317403944760002_n.mp4",
  "https://reelzstorage.blob.core.windows.net/waves/videos/final/28dec/hanuman/318166028_298169896411927_4439496895786206519_n.mp4",
  "https://reelzstorage.blob.core.windows.net/waves/videos/final/28dec/hanuman/kanha_ki_murli_3_10000000_1033779324592889_2765489029167300818_n.mp4",
  "https://reelzstorage.blob.core.windows.net/waves/videos/final/28dec/hanuman/admin_rambhakt_310719762_322048037298890_4181481611952751087_n.mp4",
  "https://reelzstorage.blob.core.windows.net/waves/videos/final/28dec/hanuman/10000000_2283895828466619_8606527751482611473_n.mp4",
  "https://reelzstorage.blob.core.windows.net/waves/videos/final/28dec/hanuman/its_ashutosh10_120723239_1036756157558166_7749509278019951700_n.mp4",
  "https://reelzstorage.blob.core.windows.net/waves/videos/final/28dec/hanuman/322930897_1155658405841240_6562317403944760002_n.mp4",
  "https://reelzstorage.blob.core.windows.net/waves/videos/final/28dec/hanuman/318166028_298169896411927_4439496895786206519_n.mp4",
  "https://reelzstorage.blob.core.windows.net/waves/videos/final/28dec/hanuman/kanha_ki_murli_3_10000000_1033779324592889_2765489029167300818_n.mp4",
  "https://reelzstorage.blob.core.windows.net/waves/videos/final/28dec/hanuman/admin_rambhakt_310719762_322048037298890_4181481611952751087_n.mp4",
  "https://reelzstorage.blob.core.windows.net/waves/videos/final/28dec/hanuman/10000000_2283895828466619_8606527751482611473_n.mp4",
  "https://reelzstorage.blob.core.windows.net/waves/videos/final/28dec/hanuman/its_ashutosh10_120723239_1036756157558166_7749509278019951700_n.mp4",
  "https://reelzstorage.blob.core.windows.net/waves/videos/final/28dec/hanuman/322930897_1155658405841240_6562317403944760002_n.mp4",
  "https://reelzstorage.blob.core.windows.net/waves/videos/final/28dec/hanuman/318166028_298169896411927_4439496895786206519_n.mp4",
  "https://reelzstorage.blob.core.windows.net/waves/videos/final/28dec/hanuman/kanha_ki_murli_3_10000000_1033779324592889_2765489029167300818_n.mp4",
  "https://reelzstorage.blob.core.windows.net/waves/videos/final/28dec/hanuman/admin_rambhakt_310719762_322048037298890_4181481611952751087_n.mp4",
  "https://reelzstorage.blob.core.windows.net/waves/videos/final/28dec/hanuman/10000000_2283895828466619_8606527751482611473_n.mp4",
  "https://reelzstorage.blob.core.windows.net/waves/videos/final/28dec/hanuman/its_ashutosh10_120723239_1036756157558166_7749509278019951700_n.mp4",
  "https://reelzstorage.blob.core.windows.net/waves/videos/final/28dec/hanuman/322930897_1155658405841240_6562317403944760002_n.mp4",
  "https://reelzstorage.blob.core.windows.net/waves/videos/final/28dec/hanuman/318166028_298169896411927_4439496895786206519_n.mp4",
  "https://reelzstorage.blob.core.windows.net/waves/videos/final/28dec/hanuman/kanha_ki_murli_3_10000000_1033779324592889_2765489029167300818_n.mp4",
  "",
  "",
  "",
  "",
  "",
  "",
  "",
  "",
];
