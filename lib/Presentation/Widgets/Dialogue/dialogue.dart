import 'dart:io';

// // import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../Constants/constants.dart';
import '../../../Logic/Cubit/user_cubit/user_cubit.dart';
import '../Buttons/gradient_primary_button.dart';
import '../loading_builder.dart';

showPremiumCustomDialogue(
    {required BuildContext context,
    // required Widget title,
    required String title,
    String? buttonText,
    String? image,
    required Size mq,
    required void Function() onTap,
    bool isGreenGradientButton = false,
    bool showSpecilOfferImage = true,
    List<Widget>? actions}) {
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              children: [
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                const SizedBox(height: 15),
                image == null
                    ? const SizedBox.shrink()
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: SizedBox(
                          height: 150,
                          child: image.startsWith("http")
                              ? Image.network(
                                  image,
                                  fit: isGreenGradientButton
                                      ? BoxFit.fitWidth
                                      : BoxFit.fitHeight,
                                  loadingBuilder: loadingBuilder,
                                )
                              : Image.file(
                                  File(image),
                                  fit: BoxFit.fitHeight,
                                ),
                        ),
                      ),
                const SizedBox(height: 15),
                Visibility(
                  visible: showSpecilOfferImage,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: SizedBox(
                        width: mq.width * 0.8,
                        child: CachedNetworkImage(
                          imageUrl: (getLocale() == "en"
                                  ? BlocProvider.of<UserCubit>(context)
                                      .state
                                      .premiumPlan
                                      ?.image
                                  : BlocProvider.of<UserCubit>(context)
                                      .state
                                      .premiumPlan
                                      ?.imageHindi) ??
                              "",
                          fit: BoxFit.fitWidth,
                        )),
                  ),
                ),
                const SizedBox(height: 15),
                PrimaryButtonGradient(
                    isGreenGradient: isGreenGradientButton,
                    // mq: mq,
                    isLoading: false,
                    onPressed: onTap,
                    buttonText: buttonText ?? tr("buy_premium")),
                const SizedBox(height: 15),
              ],
            ),
          ),
        );
      });
}

// showSupportDialogue(
//     {required BuildContext context,
//     // required Widget title,
//     required String title,
//     String? buttonText,
//     String? image,
//     required Size mq,
//     required void Function() onTap,
//     bool isGreenGradientButton = false,
//     bool showSpecilOfferImage = true,
//     List<Widget>? actions}) {
//   return AwesomeDialog(
//     context: context,
//     animType: AnimType.bottomSlide,
//     dialogType: DialogType.noHeader,
//     showCloseIcon: true,
//     title: title,
//     titleTextStyle: const TextStyle(fontSize: 20, color: Colors.black),
//     body: Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 15),
//       child: Column(
//         children: [
//           Text(
//             title,
//             textAlign: TextAlign.center,
//             style: const TextStyle(
//               fontSize: 15,
//               fontWeight: FontWeight.w300,
//             ),
//           ),
//           const SizedBox(height: 15),
//           image == null
//               ? const SizedBox.shrink()
//               : ClipRRect(
//                   borderRadius: BorderRadius.circular(10),
//                   child: SizedBox(
//                     height: 150,
//                     child: image.startsWith("http")
//                         ? Image.network(
//                             image,
//                             fit: isGreenGradientButton
//                                 ? BoxFit.fitWidth
//                                 : BoxFit.fitHeight,
//                             loadingBuilder: loadingBuilder,
//                           )
//                         : Image.file(
//                             File(image),
//                             fit: BoxFit.fitHeight,
//                           ),
//                   ),
//                 ),
//           const SizedBox(height: 15),
//           Visibility(
//             visible: showSpecilOfferImage,
//             child: ClipRRect(
//               borderRadius: BorderRadius.circular(10),
//               child: SizedBox(
//                   width: mq.width * 0.8,
//                   child: CachedNetworkImage(
//                     imageUrl: (getLocale() == "en"
//                             ? BlocProvider.of<UserCubit>(context)
//                                 .state
//                                 .premiumPlan
//                                 ?.image
//                             : BlocProvider.of<UserCubit>(context)
//                                 .state
//                                 .premiumPlan
//                                 ?.imageHindi) ??
//                         "",
//                     fit: BoxFit.fitWidth,
//                   )),
//             ),
//           ),
//           const SizedBox(height: 15),
//           PrimaryButtonGradient(
//               isGreenGradient: isGreenGradientButton,
//               // mq: mq,
//               isLoading: false,
//               onPressed: onTap,
//               buttonText: buttonText ?? tr("buy_premium")),
//           const SizedBox(height: 15),
//           Row(
//             children: [
//               const Spacer(),
//               TextButton(
//                 onPressed: () async {
//                   const url = 'tel:${6264295091}';

