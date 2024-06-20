import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Constants/constants.dart';
import '../../Data/model/ObjectModels/post_widget_model.dart';
import '../../Logic/Cubit/Posts/posts_cubit.dart';
import '../../Logic/Cubit/user_cubit/user_cubit.dart';
import '../../Utility/common.dart';
import '../../Utility/next_screen.dart';
import '../Screens/OtherScreens/donate.screen.dart';
import '../Screens/OtherScreens/rating_screen.dart';
import 'post_widget.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  // SecureStorage storage = SecureStorage();

  // TextEditingController numberController = TextEditingController(text: "");
  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    PostWidgetModel postWidgetData = PostWidgetModel(
      index: 1,
      imageLink: "assets/images/example.jpg",
      postId: "1",
      profilePos: "right",
      profileShape: "round",
      tagColor: "white",
      playStoreBadgePos: "right",
      showName: true,
      showProfile: true,
    );
    return Drawer(
      width: mq.width * 0.8,
      backgroundColor: Colors.transparent,
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(45),
          bottomRight: Radius.circular(45),
        ),
        child: BlocBuilder<UserCubit, UserState>(builder: (context, userState) {
          return Container(
            color: Colors.white,
            child: ListView(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              children: <Widget>[
                const SizedBox(height: 15),
                BlocBuilder<PostCubit, PostState>(
                    builder: (context, postState) {
                  return SizedBox(
                    width: mq.width * 0.8,
                    child: Column(
                      children: [
                        Column(
                          // alignment: Alignment.bottomCenter,
                          children: [
                            Container(
                              child: Transform.scale(
                                scale: 0.7,
                                child: PostWidget(
                                  isOnlyForControll: true,
                                  postWidgetData: postWidgetData,
                                  showEditAndShare: false,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: TextButton(
                                onPressed: () async {
                                  Uri uri = Uri.parse(
                                      "https://play.google.com/store/apps/details?id=com.aeonian.rishteyy");
                                  if (await canLaunchUrl(uri)) {
                                    launchUrl(uri,
                                        mode: LaunchMode.externalApplication);
                                  }
                                },
                                child: const Text(
                                  "Download Rishteyy App to make this type of post",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    backgroundColor: Colors.white,
                                    fontSize: 15,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 5),

                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        //   children: [
                        //     InkWell(
                        //       onTap: () {
                        //         BlocProvider.of<PostCubit>(context)
                        //             .setStateVariables(
                        //                 isDateVisible:
                        //                     !postState.isDateVisible);
                        //       },
                        //       child: Container(
                        //         height: 45,
                        //         width: 45,
                        //         decoration: BoxDecoration(
                        //           color: postState.isDateVisible
                        //               ? AppColors.primaryColor
                        //               : Colors.grey.withOpacity(0.5),
                        //           borderRadius: BorderRadius.circular(4),
                        //         ),
                        //         child: FittedBox(
                        //           child: Text(
                        //             ' Date ',
                        //             style: TextStyle(
                        //               color: !postState.isDateVisible
                        //                   ? Colors.black
                        //                   : Colors.white,
                        //             ),
                        //           ),
                        //         ),
                        //       ),
                        //     ),
                        //     InkWell(
                        //       onTap: () {
                        //         BlocProvider.of<PostCubit>(context)
                        //             .setStateVariables(
                        //                 isNameVisible:
                        //                     !(postState.isNameVisible));
                        //       },
                        //       child: Container(
                        //         height: 45,
                        //         width: 45,
                        //         decoration: BoxDecoration(
                        //           color: postState.isNameVisible
                        //               ? AppColors.primaryColor
                        //               : Colors.grey.withOpacity(0.5),
                        //           borderRadius: BorderRadius.circular(4),
                        //         ),
                        //         child: FittedBox(
                        //           child: Text(
                        //             ' Name ',
                        //             style: TextStyle(
                        //                 color: !postState.isNameVisible
                        //                     ? Colors.black
                        //                     : Colors.white),
                        //           ),
                        //         ),
                        //       ),
                        //     ),
                        //     InkWell(
                        //       onTap: () {
                        //         BlocProvider.of<PostCubit>(context)
                        //             .setStateVariables(
                        //                 isOccupationVisible:
                        //                     !postState.isOccupationVisible);
                        //       },
                        //       child: Container(
                        //         height: 45,
                        //         width: 45,
                        //         decoration: BoxDecoration(
                        //           color: postState.isOccupationVisible
                        //               ? AppColors.primaryColor
                        //               : Colors.grey.withOpacity(0.5),
                        //           borderRadius: BorderRadius.circular(4),
                        //         ),
                        //         child: Icon(
                        //           Icons.work,
                        //           size: 15,
                        //           color: !postState.isOccupationVisible
                        //               ? Colors.black
                        //               : Colors.white,
                        //         ),
                        //       ),
                        //     ),
                        //   ],
                        // ),

                        // const SizedBox(height: 15),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        //   children: [
                        //     InkWell(
                        //       onTap: () {
                        //         BlocProvider.of<PostCubit>(context)
                        //             .setStateVariables(
                        //                 isNumberVisible:
                        //                     !postState.isNumberVisible);
                        //       },
                        //       child: Container(
                        //         height: 45,
                        //         width: 45,
                        //         decoration: BoxDecoration(
                        //           color: postState.isNumberVisible
                        //               ? AppColors.primaryColor
                        //               : Colors.grey.withOpacity(0.5),
                        //           borderRadius: BorderRadius.circular(4),
                        //         ),
                        //         child: Icon(
                        //           Icons.phone,
                        //           size: 15,
                        //           color: !postState.isNumberVisible
                        //               ? Colors.black
                        //               : Colors.white,
                        //         ),
                        //       ),
                        //     ),
                        //     InkWell(
                        //       onTap: () {
                        //         BlocProvider.of<PostCubit>(context)
                        //             .setStateVariables(
                        //                 isProfileVisible:
                        //                     !postState.isProfileVisible);
                        //       },
                        //       child: Container(
                        //         height: 45,
                        //         width: 45,
                        //         decoration: BoxDecoration(
                        //           color: postState.isProfileVisible
                        //               ? AppColors.primaryColor
                        //               : Colors.grey.withOpacity(0.5),
                        //           borderRadius: BorderRadius.circular(4),
                        //         ),
                        //         child: Icon(
                        //           Icons.person,
                        //           size: 15,
                        //           color: !postState.isProfileVisible
                        //               ? Colors.black
                        //               : Colors.white,
                        //         ),
                        //       ),
                        //     ),
                        //     InkWell(
                        //       onTap: () {
                        //         BlocProvider.of<PostCubit>(context)
                        //             .setStateVariables(
                        //                 isFrameVisible:
                        //                     !postState.isFrameVisible);
                        //       },
                        //       child: Container(
                        //         height: 45,
                        //         width: 45,
                        //         decoration: BoxDecoration(
                        //           color: postState.isFrameVisible
                        //               ? AppColors.primaryColor
                        //               : Colors.grey.withOpacity(0.5),
                        //           borderRadius: BorderRadius.circular(4),
                        //         ),
                        //         child: FittedBox(
                        //           child: Text(
                        //             ' Frame ',
                        //             style: TextStyle(
                        //               color: !postState.isFrameVisible
                        //                   ? Colors.black
                        //                   : Colors.white,
                        //             ),
                        //           ),
                        //         ),
                        //       ),
                        //     ),
                        //   ],
                        // ),

                        const SizedBox(height: 15),

                        InkWell(
                          onTap: () async {
                            await Share.share(appLink,
                                subject: getOldPromotionLink());
                          },
                          child: ListTile(
                            leading: const Icon(Icons.people),
                            title: Text(tr('refer_friend')),
                            // trailing: IconButton(
                            //   tooltip: "Copy app link",
                            //   onPressed: () {
                            //     toast("Link Copied!");
                            //     Clipboard.setData(const ClipboardData(
                            //         text:
                            //             "https://play.google.com/store/apps/details?id=com.aeonian.rishteyy"));
                            //   },
                            //   icon: const Icon(
                            //     Icons.copy,
                            //     size: 20,
                            //     color: Colors.black,
                            //   ),
                            // ),
                          ),
                        ),

                        // Row(
                        //   children: [
                        //     InkWell(
                        //       onTap: () {
                        //         // postCubit.setStateVariables(
                        //         //     isOccupationVisible:
                        //         //         !postState.isOccupationVisible);
                        //       },
                        //       child: Container(
                        //         height: 45,
                        //         width: 45,
                        //         decoration: BoxDecoration(
                        //           color: postState.showOccupation
                        //               ? AppColors.primaryColor
                        //               : Colors.grey.withOpacity(0.5),
                        //           borderRadius: BorderRadius.circular(4),
                        //         ),
                        //         child: Icon(
                        //           Icons.work,
                        //           size: 15,
                        //           color: !postState.showOccupation
                        //               ? Colors.black
                        //               : Colors.white,
                        //         ),
                        //       ),
                        //     ),
                        //     InkWell(
                        //       onTap: () {
                        //         // postEditorCubit.updateStateVariables(
                        //         //     isNumberVisible:
                        //         //         !postEditorCubit.state.isNumberVisible);
                        //       },
                        //       child: Container(
                        //         height: 45,
                        //         width: 45,
                        //         decoration: BoxDecoration(
                        //           color: postState.showNumber
                        //               ? AppColors.primaryColor
                        //               : Colors.grey.withOpacity(0.5),
                        //           borderRadius: BorderRadius.circular(4),
                        //         ),
                        //         child: Icon(
                        //           Icons.phone,
                        //           size: 15,
                        //           color: !postState.showNumber
                        //               ? Colors.black
                        //               : Colors.white,
                        //         ),
                        //       ),
                        //     ),
                        //     InkWell(
                        //       onTap: () {
                        //         // postEditorCubit.updateStateVariables(
                        //         //     isProfileVisible:
                        //         //         !postEditorCubit.state.isProfileVisible);
                        //       },
                        //       child: Container(
                        //         height: 45,
                        //         width: 45,
                        //         decoration: BoxDecoration(
                        //           color: postState.isProfileVisible
                        //               ? AppColors.primaryColor
                        //               : Colors.grey.withOpacity(0.5),
                        //           borderRadius: BorderRadius.circular(4),
                        //         ),
                        //         child: Icon(
                        //           Icons.person,
                        //           size: 15,
                        //           color: !postState.isProfileVisible
                        //               ? Colors.black
                        //               : Colors.white,
                        //         ),
                        //       ),
                        //     ),
                        //   ],
                        // ),

                        // InkWell(
                        //   onTap: () {
                        //     nextScreen(
                        //         context,
                        //         const LanguageSelectionScreen(
                        //             isOnlySwitchLanguage: true));
                        //   },
                        //   child: ListTile(
                        //     leading: const Icon(
                        //       Icons.language,
                        //     ),
                        //     title: Text(
                        //       tr('switch_language'),
                        //     ),
                        //   ),
                        // ),

                        // BlocBuilder<PostCubit, PostState>(
                        //     builder: (context, state) {
                        //   return ListTile(
                        //     leading: Icon(
                        //       state.isNameVisible
                        //           ? Icons.visibility
                        //           : Icons.visibility_off_outlined,
                        //     ),
                        //     title: Text(tr('show_name')),
                        //     trailing: Switch.adaptive(
                        //         activeColor: Colors.orange,
                        //         activeTrackColor: Colors.grey.withOpacity(0.5),
                        //         value: state.isNameVisible,
                        //         onChanged: (val) async {
                        //           if (val) {
                        //             SecureStorage storage = SecureStorage();
                        //             storage
                        //                 .storeLocally(
                        //                     key: "SHOW_NAME", value: "")
                        //                 .then((_) {
                        //               BlocProvider.of<PostCubit>(context)
                        //                   .setNameAndProfileStatusInfo();
                        //             });
                        //           } else {
                        //             SecureStorage storage = SecureStorage();
                        //             storage
                        //                 .storeLocally(
                        //                     key: "SHOW_NAME", value: "N")
                        //                 .then((_) {
                        //               BlocProvider.of<PostCubit>(context)
                        //                   .setNameAndProfileStatusInfo();
                        //             });
                        //           }
                        //         }),
                        //   );
                        // }),

                        // BlocBuilder<PostCubit, PostState>(
                        //     builder: (context, state) {
                        //   return ListTile(
                        //     leading: Icon(
                        //       state.isProfileVisible
                        //           ? Icons.visibility
                        //           : Icons.visibility_off_outlined,
                        //       // color: Colors.black,
                        //     ),
                        //     title: Text(
                        //       tr('show_profile'),
                        //     ),
                        //     trailing: Switch.adaptive(
                        //       activeColor: Colors.orange,
                        //       activeTrackColor: Colors.grey.withOpacity(0.5),
                        //       value: state.isProfileVisible,
                        //       onChanged: (val) {
                        //         if (val) {
                        //           SecureStorage storage = SecureStorage();
                        //           storage
                        //               .storeLocally(
                        //                   key: "SHOW_PROFILE", value: "")
                        //               .then((_) {
                        //             BlocProvider.of<PostCubit>(context)
                        //                 .setNameAndProfileStatusInfo();
                        //           });
                        //         } else {
                        //           SecureStorage storage = SecureStorage();
                        //           storage
                        //               .storeLocally(
                        //                   key: "SHOW_PROFILE", value: "N")
                        //               .then((_) {
                        //             BlocProvider.of<PostCubit>(context)
                        //                 .setNameAndProfileStatusInfo();
                        //           });
                        //         }
                        //       },
                        //     ),
                        //   );
                        // }),
                        // BlocBuilder<PostCubit, PostState>(
                        //     builder: (context, state) {
                        //   return ListTile(
                        //     leading: Icon(
                        //       state.showOccupation
                        //           ? Icons.visibility
                        //           : Icons.visibility_off_outlined,
                        //       // color: Colors.black,
                        //     ),
                        //     title: Text(
                        //       tr('show_occupation'),
                        //     ),
                        //     trailing: Switch.adaptive(
                        //       activeColor: Colors.orange,
                        //       activeTrackColor: Colors.grey.withOpacity(0.5),
                        //       value: state.showOccupation,
                        //       onChanged: (val) {
                        //         if (val) {
                        //           storage
                        //               .storeLocally(
                        //                   key: SecureStorage.showOccupationKey,
                        //                   value: "")
                        //               .then((_) {
                        //             BlocProvider.of<PostCubit>(context)
                        //                 .setNameAndProfileStatusInfo();
                        //           });
                        //         } else {
                        //           SecureStorage storage = SecureStorage();
                        //           storage
                        //               .storeLocally(
                        //                   key: SecureStorage.showOccupationKey,
                        //                   value: "N")
                        //               .then((_) {
                        //             BlocProvider.of<PostCubit>(context)
                        //                 .setNameAndProfileStatusInfo();
                        //           });
                        //         }
                        //       },
                        //     ),
                        //   );
                        // }),

                        // BlocBuilder<PostCubit, PostState>(
                        //     builder: (context, state) {
                        //   return ListTile(
                        //     leading: Icon(state.showNumber
                        //         ? Icons.visibility
                        //         : Icons.visibility_off_outlined),
                        //     title: Text(tr("show_number")),
                        //     trailing: Switch.adaptive(
                        //       activeColor: Colors.orange,
                        //       activeTrackColor:
                        //           const Color.fromRGBO(158, 158, 158, 0.5),
                        //       value: state.showNumber,
                        //       onChanged: (val) async {
                        //         if (state.showNumber) {
                        //           storage
                        //               .storeLocally(
                        //                   key: "SHOW_NUMBER", value: "N")
                        //               .then((_) {
                        //             BlocProvider.of<PostCubit>(context)
                        //                 .setNameAndProfileStatusInfo();
                        //           });
                        //         } else {
                        //           SecureStorage storage = SecureStorage();
                        //           // await storage.deleteFromLocalStorage("NUMBER");
                        //           String number =
                        //               await storage.readLocally("NUMBER");
                        //           if (number.isEmpty) {
                        //             AwesomeDialog(
                        //               context: context,
                        //               showCloseIcon: true,
                        //               body: TextFormField(
                        //                 controller: numberController,
                        //                 maxLength: 10,
                        //                 keyboardType: TextInputType.number,
                        //                 inputFormatters: [
                        //                   FilteringTextInputFormatter.digitsOnly
                        //                 ],
                        //                 decoration: const InputDecoration(
                        //                   labelText: "Phone Number",
                        //                   prefix: Text(
                        //                     '+91 ',
                        //                     // style: const TextStyle(),
                        //                   ),
                        //                 ),
                        //               ),
                        //               btnOkText: 'Save',
                        //               btnOkColor: Colors.green,
                        //               btnOkOnPress: () {
                        //                 storage
                        //                     .storeLocally(
                        //                         key: "NUMBER",
                        //                         value: numberController.text)
                        //                     .then((_) {
                        //                   storage
                        //                       .storeLocally(
                        //                           key: "SHOW_NUMBER", value: "")
                        //                       .then((_) {
                        //                     BlocProvider.of<PostCubit>(context)
                        //                         .setNameAndProfileStatusInfo();
                        //                   });
                        //                 });
                        //               },
                        //             ).show();
                        //           } else {
                        //             storage
                        //                 .storeLocally(
                        //                     key: "SHOW_NUMBER", value: "")
                        //                 .then((_) {
                        //               BlocProvider.of<PostCubit>(context)
                        //                   .setNameAndProfileStatusInfo();
                        //             });
                        //           }
                        //         }
                        //       },
                        //     ),
                        //   );
                        // }),

                        InkWell(
                          onTap: () async {
                            String url =
                                "https://connectup.in/rishteyy/support";
                            if (await canLaunchUrl(Uri.parse(url))) {
                              await launchUrl(Uri.parse(url),
                                  mode: LaunchMode.externalApplication);
                            }
                          },
                          child: ListTile(
                            leading: const Icon(
                              Icons.whatsapp_sharp,
                              color: Colors.green,
                            ),
                            title: Text(
                              "${tr('help_support')} 🙏 ",
                            ),
                          ),
                        ),
                        // const SizedBox(height: 15),
                        InkWell(
                          onTap: () async {
                            nextScreenWithFadeAnimation(
                                context, const DonateScreen());
                          },
                          child: ListTile(
                            leading: const Icon(
                              Icons.currency_rupee,
                              color: Color(0xffFF9200),
                            ),
                            title: Text(
                              tr('donate_us'),
                              style: const TextStyle(color: Color(0xffFF9200)),
                            ),
                          ),
                        ),
                        InkWell(
                            onTap: () async {
                              nextScreenWithFadeAnimation(
                                  context, RatingScreen());
                            },
                            child: ListTile(
                                leading: const Icon(
                                  Icons.star_border,
                                  color: Color(0xffFF9200),
                                ),
                                title: Text(
                                  tr('rate_us'),
                                  style:
                                      const TextStyle(color: Color(0xffFF9200)),
                                ))),

                        // Image.asset("assets/images/sticker_3.png"),
                      ],
                    ),
                  );
                }),
              ],
            ),
          );
        }),
      ),
    );
  }
}
