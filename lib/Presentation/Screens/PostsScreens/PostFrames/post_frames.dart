// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../Constants/locations.dart';
import '../../../../Logic/Cubit/PostEditorCubit/post_editor_cubit.dart';
import '../../../../Logic/Cubit/Posts/posts_cubit.dart';
import '../../../../Logic/Cubit/user_cubit/user_cubit.dart';
import '../../../../Utility/common.dart'; 
class FrameWidget extends StatelessWidget {
  final FrameDetails frameDetails;
  final bool isNoFrame;
  const FrameWidget({
    Key? key,
    required this.frameDetails,
    this.isNoFrame = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostCubit, PostState>(builder: (context, postState) {
      if (postState.isFrameVisible == false) {
        return const SizedBox();
      }
      double rotateAngle = frameDetails.profilePos == "left" ? pi : 0;

      return Positioned(
        bottom: (-frameDetails.width / 3) + (frameDetails.width / 9) + 10,
        left: 0,
        child: Transform(
          transform: Matrix4.rotationY(rotateAngle),
          // transform: Matrix4.rotationY(0),
          // ..setEntry(3, 2, 0.001)
          // ..rotateY(0.2),
          alignment: Alignment.center,
          child: Container(
            height: isNoFrame ? null : frameDetails.width / 3,
            width: frameDetails.width.toDouble(),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
              image: isNoFrame
                  ? null
                  : frameDetails.imgLink.startsWith("http")
                      ? DecorationImage(
                          image:
                              CachedNetworkImageProvider(frameDetails.imgLink),
                          // image: NetworkImage(frameDetails.imgLink),
                          // image:1==1? NetworkImage("https://manage.connectup.in/rishteyy/frames/3_bottom.png") : AssetImage(AppImages.frames),
                          fit: BoxFit.fill)
                      : DecorationImage(
                          image: AssetImage(frameDetails.imgLink),
                          // image: NetworkImage(frameDetails.imgLink),
                          // image:1==1? NetworkImage("https://manage.connectup.in/rishteyy/frames/3_bottom.png") : AssetImage(AppImages.frames),
                          fit: BoxFit.fill),
              color: isNoFrame ? Colors.white : Colors.transparent,
            ),
            child: LayoutBuilder(builder: ((p0, constraints) {
              double parentWidth = constraints.maxWidth;
              double parentHeight = constraints.maxHeight;

              double nameX = (frameDetails.nameX / 100) * parentWidth;
              double nameY = (frameDetails.nameY / 100) * parentHeight;
              double numberX = (frameDetails.numberX / 100) * parentWidth;
              double numberY = (frameDetails.numberY / 100) * parentHeight;
              double occupationX =
                  (frameDetails.occupationX / 100) * parentWidth;
              double occupationY =
                  (frameDetails.occupationY / 100) * parentHeight;
              double profileX = (frameDetails.profileX / 100) * parentWidth;
              double profileY = (frameDetails.profileY / 100) * parentHeight;
              return BlocBuilder<UserCubit, UserState>(
                  builder: (context, userState) {
                return isNoFrame
                    ? Row(
                        // clipBehavior: Clip.none,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 15),
                            child: SizedBox(
                              height: 80,
                              // width: 80,
                              child: Column(
                                // mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Visibility(
                                    visible: postState.isNameVisible,
                                    child: Text(
                                      userState.userName.length > 30
                                          ? "${userState.userName.substring(0, 30)} ..."
                                          : userState.userName,
                                      style: TextStyle(
                                        color:
                                            hexToColor(frameDetails.nameColor),
                                        fontWeight: FontWeight.bold,
                                        fontSize: frameDetails.nameFontSize
                                            .toDouble(),
                                      ),
                                    ),
                                  ),
                                  Visibility(
                                    visible: postState.isOccupationVisible,
                                    child: Text(
                                        userState.userOccupation.length > 60
                                            ? "${userState.userOccupation.substring(0, 60)} ..."
                                            : userState.userOccupation,
                                        style: TextStyle(
                                          color: hexToColor(
                                              frameDetails.occupationColor),
                                          fontSize: frameDetails
                                              .occupationFontSize
                                              .toDouble(),
                                        )),
                                  ),
                                  Visibility(
                                    visible: postState.isNumberVisible,
                                    child: Text(
                                      userState.userNumber,
                                      style: TextStyle(
                                        color: hexToColor(
                                            frameDetails.numberColor),
                                        fontSize: frameDetails.numberFontSize
                                            .toDouble(),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Visibility(
                            visible: postState.isProfileVisible,
                            child: CircleAvatar(
                              radius: frameDetails.radius.toDouble(),
                              backgroundColor: Colors.transparent,
                              backgroundImage: userState.fileImagePath.isEmpty
                                  ? const AssetImage(AppImages.addImageIcon)
                                  : FileImage(File(userState.fileImagePath))
                                      as ImageProvider,
                            ),
                          ),
                        ],
                      )
                    : Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Visibility(
                            visible: postState.isNameVisible,
                            child: Positioned(
                              left: nameX,
                              top: nameY,
                              child: Transform(
                                alignment: Alignment.center,
                                transform: Matrix4.rotationY(rotateAngle),
                                child: Text(
                                  userState.userName.length > 30
                                      ? "${userState.userName.substring(0, 30)} ..."
                                      : userState.userName,
                                  style: TextStyle(
                                    color: hexToColor(frameDetails.nameColor),
                                    fontWeight: FontWeight.bold,
                                    fontSize:
                                        frameDetails.nameFontSize.toDouble(),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Visibility(
                            visible: postState.isOccupationVisible,
                            child: Positioned(
                                left: occupationX,
                                top: occupationY,
                                child: Transform(
                                  alignment: Alignment.center,
                                  transform: Matrix4.rotationY(rotateAngle),
                                  child: Text(
                                      userState.userOccupation.length > 60
                                          ? "${userState.userOccupation.substring(0, 60)} ..."
                                          : userState.userOccupation,
                                      style: TextStyle(
                                        color: hexToColor(
                                            frameDetails.occupationColor),
                                        fontSize: frameDetails
                                            .occupationFontSize
                                            .toDouble(),
                                      )),
                                )),
                          ),
                          Visibility(
                            visible: postState.isNumberVisible,
                            child: Positioned(
                              left: numberX,
                              top: numberY,
                              child: Transform(
                                alignment: Alignment.center,
                                transform: Matrix4.rotationY(rotateAngle),
                                child: Text(
                                  userState.userNumber,
                                  style: TextStyle(
                                    color: hexToColor(frameDetails.numberColor),
                                    fontSize:
                                        frameDetails.numberFontSize.toDouble(),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Visibility(
                            visible: postState.isProfileVisible,
                            child: Positioned.fromRect(
                              rect: Rect.fromCenter(
                                center: Offset(profileX + frameDetails.radius,
                                    profileY - frameDetails.radius),
                                width: frameDetails.radius * 2,
                                height: frameDetails.radius * 2,
                              ),
                              child: CircleAvatar(
                                radius: frameDetails.radius.toDouble(),
                                backgroundColor: Colors.transparent,
                                backgroundImage: userState.fileImagePath.isEmpty
                                    ? const AssetImage(AppImages.addImageIcon)
                                    : FileImage(File(userState.fileImagePath))
                                        as ImageProvider,
                              ),
                            ),
                          ),
                        ],
                      );
              });
            })),
          ),
        ),
      );
    });
  }
}

class FrameWidgetForEditor extends StatelessWidget {
  final FrameDetails frameDetails;
  final bool isWhiteFrame;
  const FrameWidgetForEditor({
    Key? key,
    required this.frameDetails,
    this.isWhiteFrame = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final mq = MediaQuery.of(context).size;
    return Positioned(
      // bottom: 0,
      bottom: (-frameDetails.width / 3) + (frameDetails.width / 9) + 10,
      left: 0,
      child: BlocBuilder<PostEditorCubit, PostEditorState>(
          builder: (context, postEditorState) {
        double rotateAngle = frameDetails.profilePos == "left" ? pi : 0;

        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.rotationY(rotateAngle),
          child: Container(
            height: postEditorState.isWhiteFrame
                ? frameDetails.width / 4.5
                : frameDetails.width / 3,
            width: frameDetails.width.toDouble(),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
              image: postEditorState.isWhiteFrame
                  ? null
                  : DecorationImage(
                      image: CachedNetworkImageProvider(frameDetails.imgLink),
                      // image: NetworkImage(frameDetails.imgLink),
                      // image:1==1? NetworkImage("https://manage.connectup.in/rishteyy/frames/3_bottom.png") : AssetImage(AppImages.frames),
                      fit: BoxFit.fill),
              color: postEditorState.isWhiteFrame
                  // ? Colors.black
                  ? postEditorState.customFrameColor
                  : Colors.transparent,
            ),
            child: LayoutBuilder(builder: ((p0, constraints) {
              bool loadNew = false;
              bool loadNewC = false;
              if (!kDebugMode) {
                loadNew = false;
                loadNewC = false;
              }
              double parentWidth = constraints.maxWidth;
              double parentHeight = constraints.maxHeight;

              double nameX = (frameDetails.nameX / 100) * parentWidth;
              double nameY =
                  ((loadNew ? 43 : frameDetails.nameY) / 100) * parentHeight;
              double numberX = (frameDetails.numberX / 100) * parentWidth;
              double numberY =
                  ((loadNew ? 76 : frameDetails.numberY) / 100) * parentHeight;
              double occupationX =
                  (frameDetails.occupationX / 100) * parentWidth;
              double occupationY =
                  ((loadNew ? 62 : frameDetails.occupationY) / 100) *
                      parentHeight;
              // double profileX = (frameDetails.profileX / 100) * parentWidth;
              // double profileY = (frameDetails.profileY / 100) * parentHeight;
              if (postEditorState.isWhiteFrame) {
                double whiteFrameHeight = frameDetails.width / 4.5;
                nameY = (whiteFrameHeight * 0.1);
                occupationY = (whiteFrameHeight * 0.4);
                numberY = (whiteFrameHeight * 0.6);
              }
              return BlocBuilder<UserCubit, UserState>(
                  builder: (context, userState) {
                return postEditorState.isWhiteFrame
                    ? Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Visibility(
                              visible: postEditorState.isNameVisible,
                              child: Text(
                                // userState.editedName,
                                userState.editedName.length > 30
                                    ? "${userState.editedName.substring(0, 30)} ..."
                                    : userState.editedName,
                                style: TextStyle(
                                  color: postEditorState.isWhiteFrame
                                      ? postEditorState.nameColor
                                      : hexToColor(frameDetails.nameColor),
                                  fontWeight: FontWeight.bold,
                                  fontSize:
                                      frameDetails.nameFontSize.toDouble(),
                                ),
                              ),
                            ),
                            Visibility(
                              visible: postEditorState.isOccupationVisible,
                              child: Text(
                                  // userState.userOccupation,
                                  userState.userOccupation.length > 60
                                      ? "${userState.userOccupation.substring(0, 60)} ..."
                                      : userState.userOccupation,
                                  style: TextStyle(
                                    color: postEditorState.isWhiteFrame
                                        ? postEditorState.occupationColor
                                        : hexToColor(
                                            frameDetails.occupationColor),
                                    fontSize: frameDetails.occupationFontSize
                                        .toDouble(),
                                  )),
                            ),
                            Visibility(
                              visible: postEditorState.isNumberVisible,
                              child: Text(
                                userState.userNumber,
                                style: TextStyle(
                                  color: postEditorState.isWhiteFrame
                                      ? postEditorState.numberColor
                                      : hexToColor(frameDetails.numberColor),
                                  fontSize:
                                      frameDetails.numberFontSize.toDouble(),
                                ),
                              ),
                            ),
                            const SizedBox(height: 15),
                          ],
                        ),
                      )
                    : Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Visibility(
                              visible: postEditorState.isNameVisible,
                              child: Positioned(
                                  left: nameX,
                                  top: nameY,
                                  child: Transform(
                                    alignment: Alignment.center,
                                    transform: Matrix4.rotationY(rotateAngle),
                                    child: Text(
                                      userState.editedName,
                                      style: TextStyle(
                                        color: loadNewC
                                            ? const Color(0xffffffff)
                                            : postEditorState.isWhiteFrame
                                                ? postEditorState.nameColor
                                                : hexToColor(
                                                    frameDetails.nameColor),
                                        fontWeight: FontWeight.bold,
                                        fontSize: frameDetails.nameFontSize
                                            .toDouble(),
                                      ),
                                    ),
                                  ))),
                          Visibility(
                            visible: postEditorState.isOccupationVisible,
                            child: Positioned(
                                left: occupationX,
                                top: occupationY,
                                child: Transform(
                                  alignment: Alignment.center,
                                  transform: Matrix4.rotationY(rotateAngle),
                                  child: Text(
                                      userState.userOccupation.length > 60
                                          ? "${userState.userOccupation.substring(0, 60)} ..."
                                          : userState.userOccupation,
                                      style: TextStyle(
                                        color: loadNewC
                                            ? const Color(0xff000000)
                                            : postEditorState.isWhiteFrame
                                                ? postEditorState
                                                    .occupationColor
                                                : hexToColor(frameDetails
                                                    .occupationColor),
                                        fontSize: frameDetails
                                            .occupationFontSize
                                            .toDouble(),
                                      )),
                                )),
                          ),
                          Visibility(
                            visible: postEditorState.isNumberVisible,
                            child: Positioned(
                              left: numberX,
                              top: numberY,
                              child: Transform(
                                alignment: Alignment.center,
                                transform: Matrix4.rotationY(rotateAngle),
                                child: Text(
                                  userState.userNumber,
                                  style: TextStyle(
                                    color: loadNewC
                                        ? const Color(0xff000000)
                                        : postEditorState.isWhiteFrame
                                            ? postEditorState.numberColor
                                            : hexToColor(
                                                frameDetails.numberColor),
                                    fontSize:
                                        frameDetails.numberFontSize.toDouble(),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
              });
            })),
          ),
        );
      }),
    );
  }
}

class FrameDetails {
  final String imgLink;
  final String nameColor;
  final String occupationColor;
  final String numberColor;
  final String profilePos;
  final num nameX;
  final num nameY;
  final num nameFontSize;
  final num numberX;
  final num numberY;
  final num numberFontSize;
  final num profileY;
  final num profileX;
  final num occupationX;
  final num occupationY;
  final num occupationFontSize;
  final num width;
  final num radius;
  final num side;
  FrameDetails({
    required this.imgLink,
    this.profilePos = "right",
    required this.nameColor,
    required this.occupationColor,
    required this.numberColor,
    required this.nameX,
    required this.nameY,
    required this.numberX,
    required this.numberY,
    required this.profileY,
    required this.profileX,
    required this.occupationX,
    required this.occupationY,
    required this.width,
    required this.radius,
    required this.side,
    this.nameFontSize = 15,
    this.numberFontSize = 10,
    this.occupationFontSize = 10,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'imgLink': imgLink,
      'profilePos': profilePos,
      'nameColor': nameColor,
      'occupationColor': occupationColor,
      'numberColor': numberColor,
      'nameX': nameX,
      'nameY': nameY,
      'nameFontSize': nameFontSize,
      'numberX': numberX,
      'numberY': numberY,
      'numberFontSize': numberFontSize,
      'profileY': profileY,
      'profileX': profileX,
      'occupationX': occupationX,
      'occupationY': occupationY,
      'occupationFontSize': occupationFontSize,
      'width': width,
      'radius': radius,
      'side': side,
    };
  }

  factory FrameDetails.fromMap(Map<String, dynamic> map) {
    return FrameDetails(
      imgLink: map['imgLink'] as String,
      profilePos: map['profilePos'] as String,
      nameColor: map['nameColor'] as String,
      occupationColor: map['occupationColor'] as String,
      numberColor: map['numberColor'] as String,
      nameX: map['nameX'] as double,
      nameY: map['nameY'] as double,
      nameFontSize: map['nameFontSize'] as double,
      numberX: map['numberX'] as double,
      numberY: map['numberY'] as double,
      numberFontSize: map['numberFontSize'] as double,
      profileY: map['profileY'] as double,
      profileX: map['profileX'] as double,
      occupationX: map['occupationX'] as double,
      occupationY: map['occupationY'] as double,
      occupationFontSize: map['occupationFontSize'] as double,
      width: map['width'] as double,
      radius: map['radius'] as double,
      side: map['side'] as double,
    );
  }

  String toJson() => json.encode(toMap());

  factory FrameDetails.fromJson(String source) =>
      FrameDetails.fromMap(json.decode(source) as Map<String, dynamic>);

  FrameDetails copyWith({
    String? imgLink,
    String? userName,
    String? profilePos,
    String? occupation,
    String? number,
    String? nameColor,
    String? occupationColor,
    String? numberColor,
    double? nameX,
    double? nameY,
    double? nameFontSize,
    double? numberX,
    double? numberY,
    double? numberFontSize,
    double? profileY,
    double? profileX,
    double? occupationX,
    double? occupationY,
    double? occupationFontSize,
    double? width,
    double? radius,
    double? side,
  }) {
    return FrameDetails(
      imgLink: imgLink ?? this.imgLink,
      profilePos: profilePos ?? this.profilePos,
      nameColor: nameColor ?? this.nameColor,
      occupationColor: occupationColor ?? this.occupationColor,
      numberColor: numberColor ?? this.numberColor,
      nameX: nameX ?? this.nameX,
      nameY: nameY ?? this.nameY,
      nameFontSize: nameFontSize ?? this.nameFontSize,
      numberX: numberX ?? this.numberX,
      numberY: numberY ?? this.numberY,
      numberFontSize: numberFontSize ?? this.numberFontSize,
      profileY: profileY ?? this.profileY,
      profileX: profileX ?? this.profileX,
      occupationX: occupationX ?? this.occupationX,
      occupationY: occupationY ?? this.occupationY,
      occupationFontSize: occupationFontSize ?? this.occupationFontSize,
      width: width ?? this.width,
      radius: radius ?? this.radius,
      side: side ?? this.side,
    );
  }
}
