import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gita/Constants/constants.dart';
import 'package:overlay_support/overlay_support.dart';
import '../Constants/colors.dart';
import '../Logic/Cubit/locale_cubit/locale_cubit.dart';
import 'Screens/splash_screen.dart';

class MyApp extends StatelessWidget {
  final List<BlocProvider> blocProviders;
  final bool isLoggedIn;
  final RemoteMessage? notificationFromFirebase;
  const MyApp({
    Key? key,
    required this.blocProviders,
    required this.isLoggedIn,
    this.notificationFromFirebase,
  }) : super(key: key);

  static final navigatorKey = GlobalKey<NavigatorState>();
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: blocProviders,
      child: BlocBuilder<LocaleCubit, LocaleState>(
        builder: (context, state) {
          return OverlaySupport.global(
            child: MaterialApp(
                navigatorKey: navigatorKey,
                builder: ((context, child) {
                  return MediaQuery(
                    data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                    child: child!,
                  );
                }),
                theme: ThemeData(
                    primarySwatch: Colors.orange,
                    scaffoldBackgroundColor: Colors.white,
                    secondaryHeaderColor: Colors.white,
                    appBarTheme: const AppBarTheme(
                        scrolledUnderElevation: 0,
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.white,
                        titleSpacing: 0,
                        titleTextStyle: TextStyle(fontSize: 22)),
                    navigationBarTheme: NavigationBarThemeData(
                        indicatorColor: AppColors.primaryColor.withOpacity(0.1),
                        labelTextStyle: const MaterialStatePropertyAll(
                          TextStyle(
                            fontSize: 12,
                            overflow: TextOverflow.ellipsis,
                            fontWeight: FontWeight.w600,
                          ),
                        )),
                    cardColor: Colors.white,
                    useMaterial3: true,
                    primaryColor: AppColors.primaryColor,
                    cardTheme: const CardTheme(surfaceTintColor: Colors.white),
                    iconTheme: const IconThemeData(color: Colors.black),
                    backgroundColor: Colors.white),
                title: iAppName,
                supportedLocales: context.supportedLocales,
                home: SplashScreen(
                    isLoggedIn: isLoggedIn,
                    notificationFromFirebase: notificationFromFirebase),
                localizationsDelegates: context.localizationDelegates,
                locale: context.locale,
                debugShowCheckedModeBanner: false),
          );
        },
      ),
    );
  }
}
