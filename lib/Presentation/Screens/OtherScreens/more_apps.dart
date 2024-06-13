
// import 'package:any_link_preview/any_link_preview.dart';
// import 'package:flutter/material.dart';
// import 'package:url_launcher/url_launcher.dart';

// class MoreAppsScreen extends StatefulWidget {
//   const MoreAppsScreen({super.key});

//   @override
//   State<MoreAppsScreen> createState() => _MoreAppsScreenState();
// }

// class _MoreAppsScreenState extends State<MoreAppsScreen> {
//   int showProfile = 0;
//   @override
//   Widget build(BuildContext context) {
//     final mq = MediaQuery.of(context).size;
//     return Scaffold(
//         appBar: AppBar(
//           title: InkWell(
//               onTap: () {
//                 setState(() {
//                   showProfile++;
//                 });
//               },
//               child: const Text('Other Apps')),
//         ),
//         body: SingleChildScrollView(
//           child: Padding(
//             padding: const EdgeInsets.all(20.0),
//             child: Column(
//               children: [
//                 SizedBox(
//                   // width: ,
//                   child: AnyLinkPreview(
//                     link:
//                         "https://play.google.com/store/apps/details?id=com.aeonian.rishteyy",
//                     displayDirection: UIDirection.uiDirectionHorizontal,
//                     // urlLaunchMode: Launch,
//                     cache: const Duration(days: 10),
//                     urlLaunchMode: LaunchMode.externalApplication,

//                     backgroundColor: Colors.grey[300],
//                     errorWidget: Container(
//                       color: Colors.grey[300],
//                       child: const Text('Oops!'),
//                     ),
//                     // errorImage: _errorImage,
//                   ),
//                 ),
//                 const SizedBox(height: 30),
//                 SizedBox(
//                   // width: ,
//                   child: AnyLinkPreview(
//                     link:
//                         "https://play.google.com/store/apps/details?id=com.aeonian.ganeshji",
//                     displayDirection: UIDirection.uiDirectionHorizontal,
//                     // displayDirection: UIDirection.uiDirectionHorizontal,
//                     // urlLaunchMode: Launch,
//                     cache: const Duration(days: 10),
//                     urlLaunchMode: LaunchMode.externalApplication,

//                     backgroundColor: Colors.grey[300],
//                     errorWidget: Container(
//                       color: Colors.grey[300],
//                       child: const Text('Oops!'),
//                     ),
//                     // errorImage: _errorImage,
//                   ),
//                 ),
//                 const SizedBox(height: 30),
//                 SizedBox(
//                   // width: ,
//                   child: AnyLinkPreview(
//                     link: "https://connectup.in/",
//                     displayDirection: UIDirection.uiDirectionHorizontal,
//                     // displayDirection: UIDirection.uiDirectionHorizontal,
//                     // urlLaunchMode: Launch,
//                     cache: const Duration(days: 10),

//                     urlLaunchMode: LaunchMode.externalApplication,

//                     backgroundColor: Colors.grey[300],
//                     errorWidget: Container(
//                       color: Colors.grey[300],
//                       child: const Text('Oops!'),
//                     ),
//                     // errorImage: _errorImage,
//                   ),
//                 ),
//                 const SizedBox(height: 30),
//                 // SizedBox(height: 15),
//                 Visibility(
//                   visible: (showProfile % 4 == 3),
//                   child: Column(
//                     // mainAxisAlignment: MainAxisAlignment.start,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text(
//                         'Developers:- 👇',
//                         style: TextStyle(color: Colors.black, fontSize: 25),
//                       ),
//                       const SizedBox(height: 25),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           SizedBox(
//                             width: mq.width * 0.4,
//                             child: AnyLinkPreview(
//                               link: "https://www.instagram.com/satyapsr13/",
//                               // displayDirection: UIDirection.uiDirectionHorizontal,
//                               // urlLaunchMode: Launch,

//                               urlLaunchMode: LaunchMode.externalApplication,
//                               cache: const Duration(days: 10),

//                               backgroundColor: Colors.grey[300],
//                               errorWidget: Container(
//                                 color: Colors.grey[300],
//                                 child: const Text('Oops!'),
//                               ),
//                               // errorImage: _errorImage,
//                             ),
//                           ),
//                           SizedBox(
//                             width: mq.width * 0.4,
//                             child: AnyLinkPreview(
//                               link: "https://www.instagram.com/meinhoonharsh/",
//                               // displayDirection: UIDirection.uiDirectionHorizontal,
//                               // urlLaunchMode: Launch,

//                               urlLaunchMode: LaunchMode.externalApplication,
//                               cache: const Duration(days: 10),

//                               backgroundColor: Colors.grey[300],
//                               errorWidget: Container(
//                                 color: Colors.grey[300],
//                                 child: const Text('Oops!'),
//                               ),
//                               // errorImage: _errorImage,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(height: 50),
//               ],
//             ),
//           ),
//         ));
//   }
// }