//                   if (await canLaunchUrl(Uri.parse(url))) {
//                     await launchUrl(Uri.parse(url));
//                   }
//                 },
//                 child: Row(
//                   children: [
//                     Text(
//                       tr("contact_to_support"),
//                       style: const TextStyle(
//                         fontSize: 15,
//                         color: Colors.black,
//                       ),
//                     ),
//                     const Padding(
//                       padding: EdgeInsets.symmetric(horizontal: 3),
//                       child: Icon(
//                         Icons.call,
//                         color: Colors.black,
//                         size: 15,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               const Spacer(),
//               InkWell(
//                 onTap: () async {
//                   final userState =
//                       BlocProvider.of<UserCubit>(context, listen: false).state;
//                   const String phone = '+91 6264295091';
//                   final String message =
//                       "I am facing issue with *Rishteyy Payment Subscription*. Please help me. \n Name: ${userState.userName}\n Number: ${userState.userNumber} \n Id: RST24000${userState.userId} ";
//                   final url = 'whatsapp://send?phone=$phone&text=$message';

//                   if (await canLaunchUrl(Uri.parse(url))) {
//                     await launchUrl(Uri.parse(url));
//                   } else {}
//                 },
//                 child: SvgPicture.asset(AppImages.whatsapp,
//                     color: Colors.green, height: 20, width: 20),
//               ),
//               const Spacer(),
//             ],
//           ),
//           const SizedBox(height: 15),
//         ],
//       ),
//     ),
//   ).show();
// }

// showUpdateDialogue(
//     {required BuildContext context,
//     // required Widget title,
//     // required String title,
//     String? buttonText,
//     String? image,
//     required Size mq,
//     required void Function() onTap,
//     bool isGreenGradientButton = false,
//     bool showSpecilOfferImage = true,
//     List<Widget>? actions}) {
//   return AwesomeDialog(
//     context: context,
//     animType: AnimType.bottomSlide,
//     dialogType: DialogType.noHeader,
//     showCloseIcon: true,
//     title: tr("please_update_your_app"),
//     titleTextStyle: const TextStyle(fontSize: 20, color: Colors.black),
//     body: Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 15),
//       child: Column(
//         children: [
//           // Text(
//           //   title,
//           //   textAlign: TextAlign.center,
//           //   style: const TextStyle(
//           //     fontSize: 15,
//           //     fontWeight: FontWeight.w300,
//           //   ),
//           // ),
//           const SizedBox(height: 15),
//           image == null
//               ? const SizedBox.shrink()
//               : ClipRRect(
//                   borderRadius: BorderRadius.circular(10),
//                   child: SizedBox(
//                     height: 150,
//                     child: image.startsWith("http")
//                         ? Image.network(
//                             image,
//                             fit: isGreenGradientButton
//                                 ? BoxFit.fitWidth
//                                 : BoxFit.fitHeight,
//                             loadingBuilder: loadingBuilder,
//                           )
//                         : Image.file(
//                             File(image),
//                             fit: BoxFit.fitHeight,
//                           ),
//                   ),
//                 ),
//           const SizedBox(height: 15),
//           Visibility(
//             visible: showSpecilOfferImage,
//             child: ClipRRect(
//               borderRadius: BorderRadius.circular(10),
//               child: SizedBox(
//                   width: mq.width * 0.8,
//                   child: CachedNetworkImage(
//                     imageUrl: (getLocale() == "en"
//                             ? BlocProvider.of<UserCubit>(context)
//                                 .state
//                                 .premiumPlan
//                                 ?.image
//                             : BlocProvider.of<UserCubit>(context)
//                                 .state
//                                 .premiumPlan
//                                 ?.imageHindi) ??
//                         "",
//                     fit: BoxFit.fitWidth,
//                   )),
//             ),
//           ),
//           const SizedBox(height: 15),
//           PrimaryButtonGradient(
//               isGreenGradient: isGreenGradientButton,
//               // mq: mq,
//               isLoading: false,
//               onPressed: onTap,
//               buttonText: buttonText ?? tr("please_update_your_app")),
//           const SizedBox(height: 15),
//           // Row(
//           //   children: [
//           //     const Spacer(),
//           //     TextButton(
//           //       onPressed: () async {
//           //         const url = 'tel:${6264295091}';

