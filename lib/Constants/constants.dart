import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';

import 'colors.dart';

Map<String, BorderRadiusGeometry> rishteyTagStringToBorderRadius = {
  "left": const BorderRadius.only(
    topLeft: Radius.circular(0),
    topRight: Radius.circular(5),
    bottomLeft: Radius.circular(0),
    bottomRight: Radius.circular(5),
  ),
  "right": const BorderRadius.only(
    topLeft: Radius.circular(10),
    topRight: Radius.circular(10),
    bottomLeft: Radius.circular(10),
    bottomRight: Radius.circular(10),
  ),
  "center": const BorderRadius.only(
    topLeft: Radius.circular(5),
    topRight: Radius.circular(5),
    bottomLeft: Radius.circular(5),
    bottomRight: Radius.circular(5),
  ),
  "center-touched": const BorderRadius.only(
    topLeft: Radius.circular(0),
    topRight: Radius.circular(0),
    bottomLeft: Radius.circular(5),
    bottomRight: Radius.circular(5),
  ),
  "left-touched": const BorderRadius.only(
    topLeft: Radius.circular(0),
    topRight: Radius.circular(5),
    bottomLeft: Radius.circular(0),
    bottomRight: Radius.circular(5),
  ),
  "right-touched": const BorderRadius.only(
    topLeft: Radius.circular(10),
    topRight: Radius.circular(10),
    bottomLeft: Radius.circular(10),
    bottomRight: Radius.circular(10),
  ),
};
// Map<int, String> intToMonth = {
//   1: "Jan",
//   2: "Feb",
//   3: "Mar",
//   4: "Apr",
//   5: "May",
//   6: "Jun",
//   7: "Jul",
//   8: "Aug",
//   9: "Sep",
//   10: "Oct",
//   11: "Nov",
//   12: "Dec",
// };

// Map<int, String> intToDay = {
//   7: "रविवार",
//   1: "सोमवार",
//   2: "मंगलवार",
//   3: "बुधवार",
//   4: "बृहस्पतिवार",
//   5: "शुक्रवार",
//   6: "शनिवार",
// };

class Constants {
  static List<PlatformUiSettings> get androidCropSetting {
    return [
      AndroidUiSettings(
        toolbarTitle: 'Crop Image',
        toolbarColor: Colors.white,
        toolbarWidgetColor: AppColors.primaryColor,
        initAspectRatio: CropAspectRatioPreset.original,
        lockAspectRatio: true,
        showCropGrid: true,
      ),
    ];
  }

  static List<Color> colorList = [
    Colors.white,
    Colors.orange,
    Colors.deepOrange,
    Colors.red,
    Colors.pink,
    Colors.black,
    Colors.green,
    Colors.indigo,
    Colors.blue,
    Colors.purple,
    Colors.cyan,
    Colors.deepPurple,
    Colors.lightBlue,
    Colors.teal,
    Colors.lightGreen,
    Colors.lime,
    Colors.amber,
    Colors.yellow,
  ];
  static List<Color> colorListProfileBg = [
    Colors.green,
    Colors.white,
    const Color(0xffD4AF37),
    Colors.orange,
    Colors.red,
    Colors.indigo,
    Colors.pink,
    Colors.deepOrange,
    Colors.blue,
    Colors.purple,
    Colors.cyan,
    Colors.deepPurple,
    Colors.lightBlue,
    Colors.teal,
    Colors.lightGreen,
    Colors.black,
  ];

  static LinearGradient linearGradient() {
    return const LinearGradient(
      colors: [
        Color(0xffFF9200),
        Color(0xffFF2E45),
        Color(0xffFF9200),
      ],
      begin: Alignment.topRight,
      end: Alignment.bottomLeft,
      stops: [0, 0.5, 1],
    );
  }

