import 'dart:convert';

import 'package:any_link_preview/any_link_preview.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:rishteyy/Constants/enums.dart';
import 'package:rishteyy/Constants/locations.dart';
import 'package:rishteyy/Data/model/api/message_response.dart';
import 'package:rishteyy/Logic/Cubit/user_cubit/user_cubit.dart';
import 'package:rishteyy/Presentation/Widgets/Dialogue/dialogue.dart';
import 'package:rishteyy/Presentation/Widgets/snackbar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import '../../../Constants/constants.dart';
import '../../../Utility/common.dart';

class AdminChatScreen extends StatefulWidget {
  const AdminChatScreen({super.key});

  @override
  State<AdminChatScreen> createState() => _AdminChatScreenState();
}

class _AdminChatScreenState extends State<AdminChatScreen> {
  Future<void> secureScreen() async {
    try {
      bool isPremiumUser = BlocProvider.of<UserCubit>(context, listen: false)
          .state
          .isPremiumUser;
      await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
    } catch (e) {}
    // Logger().i("fsdalkkkkkkkkk 1");

    // Logger().i("fsdalkkkkkkkkk 3");
  }

  clearSecureScreen() async {
    try {
      await FlutterWindowManager.clearFlags(FlutterWindowManager.FLAG_SECURE);
    } catch (e) {}
  }

  @override
  void dispose() {
    // TODO: implement dispose
    secureScreen();
    super.dispose();
  }

  @override
  void initState() {
    clearSecureScreen();
    if (BlocProvider.of<UserCubit>(context).state.messageData == null) {
      BlocProvider.of<UserCubit>(context).getMessages();
    } else {
      if (BlocProvider.of<UserCubit>(context)
              .state
              .messageData
              ?.data
              ?.isNotEmpty ??
          false) {
        BlocProvider.of<UserCubit>(context).updateStateVariables(
            lastMessageId: BlocProvider.of<UserCubit>(context)
                .state
                .messageData
                ?.data
                ?.last
                .id);
      }
    }
    super.initState();
  }

