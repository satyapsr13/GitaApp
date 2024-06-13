
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../Constants/constants.dart';
import '../../../Constants/enums.dart';
import '../../../Logic/Cubit/Posts/posts_cubit.dart';
import '../../../Utility/next_screen.dart';
import '../../Ads/banner_admob.dart';
import '../../Widgets/post_widget.dart';
import '../../Widgets/style.dart';
import 'specific_tags_screen.dart'; 

class AllTagsScreen extends StatefulWidget {
  const AllTagsScreen({super.key});

  @override
  State<AllTagsScreen> createState() => _AllTagsScreenState();
}

class _AllTagsScreenState extends State<AllTagsScreen> {
  @override
  void initState() {
    super.initState();
    pathTracker.add("all_tags_screen");

    BlocProvider.of<PostCubit>(context).fetchTags(toFetchAllTags: true);
  }

  @override
  void dispose() {
    pathTracker.removeLast();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: AppIcons.backButtonIcon,
        ),
        title: const Text(
          'All Tags',
          style: TextStyle(
            fontSize: 20,
            color: Colors.black,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        child: BlocBuilder<PostCubit, PostState>(builder: (context, state) {
          if (state.status == Status.loading) {
            return SizedBox(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    RishteyyShimmerLoader(mq: mq),
                    Text(
                      tr('please_wait'),
                      style: const TextStyle(color: Colors.black, fontSize: 15),
                    ),
                  ],
                ),
              ),
            );
          }
          if (state.status == Status.failure) {
            return SizedBox(
              width: mq.width,
              height: mq.height,
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: mq.height * 0.3),
                  const Text(
                    'Please try again!\n\n',
                    style: TextStyle(),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      nextScreenReplace(context, const AllTagsScreen());
                    },
                    child: const Text(
                      'Reload',
                      textAlign: TextAlign.center,
                      style: TextStyle(),
                    ),
                  ),
                  const Expanded(child: SizedBox()),
                  const BannerAdmob(),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            child: Wrap(
              children: state.allTagsList.map((e) {
                return Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: InkWell(
                      onTap: () {
                        BlocProvider.of<PostCubit>(context)
                            .state
                            .specificTagList = [];
                        nextScreenWithFadeAnimation(
                            context,
                            SpecificTagsScreen(
                              categoryTitleEnglish: e.name,
                              categoryTitleHindi: e.hindi,
                              postKeyword: e.keyword,
                            ));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              width: 1,
                              color: Colors.black,
                            )),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 4, vertical: 2),
                          child: Text(
                            tr("_a_") == "A" ? e.name : e.hindi,
                            style: TextStyles.textStyle12,
                          ),
                        ),
                      ),
                    ));
              }).toList(),
            ),
          );
        }),
      ),
 
    );
  }
}
