import 'package:flutter/material.dart';
import 'package:rishteyy/Presentation/Widgets/post_widget.dart';

import '../../Constants/colors.dart';

Widget loadingBuilder(
    BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
  if (loadingProgress == null) {
    return child;
  } else {
    return Center(
      child: true
          ? RishteyyShimmerLoader(
              mq: Size(150, 150),
            )
          : CircularProgressIndicator(
              color: AppColors.primaryColor,
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes!
                  : null,
            ),
    );
  }
}
