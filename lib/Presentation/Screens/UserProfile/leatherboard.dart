import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gita/Constants/constants.dart';
import 'package:gita/Constants/enums.dart';
import 'package:gita/Data/model/api/leaderboard_response.dart';
import 'package:gita/Logic/Cubit/user_cubit/user_cubit.dart';
import 'package:gita/Presentation/Screens/PremiumPlanScreens/premium_plan_screen.dart';
import 'package:gita/Utility/next_screen.dart';

import '../../../Constants/locations.dart';

class LeatherboardScreen extends StatefulWidget {
  const LeatherboardScreen({super.key});

  @override
  State<LeatherboardScreen> createState() => _LeatherboardScreenState();
}

class _LeatherboardScreenState extends State<LeatherboardScreen> {
  @override
  void initState() {
    BlocProvider.of<UserCubit>(context).fetchLeaderboardData();
    super.initState();
  }

  Future<void> refresh() async {
    BlocProvider.of<UserCubit>(context).fetchLeaderboardData();
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Leaderboard',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ),
        bottomNavigationBar: SafeArea(
          child:
              BlocBuilder<UserCubit, UserState>(builder: (context, userState) {
            return Visibility(
              child: Container(
                width: mq.width,
                height: 120,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 10,
                      blurRadius: 7,
                      offset: const Offset(0, 3),
                    ),
                  ],
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    leaderboardTile(
                        isPremiumUser: userState.isPremiumUser,
                        isCurrentUser: true,
                        count: userState.leaderboardData?.userScore ?? 0,
                        prifileImg: userState.fileImagePath ?? "",
                        index: 18,
                        mq: mq,
                        name: userState.userName),
                    Visibility(
                      visible: !userState.isPremiumUser,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 30),
                        child: Text(
                          tr("leaderboard_buy"),
                          maxLines: 1,
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
        body: BlocBuilder<UserCubit, UserState>(builder: (context, userState) {
          if (userState.leaderboardStatus == Status.failure) {
            return Center(
              child: TextButton.icon(
                onPressed: () {
                  BlocProvider.of<UserCubit>(context).fetchLeaderboardData();
                },
                icon: const Icon(Icons.refresh),
                label: const Text(
                  'Refresh',
                  style: TextStyle(),
                ),
              ),
            );
          }
          return Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: mq.width,
                  margin: const EdgeInsets.all(15),
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    image: const DecorationImage(
                        image: AssetImage(
                          "assets/images/lb_header.png",
                        ),
                        fit: BoxFit.fitWidth),
                    borderRadius: BorderRadius.circular(10),
                    // gradient: const LinearGradient(
                    //   colors: [
                    //     Color(0xffffcb0a),
                    //     Color(0xfffff3bb),
                    //   ],
                    //   begin: Alignment.centerLeft,
                    //   end: Alignment.centerRight,
                    // ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                          flex: 8,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${tr("leaderboard")} - ${DateFormat('MMMM', getLocale()).format(DateTime.now())}',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 22,
                                ),
                              ),
                              Text(
                                tr("leaderboard_txt"),
                                style: const TextStyle(
                                  color: Color.fromARGB(140, 0, 0, 0),
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          )),
                      const Expanded(flex: 4, child: SizedBox())
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    children: [
                      const Spacer(),
                      Text(
                        tr("leaderboard_update_text"),
                        maxLines: 1,
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),

                // const SizedBox(height: 25),
                Expanded(
                    child: Visibility(
                  visible: userState.leaderboardStatus != Status.loading,
                  replacement: const Center(child: CircularProgressIndicator()),
                  child: RefreshIndicator(
                    displacement: 80,
                    onRefresh: () {
                      return refresh();
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: ListView(
                        physics: const BouncingScrollPhysics(),
                        children: [
                          ...List.generate(
                              userState.leaderboardData?.leaderboard?.length ??
                                  0, (index) {
                            final Leaderboard ld =
                                userState.leaderboardData!.leaderboard![index];
                            return leaderboardTile(
                                count: ld.sharesCount ?? 0,
                                prifileImg: ld.user?.profilePhotoPath ?? "",
                                index: index,
                                mq: mq,
                                name: ld.user?.name ?? "");
                          })
                        ],
                      ),
                    ),
                  ),
                ))
              ],
            ),
          );
        }));
  }

  Container leaderboardTile({
    required Size mq,
    required int index,
    required String name,
    String? prifileImg,
    required num count,
    bool isCurrentUser = false,
    bool isPremiumUser = false,
  }) {
    return Container(
      width: mq.width * 0.9,
      // height: mq.width * 0.1,
      margin: const EdgeInsets.symmetric(vertical: 7),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        gradient: index > 2
            ? null
            : LinearGradient(
                colors: index == 0
                    ? [
                        const Color(0xffffbb0b),
                        const Color(0xfffff0ca),
                      ]
                    : index == 1
                        ? [
                            const Color(0xffa9a9a9),
                            const Color(0xfff0f0f0),
                          ]
                        : [
                            const Color(0xfff6ae71),
                            const Color(0xfffdf0e5),
                          ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
      ),
      child: Row(
        children: [
          Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.only(right: 4),
                child: Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.topRight,
                  children: [
                    Container(
                      decoration: const BoxDecoration(shape: BoxShape.circle),
                      clipBehavior: Clip.antiAlias,
                      child: (prifileImg ?? "").startsWith("http")
                          ? CachedNetworkImage(imageUrl: prifileImg ?? "")
                          : Image.file(File(prifileImg ?? "")),
                    ),
                    Visibility(
                      visible: !isCurrentUser || isPremiumUser,
                      child: SizedBox(
                        height: 20,
                        width: 20,
                        child: Image.asset(
                          AppImages.nonPremiumUserIcon,
                        ),
                      ),
                    )
                  ],
                ),
              )),
          const SizedBox(width: 7),
          Expanded(
              flex: 4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name,
                      maxLines: 1,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                      )),
                  RichText(
                      text: TextSpan(
                          style: const TextStyle(
                              fontSize: 20, color: Colors.black),
                          children: <TextSpan>[
                        TextSpan(
                            text: count.toString(),
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                        const TextSpan(
                          text: " Shares ",
                          style: TextStyle(
                              // fontSize: 30,
                              color: Colors.black),
                        )
                      ]))
                ],
              )),
          isCurrentUser
              ? const SizedBox()
              : Expanded(
                  flex: 1,
                  child: index > 2
                      ? Center(
                          child: Text(
                          '${index + 1}',
                          style: const TextStyle(
                              color: Colors.black45,
                              fontWeight: FontWeight.bold,
                              fontSize: 30),
                        ))
                      : Image.asset(
                          index == 0
                              ? "assets/images/1st.png"
                              : index == 1
                                  ? "assets/images/2nd.png"
                                  : "assets/images/3rd.png",
                          fit: BoxFit.cover,
                        )),
          Visibility(
            visible: isCurrentUser && !isPremiumUser,
            child: InkWell(
              onTap: () {
                nextScreenWithFadeAnimation(context, const PremiumPlanScreen());
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    height: 50,
                    width: 130,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: Gradients.gradient2,
                    ),
                    child: Center(
                      child: false
                          ? Image.asset(AppImages.premiumPromoHi)
                          : Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: Image.asset(
                                        AppImages.nonPremiumUserIcon,
                                        fit: BoxFit.cover,
                                      )),
                                ),
                                const Text(
                                  'Become \n Premium',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
