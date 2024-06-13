// ignore_for_file: unnecessary_brace_in_string_interps

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:share_plus/share_plus.dart';

import '../Constants/constants.dart';
import '../Logic/Cubit/TestCubit/test_cubit.dart';
import '../Logic/Cubit/user_cubit/user_cubit.dart';
import '../Presentation/Screens/DpMakerScreens/dp_maker_screens.dart';
import '../Presentation/Screens/Microapps/NewsApp/news_main_screen.dart';
import '../Presentation/Screens/PremiumPlanScreens/premium_plan_screen.dart';
import '../Presentation/Widgets/model_bottom_sheet.dart';
import '../Utility/next_screen.dart';
import 'frame_test_screen.dart';

class TestHomeScreen extends StatefulWidget {
  const TestHomeScreen({super.key});

  @override
  State<TestHomeScreen> createState() => _TestHomeScreenState();
}

class _TestHomeScreenState extends State<TestHomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          title: const Text('Test Home Screen'),
          actions: [
            IconButton(
                onPressed: () {
                  _downloadGif(
                      "https://media1.tenor.com/m/BO1Cl_CsuBAAAAAC/gutmornink-gudmorning.gif");
                },
                icon: const Icon(
                  Icons.share,
                  size: 20,
                )),
            IconButton(
                onPressed: () {
                  showCBottomSheet(
                      context: context,
                      height: mq.height * 0.9,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            ...List.generate(logsMessages.length, (index) {
                              String mess = logsMessages[index];
                              bool isApiResponse =
                                  mess.contains("api_response");
                              return Column(
                                children: [
                                  Text(
                                    "${index} -> ${mess}\n",
                                    style: TextStyle(
                                        color: isApiResponse
                                            ? Colors.black
                                            : Colors.red,
                                        fontSize: isApiResponse ? 10 : 15),
                                  ),
                                  const Divider(
                                    color: Colors.black,
                                    thickness: 1,
                                  ),
                                ],
                              );
                            })
                          ],
                        ),
                      ));
                },
                icon: const Icon(
                  Icons.logo_dev_sharp,
                  size: 20,
                )),
          ],
        ),
        persistentFooterButtons: const [],
        body: BlocBuilder<TestCubit, TestState>(builder: (context, state) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          if (GlobalVariables.appVersion % 2 == 0) {
                            BlocProvider.of<UserCubit>(context)
                                .updateStateVariables(
                                    isPremiumUser:
                                        !BlocProvider.of<UserCubit>(context)
                                            .state
                                            .isPremiumUser);
                          } else {
                            toast(
                              "Contact to developer for this feature",
                              duration: Toast.LENGTH_LONG,
                            );
                          }
                        },
                        child: const Text(
                          'Change Premium status',
                          style: TextStyle(),
                        ),
                      )
                    ],
                  ),

                  // if (state.messages.isEmpty)
                  //   const Text(
                  //     'Kuch operation kro tabhi to logs aayega',
                  //     style: TextStyle(),
                  //   ),
                  // ...List.generate(state.messages.length, (index) {
                  //   return Column(
                  //     children: [
                  //       Text(
                  //         "${index} -> ${state.messages[index]}\n",
                  //         style: const TextStyle(
                  //             color: Colors.black, fontSize: 10),
                  //       ),
                  //       const Divider(
                  //         color: Colors.black,
                  //         thickness: 1,
                  //       ),
                  //     ],
                  //   );
                  // }),
                  ElevatedButton(
                    onPressed: () {
                      // nextScreen(context, GifMainScreen());
                      toast("Coming Soon", duration: Toast.LENGTH_LONG);
                    },
                    child: const Text(
                      'Gif App',
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // nextScreen(context, ImageToVideoMainScreen());
                      toast("Coming Soon", duration: Toast.LENGTH_LONG);
                    },
                    child: const Text(
                      'Image to Video',
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ),
                  ElevatedButton(
                      onPressed: () {
                        nextScreen(context, NewsMainScreen());
                      },
                      child: const Text('News App',
                          style: TextStyle(
                            fontSize: 15,
                          ))),
                  ElevatedButton(
                    onPressed: () {
                      nextScreen(context, const DPMakerScreen());
                    },
                    child: const Text(
                      'Dp Maker',
                      style: TextStyle(),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      nextScreen(context, const PremiumPlanScreen());
                    },
                    child: const Text(
                      'Premium Plan screen',
                      style: TextStyle(),
                    ),
                  ),

                  ElevatedButton(
                    onPressed: () {
                      nextScreen(context, const FrameTestScreen());
                    },
                    child: const Text(
                      'Frame Test Screen',
                      style: TextStyle(),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // nextScreen(context, const FrameTestScreen());
                      toast("Coming Soon", duration: Toast.LENGTH_LONG);
                    },
                    child: const Text(
                      'Wallpaper App',
                      style: TextStyle(),
                    ),
                  )
                ],
              ),
            ),
          );
        }));
  }
}

Future<File?> _downloadGif(String url) async {
  final response =
      await Dio().get(url, options: Options(responseType: ResponseType.bytes));
  if (response.statusCode == 200) {
    const directory =
        "/storage/emulated/0/Android/data/com.aeonian.rishteyy/files"; // Or getDownloadsDirectory()
    const fileName = "$directory/my_gif.gif";
    final file = File(fileName);
    await file.writeAsBytes(response.data);
    await Share.shareFiles([fileName]);
    return file;
  } else {
    print('Error downloading GIF: ${response.statusCode}');
    return null;
  }
}
