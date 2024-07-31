import 'dart:math';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:gita/Constants/constants.dart';
import 'package:gita/Data/model/api/SeriesPostResponse/gita_post_response.dart';
import 'package:gita/Presentation/Screens/SeriesPosts/GitsGyanScreens/gita_sloke_specific_post_screen.dart';
import 'package:gita/Presentation/app.dart';
import 'package:logger/logger.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../../../Logic/Cubit/SeriesPostCubit/series_post_cubit.dart';
import '../SeriesPosts/GitsGyanScreens/gita_sloke_main_screen.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  static const platform = MethodChannel('com.aeonian.gita/alarm_permission');

  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  @override
  void initState() {
  
    initializeNotifications();

    super.initState();
  }

  FlutterTts flutterTts = FlutterTts();

  void initializeNotifications() async {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@drawable/app_icon');
    final InitializationSettings initializationSettings =
        const InitializationSettings(
      android: initializationSettingsAndroid,
      // iOS: IOSInitializationSettings(),
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse:
          (NotificationResponse notificationResponse) async {
        Logger().i(notificationResponse.payload);
        List<String> parts = notificationResponse.payload!.split('-');
        int adhaya = int.parse(parts[0]);
        int sloke = int.parse(parts[1]);
        if (sloke < 0) {
          sloke = 0;
        }
        await MyApp.navigatorKey.currentState?.push(MaterialPageRoute(
            builder: (context) => GitaGyanSpecificSlokeScreen(
                chaperNo: adhaya.toString(),
                isFromNotification: true,
                tabIndex: sloke - 1,
                flutterTts: flutterTts)));
      },
    );
    tz.initializeTimeZones();
    scheduleDailyNotifications();
  }

  void cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('All notifications have been cancelled')),
    );
  }

  GitaSloke? getRandomSloke() {
    final Map<int, List<GitaSloke>> allSloke =
        BlocProvider.of<SeriesPostCubit>(context).state.allGitaSlokeList;

    if (allSloke.isEmpty) {
      return null;
    }

    // Flatten the map to get a list of all GitaSloke objects
    List<GitaSloke> allSlokeList =
        allSloke.values.expand((list) => list).toList();

    // Check if the list is empty
    if (allSlokeList.isEmpty) {
      return null;
    }

    // Pick a random GitaSloke from the list
    final randomIndex = Random().nextInt(allSlokeList.length);
    return allSlokeList[randomIndex];
  }

  final List<GitaAdhyay> gitaChapters = const [
    GitaAdhyay(
      chapterNo: 1,
      hindiTitle: "अध्याय 1",
      englishTitle: "Adhyay 1",
      hindiTopic: "अर्जुन विषाद योग",
      englishTopic: "Arjuna Vishada Yoga",
    ),
    GitaAdhyay(
      chapterNo: 2,
      hindiTitle: "अध्याय 2",
      englishTitle: "Adhyay 2",
      hindiTopic: "सांख्य योग",
      englishTopic: "Sankhya Yoga",
    ),
    GitaAdhyay(
      chapterNo: 3,
      hindiTitle: "अध्याय 3",
      englishTitle: "Adhyay 3",
      hindiTopic: "कर्म योग",
      englishTopic: "Karma Yoga",
    ),
    GitaAdhyay(
      chapterNo: 4,
      hindiTitle: "अध्याय 4",
      englishTitle: "Adhyay 4",
      hindiTopic: "ज्ञान कर्म संन्यास योग",
      englishTopic: "Jnana Karma Sanyasa Yoga",
    ),
    GitaAdhyay(
      chapterNo: 5,
      hindiTitle: "अध्याय 5",
      englishTitle: "Adhyay 5",
      hindiTopic: "कर्म संन्यास योग",
      englishTopic: "Karma Sanyasa Yoga",
    ),
    GitaAdhyay(
      chapterNo: 6,
      hindiTitle: "अध्याय 6",
      englishTitle: "Adhyay 6",
      hindiTopic: "आत्म संयम योग",
      englishTopic: "Atma Samyama Yoga",
    ),
    GitaAdhyay(
      chapterNo: 7,
      hindiTitle: "अध्याय 7",
      englishTitle: "Adhyay 7",
      hindiTopic: "ज्ञान विज्ञान योग",
      englishTopic: "Jnana Vijnana Yoga",
    ),
    GitaAdhyay(
      chapterNo: 8,
      hindiTitle: "अध्याय 8",
      englishTitle: "Adhyay 8",
      hindiTopic: "अक्षर परब्रह्म योग",
      englishTopic: "Aksara ParaBrahma Yoga",
    ),
    GitaAdhyay(
      chapterNo: 9,
      hindiTitle: "अध्याय 9",
      englishTitle: "Adhyay 9",
      hindiTopic: "राज विद्या राज गुह्य योग",
      englishTopic: "Raja Vidya Raja Guhya Yoga",
    ),
    GitaAdhyay(
      chapterNo: 10,
      hindiTitle: "अध्याय 10",
      englishTitle: "Adhyay 10",
      hindiTopic: "विभूति योग",
      englishTopic: "Vibhooti Yoga",
    ),
    GitaAdhyay(
      chapterNo: 11,
      hindiTitle: "अध्याय 11",
      englishTitle: "Adhyay 11",
      hindiTopic: "विश्वरूप दर्शन योग",
      englishTopic: "Vishwaroopa Darshana Yoga",
    ),
    GitaAdhyay(
      chapterNo: 12,
      hindiTitle: "अध्याय 12",
      englishTitle: "Adhyay 12",
      hindiTopic: "भक्ति योग",
      englishTopic: "Bhakti Yoga",
    ),
    GitaAdhyay(
      chapterNo: 13,
      hindiTitle: "अध्याय 13",
      englishTitle: "Adhyay 13",
      hindiTopic: "क्षेत्र-क्षेत्रज्ञ विभाग योग",
      englishTopic: "Ksetra Ksetrajna Vibhaaga Yoga",
    ),
    GitaAdhyay(
      chapterNo: 14,
      hindiTitle: "अध्याय 14",
      englishTitle: "Adhyay 14",
      hindiTopic: "गुणत्रय विभाग योग",
      englishTopic: "Gunatraya Vibhaga Yoga",
    ),
    GitaAdhyay(
      chapterNo: 15,
      hindiTitle: "अध्याय 15",
      englishTitle: "Adhyay 15",
      hindiTopic: "पुरुषोत्तम योग",
      englishTopic: "Purushottama Yoga",
    ),
    GitaAdhyay(
      chapterNo: 16,
      hindiTitle: "अध्याय 16",
      englishTitle: "Adhyay 16",
      hindiTopic: "दैवासुर सम्पद विभाग योग",
      englishTopic: "Daivasura Sampad Vibhaga Yoga",
    ),
    GitaAdhyay(
      chapterNo: 17,
      hindiTitle: "अध्याय 17",
      englishTitle: "Adhyay 17",
      hindiTopic: "श्रद्धात्रय विभाग योग",
      englishTopic: "Sraddhatraya Vibhaga Yoga",
    ),
    GitaAdhyay(
      chapterNo: 18,
      hindiTitle: "अध्याय 18",
      englishTitle: "Adhyay 18",
      hindiTopic: "मोक्ष सन्यास योग",
      englishTopic: "Moksha Sanyaasa Yoga",
    ),
  ];
  int tillWhatDay = 30;
  void scheduleDailyNotifications() async {
    final now = DateTime.now();
    Time time = _selectedTime != null
        ? Time(_selectedTime!.hour, _selectedTime!.minute)
        : const Time(18, 0, 0); // 6 PM
    for (int i = 0; i < tillWhatDay; i++) {
      Logger().i("message");
      final scheduledDate = DateTime(
          now.year, now.month, now.day + i, time.hour, time.minute + 1);
      Logger().i(scheduledDate);
      final randomSloke = getRandomSloke();
      int gitaChapterIndex = (randomSloke?.chapter ?? 1) - 1;
      if (randomSloke != null) {
        await flutterLocalNotificationsPlugin.zonedSchedule(
            i,
            gitaChapters[gitaChapterIndex].hindiTitle,
            randomSloke.meaning,
            tz.TZDateTime.from(scheduledDate, tz.local),
            NotificationDetails(
              android: AndroidNotificationDetails(
                'gita_app',
                'gita_app1',
                channelDescription:
                    'This notification is to send user daily notification for Reading Bhagwat Geeta',
                importance: Importance.max,
                priority: Priority.high,
                showWhen: false,
                largeIcon:
                    const DrawableResourceAndroidBitmap('@drawable/app_icon'),
                styleInformation: BigPictureStyleInformation(
                  const DrawableResourceAndroidBitmap('@drawable/app_icon'),
                  contentTitle: gitaChapters[gitaChapterIndex].hindiTitle,
                  summaryText: randomSloke.meaning,
                ),
              ),
            ),
            androidAllowWhileIdle: true,
            uiLocalNotificationDateInterpretation:
                UILocalNotificationDateInterpretation.wallClockTime,
            matchDateTimeComponents: DateTimeComponents.time,
            payload:
                "${(randomSloke.chapter ?? 1)}-${(randomSloke.verse ?? 2)}");
      }
    }
  }

  Future<void> requestExactAlarmPermission() async {
    try {
      await platform.invokeMethod('requestExactAlarmPermission');
    } on PlatformException catch (e) {
      print("Failed to request exact alarm permission: ${e.message}");
    }
  }

  Future<void> requestNotificationPermissions() async {
    bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (!isAllowed) {
      await AwesomeNotifications().requestPermissionToSendNotifications();
    }
  }

  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required String imageUrl,
    required DateTime scheduledDate,
  }) async {
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: id,
        channelKey: 'basic_channel',
        title: title,
        body: body,
        // bigPicture: imageUrl,
        notificationLayout: NotificationLayout.BigText,
      ),
      schedule: NotificationCalendar.fromDate(date: scheduledDate),
    );
  }

  TimeOfDay? _selectedTime;

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          title: Text(
            tr('set_notification'),
            style: const TextStyle(
              color: Colors.black,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            //  color:  Colors.white,
            // mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 15),
              Text(tr('_gita_notification_screen_title'),
                  style: const TextStyle(
                    color: Colors.black,
                  )),
              const SizedBox(height: 15),
              InkWell(
                onTap: () {
                  requestNotificationPermissions();
                  requestExactAlarmPermission();
                  tillWhatDay = 5;
                  _selectedTime = TimeOfDay.now();
                  // scheduleDailyNotifications();
                },
                child: Container(
                  width: mq.width * 0.8,
                  // height: mq.width * 0.6,

                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: Gradients.redGradient,
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'One Time\na Day',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 50,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Divider(
                        color: Colors.white,
                        thickness: 1,
                      ),
                      Text(
                        '700 days till\n(Till ${DateFormat("yMMMd").format(DateTime.now().add(
                          const Duration(days: 700),
                        ))})',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 15),

              Row(
                children: [
                  const Spacer(),
                  Container(
                    color: Colors.grey,
                    height: 2,
                    width: mq.width * 0.25,
                  ),
                  const Spacer(),
                  const Text(
                    'OR',
                    style: TextStyle(),
                  ),
                  const Spacer(),
                  Container(
                    color: Colors.grey,
                    height: 2,
                    width: mq.width * 0.25,
                  ),
                  const Spacer(),
                ],
              ),
              const SizedBox(height: 15),
              InkWell(
                onTap: () {},
                child: Container(
                  width: mq.width * 0.8,
                  // height: mq.width * 0.6,

                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: Gradients.blueGradient,
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'Two Times\na Day',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 50,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Divider(
                        color: Colors.white,
                        thickness: 1,
                      ),
                      Text(
                        '350 days till\n(Till ${DateFormat("yMMMd").format(DateTime.now().add(
                          const Duration(days: 350),
                        ))})',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 15),
              const SizedBox(height: 15),
              const SizedBox(height: 15),
              // TextButton(
              //     onPressed: () async {
              //       scheduleDailyNotifications();
              //     },
              //     child: const Text('Renew',
              //         style: TextStyle(
              //           fontSize: 15,
              //           color: Colors.black,
              //         ))),
              TextFormField(
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                      RegExp(r'[0-9]')), // Only digits allowed
                ],
                onChanged: (value) {
                  setState(() {
                    tillWhatDay = int.tryParse(value.toString()) ?? 30;
                  });
                },
              ),
              TextButton(
                onPressed: () {
                  _selectTime(context);
                  // cancelAllNotifications();
                },
                child: const Text(
                  'Select time',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  cancelAllNotifications();
                },
                child: const Text(
                  'Clear all notifications',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
