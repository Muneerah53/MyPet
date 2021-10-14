part of event_calendar;

//bool? _isChecked = false;

class Grooming extends StatefulWidget {
  final String? title;
  final String? date;
  final String? pet;
  final String? time;
  final String? appointID;

  const Grooming({this.title, this.date, this.pet, this.time, this.appointID});
  @override
  _GroomingState createState() => _GroomingState();
}

class _GroomingState extends State<Grooming> {
  var selectedCurrency;
  bool ShowerAndDryingV = false;
  bool DryCleanV = false;
  int? t = 0;
  bool? RShV;
  bool? flShV;
  bool? funShV;
  bool ShavingV = false;
  bool? Shav0V;
  bool? Shav1V;
  bool? Shav2V;
  bool? Shav3V;
  bool HairCutV = false;
  bool EarCleaningV = false;
  bool CutnailsV = false;
  bool NeedsAnesthesiaV = false;
  int _Value = 1;
  int _Value2 = 2;
  String? d;
  String? p;
  String? ti;
  String? id;
  double? total = 0.0;

  bool type = false; // default false: 0 -> Check-Up
  setType() {
    setState(() {
      type = !type; // to true(1) if grooming
    });
  }

  void initState() {
    super.initState();
    d = widget.date;
    p = widget.pet;
    ti = widget.time;
    id= widget.appointID;
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation:0,
          leading: ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },

