import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; 

import '../../../Constants/colors.dart';
import '../../../Logic/Cubit/user_cubit/user_cubit.dart';
import '../../../Utility/next_screen.dart';
import '../PostsScreens/shared_post_widget.dart';
import '../profile.screen.dart'; 

class InstaProfilePage extends StatefulWidget {
  @override
  _InstaProfilePageState createState() => _InstaProfilePageState();
}

class _InstaProfilePageState extends State<InstaProfilePage> {
  // double get randHeight => Random().nextInt(100).toDouble();

  // final List<Widget> _randomChildren = [];

  @override
  void initState() {
    BlocProvider.of<UserCubit>(context).savedPostDbOperations();
    super.initState();
  }

  // Children with random heights - You can build your widgets of unknown heights here
  // I'm just passing the context in case if any widgets built here needs  access to context based data like Theme or MediaQuery

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    return Scaffold(
      body: BlocBuilder<UserCubit, UserState>(builder: (context, state) {
        return DefaultTabController(
          length: 2,
          child: NestedScrollView(
            // allows you to build a list of elements that would be scrolled away till the body reached the top
            headerSliverBuilder: (context, _) {
              return [
                SliverAppBar(
                  expandedHeight: 90,
                  // expandedHeight: 250,
                  floating: false,
                  // automaticallyImplyLeading: true,
                  pinned: false,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Column(
                      children: [
                        Container(
                            child: ListTile(
                          leading: Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
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
                                          color:  AppColors.primaryColor,
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
                        )),
                        // MultiplePhotoSelector(mq: mq),
                      ],
                    ),
                  ),
                ),
              ];
            },
            // You tab view goes here
            body: Column(
              children: <Widget>[
                const TabBar(
                  indicatorColor:  AppColors.primaryColor,
                  // labelColor:  AppColors.primaryColor,
                  tabs: [
                    Tab(
                        child: Text(
                      'Images',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    )),
                    Tab(
                        child: Text(
                      'Videos',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    )),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      SharedPostWidget(mq: mq),
                      Center(
                        child: Text(
                          tr('coming_soon'),
                          style: const TextStyle(
                              fontSize: 25,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
