// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../Constants/colors.dart';

class CSwitch extends StatefulWidget {
  // const CSwitch({super.key});
  Function(bool) onChange;
  final bool? initialVal;
  CSwitch({Key? key, required this.onChange, this.initialVal})
      : super(key: key);

  @override
  State<CSwitch> createState() => _CSwitchState();
}

class _CSwitchState extends State<CSwitch> {
  bool val = true;
  @override
  void initState() {
    // TODO: implement initState
    if (widget.initialVal != null) {
      val = widget.initialVal!;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        setState(() {
          val = !val;
        });
        widget.onChange(val);
      },
      child: Container(
        width: 60,
        height: 25,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: val == false ? Colors.grey : AppColors.primaryColor),
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Visibility(
                visible: val,
                replacement: Container(
                  // width: 60,
                  width: 20,
                  height: 20,
                  decoration: const BoxDecoration(
                      // borderRadius: BorderRadius.circular(30),
                      shape: BoxShape.circle,
                      color: Colors.white),
                ),
                child: Container(
                  width: 33,
                  height: 30,
                  decoration: const BoxDecoration(
                      // borderRadius: BorderRadius.circular(30),
                      // shape: BoxShape.circle,
                      color: Colors.transparent),
                  child: Center(
                      child: Text(
                    tr("yes"),
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  )),
                ),
              ),
              Visibility(
                visible: val,
                replacement: Container(
                  width: 33,
                  height: 30,
                  decoration: const BoxDecoration(
                      // borderRadius: BorderRadius.circular(30),
                      // shape: BoxShape.circle,
                      color: Colors.transparent),
                  child: Center(
                      child: Text(
                    tr("no"),
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  )),
                ),
                child: Container(
                  // width: 60,
                  // height: 30,
                  height: 20,
                  width: 20,
                  decoration: const BoxDecoration(
                      // borderRadius: BorderRadius.circular(30),
                      shape: BoxShape.circle,
                      color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