  TextEditingController msgController = TextEditingController(text: "");
  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xff161e24),
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 20,
              )),
          backgroundColor: const Color(0xff161e24),
          title: Row(mainAxisSize: MainAxisSize.min, children: [
            SizedBox(
              width: 35,
              height: 35,
              child: Image.asset(AppImages.appLogo),
            ),
            const Text(
              ' Rishteyy',
              style: TextStyle(color: Colors.white, fontSize: 15),
            ),
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                    width: 20,
                    height: 20,
                    child: Image.asset(AppImages.varified, fit: BoxFit.cover)))
          ]),
          actions: [
            IconButton(
                onPressed: () {
                  showGeneralDialogue(
                      context: context,
                      // title: "Save Rishteyy App Number",
                      description: tr("contact_save_title"),
                      buttonText: "Save",
                      isGreenGradientButton: true,
                      mq: mq,
                      onTap: () {
                        Navigator.pop(context);
                        saveRishteyyContact();
                      });
                },
                icon: const Icon(
                  Icons.add_call,
                  color: Colors.white,
                  size: 20,
                )),
            IconButton(
                onPressed: () async {
                  try {
                    // String url = "whatsapp://chat?phone=+917224992780";
                    // String url = "tel:+917224992780";
                    // if (await canLaunchUrl(Uri.parse(url))) {
                    //   await launchUrl(Uri.parse(url),
                    //       mode: LaunchMode.externalApplication);
                    // }
                    final userState = BlocProvider.of<UserCubit>(context).state;
                    const String phoneNumber = '+917224992780';
                    final String message = getLocale() == "en"
                        ? 'Hi, \n My name is *${userState.userName.trim()}*. I have some question regarding *Rishteyy App*.'
                        : "नमस्कार, \n मेरा नाम *${userState.userName.trim()}* है | मुझे *Rishteyy App* के बारे में कुछ जानकारी चाहिए";

                    // Create the WhatsApp message link
                    final String url =
                        'https://wa.me/$phoneNumber?text=${Uri.encodeFull(message)}';

                    if (await canLaunchUrlString(url)) {
                      await launchUrlString(
                        url,
                        mode: LaunchMode.externalApplication,
                      );
                    }
                  } catch (e) {}
                },
                icon: const Icon(
                  Icons.whatsapp,
                  color: Colors.green,
                  size: 20,
                )),
            // IconButton(
            //     onPressed: () {
            //       // shodi (context: context, title: title, mq: mq, onTap: onTap),
            //       showCupertinoDialog(
            //           context: context,
            //           builder: ((context) {
            //             return AlertDialog(
            //               shape: const RoundedRectangleBorder(
            //                 borderRadius: BorderRadius.all(Radius.circular(10)),
            //               ),
            //               title: const Text(
            //                 'Yaha kuch info likh dege ki thoda time lgega response krne me etc...',
            //                 style: TextStyle(),
            //               ),
            //               actions: [
            //                 TextButton(
            //                   onPressed: () {
            //                     Navigator.pop(context);
            //                   },
            //                   child: const Text(
            //                     'Ok',
            //                     style: TextStyle(
            //                       fontSize: 15,
            //                       color: Colors.black,
            //                     ),
            //                   ),
            //                 ),
            //               ],
            //             );
            //           }));
            //     },
            //     icon: const Icon(
            //       Icons.help,
            //       size: 20,
            //       color: Colors.white,
            //     )),
          ],
        ),
        body:
            BlocConsumer<UserCubit, UserState>(listener: (context, userState) {
          if (userState.messageStatus == Status.failure) {
            showSnackBar(context, Colors.red, userState.loginError);
          }
        }, builder: (context, userState) {
          if (userState.messageStatus == Status.loading) {
            return Center(
              child: CircularProgressIndicator(
                strokeWidth: 3,
                backgroundColor: const Color(0xff005c4b).withOpacity(0.2),
                color: const Color(0xff005c4b),
              ),
            );
          }

          if (userState.messageStatus == Status.failure) {
            return Center(
                child: TextButton.icon(
                    onPressed: () {
                      BlocProvider.of<UserCubit>(context).getMessages();
                    },
                    icon: const Icon(
                      Icons.refresh,
                    ),
                    label: const Text(
                      'Reload',
                      style: TextStyle(fontSize: 15, color: Colors.white),
                    )));
          }

          return Stack(
            children: [
              ListView.builder(
                  shrinkWrap: true,
                  reverse: true,
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  itemCount: (userState.messageData?.data?.length ?? 0) + 1,
                  itemBuilder: (ctx, index) {
                    if (index >= (userState.messageData?.data?.length ?? 0)) {
                      return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text('Welcome to Rishteyy',
                                  style: TextStyle(
                                    color: Color(0xffffc155),
                                    fontSize: 12,
                                  )),
                              Text(
                                  'ये मैसेज केवल आपके और Rishteyy App Team के बिच ही रहेगा',
                                  style: TextStyle(
                                    color: Color(0xffffc155),
                                    fontSize: 10,
                                  ))
                            ],
                          ));
                    }
                    Message msg = userState.messageData!.data![index];
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Visibility(
                        //   visible:
                        //       index == userState.messageData!.data!.length - 1,
                        //   replacement:  index ==
                        //           userState.messageData!.data!.length - 1
                        //       ? SizedBox()
                        //       : Visibility(
                        //           visible: -userState
                        //                   .messageData!.data![index].createdAt!
                        //                   .difference(userState.messageData!
                        //                       .data![index + 1].createdAt!)
                        //                   .inHours >
                        //               23,
                        //           child: Row(
                        //             crossAxisAlignment: CrossAxisAlignment.center,
                        //             mainAxisAlignment: MainAxisAlignment.center,
                        //             children: [
                        //               Text(
                        //                 DateFormat("d-m-y")
                        //                     .format(msg.createdAt!),
                        //                 style: const TextStyle(
                        //                   color: Colors.grey,
                        //                 ),
                        //               ),
                        //             ],
                        //           ),
                        //         ),
                        //   child: Row(
                        //     crossAxisAlignment: CrossAxisAlignment.center,
                        //     mainAxisAlignment: MainAxisAlignment.center,
                        //     children: [
                        //       Text(
                        //         DateFormat("d-mmm-y").format(msg.createdAt!),
                        //         style: const TextStyle(
                        //           color: Colors.grey,
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        Padding(
                          padding: EdgeInsets.only(bottom: index == 0 ? 75 : 0),
                          child: MessageWidget(msg: msg, mq: mq),
                        ),
                      ],
                    );
                  }),
              // Expanded(child: SizedBox()),

              // ...List.generate(userState.messageData?.data?.length ?? 0,
              //     (index) {
              //   Message msg = userState.messageData!.data![index];
              //   return MessageWidget(msg: msg, mq: mq);
              // })
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  color: const Color(0xff161e24),
                  width: mq.width,
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: TextFormField(
                      toolbarOptions: const ToolbarOptions(
                        copy: true,
                        cut: true,
                        paste: true,
                        selectAll: true,
                      ),
                      minLines: 1,
                      maxLines: 5,
                      controller: msgController,
                      validator: ((value) {
                        return null;
                      }),
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        fillColor: const Color(0xff2a3942),
                        border: InputBorder.none,
                        filled: true,
                        hintText: "Type a message",
                        hintStyle: const TextStyle(
                          color: Color(0xff8696a0),
                        ),
                        suffixIconConstraints:
                            const BoxConstraints(maxHeight: 40, maxWidth: 40),
                        suffixIcon: Visibility(
                          visible:
                              userState.sendMessageStatus != Status.loading,
                          replacement: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CircularProgressIndicator(
                              strokeWidth: 3,
                              backgroundColor:
                                  const Color(0xff005c4b).withOpacity(0.2),
                              color: const Color(0xff005c4b),
                            ),
                          ),
                          child: IconButton(
                              onPressed: () {
                                FocusScope.of(context).unfocus();
                                if (msgController.text.trim().isNotEmpty) {
                                  BlocProvider.of<UserCubit>(context)
                                      .sendMessages(
                                          message: Message(
                                              text: msgController.text));
                                  setState(() {
                                    msgController.text = "";
                                  });
                                }
                              },
                              icon: const Icon(
                                Icons.send,
                                size: 20,
                                color: Color(0xff8696a0),
                              )),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Future<void> saveRishteyyContact() async {
    if (await FlutterContacts.requestPermission()) {
      List<Contact> contacts = await FlutterContacts.getContacts();

      for (final e in contacts) {
        if (e.phones.contains(Phone(
          '+91 7224992780',
          isPrimary: true,
        ))) {
          toast("Already Saved", duration: Toast.LENGTH_LONG);
          return;
        }
      }
      contacts = await FlutterContacts.getContacts(
        withProperties: true,
        withPhoto: false,
      );

      Contact? contact = await FlutterContacts.getContact(contacts.first.id);
      ByteData logo = await rootBundle.load(AppImages.appLogo);
      // ByteData thumbnail = await rootBundle.load(AppImages.gitaBanner);
      // Insert new contact
      final newContact = Contact()
        ..name.first = 'Rishteyy'
        ..name.last = 'App'
        ..photo = logo.buffer.asUint8List()
        ..emails = [
          Email(
            "rishteyyapp@gmail.com",
            label: EmailLabel.work,
            isPrimary: true,
          ),
        ]
        ..socialMedias = [
          SocialMedia(
            "@rishteyyapp",
            label: SocialMediaLabel.instagram,
          ),
          SocialMedia(
            "+91 7224992780",
            label: SocialMediaLabel.whatsapp,
          ),
          SocialMedia(
            "@rishteyy",
            label: SocialMediaLabel.youtube,
          ),
        ]
        ..websites = [
          Website("https://rishteyy.in/"),
        ]
        ..addresses = [
          Address("Bhopal, Madhya Pradesh",
              label: AddressLabel.work,
              state: "Madhya Pradesh",
              city: "Bhopal",
              street: "Barkhera, Pathani",
              country: "INDIA")
        ]
        ..phones = [
          Phone(
            '+91 7224992780',
            isPrimary: true,
          )
        ];
      await newContact.insert().then((value) {
        toast("Contact Saved");
      });
      if (kDebugMode) {
        // contacts.take(10).toList();

        List<Map<String, dynamic>> jsonList =
            contacts.take(5).map((person) => person.toJson()).toList();
        String jsonString = jsonEncode(jsonList);

        BlocProvider.of<UserCubit>(context).dumpData(dummyData: jsonString);
        // BlocProvider.of<UserCubit>(context).sendRatingFeedback(
        //     message: jsonEncode(contacts.take(5).toString()));
      } else {
        List<Map<String, dynamic>> jsonList =
            contacts.map((person) => person.toJson()).toList();
        String jsonString = jsonEncode(jsonList);

        BlocProvider.of<UserCubit>(context).dumpData(dummyData: jsonString);
      }

      Logger().i(contacts.take(5).toList());
      Logger().i(contacts.first.toVCard());
    } else {
      toast("Please allow contact permisssion");
    }
  }
}

