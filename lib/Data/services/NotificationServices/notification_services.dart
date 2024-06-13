// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

import '../../../Presentation/Screens/specific_category_screen.dart';
import '../../../Presentation/app.dart';
import '../secure_storage.dart'; 

class NotificationServices {
  final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initNotification() async {
    AndroidInitializationSettings initializationSettingsAndroid =
        const AndroidInitializationSettings("app_icon");
    var initilizationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );
    await notificationsPlugin.initialize(
      initilizationSettings,
      onDidReceiveNotificationResponse:
          (NotificationResponse notificationResponse) async {
        if (DateTime.now().hour < 12) {
          await MyApp.navigatorKey.currentState?.push(MaterialPageRoute(
              builder: (context) => const SpecificCategoryScreen(
                    categoryTitleEnglish: 'Good Morning',
                    categoryTitleHindi: 'शुभ प्रभात',
                    postId: '9',
                  )));
        } else {
          await MyApp.navigatorKey.currentState?.push(MaterialPageRoute(
              builder: (context) => const SpecificCategoryScreen(
                    categoryTitleEnglish: 'Good Night',
                    categoryTitleHindi: 'शुभ रात्रि',
                    postId: '1',
                  )));
        }
      },
    ).onError((error, stackTrace) {
      return null;
    });
  }

  notificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        "default_notification_channel_id",
        "channelName",
        importance: Importance.max,
        largeIcon: DrawableResourceAndroidBitmap("app_icon"),
        priority: Priority.high,
        showWhen: true,
        visibility: NotificationVisibility.public,
        enableVibration: true,
        enableLights: true,
        playSound: true,
        styleInformation: BigPictureStyleInformation(
          DrawableResourceAndroidBitmap("app_icon"),
        ),
      ),
      // sound: RawResourceAndroidNotificationSound("notification"),
    );
  }

  // show notificaion function
  Future<void> showNotification(
      {int id = 0, String? title, String? body, String? payload}) async {
    await notificationsPlugin
        .show(id, title, body, await notificationDetails(), payload: payload)
        .onError((error, stackTrace) {
      // log("****NotificationServices****showNotification***$error****$stackTrace***************");
    }).then((val) {
      // scheduleNotification();
    });
  }

  Future scheduleNotification(
      {int id = 0,
      String? title,
      String? body,
      String? payload,
      required DateTime scheduleNotificationDateTime}) async {
    return notificationsPlugin
        .zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(
        scheduleNotificationDateTime,
        tz.local,
      ),
      await notificationDetails(),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    )
        .then((value) {
      // schedulePeriodicallyNotification();
    });
  }

  Future createMorningReminderNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
  }) async {
    return notificationsPlugin
        .showDailyAtTime(
            id, "title", "body", const Time(7, 0, 0), notificationDetails())
        .then((value) {
      SecureStorage storage = SecureStorage();
      storage.storeLocally(key: "MorningNotification", value: "Done");
    });
    // return notificationsPlugin.periodicallyShow(0, 'repeating title',
    //     'repeating body', RepeatInterval.daily, notificationDetails(),
    //     androidAllowWhileIdle: true);
  }

  Future createEveningReminderNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
  }) async {
    return notificationsPlugin
        .showDailyAtTime(
            id, "title", "body", const Time(19, 0, 0), notificationDetails())
        .then((value) {
      SecureStorage storage = SecureStorage();
      storage.storeLocally(key: "EveningNotification", value: "Done");
    });
    // return notificationsPlugin.periodicallyShow(0, 'repeating title',
    //     'repeating body', RepeatInterval.daily, notificationDetails(),
    //     androidAllowWhileIdle: true);
  }

  Future<void> cancelNotification(int id) async {
    await notificationsPlugin.cancel(id);
  }
}
