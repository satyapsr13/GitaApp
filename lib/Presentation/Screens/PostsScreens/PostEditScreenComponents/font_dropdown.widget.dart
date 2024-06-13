import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../Constants/constants.dart';
import '../../../../Logic/Cubit/StickerCubit/sticker_cubit.dart';

class FontDropdownWidget extends StatelessWidget {
  final bool? isDense;
  final bool? isBlankPostFont;
  final double? width;
  final void Function(int)? onChange;
  const FontDropdownWidget({
    Key? key,
    this.isBlankPostFont,
    this.width,
    this.isDense,
    this.onChange,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: width,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 1),
        borderRadius: BorderRadius.circular(5),
        color: Colors.transparent,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 0),
        child: DropdownButtonHideUnderline(
          child: DropdownButton(
            menuMaxHeight: 400,
            focusColor: Colors.white,
            isDense: isDense ?? false,
            iconSize: 15,
            style: const TextStyle(color: Colors.white),
            items: <int>[
              ...List.generate(
                  Constants.googleFontStyles.length, (index) => index)
            ].map<DropdownMenuItem<int>>((int value) {
              return DropdownMenuItem<int>(
                value: value,
                child: Text(
                  "${value + 1}- ${tr("aa")}",
                  style: Constants.googleFontStyles[value],
                ),
              );
            }).toList(),
            hint: BlocBuilder<StickerCubit, StickerState>(
                builder: (context, state) {
              return Text(
                tr("font"),
                style: Constants.googleFontStyles[isBlankPostFont == true
                    ? state.blankPostTextFontIndex
                    : state.fontIndex],
              );
            }),
            onChanged: (value) {
              if (onChange != null) {
                onChange!(int.tryParse(value.toString()) ?? 0);
              }
              if (isBlankPostFont == true) {
                BlocProvider.of<StickerCubit>(context).updateStateVariables(
                    blankPostTextFontIndex: int.tryParse(value.toString()));
              } else {
                BlocProvider.of<StickerCubit>(context).updateStateVariables(
                    fontIndex: int.tryParse(value.toString()));
              }
            },
          ),
        ),
      ),
    );
  }
}
