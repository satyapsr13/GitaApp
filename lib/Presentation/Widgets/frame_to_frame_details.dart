import 'dart:math';

import '../../Data/model/api/frames_response.dart';
import '../Screens/PostsScreens/PostFrames/post_frames.dart';
 

FrameDetails frameToFrameDetails(Frame f, double maxWidth) {
  return FrameDetails(
    imgLink: f.profile?.image ?? "",
    nameX: f.name?.x ?? 0,
    nameY: f.name?.y ?? 0,
    numberX: f.number?.x ?? 0,
    numberY: f.number?.y ?? 0,
    profileX: f.profile?.x ?? 0,
    profileY: f.profile?.y ?? 0,
    occupationX: f.occupation?.x ?? 0,
    occupationY: f.occupation?.y ?? 0,
    width: maxWidth,
    profilePos: f.profile?.position ?? "right",
    radius: 40,
    side: 200.0,
    nameColor: f.name?.color ?? '#ffffff',
    numberColor: f.number?.color ?? '#ffffff',
    occupationColor: f.occupation?.color ?? '#ffffff',
  );
}
