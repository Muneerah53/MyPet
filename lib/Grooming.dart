// ignore: file_names
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_app3/OrderList.dart';
import 'package:flutter_app3/custom_checkbox.dart';
import 'package:flutter_app3/main.dart';

const List<String> pList = ["jolly", "milo", "Tommy"];
bool? _isChecked = false;

class Grooming extends StatefulWidget {
  const Grooming({Key? key}) : super(key: key);
  @override
  _GroomingState createState() => _GroomingState();
}

class _GroomingState extends State<Grooming> {
  int _Value = 1;
  int _Value2 = 2;
  String dropdownValue = 'No Pet';

  @override
  Widget build(BuildContext context) {
    bool? ShowerAndDryingV;
    bool? RShV;
    bool? flShV;
    bool? funShV;
    bool? DryCleanV;
    bool? ShavingV;
    bool? Shav0V;
    bool? Shav1V;
    bool? Shav2V;
    bool? Shav3V;
    bool? HairCutV;
    bool? EarCleaningV;
    bool? CutnailsV;
    bool? NeedsAnesthesiaV;
    return Scaffold(
      backgroundColor: const Color(0xFFF4E3E3),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.fromLTRB(0, 80, 330, 0),
              padding: EdgeInsets.only(left: 10.0),
              width: 50,
              height: 50,
              child: BackButton(
                color: Colors.white,
              ),
              decoration: BoxDecoration(
                  color: Colors.lightBlueAccent, shape: (BoxShape.circle)),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
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
                'Check any of the servaces you want to do it on your pet ...',
                style: TextStyle(
                    color: const Color(0xFF52648B),
                    fontSize: 14,
                    fontStyle: FontStyle.italic),
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(50, 40, 0, 0),
              child: Row(
                children: [
                  Container(
                      child: Text("Shower & Drying",
                          style: TextStyle(
                              color: const Color(0xFF552648B),
                              fontSize: 20,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold))),
                  const SizedBox(
                    width: 130.0,
                  ),
                  Container(
                      child: CustomCheckbox(
                    isChecked: ShowerAndDryingV,
                  )),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(55, 20, 220, 10),
              child: Text(
                'Shampoo Type...',
                style: TextStyle(
                    color: const Color(0xFF52648B),
                    fontSize: 17,
                    fontStyle: FontStyle.italic),
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(45, 0, 0, 0),
              child: Row(
                children: [
                  Container(
                    child: Radio(
                      fillColor: MaterialStateColor.resolveWith(
                          (states) => Colors.black26),
                      value: 1,
                      groupValue: _Value,
                      onChanged: (value) {
                        setState(() {
                          _Value = value as int;
                        });
                      },
                    ),
                  ),
                  Container(
                    child: Text("Regular shampoo",
                        style: TextStyle(
                            color: const Color(0xFF552648B),
                            fontSize: 14,
                            fontStyle: FontStyle.italic)),
                  ),
                  Container(
                    child: Radio(
                      fillColor: MaterialStateColor.resolveWith(
                          (states) => Colors.black26),
                      value: 2,
                      groupValue: _Value,
                      onChanged: (value) {
                        setState(() {
                          _Value = value as int;
                        });
                      },
                    ),
                  ),
                  Container(
                    child: Text("Shampoo for fleas",
                        style: TextStyle(
                            color: const Color(0xFF552648B),
                            fontSize: 14,
                            fontStyle: FontStyle.italic)),
                  )
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(45, 0, 0, 0),
              child: Row(
                children: [
                  Container(
                    child: Radio(
                      fillColor: MaterialStateColor.resolveWith(
                          (states) => Colors.black26),
                      value: 3,
                      groupValue: _Value,
                      onChanged: (value) {
                        setState(() {
                          _Value = value as int;
                        });
                      },
                    ),
                  ),
                  Container(
                    child: Text("Shampoo for fungus",
                        style: TextStyle(
                            color: const Color(0xFF552648B),
                            fontSize: 14,
                            fontStyle: FontStyle.italic)),
                  )
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(50, 30, 0, 0),
              child: Row(
                children: [
                  Container(
                      child: Text("Dry Cleaning  ",
                          style: TextStyle(
                              color: const Color(0xFF552648B),
                              fontSize: 20,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold))),
                  const SizedBox(
                    width: 160.0,
                  ),
                  Container(
                      child: CustomCheckbox(
                    isChecked: false,
                  )),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(50, 30, 0, 0),
              child: Row(
                children: [
                  Container(
                      child: Text("Shaving",
                          style: TextStyle(
                              color: const Color(0xFF552648B),
                              fontSize: 20,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold))),
                  const SizedBox(
                    width: 218.0,
                  ),
                  Container(
                      child: CustomCheckbox(
                    isChecked: false,
                  )),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(45, 15, 220, 0),
              child: Text(
                'Level of Shaving ..',
                style: TextStyle(
                    color: const Color(0xFF52648B),
                    fontSize: 14,
                    fontStyle: FontStyle.italic),
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(50, 0, 0, 0),
              child: Row(
                children: [
                  Container(
                    child: Radio(
                      fillColor: MaterialStateColor.resolveWith(
                          (states) => Colors.black26),
                      value: 1,
                      groupValue: _Value2,
                      onChanged: (value) {
                        setState(() {
                          _Value2 = value as int;
                        });
                      },
                    ),
                  ),
                  Container(
                    child: Text("0",
                        style: TextStyle(
                            color: const Color(0xFF552648B),
                            fontSize: 14,
                            fontStyle: FontStyle.italic)),
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(35, 0, 0, 0),
                    child: Radio(
                      fillColor: MaterialStateColor.resolveWith(
                          (states) => Colors.black26),
                      value: 2,
                      groupValue: _Value2,
                      onChanged: (value) {
                        setState(() {
                          _Value2 = value as int;
                        });
                      },
                    ),
                  ),
                  Container(
                    child: Text("1",
                        style: TextStyle(
                            color: const Color(0xFF552648B),
                            fontSize: 14,
                            fontStyle: FontStyle.italic)),
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(35, 0, 0, 0),
                    child: Radio(
                      fillColor: MaterialStateColor.resolveWith(
                          (states) => Colors.black26),
                      value: 3,
                      groupValue: _Value2,
                      onChanged: (value) {
                        setState(() {
                          _Value2 = value as int;
                        });
                      },
                    ),
                  ),
                  Container(
                    child: Text("2",
                        style: TextStyle(
                            color: const Color(0xFF552648B),
                            fontSize: 14,
                            fontStyle: FontStyle.italic)),
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(35, 0, 0, 0),
                    child: Radio(
                      fillColor: MaterialStateColor.resolveWith(
                          (states) => Colors.black26),
                      value: 4,
                      groupValue: _Value2,
                      onChanged: (value) {
                        setState(() {
                          _Value2 = value as int;
                        });
                      },
                    ),
                  ),
                  Container(
                    child: Text("3",
                        style: TextStyle(
                            color: const Color(0xFF552648B),
                            fontSize: 14,
                            fontStyle: FontStyle.italic)),
                  )
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(50, 30, 0, 0),
              child: Row(
                children: [
                  Container(
                      child: Text("Hair Cut ",
                          style: TextStyle(
                              color: const Color(0xFF552648B),
                              fontSize: 20,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold))),
                  const SizedBox(
                    width: 210.0,
                  ),
                  Container(
                      child: CustomCheckbox(
                    isChecked: false,
                  )),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(50, 30, 0, 0),
              child: Row(
                children: [
                  Container(
                      child: Text("Ear Cleaning ",
                          style: TextStyle(
                              color: const Color(0xFF552648B),
                              fontSize: 20,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold))),
                  const SizedBox(
                    width: 167.0,
                  ),
                  Container(
                      child: CustomCheckbox(
                    isChecked: false,
                  )),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(50, 30, 0, 0),
              child: Row(
                children: [
                  Container(
                      child: Text("Cut Nails ",
                          style: TextStyle(
                              color: const Color(0xFF552648B),
                              fontSize: 20,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold))),
                  const SizedBox(
                    width: 202.0,
                  ),
                  Container(
                      child: CustomCheckbox(
                    isChecked: false,
                  )),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(50, 30, 0, 0),
              child: Row(
                children: [
                  Container(
                      child: Text("Needs Anesthesia",
                          style: TextStyle(
                              color: const Color(0xFF552648B),
                              fontSize: 20,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold))),
                  const SizedBox(
                    width: 118.0,
                  ),
                  Container(
                      child: CustomCheckbox(
                    isChecked: false,
                  )),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(0, 50, 0, 80),
              width: 193,
              height: 73,
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => OrderList()),
                    );
                  },
                  child: Text('Next',
                      style:
                          TextStyle(fontStyle: FontStyle.italic, fontSize: 25)),
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Color(0XFF2F3542)),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0))),
                  )),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
              width: 193,
              height: 73,
              child: ElevatedButton(
                  onPressed: () {
                    print(ShowerAndDryingV);
                  },
                  child: Text('print',
                      style:
                          TextStyle(fontStyle: FontStyle.italic, fontSize: 25)),
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Color(0XFF2F3542)),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0))),
                  )),
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

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    throw UnimplementedError();
  }
}

class groomingOrder {
  bool? ShowerAndDrying;
  bool? RSh = false;
  bool? flSh = false;
  bool? funSh = false;
  bool? DryClean = false;
  bool? Shaving = false;
  bool? Shav0 = false;
  bool? Shav1 = false;
  bool? Shav2 = false;
  bool? Shav3 = false;
  bool? HairCut = false;
  bool? EarCleaning = false;
  bool? Cutnails = false;
  bool? NeedsAnesthesia = false;

  groomingOrder(
      {this.ShowerAndDrying,
      this.RSh,
      this.flSh,
      this.funSh,
      this.DryClean,
      this.Shaving,
      this.Shav0,
      this.Shav1,
      this.Shav2,
      this.Shav3,
      this.HairCut,
      this.EarCleaning,
      this.Cutnails,
      this.NeedsAnesthesia});

  void main() {
    var t = new groomingOrder(
        // ShowerAndDrying ,
        // RSh,
        // flSh,
        // funSh,
        // DryClean,
        // Shaving,
        // Shav0,
        // Shav1,
        // Shav2,
        // Shav3,
        // HairCut,
        // EarCleaning,
        // Cutnails,
        // NeedsAnesthesia
        );
    print(t.toString());
  }
}
