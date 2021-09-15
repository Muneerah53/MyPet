import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

const List<String> pList = ["jolly", "milo", "Tommy"];

class Grooming extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4E3E3),
      body: Center(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.fromLTRB(0, 120, 0, 0),
              child: Text(
                'Grooming',
                style: TextStyle(
                    color: Color(0XFFFF6B81),
                    fontSize: 34,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(0, 40, 0, 0),
              child: Text(
                'check any of the servaces you want to do it on you pet ...',
                style: TextStyle(
                    color: const Color(0xFF52648B),
                    fontSize: 14,
                    fontStyle: FontStyle.italic),
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(0, 40, 0, 0),
              height: 35.0,
              child: CupertinoPicker(
                itemExtent: 33.0,
                diameterRatio: 5,
                offAxisFraction: 10,
                onSelectedItemChanged: (selectedIndex) {
                  print(selectedIndex);
                },
                children: getPet(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Text> getPet() {
    List<Text> pickerItems = [];
    for (String p in pList) {
      pickerItems.add(Text(p,
          style: TextStyle(
            color: Color(0xFF000000),
          )));
    }
    return pickerItems;
  }
}
