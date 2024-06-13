import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:overlay_support/overlay_support.dart'; 
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../Constants/colors.dart';
import '../../../Constants/constants.dart';
import '../../../Constants/locations.dart';
import '../../../Data/services/secure_storage.dart';
import '../../../Logic/Cubit/user_cubit/user_cubit.dart';
import '../../../Utility/common.dart';
import '../../../Utility/next_screen.dart';
import '../PremiumPlanScreens/premium_plan_list_screen.dart';
import '../PremiumPlanScreens/premium_plan_screen.dart';
import '../language_selection_screen.dart';
import '../login.screen.dart';
import '../profile.screen.dart';
import 'donate.screen.dart';
import 'rating_screen.dart';

class MenuScreen extends StatefulWidget {
  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  
  Future<void> clearSecureScreen() async {
    try {
      await FlutterWindowManager.clearFlags(FlutterWindowManager.FLAG_SECURE);
    } catch (e) {}
  }

  Future<void> secureScreen() async {
    try {
      if (BlocProvider.of<UserCubit>(context).state.isPremiumUser == false) {
        await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
      }
    } catch (e) {}
  }

  @override
  void initState() {
    clearSecureScreen();
    // getPackageInfo();
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    secureScreen();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Menu',
            style: TextStyle(
              fontSize: 20,
              color: Colors.black,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: SizedBox(
            height: mq.height - (100),
            child: BlocBuilder<UserCubit, UserState>(builder: (context, state) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: ListTile(
                      leading: Container(
                        clipBehavior: Clip.antiAlias,
                        height: 50,
                        width: 50,
                        decoration: const BoxDecoration(
                          // borderRadius: BorderRadius.circular(5),
                          shape: BoxShape.circle,
                        ),
                        child: Image.file(
                          File(state.fileImagePath),
                          fit: BoxFit.cover,
                        ),
                      ),
                      title: Text(
                        state.userName,
                        style: const TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      trailing: Column(
                        children: [
                          IconButton(
                              onPressed: () {
                                nextScreenWithFadeAnimation(
                                    context, const ProfileScreen());
                              },
                              icon: Column(
                                children: const [
                                  Icon(
                                    Icons.edit,
                                    color: AppColors.primaryColor,
                                  ),
                                  Text(
                                    'Edit',
                                    style: TextStyle(
                                      color: AppColors.primaryColor,
                                      fontSize: 10,
                                    ),
                                  ),
                                ],
                              )),
                        ],
                      ),
                      subtitle: Text(
                        "+91 ${state.userNumber}",
                        style: const TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      // selected: true,
                    ),
                  ),
                  menuContents(
                      title: "Rishteyy Premium",
                      icon: Icons.abc,
                      customIcon: Container(
                        height: 30,
                        color: Colors.white,
                        // width: 75,
                        // decoration: BoxDecoration(
                        //   borderRadius: BorderRadius.circular(4),
                        //   color: Colors.orange,
                        // ),
                        child: Center(
                            child: Image.asset(
                          getLocale() == "en"
                              ? AppImages.premiumPromoEn
                              : AppImages.premiumPromoHi,
                          fit: BoxFit.fitHeight,
                        )),
                      ),
                      onTap: (() {
                        if (BlocProvider.of<UserCubit>(context, listen: false)
                            .state
                            .isPremiumUser) {
                          nextScreenWithFadeAnimation(
                              context, const PremiumPlanListScreen());
                        } else {
                          nextScreenWithFadeAnimation(
                              context, const PremiumPlanScreen());
                        }
                      })),
                  divider(),
                  menuContents(
                      title: tr('rate_us'),
                      icon: Icons.star_border,
                      onTap: (() {
                        nextScreenWithFadeAnimation(context, RatingScreen());
                      })),
                  divider(),
                  menuContents(
                      title: tr('donate_us'),
                      icon: Icons.currency_rupee,
                      onTap: (() {
                        nextScreenWithFadeAnimation(
                            context, const DonateScreen());
                      })),
                  divider(),
                  menuContents(
                      title: tr('help_support'),
                      icon: Icons.whatsapp,
                      customIcon: const Icon(
                        Icons.whatsapp,
                        color: Colors.green,
                      ),
                      onTap: (() async {
                        try {
                          String url = "https://connectup.in/rishteyy/support";
                          if (await canLaunchUrl(Uri.parse(url))) {
                            await launchUrl(Uri.parse(url),
                                mode: LaunchMode.externalApplication);
                          }
                        } catch (e) {}
                      })),
                  divider(),
                  menuContents(
                      title: tr('switch_language'),
                      icon: Icons.language,
                      onTap: (() {
                        nextScreenWithFadeAnimation(
                            context,
                            const LanguageSelectionScreen(
                              isOnlySwitchLanguage: true,
                            ));
                      })),
                  divider(),
                  menuContents(
                      title: tr('refer_friend'),
                      icon: Icons.share,
                      onTap: (() async {
                        await Share.share(
                            "https://play.google.com/store/apps/details?id=com.aeonian.rishteyy",
                            subject: getOldPromotionLink());
                      })),
                  divider(),
                  menuContents(
                      title: tr('logout'),
                      icon: Icons.logout,
                      onTap: (() {
                        AwesomeDialog(
                          context: context, showCloseIcon: true,
                          dialogType: DialogType.warning,
                          animType:
                              AnimType.bottomSlide, //awesome_dialog: ^2.1.1
                          // title: ,
                          body: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: Text(
                              tr("app_data_delete_warning"),
                              style: const TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          ),
                          btnOkText: 'Ok',
                          // btnOkColor: Theme.of(context).primaryColor,
                          btnCancelText: "Cancel",

                          btnCancelColor: AppColors.primaryColor,
                          btnOkColor: Colors.grey,
                          btnCancelOnPress: (() {}),

                          btnOkOnPress: () async {
                            nextScreenCloseOthers(context, const LoginScreen());
                            BlocProvider.of<UserCubit>(context)
                                .updateStateVariables(
                                    fileImagePath: "", profileImagesList: []);
                            SecureStorage storage = SecureStorage();

                            await storage.saveProfilePhotos([]);

                            toast("Loggedout");
                          },
                        ).show();
                      })),
                  divider(),
                  const Expanded(child: SizedBox()),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: TextButton(
                      onPressed: (() async {
                        try {
                          if (await canLaunchUrl(Uri.parse(
                              "https://connectup.in/rishteyy/privacypolicy"))) {
                            await launchUrl(
                              Uri.parse(
                                  "https://connectup.in/rishteyy/privacypolicy"),
                              mode: LaunchMode.inAppWebView,
                            );
                          }
                        } catch (e) {}
                      }),
                      child: const Text(
                        'Privacy Policy',
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),

                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: TextButton(
                      onPressed: null,
                      child: Text(
                        'App Version:- ${GlobalVariables.appVersionInD}',
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  // divider(),
                  // divider(),
                  // divider(),
                ],
              );
            }),
          ),
        ));
  }

  Divider divider() {
    return const Divider(
      height: 1,
      color: Color(0x449E9E9E),
      thickness: 1,
    );
  }

  Widget menuContents(
      {required String title,
      required IconData icon,
      Widget? customIcon,
      required void Function() onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: InkWell(
        // enableFeedback: false,
        // splashColor: Colors.transparent,
        // splashFactory: NoSplash.splashFactory,
        onTap: onTap,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(),
              ),
              customIcon ?? Icon(icon)
            ],
          ),
        ),
      ),
    );
  }
}