//           //         if (await canLaunchUrl(Uri.parse(url))) {
//           //           await launchUrl(Uri.parse(url));
//           //         }
//           //       },
//           //       child: Row(
//           //         children: [
//           //           Text(
//           //             tr("contact_to_support"),
//           //             style: const TextStyle(
//           //               fontSize: 15,
//           //               color: Colors.black,
//           //             ),
//           //           ),
//           //           const Padding(
//           //             padding: EdgeInsets.symmetric(horizontal: 3),
//           //             child: Icon(
//           //               Icons.call,
//           //               color: Colors.black,
//           //               size: 15,
//           //             ),
//           //           ),
//           //         ],
//           //       ),
//           //     ),
//           //     // const Spacer(),
//           //     // // InkWell(
//           //     // //   onTap: () async {
//           //     // //     final userState =
//           //     // //         BlocProvider.of<UserCubit>(context, listen: false).state;
//           //     // //     const String phone = '+91 6264295091';
//           //     // //     final String message =
//           //     // //         "I am facing issue with *Rishteyy Payment Subscription*. Please help me. \n Name: ${userState.userName}\n Number: ${userState.userNumber} \n Id: RST24000${userState.userId} ";
//           //     // //     final url = 'whatsapp://send?phone=$phone&text=$message';

//           //     // //     if (await canLaunchUrl(Uri.parse(url))) {
//           //     // //       await launchUrl(Uri.parse(url));
//           //     // //     } else {}
//           //     // //   },
//           //     // //   child: SvgPicture.asset(AppImages.whatsapp,
//           //     // //       color: Colors.green, height: 20, width: 20),
//           //     // // ),
//           //     // const Spacer(),
//           //   ],
//           // ),
//           // const SizedBox(height: 15),
//         ],
//       ),
//     ),
//   ).show();
// }

// showGeneralDialogue(
//     {required BuildContext context,
//     String? title,
//     // required String title,
//     String? buttonText,
//     String? image,
//     String? description,
//     required Size mq,
//     required void Function() onTap,
//     bool isGreenGradientButton = false,
//     bool showSpecilOfferImage = true,
//     List<Widget>? actions}) {
//   return AwesomeDialog(
//     context: context,
//     animType: AnimType.bottomSlide,
//     dialogType: DialogType.noHeader,
//     showCloseIcon: true,
//     title: title,
//     titleTextStyle: const TextStyle(fontSize: 20, color: Colors.black),
//     body: Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 15),
//       child: Column(
//         children: [
//           const SizedBox(height: 15),
//           image == null
//               ? const SizedBox.shrink()
//               : ClipRRect(
//                   borderRadius: BorderRadius.circular(10),
//                   child: SizedBox(
//                     height: 150,
//                     child: image.startsWith("http")
//                         ? Image.network(
//                             image,
//                             fit: isGreenGradientButton
//                                 ? BoxFit.fitWidth
//                                 : BoxFit.fitHeight,
//                             loadingBuilder: loadingBuilder,
//                           )
//                         : Image.file(
//                             File(image),
//                             fit: BoxFit.fitHeight,
//                           ),
//                   ),
//                 ),
//           const SizedBox(height: 15),
//           Text(
//             description ?? "",
//             textAlign: TextAlign.center,
//             style: const TextStyle(
//               color: Colors.black,
//               fontSize: 15,
//             ),
//           ),
//           SizedBox(
//             height: 100,
//             width: 100,
//             child: Lottie.asset("assets/images/call.json", fit: BoxFit.cover),
//           ),
//           const SizedBox(height: 15),
//           PrimaryButtonGradient(
//               isGreenGradient: isGreenGradientButton,
//               // mq: mq,
//               isLoading: false,
//               onPressed: onTap,
//               buttonText: buttonText ?? tr("please_update_your_app")),
//           const SizedBox(height: 15),
//         ],
//       ),
//     ),
//   ).show();
// }
