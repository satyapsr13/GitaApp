// ignore_for_file: prefer_const_constructors
// import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../Constants/constants.dart';
import '../../Data/model/ObjectModels/post_widget_model.dart';
import '../../Logic/Cubit/Posts/posts_cubit.dart';
import '../Ads/banner_admob.dart';
import '../Widgets/post_widget.dart';
import '../Widgets/style.dart';

class SharedPostScreen extends StatefulWidget {
  const SharedPostScreen({super.key});

  @override
  State<SharedPostScreen> createState() => _SharedPostScreenState();
}

class _SharedPostScreenState extends State<SharedPostScreen> {
  // List<PostWidgetModel> postModel = [];
  @override
  void initState() {
    pathTracker.add("shared_post_screen");

    super.initState();
  }

  @override
  void dispose() {
    pathTracker.removeLast();
    super.dispose();
  }

  double deleteIconSide = 150;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Saved Post',
          style: TextStyle(
            fontSize: 20,
            color: Colors.black,
          ),
        ),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: AppIcons.backButtonIcon),
      ),
      body: BlocBuilder<PostCubit, PostState>(builder: (context, state) {
        return state.sharePostList.isEmpty
            ? Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Please share some post',
                    style: const TextStyle(),
                  ),
                ),
              )
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(children: [
                    SizedBox(
                      child: ListView.separated(
                        shrinkWrap: true,
                        reverse: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: state.sharePostList.length,
                        itemBuilder: (ctx, index) {
                          PostWidgetModel postWidgetData = PostWidgetModel(
                            index: index,
                            imageLink: state.sharePostList[index].imageLink,
                            postId:
                                state.sharePostList[index].postId.toString(),
                            profilePos: "right",
                            profileShape: "round",
                            tagColor: "white",
                            playStoreBadgePos: "center",
                            showName: state.isNameVisible,
                            // showProfile: shouldShowProfile.isNotEmpty,
                            showProfile: state.isProfileVisible,
                          );
                          if (index % 3 == 1) {
                            return Column(
                              children: [
                                Dismissible(
                                  key: Key(index.toString()),
                                  onDismissed: (e) {
                                     
                                  },
                                  background: Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                    size: deleteIconSide,
                                  ),
                                  child: PostWidget(
                                    postWidgetData: postWidgetData,
                                  ),
                                ),
                                AppGaps.boxH5,
                                BannerAdmob()
                              ],
                            );
                          }
                          return Dismissible(
                            key: Key(index.toString()),
                            background: Icon(
                              Icons.delete,
                              color: Colors.red,
                              size: deleteIconSide,
                            ),
                            child: PostWidget(
                              postWidgetData: postWidgetData,
                            ),
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return AppGaps.boxH20;
                        },
                      ),
                    ),
                  ]),
                ),
              );
      }),
    );
  }
}
