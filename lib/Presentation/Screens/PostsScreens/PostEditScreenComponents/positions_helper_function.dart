

import '../../../../Constants/enums.dart';

double? rishteyyTagTopPosition(String posi) {
  return 200;
  switch (posi) {
    case "left":
      return 200;
    case "left-touched":
      return 200;
    case "right":
      return 200;
    case "right-touched":
      return 200;

    default:
      return 200;
  }
}

double? rishteyyTagRightPosition(String posi) {
  if (1 == 1) {
    if (posi.startsWith("rig") || posi.startsWith("cen")) {
      return -33.5;
    }
    return null;
  }
  switch (posi) {
    case "right":
      return -33.5;
    case "right-touched":
      return -33.5;
    case "center-touched":
      return -33.5;

    default:
      return null;
  }
}

double? rishteyyTagLeftPosition(String posi) {
  if (1 == 1) {
    if (posi.startsWith("lef")) {
      return -33.5;
    }
    return null;
  }
  switch (posi) {
    case "left":
      return -33.5;
    case "left-touched":
      return -33.5;
    // case "center-touched":
    //   return -33;
    default:
      return null;
  }
}

double? getDatePosition({
  DatePos datePosition = DatePos.topLeft,
  bool isLeft = false,
}) {
  if (datePosition == DatePos.topLeft && isLeft == true) {
    return 10;
  }

  if (datePosition == DatePos.topRight && isLeft == false) {
    return 10;
  }
  return null;
}
