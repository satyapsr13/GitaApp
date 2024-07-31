import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';

import 'Data/services/secure_storage.dart';
import 'Logic/block_provider.dart';
import 'Presentation/app.dart';
// https://fontawesomeicons.com/flutter/icons

//
// keytool -genkey -v -keystore D:\projects\upload-keystore.jks  -storetype JKS -keyalg RSA -keysize 2048 -validity 10000  -alias upload
/*
Figma link
https://www.figma.com/file/CxZT2MEmc8nfBftLjCkOLX/Rishteyy-UI?node-id=0%3A1&t=PLZ0EGBQ2ptSKcy8-0

 */

// run below command to generate Routes dart file
// flutter packages pub run build_runner watch
//
// To create .aab file flutter
// flutter build appbundle --release
//
// adb uninstall "com.aeonian.rishteyy"
//
// Playstore Link:- https://play.google.com/store/apps/details?id=com.aeonian.rishteyy
//
/*
* */
// const AndroidNotificationChannel channel = AndroidNotificationChannel(
//   "high_importance_channel",
//   "Hign Importance Notifications",
//   importance: Importance.high,
//   playSound: true,
// );
// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//     FlutterLocalNotificationsPlugin();

// Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp();
// }





Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final HydratedStorage hydratedStorage = await HydratedStorage.build(
      storageDirectory: await getApplicationDocumentsDirectory());
  // await Firebase.initializeApp();

  // NotificationServices().initNotification();
  // AwesomeNotifications().initialize(
  //   'resource://drawable/app_icon', // Your app icon resource
  //   [
  //     NotificationChannel(
  //       channelKey: 'basic_channel',
  //       channelName: 'Basic notifications',
  //       channelDescription: 'Notification channel for basic tests',
  //       defaultColor: Color(0xFF9D50DD),
  //       ledColor: Colors.white,
  //       importance: NotificationImportance.High,
  //     )
  //   ],
  // );

  // FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  // final notificationFromFirebase =
  //     await FirebaseMessaging.instance.getInitialMessage();

  // if (notificationFromFirebase != null) {
  //   pathTracker.add("notification");
  // }
  // MobileAds.instance.initialize();

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent));

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  await EasyLocalization.ensureInitialized();
  final secureStorage = SecureStorage();
  bool isLoggedIn = await secureStorage.hasToken();

  var blocProviders = await getBlocProviders(secureStorage, hydratedStorage);

  HydratedBlocOverrides.runZoned(
      () => runApp(EasyLocalization(
          path: 'assets/translation',
          supportedLocales: const [
            Locale('en'),
            Locale('hi'),
            Locale('mr'),
            Locale('gu'),
            Locale('or'),
            Locale('bn'),
            Locale('pa'),
            Locale('ur'),
          ],
          fallbackLocale: const Locale('en'),
          useFallbackTranslations: true,
          child: MyApp(
            blocProviders: blocProviders,
            isLoggedIn: isLoggedIn,
            // notificationFromFirebase: notificationFromFirebase,
          ))),
      storage: hydratedStorage);
}
