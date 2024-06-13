// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import '../../../Constants/constants.dart';
import '../../../Data/model/ObjectModels/post_widget_model.dart';
import '../../../Utility/next_screen.dart';
import '../../Screens/PostsScreens/post_edit_screen.dart'; 

class EditButton extends StatelessWidget {
  // const EditButton({super.key});
  final String parentScreenName;
  final PostWidgetModel postWidgetData;
  const EditButton({
    Key? key,
    required this.parentScreenName,
    required this.postWidgetData,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        nextScreenWithFadeAnimation(
            context,
            PostEditScreen(
              postWidgetData: postWidgetData.copyWith(topTagPosition: "right"),
              parentScreenName: parentScreenName,
            ));
      },
      child: Container(
        height: 35,
        width: 70,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: Gradients.blueGradient),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: const [
            Icon(
              Icons.edit,
              size: 15,
              color: Colors.white,
            ),
            Text(
              'Edit',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
