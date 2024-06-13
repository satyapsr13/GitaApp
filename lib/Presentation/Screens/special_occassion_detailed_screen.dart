import 'dart:io';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';

import '../../Constants/colors.dart';
import '../../Constants/constants.dart';
import '../../Constants/enums.dart';
import '../../Constants/locations.dart';
import '../../Data/model/ObjectModels/post_widget_model.dart';
import '../../Data/services/secure_storage.dart';
import '../../Logic/Cubit/Posts/posts_cubit.dart';
import '../../Logic/Cubit/locale_cubit/locale_cubit.dart';
import '../../Utility/next_screen.dart';
import '../Ads/banner_admob.dart';
import '../Widgets/post_widget.dart';
import 'profile.screen.dart'; 

class SpecialOcassionDetailedScreen extends StatefulWidget {
  // const SpecialOcassionDetailedScreen({Key? key}) : super(key: key);
  final String headerImage;
  final String postId;
  final String title;
  const SpecialOcassionDetailedScreen({
    Key? key,
    required this.headerImage,
    required this.postId,
    required this.title,
  }) : super(key: key);

  @override
  State<SpecialOcassionDetailedScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<SpecialOcassionDetailedScreen> {
  Uint8List? image;
  String? photoUrl;
  Future<void> getImage() async {
    // Uint8List? image;
    SecureStorage secureStorage = SecureStorage();
    String imagePath = await secureStorage.readLocally('PHOTO_URL');
    if (imagePath.isNotEmpty) {
      image = await File(imagePath).readAsBytes();
    }

    setState(() {});
  }

  int currentPage = 1;
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    pathTracker.add("special_ocassion_screen");
    // checkNotificationPermission();
    getImage();
    // BlocProvider.of<PostCubit>(context).fetchNextPagePosts(0);
    BlocProvider.of<PostCubit>(context)
        .fetchSpecificCategoryResponse(widget.postId, 0, true);

    _scrollController.addListener(_onScroll);
    // AwesomeNotifications().actionStream.listen((event) {});
  }

  _onScroll() {
    if ((_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent)) {
      BlocProvider.of<PostCubit>(context)
          .fetchSpecificCategoryResponse(widget.postId, currentPage, true);
    }
  }

  @override
  void dispose() {
    pathTracker.removeLast();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    return BlocBuilder<LocaleCubit, LocaleState>(builder: (context, state) {
      return Scaffold(
        drawerEdgeDragWidth: mq.width * 0.2, // drawerScrimColor: Colors.,
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.black),
          backgroundColor: Colors.white,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: AppIcons.backButtonIcon,
          ),
          title: Text(
            widget.title,
            style: const TextStyle(color: Colors.black),
          ),
          elevation: 0,
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () {
                  nextScreen(context, const ProfileScreen());
                },
                child: SizedBox(
                  height: 35,
                  width: 35,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: image == null
                          ? Image.asset(
                              AppImages.addImageIcon,
                              fit: BoxFit.cover,
                            )
                          : Image.memory(image!),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),

        body: BlocBuilder<PostCubit, PostState>(builder: (context, state) {
          if (state.status == Status.failure) {
            return TextButton(
              onPressed: () {
                // BlocProvider.of<PostCubit>(context)
                //     .fetchSpecificCategoryResponse(widget.postId, 0, true);
                nextScreenReplace(
                    context,
                    SpecialOcassionDetailedScreen(
                        headerImage: widget.headerImage,
                        postId: widget.postId,
                        title: widget.title));
              },
              child: const Center(
                child: Text(
                  'Please try again!\n\n Click me!',
                  textAlign: TextAlign.center,
                  style: TextStyle(),
                ),
              ),
            );
          }
          currentPage = state.forYouPageNo + 1;
          return SingleChildScrollView(
            controller: _scrollController,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  headerImageWidget(),
                  const SizedBox(height: 30),

                  (state.status == Status.loading)
                      ? rishteyyLoader(mq)
                      : Visibility(
                          child: SizedBox(
                            child: Column(
                              children: [
                                ListView.separated(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  // controller: _scrollController,
                                  itemCount: state.ocassionWisePostList.length,
                                  itemBuilder: (ctx, index) {
                                    PostWidgetModel postWidgetData =
                                        PostWidgetModel(
                                      imageLink: state
                                              .ocassionWisePostList[index]
                                              .image ??
                                          "",
                                      postId: state
                                          .ocassionWisePostList[index].id
                                          .toString(),
                                      profilePos: state
                                          .ocassionWisePostList[index]
                                          .frameOptions!
                                          .bottom
                                          .toString(),
                                      profileShape: state
                                          .ocassionWisePostList[index]
                                          .frameOptions!
                                          .border
                                          .toString(),
                                      tagColor: state
                                          .ocassionWisePostList[index]
                                          .frameOptions!
                                          .color
                                          .toString(),
                                      playStoreBadgePos: state
                                          .ocassionWisePostList[index]
                                          .frameOptions!
                                          .top
                                          .toString(),
                                      showName: state.isNameVisible,
                                      showProfile: state.isProfileVisible,
                                    );
                                    return (index + 1) % 8 == 0
                                        ? Column(
                                            children: [
                                              PostWidget(
                                                postWidgetData: postWidgetData,
                                              ),
                                              // BannerAd(size: size, adUnitId: adUnitId, listener: listener, request: request)
                                              const SizedBox(height: 10),
                                              const BannerAdmob(),
                                            ],
                                          )
                                        : PostWidget(
                                            postWidgetData: postWidgetData,
                                          );
                                  },
                                  separatorBuilder:
                                      (BuildContext context, int index) {
                                    return const SizedBox(height: 25);
                                  },
                                ),
                                Visibility(
                                  // visible: (state.status == Status.loadingNextPage),
                                  child: SizedBox(
                                    height: 120,
                                    child: Column(
                                      children: [
                                        const SizedBox(height: 50),
                                        Row(
                                          children: const [
                                            Spacer(),
                                            Text(
                                              'Loading NextPage',
                                              style: TextStyle(),
                                            ),
                                            Spacer(),
                                            CircularProgressIndicator(
                                              color: AppColors.primaryColor,
                                            ),
                                            Spacer(),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                  // SizedBox(height: mq.height * 0.5),
                ],
              ),
            ),
          );
        }),

        //floatingActionButton: FloatingActionButton(onPressed: (){},),
      );
    });
  }

  SizedBox rishteyyLoader(Size mq) {
    return SizedBox(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            RishteyyShimmerLoader(mq: mq),
            Text(
              tr('please_wait'),
              style: const TextStyle(
                color: Colors.black,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Padding headerImageWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1),
      child: FlutterCarousel(
        options: CarouselOptions(
          aspectRatio: 2 / 1,
          autoPlay: false,
          viewportFraction: 1,
        ),
        items: [1].map((i) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: CachedNetworkImage(
              imageUrl: widget.headerImage,
              imageBuilder: (context, imageProvider) => Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              placeholder: (context, url) => const Center(
                  child: SizedBox(
                      height: 50,
                      width: 50,
                      child: CircularProgressIndicator())),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          );
        }).toList(),
      ),
    );
  }

  Container searchBox(Size mq) {
    return Container(
      height: 35,
      width: mq.width * 0.5,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: const [
          SizedBox(
            width: 10,
          ),
          Icon(
            Icons.search,
            size: 20,
            color: Colors.grey,
          ),
          SizedBox(
            width: 10,
          ),
          Text(
            "Search",
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
