// ignore_for_file: prefer_const_constructors, unused_field

import 'package:flutter/material.dart';

class MessagingWidget extends StatefulWidget {
  const MessagingWidget({super.key});

  @override
  State<MessagingWidget> createState() => _MessagingWidgetState();
}

class _MessagingWidgetState extends State<MessagingWidget> {
  // final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  @override
  void initState() {
    super.initState();

    // FirebaseMessaging.onBackgroundMessage((RemoteMessage message) {
    // //  return message.messageId;
    // message.
    // });

    // _firebaseMessaging.getToken().then((String token) {
    //   assert(token != null);
    //   print('Push Messaging token: $token');
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
