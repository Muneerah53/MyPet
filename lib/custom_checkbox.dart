import 'package:flutter/material.dart';
import 'package:flutter_app3/Grooming.dart';

class CustomCheckbox extends StatefulWidget {
  //const CustomCheckbox({Key? key}) : super(key: key);

  final bool? isChecked;

  CustomCheckbox({this.isChecked});

  @override
  _CustomCheckboxState createState() => _CustomCheckboxState();
}

class _CustomCheckboxState extends State<CustomCheckbox> {
  bool _isSelected = false;

  @override
  void initState() {
    _isSelected = widget.isChecked ?? false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isSelected = !_isSelected;
        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 400),
        curve: Curves.fastLinearToSlowEaseIn,
        decoration: BoxDecoration(
            border: _isSelected
                ? null
                : Border.all(
                    color: Color(0XFFF4F4F4),
                    width: 2.0,
                  ),
            color: _isSelected ? Colors.pinkAccent : Color(0XFFF4F4F4),
            borderRadius: BorderRadius.circular(5.0)),
        width: 25,
        height: 25,
        child: _isSelected
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

  bool isHSelected(bool value) {
    return value;
  }
  //
  // bool get check {
  //   return _isSelected;
  // }
}
