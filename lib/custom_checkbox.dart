library event_calendar;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'OrderList.dart';
import 'appointment_main.dart';

part 'grooming.dart';

class CustomCheckbox extends StatefulWidget {
  //const CustomCheckbox({Key? key}) : super(key: key);

  final bool? isChecked;
  CustomCheckbox({this.isChecked});

  @override
  _CustomCheckboxState createState() => _CustomCheckboxState();
}

class _CustomCheckboxState extends State<CustomCheckbox> {
  bool isSelected = false;

  @override
  void initState() {
    isSelected = widget.isChecked ?? false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isSelected = !isSelected;
        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 400),
        curve: Curves.fastLinearToSlowEaseIn,
        decoration: BoxDecoration(
            border: isSelected
                ? null
                : Border.all(
                    color: Color(0XFFF4F4F4),
                    width: 2.0,
                  ),
            color: isSelected ? Colors.pinkAccent : Color(0XFFF4F4F4),
            borderRadius: BorderRadius.circular(5.0)),
        width: 25,
        height: 25,
        child: isSelected
            ? Icon(
                Icons.check,
                color: Colors.white,
                size: 20,
              )
            : null,
      ),
    );
    //);
  }
}

// bool? onSelectParam(bool? isSelected) {
//   return isChecked;
// }
