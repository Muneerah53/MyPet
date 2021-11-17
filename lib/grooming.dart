import 'package:cloud_firestore/cloud_firestore.dart';
import 'OrderList.dart';
import 'appointment_object.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';



class Grooming extends StatefulWidget {


  final appointment? appoint;


  const Grooming(
      {this.appoint});
  @override
  _GroomingState createState() => _GroomingState();
}

class _GroomingState extends State<Grooming> {
  Map<String, bool > SList = {};
  Map<String, String > PList = {};
  Map<String, String > SNList = {};


  //
  // var selectedCurrency;
  //
  // bool ShowerAndDryingV = false;
  // bool DryCleanV = false;
   int? t = 0;
  // bool? RShV;
  // bool? flShV;
  // bool? funShV;
  // bool ShavingV = false;
  // bool? Shav0V;
  // bool? Shav1V;
  // bool? Shav2V;
  // bool? Shav3V;
  // bool HairCutV = false;
  // bool EarCleaningV = false;
  // bool CutnailsV = false;
  // bool NeedsAnesthesiaV = false;
  // int _Value = 1;
  // int _Value2 = 2;
  //

  double? total = 0.0;
appointment? a;
  bool type = false; // default false: 0 -> Check-Up
  setType() {
    setState(() {
      type = !type; // to true(1) if grooming
    });
  }

  void initState() {
    super.initState();
    a = widget.appoint;


  }


  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Icon(Icons.arrow_back_ios, color: Color(0xFF2F3542)),
          style: ElevatedButton.styleFrom(
            shape: CircleBorder(),
            padding: EdgeInsets.all(20),
            primary: Colors.transparent,
            shadowColor: Colors.transparent,
          ),
        ), // <-- Button color// <-- Splash color
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
              margin: const EdgeInsets.fromLTRB(20, 40, 0, 0),
              child: Text(
                'Check any of the services you want to do it on your pet ...',
                style: TextStyle(
                    color: const Color(0xFF52648B),
                    fontSize: 14,
                    fontStyle: FontStyle.italic),
              ),
            ),
SizedBox(height: 30),
          Container(
                width: double.maxFinite,
                child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("service")
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData)
                        return const Text('loading');
                      if (snapshot.data!.docs.isEmpty)
                        return Padding(
                            padding: EdgeInsets.all(20),
                            child: const Text('No Added services',
                                style: TextStyle(
                                    color: const Color(0xFF552648B),
                                    fontSize: 20,
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.bold))
                        );
                      return ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            String key = (snapshot.data!)
                                .docs[index]['serviceID'];
                            SList[key] = SList[key] ?? false;
PList[key]= (snapshot.data!)
    .docs[index]['servicePrice'];
                            SNList[key]= (snapshot.data!)
                                .docs[index]['serviceName'];

                            return CheckboxListTile(

                                title: Text((snapshot.data!)
                                    .docs[index]['serviceName']+"                "+(snapshot.data!)
                                    .docs[index]['servicePrice']+" SAR" ,
                                    style: TextStyle(
                                    color: const Color(0xFF552648B),
                                    fontSize: 20,
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.bold)),
                                value: SList[key],
                                onChanged: (value) {
                                  setState(() {
                                    SList[key] = value!;
                                  });

                                }
                            );

                          });
                    })

            ),

            // Container(
            //   margin: const EdgeInsets.fromLTRB(0, 50, 0, 80),
            //   width: 193,
            //   height: 73,
            //   child: ElevatedButton(
            //       onPressed: () {
            //         if (!(ShowerAndDryingV ||
            //             DryCleanV ||
            //             ShavingV ||
            //             HairCutV ||
            //             EarCleaningV ||
            //             CutnailsV ||
            //             NeedsAnesthesiaV)) {
            //           showAlertDialog(
            //               context, "You Must Select at Least One Servace");
            //         } else {
            //           t = 1;
            //           a!.total = TotalPrice();
            //           a!.desc = a!.type!+":"+ getService().toString();
            //
            //
            //           Navigator.push(
            //             context,
            //             MaterialPageRoute(
            //                 builder: (BuildContext context) => OrderList(
            //                     appoint: a)),
            //           );
            //         }
            //       },
            //       child: Text('Next',
            //           style:
            //               TextStyle(fontStyle: FontStyle.italic, fontSize: 25)),
            //       style: ButtonStyle(
            //         backgroundColor:
            //             MaterialStateProperty.all(Color(0XFF2F3542)),
            //         shape: MaterialStateProperty.all(RoundedRectangleBorder(
            //             borderRadius: BorderRadius.circular(20.0))),
            //       )),
            // ),
            Container(
              margin: const EdgeInsets.fromLTRB(0, 50, 0, 80),
              width: 193,
              height: 73,
              child: ElevatedButton(

                  onPressed: () {

                    if (check(SList)) {
                      showAlertDialog(
                          context, "You Must Select at Least One Service");
                    } else {
                      t = 1;
                      a!.total = TotalPrice(SList);
                      a!.desc = a!.type!+":"+ getService().toString();


                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => OrderList(
                                appoint: a)),
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
  double TotalPrice(Map<String, bool> sList) {
    double to =0.0;
    SList.forEach((key, value) {
if(value==true){
  String v = key;
  PList.forEach((key, value) {
    if(v == key){
       to += double.parse(value);
    }
  });
}
      }

    );
    return to;
  }

  List<String> getService() {
    List<String> services = <String>[];
    // PList.forEach((key, value) {
    //   if(value==true){
    //   services.add(value);}
    // });
    // return services;
    SList.forEach((key, value) {
      if(value==true){
        String v = key;
        SNList.forEach((key, value) {
          if(v == key){
            services.add(value);
          }
        });
      }
    }

    );
    return   services ;
  }

  bool check(Map<String, bool> sList){
    bool v = true;
    sList.forEach((key, value) {
      if(value==true){
        v = false;
      }
    }
    );
    return v;
  }
  // double TotalPrice() {
  //   double t = 0.0;
  //   if (ShowerAndDryingV) {
  //     t = t + 30.0;
  //   }
  //   if (DryCleanV) {
  //     t = t + 20.0;
  //   }
  //   if (ShavingV) {
  //     t = t + 30.0;
  //   }
  //   if (HairCutV) {
  //     t = t + 30.0;
  //   }
  //   if (EarCleaningV) {
  //     t = t + 2.0;
  //   }
  //   if (CutnailsV) {
  //     t = t + 5.0;
  //   }
  //   if (NeedsAnesthesiaV) {
  //     t = t + 30.0;
  //   }
  //   return t;
  // }
  //
  // List<String> getService() {
  //   List<String> services = <String>[];
  //   if (ShowerAndDryingV) {
  //     services.add("Shower and Drying");
  //   }
  //   if (DryCleanV) {
  //     services.add("Dry Clean");
  //   }
  //   if (ShavingV) {
  //     services.add("Shaving");
  //   }
  //   if (HairCutV) {
  //     services.add("Hair Cut");
  //   }
  //   if (EarCleaningV) {
  //     services.add("Ear Cleaning");
  //   }
  //   if (CutnailsV) {
  //     services.add("Cut Nails");
  //   }
  //   if (NeedsAnesthesiaV) {
  //     services.add("Anesthesia");
  //   }
  //   print(services.toString());
  //   return services;
  // }

  showAlertDialog(BuildContext context, message) {
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
