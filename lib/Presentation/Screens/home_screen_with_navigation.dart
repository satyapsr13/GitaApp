import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:rishteyy/Presentation/Screens/UserProfile/leatherboard.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Constants/constants.dart';
import '../../Constants/enums.dart';
import '../../Constants/locations.dart';
import '../../Logic/Cubit/user_cubit/user_cubit.dart';
import '../../Utility/next_screen.dart';
import '../Widgets/Dialogue/dialogue.dart';
import '../Widgets/bottom_navigation_bar.dart';
import '../Widgets/drawer.dart';
import 'Chats/admin_chats_screen.dart';
import 'OtherScreens/menu_screen.dart';
import 'PostsScreens/create_post_screen.dart';
import 'TagsScreen/tag_search.dart';
import 'home_screen.dart';
import 'login.screen.dart';
import 'profile.screen.dart';

class TabItem {
  final Widget tab;
  final String title;

  TabItem({
    required this.tab,
    required this.title,
  });
}

class NavigationWrapper extends StatefulWidget {
  const NavigationWrapper({super.key});

  @override
  State<NavigationWrapper> createState() => _NavigationWrapperState();
}

class _NavigationWrapperState extends State<NavigationWrapper>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late TabController _tabController;
  int _selectedTab = 0;
  int _selectedNavigation = 0;
  late final List<TabItem> _tabItems = [
    TabItem(tab: const HomeScreen(), title: "Rishteyy"),
    // TabItem(tab: const DpMakerListScreen(), title: "Dp Maker"),
    TabItem(tab: const CreatePostScreen(), title: "Create"),
    TabItem(tab: const LeatherboardScreen(), title: "Leaderboard"),
    // TabItem(tab: const DonateScreen(), title: "Donate"),
    TabItem(tab: MenuScreen(), title: "Profile"),
    // TabItem(tab: InstaProfilePage(), title: "Profile"),
  ];
  Future<void> secureScreen() async {
    if (kDebugMode) {
      await FlutterWindowManager.clearFlags(FlutterWindowManager.FLAG_SECURE);
      return;
    }
    try {
      bool isPremiumUser =
          BlocProvider.of<UserCubit>(context).state.isPremiumUser;
      if (!isPremiumUser) {
        await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
      } else {
        await FlutterWindowManager.clearFlags(FlutterWindowManager.FLAG_SECURE);
      }
    } catch (e) {}
  }

  Future<void> clearSecureScreen() async {
    try {
      await FlutterWindowManager.clearFlags(FlutterWindowManager.FLAG_SECURE);
    } catch (e) {}
  }

  @override
  void initState() {
    secureScreen();
    // TODO: implement initState

    // BlocProvider.of<PostCubit>(context).loadFrames();
    _tabController = TabController(
      vsync: this,
      length: 4,
    );
    _tabController.animation!.addListener(() {
      setState(() {
        _selectedTab = (_tabController.indexIsChanging)
            ? _tabController.index
            : _tabController.animation!.value.round();
      });
    });
    super.initState();
  }

  _changeCurrentTab(int value) {
    if (value == 3) {
      nextScreenWithFadeAnimation(context, MenuScreen());
    } else if (value == 2) {
      nextScreenWithFadeAnimation(context, const LeatherboardScreen());
    } else {
      _tabController.animateTo(value);
      setState(() {
        _selectedTab = value;
      });
    }
    if (value == 0) {
      secureScreen();
    } else {
      clearSecureScreen();
    }
  }

  _changeSelectedNavigation(int value) {
    setState(() {
      _selectedNavigation = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.elliptical(20, 20)),
        ),
        onPressed: () async {
          // BlocProvider.of<UserCubit>(context).getProfileData();
          // return;
          // final userState = BlocProvider.of<UserCubit>(context).state;
          // String phoneNumber = '+917224992780';
          // String message = getLocale() == "en"
          //     ? 'Hi, \n My name is *${userState.userName}*. I have some question regarding *Rishteyy app*.'
          //     : " नमस्कार, \n मेरा नाम *${userState.userName}* है | मुझे *Rishteyy App* के बारे में कुछ पूछना है";

          // // Create the WhatsApp message link
          // final String url =
          //     'https://wa.me/$phoneNumber?text=${Uri.encodeFull(message)}';

          // // Launch the WhatsApp application
          // if (await canLaunchUrlString(url)) {
          //   await launchUrlString(
          //     url,
          //     mode: LaunchMode.externalApplication,
          //   );
          // } else {
          //   throw 'Could not launch $url';
          // }
          // Logger().i(BlocProvider.of<UserCubit>(context).state.lastMessageId);
          // Logger().i(BlocProvider.of<UserCubit>(context)
          //     .state
          //     .messageData
          //     ?.data?.first.id);
          // return;
          nextScreenWithFadeAnimation(context, const AdminChatScreen());
        },
        backgroundColor: Colors.green,
        child: BlocBuilder<UserCubit, UserState>(builder: (context, state) {
          return Stack(
            alignment: Alignment.topRight,
            clipBehavior: Clip.none,
            children: [
              Container(
                height: 75,
                width: 75,
                decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: AssetImage(
                      AppImages.whatsapp,
                    ))),
                child: true
                    ? const Icon(
                        Icons.whatsapp,
                        color: Colors.white,
                      )
                    : SvgPicture.asset(
                        AppImages.whatsapp,
                        color: Colors.white,
                      ),
              ),
              // (state.messageData?.data?.isEmpty ?? true)
              //     ? SizedBox()
              //     : Visibility(
              //         visible: (state.lastMessageId !=
              //                 state.messageData?.data?.first.id) &&
              //             state.lastMessageId != -1,
              //         child: const Icon(
              //           Icons.circle,
              //           color: Colors.red,
              //           size: 15,
              //         ),
              //       ),
            ],
          );
        }),
      ),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text("Rishteyy ",
                textScaleFactor: 1,
                // title: Text(_tabItems[_selectedTab].title,
                style: TextStyle(fontSize: 20, color: Colors.black)),
            BlocBuilder<UserCubit, UserState>(builder: (context, state) {
              return Visibility(
                visible: state.isPremiumUser,
                child: SizedBox(
                    height: 20,
                    width: 20,
                    child: Image.asset(
                      AppImages.nonPremiumUserIcon,
                      fit: BoxFit.cover,
                    )),
              );
            }),
          ],
        ),
        actions: [
          Visibility(
            visible: isEvenVersion(),
            child: IconButton(
                onPressed: () {
                  // BlocProvider.of<SeriesPostCubit>(context).fetchMiniapps();

                  nextScreen(context, const LeatherboardScreen());
                  return;

                  if (false) {
                    showSupportDialogue(
                        showSpecilOfferImage: false,
                        isGreenGradientButton: true,
                        context: context,
                        title: tr("join_wgruoup"),
                        buttonText: tr("join_support_group"),
                        image:
                            "https://manage.connectup.in/rishteyy/occasions/joinwa.jpg",
                        mq: const Size(350, 350),
                        onTap: (() async {
                          try {
                            String url =
                                "https://connectup.in/rishteyy/support";
                            if (await canLaunchUrl(Uri.parse(url))) {
                              await launchUrl(Uri.parse(url),
                                  mode: LaunchMode.externalApplication);
                            }
                          } catch (e) {}
                        }));
                  } else {
                    // BlocProvider.of<PostCubit>(context).fetchTodayData();
                    // nextScreen(context, const BgRemoverScreen());
                    BlocProvider.of<UserCubit>(context).updateStateVariables(
                        isPremiumUser: !BlocProvider.of<UserCubit>(context)
                            .state
                            .isPremiumUser);
                    // final temp =
                  }
                  //     BlocProvider.of<PostCubit>(context).state.categoriesList;
                  // Logger().i(temp);

                  // BlocProvider.of<StickerCubit>(context).syncActiveFrameById();
                  // BlocProvider.of<StickerCubit>(context)
                  //     .fetchBackgroundImages();
                },
                icon: const Icon(
                  Icons.person,
                  size: 20,
                )),
          ),
          IconButton(
              onPressed: () {
                showSearch(context: context, delegate: TagsSearch());
              },
              padding: const EdgeInsets.all(2),
              icon: const Icon(
                Icons.search,
                size: 20,
                color: Colors.black,
              )),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () {
                nextScreenWithFadeAnimation(context, const ProfileScreen());
              },
              child: appBarProfileIcon(),
            ),
          ),
          Visibility(
            visible: isEvenVersion(),
            child: IconButton(
                onPressed: () {
                  BlocProvider.of<UserCubit>(context).updateStateVariables(
                      isPremiumUser: !BlocProvider.of<UserCubit>(context)
                          .state
                          .isPremiumUser);
                },
                icon: const Icon(
                  Icons.more_vert,
                  size: 20,
                )),
          ),
        ],
      ),
      body: BlocConsumer<UserCubit, UserState>(listener: (context, userState) {
        if (userState.getProfileStatus == Status.phoneNumberInvalid) {
          nextScreenCloseOthers(context, const LoginScreen());
        }
      }, builder: (context, _) {
        return TabBarView(
          physics: const NeverScrollableScrollPhysics(),
          controller: _tabController,
          children: _tabItems.map<Widget>((TabItem e) => e.tab).toList(),
        );
      }),
      bottomNavigationBar: CBottomNavigation(
        currentTab: _selectedTab,
        changeTab: _changeCurrentTab,
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  Widget appBarProfileIcon() {
    return BlocBuilder<UserCubit, UserState>(builder: (context, state) {
      return Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.bottomCenter,
        children: [
          SizedBox(
            height: 35,
            width: 35,
            child: CircleAvatar(
              radius: 50,
              backgroundColor: Colors.white,
              child:
                  BlocBuilder<UserCubit, UserState>(builder: (context, state) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: state.fileImagePath.isEmpty
                      ? Image.asset(
                          AppImages.addImageIcon,
                          fit: BoxFit.cover,
                        )
                      : Image.file(File(state.fileImagePath)),
                );
              }),
            ),
          ),
          // Positioned(
          //   bottom: -5,
          //   child: Visibility(
          //     visible: state.isPremiumUser,
          //     child: SizedBox(
          //         height: 20,
          //         width: 20,
          //         child: Image.asset(
          //           state.isPremiumUser
          //               ? AppImages.premiumUserIcon
          //               : AppImages.nonPremiumUserIcon,
          //           fit: BoxFit.cover,
          //         )),
          //   ),
          // )
        ],
      );
    });
  }
}
