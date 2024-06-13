import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import '../../../Constants/colors.dart';
import '../../../Data/model/api/special_ocassion_model.dart';
import '../../../Logic/Cubit/Posts/posts_cubit.dart';
import '../../../Utility/common.dart';
// import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class NewUpdatesScreen extends StatefulWidget {
  // const NewUpdatesScreen({super.key});
  // final String videoId = "";
  final List<YoutubeAndUpdateModel> listOfUpdates;
  NewUpdatesScreen({
    Key? key,
    // required this.videoId,
    required this.listOfUpdates,
  }) : super(key: key);

  @override
  State<NewUpdatesScreen> createState() => _NewUpdatesScreenState();
}

class _NewUpdatesScreenState extends State<NewUpdatesScreen> {
  String extractVideoId(String url) {
    RegExp regExp = RegExp(
      r"(?:https?:\/\/)?(?:www\.)?(?:youtube\.com\/(?:[^\/\n\s]+\/\S+\/|(?:v|e(?:mbed)?)\/|\S*?[?&]v=)|youtu\.be\/)([a-zA-Z0-9_-]{11})",
      caseSensitive: false,
      multiLine: false,
    );
    Iterable<RegExpMatch> matches = regExp.allMatches(url);
    if (matches.isNotEmpty) {
      return matches.elementAt(0).group(1)!;
    } else {
      return ""; // or handle invalid URLs as per your requirement
    }
  }

  // List<YoutubePlayerController> controllers = [];
  Map<int, YoutubePlayerController> controllers = {};
  @override
  void initState() {
    loadControllers();
    super.initState();
  }

  loadControllers() {
    for (int i = 0; i < widget.listOfUpdates.length; ++i) {
      YoutubeAndUpdateModel y = widget.listOfUpdates[i];
      String? videoId =
          YoutubePlayerController.convertUrlToId(y.youtube ?? "") ??
              (kDebugMode ? "PiWJWfzVwjU" : null);
      if (videoId != null) {
        controllers[i] = YoutubePlayerController.fromVideoId(
          params: YoutubePlayerParams(
            showControls: true,
            mute: false,
            enableCaption: false,
            interfaceLanguage: (tr("_a_") == "A") ? "en" : "hi",
            showFullscreenButton: false,
            strictRelatedVideos: true,
            loop: false,
          ),
          videoId: videoId,
        );
      }
    }
  }

  @override
  void dispose() {
    controllers.clear();
    super.dispose();
  }

  AppUpdateInfo? isUpdateAvailable;
  checkForUpdate() async {
    setState(() async {
      isUpdateAvailable = await InAppUpdate.checkForUpdate();
    });
  }

// print(videoId); // BBAyRBTfsOU
  bool isEnglish = (tr("_a_") == "A");

  @override
  Widget build(BuildContext context) {
    // bool isUpdateAvailable =await InAppUpdate.checkForUpdate();
    final mq = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            tr('update_title'),
            style: const TextStyle(
                color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        body: BlocBuilder<PostCubit, PostState>(builder: (context, state) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: SizedBox(
                width: mq.width,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ...List.generate(widget.listOfUpdates.length, (index) {
                        YoutubeAndUpdateModel update =
                            widget.listOfUpdates[index];

                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              (isEnglish ? update.text : update.hindi) ?? "",
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 15),
                            Visibility(
                                visible: update.image != null,
                                child: Image.network(update.image ?? "")),
                            update.youtube != null
                                ? AspectRatio(
                                    aspectRatio:
                                        !update.youtube!.contains("short")
                                            ? 16 / 12
                                            : 9 / 16,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: YoutubePlayerScaffold(
                                        controller: controllers[index]!,
                                        enableFullScreenOnVerticalDrag: false,
                                        builder: (BuildContext context,
                                            Widget player) {
                                          return player;
                                        },
                                        // gestureRecognizers: ,
                                      ),
                                    ),
                                  )
                                : const SizedBox(),
                            const SizedBox(height: 15),
                            update.buttonType != null
                                ? InkWell(
                                    onTap: () async {
                                      if (update.buttonType == "screen") {
                                        navigatorFunction(
                                            update.url ?? "", context);
                                      } else if (update.buttonType == "url") {
                                        Uri uri = Uri.parse(update.url ?? "");
                                        if (await canLaunchUrl(uri)) {
                                          launchUrl(uri,
                                              mode: LaunchMode
                                                  .externalApplication);
                                        }
                                      }
                                    },
                                    child: Container(
                                      height: 50,
                                      width: mq.width - 30,
                                      decoration: BoxDecoration(
                                        color: AppColors.primaryColor,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Center(
                                        child: Text(
                                          (isEnglish
                                                  ? update.buttonText
                                                  : update.buttonTextHindi) ??
                                              "",
                                          style: const TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                : const SizedBox(),
                            const SizedBox(height: 15),
                            const Divider(
                              color: Colors.black,
                              thickness: 1,
                            ),
                            const SizedBox(height: 30),
                            Visibility(
                              visible: isUpdateAvailable != null,
                              child: InkWell(
                                onTap: () async {
                                  try {
                                    await InAppUpdate.startFlexibleUpdate();
                                  } catch (e) {}
                                },
                                child: Container(
                                  height: 50,
                                  width: mq.width - 30,
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryColor,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Center(
                                    child: Text(
                                      "Update app",
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        );
                      })
                    ]),
              ),
            ),
          );
        }));
  }
}