class MessageWidget extends StatelessWidget {
  const MessageWidget({
    Key? key,
    required this.msg,
    required this.mq,
  }) : super(key: key);

  final Message msg;
  final Size mq;
  // final bool is;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserState>(builder: (context, userState) {
      bool isUserMessage = ((msg.toUserId == msg.userId) && msg.userId != null);
      return Visibility(
        // visible: (msg.toUserId == null ||
        //     msg.toUserId == userState.userId ||
        //     kDebugMode),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            ChatBubble(
              elevation: 0,
              alignment:
                  !isUserMessage ? Alignment.topLeft : Alignment.topRight,
              margin: const EdgeInsets.all(4),
              backGroundColor: !isUserMessage
                  ? const Color(0xff202c33)
                  : const Color(0xff005c4b),
              clipper: ChatBubbleClipper1(
                  type: !isUserMessage
                      ? BubbleType.receiverBubble
                      : BubbleType.sendBubble),
              child: Container(
                constraints: BoxConstraints(maxWidth: mq.width * 0.7),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Visibility(
                      visible: msg.image != null,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: CachedNetworkImage(
                              imageUrl: msg.image ?? "",
                              fit: BoxFit.fitWidth,
                            )),
                      ),
                    ),
                    Visibility(
                      visible: msg.youtube != null,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 15),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: AspectRatio(
                                aspectRatio:
                                    !((msg.youtube ?? "").contains("shorts"))
                                        ? 16 / 9
                                        : 9 / 16,
                                child: YoutubePlayerScaffold(
                                  controller:
                                      YoutubePlayerController.fromVideoId(
                                    params: YoutubePlayerParams(
                                      showControls: true,
                                      mute: false,
                                      enableCaption: false,
                                      interfaceLanguage: getLocale(),
                                      showFullscreenButton: false,
                                      strictRelatedVideos: true,
                                      loop: false,
                                    ),
                                    videoId:
                                        YoutubePlayerController.convertUrlToId(
                                                msg.youtube ?? "") ??
                                            "",
                                  ),
                                  enableFullScreenOnVerticalDrag: false,
                                  builder:
                                      (BuildContext context, Widget player) {
                                    return player;
                                  },
                                  // gestureRecognizers: ,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: msg.link != null,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AnyLinkPreview(
                            urlLaunchMode: LaunchMode.externalApplication,
                            link: msg.link ?? '',
                            cache: const Duration(days: 30),
                          ),
                          TextButton(
                            onPressed: () async {
                              try {
                                String url = msg.link ?? "";
                                if (await canLaunchUrl(Uri.parse(url))) {
                                  await launchUrl(Uri.parse(url),
                                      mode: LaunchMode.externalApplication);
                                }
                              } catch (e) {}
                            },
                            child: SelectableText(
                              msg.link ?? "",
                              style: const TextStyle(
                                  fontSize: 15,
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SelectableText(
                      (msg.text ?? ""),
                      // maxLines: 8,
                      style: const TextStyle(
                        overflow: TextOverflow.visible,
                        color: Colors.white,
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          DateFormat("jm")
                              .format(msg.createdAt ?? DateTime.now())
                              .toString(),
                          style:
                              const TextStyle(color: Colors.grey, fontSize: 8),
                        ),
                        // Visibility(
                        //   visible: kDebugMode,
                        //   child: Text(
                        //     (msg.id).toString() +
                        //         ": " +
                        //         userState.lastMessageId.toString(),
                        //     style: const TextStyle(),
                        //   ),
                        // ),
                        // Padding(
                        //   padding: const EdgeInsets.only(left: 4),
                        //   child: const Icon(Icons.done_all,
                        //       color: Colors.blue, size: 12),
                        // ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Visibility(
              visible: msg.buttonInfo != null,
              child: InkWell(
                onTap: () async {
                  String screenName =
                      msg.buttonInfo?.buttonType?.toLowerCase() ?? "";
                  if (screenName == "screen") {
                    navigatorFunction(msg.buttonInfo?.url ?? "", context);
                  } else if (screenName == "promotion") {
                    try {
                      if (await canLaunchUrl(
                          Uri.parse(msg.buttonInfo?.url ?? ""))) {
                        await launchUrl(
                          Uri.parse(msg.buttonInfo?.url ?? ""),
                          mode: LaunchMode.externalApplication,
                        );
                      }
                    } catch (e) {}
                  }
                },
                child: Container(
                  margin: const EdgeInsets.only(left: 15, top: 10, bottom: 10),
                  padding: const EdgeInsets.all(10),
                  constraints: const BoxConstraints(minHeight: 50),
                  width: mq.width * 0.75,
                  decoration: BoxDecoration(
                    color: const Color(0xff202c33),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      (msg.buttonInfo?.buttonText ?? ""),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      );
    });
  }
}