  static List<TextStyle> googleFontStyles = [
    GoogleFonts.poppins(
      textStyle: const TextStyle(
        color: Colors.black,
      ),
    ),
    GoogleFonts.amita(
      textStyle: const TextStyle(
        color: Colors.black,
      ),
    ),
    GoogleFonts.tillana(
      textStyle: const TextStyle(
        color: Colors.black,
      ),
    ),
    GoogleFonts.ranga(
      textStyle: const TextStyle(
        color: Colors.black,
      ),
    ),
    GoogleFonts.gotu(
      textStyle: const TextStyle(
        color: Colors.black,
      ),
    ),
    GoogleFonts.dekko(
      textStyle: const TextStyle(
        color: Colors.black,
      ),
    ),
    GoogleFonts.notoSans(
      textStyle: const TextStyle(
        color: Colors.black,
      ),
    ),
    GoogleFonts.mukta(
      textStyle: const TextStyle(
        color: Colors.black,
      ),
    ),
    GoogleFonts.hind(
      textStyle: const TextStyle(
        color: Colors.black,
      ),
    ),
    GoogleFonts.teko(
      textStyle: const TextStyle(
        color: Colors.black,
      ),
    ),
    GoogleFonts.rajdhani(
      textStyle: const TextStyle(
        color: Colors.black,
      ),
    ),
    GoogleFonts.kalam(
      textStyle: const TextStyle(
        color: Colors.black,
      ),
    ),
    GoogleFonts.martel(
      textStyle: const TextStyle(
        color: Colors.black,
      ),
    ),
    GoogleFonts.yantramanav(
      textStyle: const TextStyle(
        color: Colors.black,
      ),
    ),
    GoogleFonts.khand(
      textStyle: const TextStyle(
        color: Colors.black,
      ),
    ),
    GoogleFonts.baloo2(
      textStyle: const TextStyle(
        color: Colors.black,
      ),
    ),
    GoogleFonts.eczar(
      textStyle: const TextStyle(
        color: Colors.black,
      ),
    ),
    GoogleFonts.jaldi(
      textStyle: const TextStyle(
        color: Colors.black,
      ),
    ),
    GoogleFonts.laila(
      textStyle: const TextStyle(
        color: Colors.black,
      ),
    ),
    GoogleFonts.spaceMono(
      textStyle: const TextStyle(
        color: Colors.black,
      ),
    ),
    GoogleFonts.syne(
      textStyle: const TextStyle(
        color: Colors.black,
      ),
    ),
    GoogleFonts.italianno(
      textStyle: const TextStyle(
        color: Colors.black,
      ),
    ),
    GoogleFonts.parisienne(
      textStyle: const TextStyle(
        color: Colors.black,
      ),
    ),
    GoogleFonts.tangerine(
      textStyle: const TextStyle(
        color: Colors.black,
      ),
    ),
    GoogleFonts.yellowtail(
      textStyle: const TextStyle(
        color: Colors.black,
      ),
    ),
  ];
}

class AppIcons {
  static Icon backButtonIcon = const Icon(
    Icons.arrow_back_ios,
    size: 20,
    color: Colors.black,
  );
}

class Gradients {
  static const Gradient redGradient = LinearGradient(
    colors: [
      Color(0xffFC6076),
      Color(0xffFF9A44),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    // stops: [0, 1],
  );
  static const Gradient greenGradient = LinearGradient(
    colors: [
      Color(0xff21C0B4),
      Color(0xff71D99B),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static const Gradient blueGradient = LinearGradient(
    colors: [
      Color(0xff009FFD),
      Color(0xff2A2A72),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static const Gradient gradient1 = LinearGradient(
    colors: [
      Color(0xfffdfc47),
      Color(0xff24fe41),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static const Gradient gradient2 = LinearGradient(
    colors: [
      Color(0xfffe8c00),
      Color(0xfff83600),
    ],
    begin: Alignment.bottomLeft,
    end: Alignment.topRight,
  );
  static const Gradient gradient3 = LinearGradient(
    colors: [
      Color(0xff9d50bb),
      Color(0xff6e48aa),
    ],
    begin: Alignment.bottomLeft,
    end: Alignment.topRight,
  );
  static const Gradient gradient4 = LinearGradient(
    colors: [
      Color(0xfff2709c),
      Color(0xffff947c),
    ],
    begin: Alignment.bottomLeft,
    end: Alignment.topRight,
  );
}

// int appVersion = 28;
class GlobalVariables {
  static const int appVersion = 71;
  static const String appVersionInD = "17.15.71";
  static const String telErrorChannel = "@rishteyyerrors";
  static const String telCustomPostChannel = "@rishteyycustom";
  static const String telEditPostChannel = "@rishteyyedit";
  static const String telNormalPostChannel = "@rishteyychannel";
  static const String telVedPostChannel = "@rishteyyved";
}

class GErrorVar {
  static const String errorLogin = "error_login";
  // static const String errorProfileUpdate = "error_login";
  static const String errorEditShare = "error_editshare";
  static const String errorEditDownload = "error_editdownload";
  static const String errorHomeScreen = "error_homescreen";
  static const String sendMessage = "send_message";
}

List<String> pathTracker = [
  "start",
];

String getLocale() {
  return (tr("_a_") == "A") ? "en" : "hi";
}

removeDownloadKeysInPathTracker() {
  try {
    for (var i = 0; i < pathTracker.length; i++) {
      if (pathTracker[i] == "download" || pathTracker[i].startsWith("path")) {
        pathTracker.removeAt(i);
      }
    }
  } catch (e) {}
}

List<String> logsMessages = [];

bool isEvenVersion() {
  return GlobalVariables.appVersion % 2 == 0;
}
