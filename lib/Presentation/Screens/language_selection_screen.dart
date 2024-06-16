// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

// import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gita/Presentation/Screens/SeriesPosts/GitsGyanScreens/gita_sloke_main_screen.dart';
import '../../Constants/colors.dart';
import '../../Constants/constants.dart';
import '../../Constants/locations.dart';
import '../../Data/services/secure_storage.dart';
import '../../Logic/Cubit/locale_cubit/locale_cubit.dart';
import '../../Utility/next_screen.dart';
import 'home_screen_with_navigation.dart';
import 'login.screen.dart';

class LanguageSelectionScreen extends StatefulWidget {
  final bool? isOnlySwitchLanguage;
  const LanguageSelectionScreen({
    Key? key,
    this.isOnlySwitchLanguage,
  }) : super(key: key);

  @override
  State<LanguageSelectionScreen> createState() =>
      _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  final SecureStorage _secureStorage = SecureStorage();
  bool isLoading = false;
  onLanguageChange(
    Locale value,
  ) async {
    // setState(() {
    //   isLoading = true;
    // });
    // log(context.supportedLocales.toString());
    await context.setLocale(value);
    BlocProvider.of<LocaleCubit>(context).updateLocale(value);
    var localeString = value.languageCode +
        (value.countryCode != null ? '_${value.countryCode}' : '');
    await _secureStorage.persistLocale(localeString);

    nextScreenCloseOthers(context, const GitagyanMainScreen());
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: BlocBuilder<LocaleCubit, LocaleState>(builder: (context, state) {
          return Stack(
            children: [
              GradientContainer(mq: mq),
              Column(
                children: [
                  SizedBox(height: mq.height * 0.35 - 50),
                  Container(
                    width: mq.width,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(30),
                        topLeft: Radius.circular(30),
                      ),
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 60),
                        const Text(
                          'Select language\nभाषा का चयन करें',
                          textScaleFactor: 1,
                          style: TextStyle(fontSize: 25),
                        ),
                        const SizedBox(height: 40),
                        Visibility(
                          visible: isEvenVersion(),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  LanguageSelectionButton(
                                    onTap: () {
                                      onLanguageChange(const Locale('en'));
                                      BlocProvider.of<LocaleCubit>(context)
                                          .updateLocaleKey(localeKey: 'en');
                                    },
                                    isSelected: state.localeKey == "en",
                                    languageTitleInEn: "",
                                    languageTitle: "English",
                                    mq: mq,
                                    isLoading: isLoading,
                                  ),
                                  LanguageSelectionButton(
                                    onTap: () {
                                      onLanguageChange(const Locale('hi'));
                                      BlocProvider.of<LocaleCubit>(context)
                                          .updateLocaleKey(localeKey: 'hi');
                                    },
                                    isSelected: state.localeKey == "hi",
                                    languageTitleInEn: "Hindi",
                                    languageTitle: "हिंदी",
                                    isLoading: isLoading,
                                    mq: mq,
                                  ),
                                ],
                              ),
                              SizedBox(height: 15),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  LanguageSelectionButton(
                                    onTap: () {
                                      onLanguageChange(const Locale('mr'));
                                      BlocProvider.of<LocaleCubit>(context)
                                          .updateLocaleKey(localeKey: 'mr');
                                    },
                                    isSelected: state.localeKey == "mr",
                                    languageTitleInEn: "",
                                    languageTitle: "Marathi",
                                    mq: mq,
                                    isLoading: isLoading,
                                  ),
                                  LanguageSelectionButton(
                                    onTap: () {
                                      onLanguageChange(const Locale('gu'));
                                      BlocProvider.of<LocaleCubit>(context)
                                          .updateLocaleKey(localeKey: 'gu');
                                    },
                                    isSelected: tr("_a_") == "gu",
                                    languageTitleInEn: "Gujarati",
                                    languageTitle: "Gujarati",
                                    isLoading: isLoading,
                                    mq: mq,
                                  ),
                                ],
                              ),
                              SizedBox(height: 15),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  LanguageSelectionButton(
                                    onTap: () {
                                      onLanguageChange(const Locale('bn'));
                                      BlocProvider.of<LocaleCubit>(context)
                                          .updateLocaleKey(localeKey: 'bn');
                                    },
                                    isSelected: state.localeKey == "bn",
                                    languageTitleInEn: "",
                                    languageTitle: "Bengoli",
                                    mq: mq,
                                    isLoading: isLoading,
                                  ),
                                  LanguageSelectionButton(
                                    onTap: () {
                                      onLanguageChange(const Locale('or'));
                                      BlocProvider.of<LocaleCubit>(context)
                                          .updateLocaleKey(localeKey: 'or');
                                    },
                                    isSelected: tr("_a_") == "or",
                                    languageTitleInEn: "Oriya",
                                    languageTitle: "Oriya",
                                    isLoading: isLoading,
                                    mq: mq,
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  LanguageSelectionButton(
                                    onTap: () {
                                      onLanguageChange(const Locale('pa'));
                                      BlocProvider.of<LocaleCubit>(context)
                                          .updateLocaleKey(localeKey: 'pa');
                                    },
                                    isSelected: state.localeKey == "pa",
                                    languageTitleInEn: "Punjabi",
                                    languageTitle: "पंजाबी",
                                    mq: mq,
                                    isLoading: isLoading,
                                  ),
                                  LanguageSelectionButton(
                                    onTap: () {
                                      onLanguageChange(const Locale('ur'));
                                      BlocProvider.of<LocaleCubit>(context)
                                          .updateLocaleKey(localeKey: 'ur');
                                    },
                                    isSelected: tr("_a_") == "ur",
                                    languageTitleInEn: "Ordu",
                                    languageTitle: "उर्दू",
                                    isLoading: isLoading,
                                    mq: mq,
                                  ),
                                ],
                              ),
                              // Row(
                              //   mainAxisAlignment:
                              //       MainAxisAlignment.spaceEvenly,
                              //   children: [
                              //     LanguageSelectionButton(
                              //       onTap: () {
                              //         onLanguageChange(const Locale('mr'));
                              //         BlocProvider.of<LocaleCubit>(context)
                              //             .updateLocaleKey(localeKey: 'mr');
                              //       },
                              //       isSelected: state.localeKey == "mr",
                              //       languageTitleInEn: "",
                              //       languageTitle: "Marathi",
                              //       mq: mq,
                              //       isLoading: isLoading,
                              //     ),
                              //     LanguageSelectionButton(
                              //       onTap: () {
                              //         onLanguageChange(const Locale('rus'));
                              //         BlocProvider.of<LocaleCubit>(context)
                              //             .updateLocaleKey(localeKey: 'rus');
                              //       },
                              //       isSelected: tr("_a_") == "rus",
                              //       languageTitleInEn: "Russian",
                              //       languageTitle: "Russion",
                              //       isLoading: isLoading,
                              //       mq: mq,
                              //     ),
                              //   ],
                              // ),
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            onLanguageChange(const Locale('en'));
                            BlocProvider.of<LocaleCubit>(context)
                                .updateLocaleKey(localeKey: 'en');
                          },
                          child: Container(
                            height: 50,
                            width: mq.width * 0.8,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                    width: 2,
                                    color: state.locale == const Locale("en")
                                        ? AppColors.primaryColor
                                        : Colors.grey)),
                            child: const Center(
                              child: Text(
                                'English',
                                textScaleFactor: 1,
                                style: TextStyle(
                                    color: Colors.black, fontSize: 20),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        InkWell(
                          onTap: () {
                            onLanguageChange(const Locale('hi'));
                            BlocProvider.of<LocaleCubit>(context)
                                .updateLocaleKey(localeKey: 'hi');
                          },
                          child: Container(
                            height: 50,
                            width: mq.width * 0.8,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                    width: 2,
                                    color: state.locale == const Locale("hi")
                                        ? AppColors.primaryColor
                                        : Colors.grey)),
                            child: const Center(
                              child: Text(
                                'हिंदी',
                                textScaleFactor: 1,
                                style: TextStyle(
                                    color: Colors.black, fontSize: 20),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 30),
                        // Image.asset("assets/images/sticker_3.png"),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          );
        }),
      ),
      //floatingActionButton: FloatingActionButton(onPressed: (){},),
    );
  }
}

