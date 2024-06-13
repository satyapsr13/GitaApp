// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:rishteyy/Presentation/Widgets/post_widget.dart';

import '../../../../Data/model/ObjectModels/post_widget_model.dart';

class NewsMainScreen extends StatelessWidget {
  NewsMainScreen({Key? key}) : super(key: key);

  // Sample news data with images
  final List<Map<String, dynamic>> newsList = [
    {
      'title': 'Breaking News: Flutter App Launched',
      'content': 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
      'image': 'https://pbs.twimg.com/media/C2cyM1FWEAA2Oib.jpg',
    },
    {
      'title': 'New Study Shows Benefits of Flutter Development',
      'content':
          'Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
      'image':
          'https://th.bing.com/th/id/R.41526ef38109c84f5318ee3ddccdd899?rik=hin%2bEU1Q4s206g&riu=http%3a%2f%2fclaynewsnetwork.com%2fwp-content%2fuploads%2f03-10-17BAnner.png&ehk=TO4eW7GK7QnROcT4A6JXeBgW0oSGHhplJcfXCrGfDcg%3d&risl=&pid=ImgRaw&r=0',
    },
    {
      'title': 'Flutter 3.0 Released with Exciting Features',
      'content':
          'Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris.',
      'image':
          'https://static.vecteezy.com/system/resources/thumbnails/013/704/506/original/news-world-map-background-video.jpg',
    },
  ];

  @override
  Widget build(BuildContext context) {
    PostWidgetModel postWidgetData = PostWidgetModel(
      index: 1,
      imageLink: "https://pbs.twimg.com/media/C2cyM1FWEAA2Oib.jpg",
      postId: "1",
      profilePos: "right",
      profileShape: "round",
      tagColor: "white",
      playStoreBadgePos: "right",
      showName: true,
      showProfile: true,
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Latest News',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      body: ListView(
        children: [
          ...List.generate(20, (index) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: PostWidget(
                      postWidgetData: postWidgetData.copyWith(
                          imageLink: index % 3 == 1
                              ? "https://akm-img-a-in.tosshub.com/indiatoday/images/story/202404/stocks-to-watch-out-for-today-lt--pb-fintech--voltas--kec-international-and-more-310202815-16x9.jpg?VersionId=2pVDIEnNpWbmpyRSVG3ldE0gKOGFdL.h&size=690:388"
                              : index % 3 == 2
                                  ? "https://akm-img-a-in.tosshub.com/indiatoday/images/device/1712569504Galaxy-m15-5g-specs--800x800_one_to_one.jpg?VersionId=wCsJSqUJvkZyjBoozPIleDD..jeh6On7"
                                  : "https://pbs.twimg.com/media/C2cyM1FWEAA2Oib.jpg")),
                ),
                Divider(color: Colors.black, thickness: 1),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    index % 2 == 0
                        ? "Michigan restaurant customer shoots employee over guacamole dip"
                        : 'Realme 12x 5G available at under Rs 12,000 on Flipkart, all details',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 10),
              ],
            );
          })
        ],
      ),
    );
  }
}