              child: Icon(Icons.arrow_back_ios, color: Color(0xFF2F3542)),
              style: ElevatedButton.styleFrom(shape: CircleBorder(), padding: EdgeInsets.all(20), primary: Colors.transparent, shadowColor: Colors.transparent,),
    ),// <-- Button color// <-- Splash color

      ),
      backgroundColor: const Color(0xFFF4E3E3),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
                'Check any of the services you want to do it on your pet ...',
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
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          ShowerAndDryingV = !ShowerAndDryingV;
                        });
                      },
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 400),
                        curve: Curves.fastLinearToSlowEaseIn,
                        decoration: BoxDecoration(
                            border: ShowerAndDryingV
                                ? null
                                : Border.all(
                                    color: Color(0XFFF4F4F4),
                                    width: 2.0,
                                  ),
                            color: ShowerAndDryingV
                                ? Colors.pinkAccent
                                : Color(0XFFF4F4F4),
                            borderRadius: BorderRadius.circular(5.0)),
                        width: 25,
                        height: 25,
                        child: ShowerAndDryingV
                            ? Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 20,
                              )
                            : null,
                      ),
                    ),
                  ),
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
              margin: const EdgeInsets.fromLTRB(30, 30, 0, 0),
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
              margin: const EdgeInsets.fromLTRB(30, 30, 0, 0),
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
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          DryCleanV = !DryCleanV;
                        });
                      },
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 400),
                        curve: Curves.fastLinearToSlowEaseIn,
                        decoration: BoxDecoration(
                            border: DryCleanV
                                ? null
                                : Border.all(
                                    color: Color(0XFFF4F4F4),
                                    width: 2.0,
                                  ),
                            color: DryCleanV
                                ? Colors.pinkAccent
                                : Color(0XFFF4F4F4),
                            borderRadius: BorderRadius.circular(5.0)),
                        width: 25,
                        height: 25,
                        child: DryCleanV
                            ? Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 20,
                              )
                            : null,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(30, 30, 0, 0),
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
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          ShavingV = !ShavingV;
                        });
                      },
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 400),
                        curve: Curves.fastLinearToSlowEaseIn,
                        decoration: BoxDecoration(
                            border: ShavingV
                                ? null
                                : Border.all(
                                    color: Color(0XFFF4F4F4),
                                    width: 2.0,
                                  ),
                            color: ShavingV
                                ? Colors.pinkAccent
                                : Color(0XFFF4F4F4),
                            borderRadius: BorderRadius.circular(5.0)),
                        width: 25,
                        height: 25,
                        child: ShavingV
                            ? Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 20,
                              )
                            : null,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(30, 30, 0, 0),
              child: Text(
                'Level of Shaving ..',
                style: TextStyle(
                    color: const Color(0xFF52648B),
                    fontSize: 14,
                    fontStyle: FontStyle.italic),
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(30, 30, 0, 0),
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
              margin: const EdgeInsets.fromLTRB(30, 30, 0, 0),
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
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          HairCutV = !HairCutV;
                        });
                      },
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 400),
                        curve: Curves.fastLinearToSlowEaseIn,
                        decoration: BoxDecoration(
                            border: HairCutV
                                ? null
                                : Border.all(
                                    color: Color(0XFFF4F4F4),
                                    width: 2.0,
                                  ),
                            color: HairCutV
                                ? Colors.pinkAccent
                                : Color(0XFFF4F4F4),
                            borderRadius: BorderRadius.circular(5.0)),
                        width: 25,
                        height: 25,
                        child: HairCutV
                            ? Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 20,
                              )
                            : null,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(30, 30, 0, 0),
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
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          EarCleaningV = !EarCleaningV;
                        });
                      },
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 400),
                        curve: Curves.fastLinearToSlowEaseIn,
                        decoration: BoxDecoration(
                            border: EarCleaningV
                                ? null
                                : Border.all(
                                    color: Color(0XFFF4F4F4),
                                    width: 2.0,
                                  ),
                            color: EarCleaningV
                                ? Colors.pinkAccent
                                : Color(0XFFF4F4F4),
                            borderRadius: BorderRadius.circular(5.0)),
                        width: 25,
                        height: 25,
                        child: EarCleaningV
                            ? Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 20,
                              )
                            : null,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(30, 30, 0, 0),
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
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          CutnailsV = !CutnailsV;
                        });
                      },
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 400),
                        curve: Curves.fastLinearToSlowEaseIn,
                        decoration: BoxDecoration(
                            border: CutnailsV
                                ? null
                                : Border.all(
                                    color: Color(0XFFF4F4F4),
                                    width: 2.0,
                                  ),
                            color: CutnailsV
                                ? Colors.pinkAccent
                                : Color(0XFFF4F4F4),
                            borderRadius: BorderRadius.circular(5.0)),
                        width: 25,
                        height: 25,
                        child: CutnailsV
                            ? Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 20,
                              )
                            : null,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(30, 30, 0, 0),
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
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          NeedsAnesthesiaV = !NeedsAnesthesiaV;
                        });
                      },
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 400),
                        curve: Curves.fastLinearToSlowEaseIn,
                        decoration: BoxDecoration(
                            border: NeedsAnesthesiaV
                                ? null
                                : Border.all(
                                    color: Color(0XFFF4F4F4),
                                    width: 2.0,
                                  ),
                            color: NeedsAnesthesiaV
                                ? Colors.pinkAccent
                                : Color(0XFFF4F4F4),
                            borderRadius: BorderRadius.circular(5.0)),
                        width: 25,
                        height: 25,
                        child: NeedsAnesthesiaV
                            ? Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 20,
                              )
                            : null,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(0, 50, 0, 80),
              width: 193,
              height: 73,
              child: ElevatedButton(
                  onPressed: () {

                    if (!(ShowerAndDryingV ||
                        DryCleanV ||
                        ShavingV ||
                        HairCutV ||
                        EarCleaningV ||
                        CutnailsV ||
                        NeedsAnesthesiaV)) {
                      showAlertDialog(context,"You Must Select at Least One Servace");
                    } else {
                      t = 1;
                      total = TotalPrice();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => OrderList(
                                type: t,
                                date: d,
                                pet: p,
                                time: ti,
                                appointID: id,
                                total: total)),
                      );
                    }
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
            // Container(
            //   margin: const EdgeInsets.fromLTRB(0, 50, 0, 80),
            //   width: 193,
            //   height: 73,
            //   child: ElevatedButton(
            //       onPressed: () {
            //         print(TotalPrice());
            //       },
            //       child: Text('print',
            //           style:
            //               TextStyle(fontStyle: FontStyle.italic, fontSize: 25)),
            //       style: ButtonStyle(
            //         backgroundColor:
            //             MaterialStateProperty.all(Color(0XFF2F3542)),
            //         shape: MaterialStateProperty.all(RoundedRectangleBorder(
            //             borderRadius: BorderRadius.circular(20.0))),
            //       )),
            // ),
          ],
        ),
      ),
    );
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    throw UnimplementedError();
  }

  double TotalPrice() {
    double t = 0.0;
    if (ShowerAndDryingV) {
      t = t + 30.0;
    }
    if (DryCleanV) {
      t = t + 20.0;
    }
    if (ShavingV) {
      t = t + 30.0;
    }
    if (HairCutV) {
      t = t + 30.0;
    }
    if (EarCleaningV) {
      t = t + 2.0;
    }
    if (CutnailsV) {
      t = t + 5.0;
    }
    if (NeedsAnesthesiaV) {
      t = t + 30.0;
    }
    return t;
  }

  showAlertDialog(BuildContext context,message) {
    // set up the button
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Missing Input"),
      content: Text(message),
      actions: [
        okButton,
      ],
    );
// show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