class LanguageSelectionButton extends StatelessWidget {
  final String languageTitle;
  final String languageTitleInEn;
  final bool isSelected;
  final bool isLoading;
  final Size mq;
  final Function() onTap;
  const LanguageSelectionButton({
    Key? key,
    required this.languageTitle,
    required this.languageTitleInEn,
    required this.isSelected,
    required this.isLoading,
    required this.mq,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      splashColor: isSelected ? AppColors.primaryColor : Colors.grey,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: mq.width * 0.3,
            height: mq.width * 0.3,
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primaryColor.withOpacity(0.1)
                  : Colors.white,
              border: Border.all(
                  color: isSelected ? AppColors.primaryColor : Colors.grey,
                  width: 1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Spacer(),
                  Column(
                    // mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        languageTitle,
                        textScaleFactor: 1,
                        style: TextStyle(
                          color:
                              isSelected ? AppColors.primaryColor : Colors.grey,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        languageTitleInEn,
                        textScaleFactor: 1,
                        style: TextStyle(
                            color: isSelected
                                ? AppColors.primaryColor
                                : Colors.grey,
                            fontSize: 20),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Icon(
                    isSelected ? Icons.adjust : Icons.circle_outlined,
                    color: isSelected ? AppColors.primaryColor : Colors.grey,
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ),
          Visibility(
            visible: isLoading && isSelected,
            child: CircularProgressIndicator(
              color: AppColors.primaryColor,
            ),
          )
        ],
      ),
    );
  }
}

class GradientContainer extends StatelessWidget {
  const GradientContainer({
    Key? key,
    required this.mq,
  }) : super(key: key);

  final Size mq;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: mq.width,
      height: mq.height * 0.4,
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          center: Alignment(0, 0),
          stops: [
            0.2,
            0.8,
          ],
          radius: 1,
          colors: [
            Color(0xffFF9200),
            Color(0xffFF2E45),
          ],
        ),
      ),
      child: Column(
        children: [
          SizedBox(height: mq.height * 0.08),
          SizedBox(
            width: 70,
            height: 70,
            // color: Colors.red,
            child: Image.asset(
              AppImages.whiteLogo,
              // fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            // color: Colors.red,
            width: 130,
            // height: mq.width * 0.1,
            child: Image.asset(
              AppImages.rishteyTag,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}
