import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../Constants/colors.dart';
import '../../../Data/model/ObjectModels/post_widget_model.dart';
import '../../../Logic/Cubit/Posts/posts_cubit.dart';
import '../../../Utility/next_screen.dart';
import '../../Widgets/Buttons/primary_button.dart';
import '../../Widgets/post_widget.dart';
import '../home_screen_with_navigation.dart';

class PostSettingScreen extends StatefulWidget {
  const PostSettingScreen({super.key});

  @override
  State<PostSettingScreen> createState() => _PostSettingScreenState();
}

class _PostSettingScreenState extends State<PostSettingScreen> {
  @override
  void initState() {
    _checkNotificationPermissionStatus();
    super.initState();
  }

  // PermissionStatus? status;
  Future<void> _checkNotificationPermissionStatus() async {
    try {
      await Permission.notification.status;

      if (await Permission.notification.isDenied ||
          await Permission.notification.isPermanentlyDenied) {
        await Permission.notification.request();
      } else {
        // print("object")
        Logger().i("message");
      }
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
            title: Text(
          tr('choose_default_setting'),
          style: const TextStyle(
              backgroundColor: Colors.white,
              fontSize: 18,
              color: Colors.black,
              fontWeight: FontWeight.bold),
        )),
        body: BlocBuilder<PostCubit, PostState>(builder: (context, postState) {
          return SingleChildScrollView(
            child: Container(
              height: mq.height,
              width: mq.width,
              child: Column(
                children: [
                  // const SizedBox(height: 55),

                  const SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: PostWidget(
                      postWidgetData: PostWidgetModel(
                        index: 1,
                        imageLink: "assets/images/testimg.jpg",
                        postId: "1",
                        profilePos: "right",
                        profileShape: "round",
                        tagColor: "white",
                        playStoreBadgePos: "right",
                        showName: true,
                        showProfile: true,
                      ),
                      showEditAndShare: false,
                    ),
                  ),
                  // const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        onTap: () {
                          BlocProvider.of<PostCubit>(context).setStateVariables(
                              isDateVisible: !postState.isDateVisible);
                        },
                        child: Container(
                          height: 45,
                          width: 45,
                          decoration: BoxDecoration(
                            color: postState.isDateVisible
                                ? AppColors.primaryColor
                                : Colors.grey.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: FittedBox(
                            child: Text(
                              ' Date ',
                              style: TextStyle(
                                color: !postState.isDateVisible
                                    ? Colors.black
                                    : Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          BlocProvider.of<PostCubit>(context).setStateVariables(
                              isNameVisible: !(postState.isNameVisible));
                        },
                        child: Container(
                          height: 45,
                          width: 45,
                          decoration: BoxDecoration(
                            color: postState.isNameVisible
                                ? AppColors.primaryColor
                                : Colors.grey.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: FittedBox(
                            child: Text(
                              ' Name ',
                              style: TextStyle(
                                  color: !postState.isNameVisible
                                      ? Colors.black
                                      : Colors.white),
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          BlocProvider.of<PostCubit>(context).setStateVariables(
                              isOccupationVisible:
                                  !postState.isOccupationVisible);
                        },
                        child: Container(
                          height: 45,
                          width: 45,
                          decoration: BoxDecoration(
                            color: postState.isOccupationVisible
                                ? AppColors.primaryColor
                                : Colors.grey.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Icon(
                            Icons.work,
                            size: 15,
                            color: !postState.isOccupationVisible
                                ? Colors.black
                                : Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        onTap: () {
                          BlocProvider.of<PostCubit>(context).setStateVariables(
                              isNumberVisible: !postState.isNumberVisible);
                        },
                        child: Container(
                          height: 45,
                          width: 45,
                          decoration: BoxDecoration(
                            color: postState.isNumberVisible
                                ? AppColors.primaryColor
                                : Colors.grey.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Icon(
                            Icons.phone,
                            size: 15,
                            color: !postState.isNumberVisible
                                ? Colors.black
                                : Colors.white,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          BlocProvider.of<PostCubit>(context).setStateVariables(
                              isProfileVisible: !postState.isProfileVisible);
                        },
                        child: Container(
                          height: 45,
                          width: 45,
                          decoration: BoxDecoration(
                            color: postState.isProfileVisible
                                ? AppColors.primaryColor
                                : Colors.grey.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Icon(
                            Icons.person,
                            size: 15,
                            color: !postState.isProfileVisible
                                ? Colors.black
                                : Colors.white,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          BlocProvider.of<PostCubit>(context).setStateVariables(
                              isFrameVisible: !postState.isFrameVisible);
                        },
                        child: Container(
                          height: 45,
                          width: 45,
                          decoration: BoxDecoration(
                            color: postState.isFrameVisible
                                ? AppColors.primaryColor
                                : Colors.grey.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: FittedBox(
                            child: Text(
                              ' Frame ',
                              style: TextStyle(
                                color: !postState.isFrameVisible
                                    ? Colors.black
                                    : Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 45),
                  SecondryButton(
                      onPressed: () {
                        nextScreenCloseOthers(
                            context, const NavigationWrapper());
                      },
                      buttonText: tr("next")),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          );
        }));
  }

  Container backButton() {
    return Container(
      height: 50,
      width: 50,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.orange,
      ),
      child: const Icon(
        Icons.arrow_back,
        color: Colors.white,
      ),
    );
  }
}
