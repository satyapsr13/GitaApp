import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../Constants/colors.dart';
import '../../../../Logic/Cubit/PostEditorCubit/post_editor_cubit.dart';
import '../../../../Logic/Cubit/Posts/posts_cubit.dart';
import '../../../Widgets/frames_list_widget.dart';

class EditScreenShowHideAndFramesWidget extends StatelessWidget {
  const EditScreenShowHideAndFramesWidget({
    Key? key,
    required this.mq,
  }) : super(key: key);

  final Size mq;

  @override
  Widget build(BuildContext context) {
    final postEditorCubit = BlocProvider.of<PostEditorCubit>(context);
    return BlocBuilder<PostEditorCubit, PostEditorState>(
        builder: (context, postEditState) {
      return BlocBuilder<PostCubit, PostState>(builder: (context, state) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: () {
                      postEditorCubit.updateStateVariables(
                          isDateTagVisible:
                              !postEditorCubit.state.isDateTagVisible);
                    },
                    child: Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        color: postEditState.isDateTagVisible
                            ? AppColors.primaryColor
                            : Colors.grey.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: FittedBox(
                        child: Text(
                          ' Date ',
                          style: TextStyle(
                            color: !postEditState.isDateTagVisible
                                ? Colors.black
                                : Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      postEditorCubit.updateStateVariables(
                          isNameVisible: !postEditorCubit.state.isNameVisible);
                    },
                    child: Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        color: postEditState.isNameVisible
                            ? AppColors.primaryColor
                            : Colors.grey.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: FittedBox(
                        child: Text(
                          ' Name ',
                          style: TextStyle(
                              color: !postEditState.isNameVisible
                                  ? Colors.black
                                  : Colors.white),
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      postEditorCubit.updateStateVariables(
                          isOccupationVisible:
                              !postEditorCubit.state.isOccupationVisible);
                    },
                    child: Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        color: postEditState.isOccupationVisible
                            ? AppColors.primaryColor
                            : Colors.grey.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Icon(
                        Icons.work,
                        size: 15,
                        color: !postEditState.isOccupationVisible
                            ? Colors.black
                            : Colors.white,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      postEditorCubit.updateStateVariables(
                          isNumberVisible:
                              !postEditorCubit.state.isNumberVisible);
                    },
                    child: Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        color: postEditState.isNumberVisible
                            ? AppColors.primaryColor
                            : Colors.grey.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Icon(
                        Icons.phone,
                        size: 15,
                        color: !postEditState.isNumberVisible
                            ? Colors.black
                            : Colors.white,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      postEditorCubit.updateStateVariables(
                          isProfileVisible:
                              !postEditorCubit.state.isProfileVisible);
                    },
                    child: Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        color: postEditState.isProfileVisible
                            ? AppColors.primaryColor
                            : Colors.grey.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Icon(
                        Icons.person,
                        size: 15,
                        color: !postEditState.isProfileVisible
                            ? Colors.black
                            : Colors.white,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      postEditorCubit.updateStateVariables(
                          isFrameVisible:
                              !postEditorCubit.state.isFrameVisible);
                    },
                    child: Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        color: postEditState.isFrameVisible
                            ? AppColors.primaryColor
                            : Colors.grey.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: FittedBox(
                        child: Text(
                          ' Frame ',
                          style: TextStyle(
                            color: !postEditState.isFrameVisible
                                ? Colors.black
                                : Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            FramesListWidgetForEditor(
              mq: mq,
              showWhiteFrame: true,
            ),
          ],
        );
      });
    });
  }
}
