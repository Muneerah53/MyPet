import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Payment.dart';
import 'models/data.dart';


class Paymentscreen extends StatefulWidget{
  Paymentscreen(
      this.price,
      this.type,
      this.date,
      this.pet,
      this.time,
      this.total,
      this.appointID,
      this.petId,
      this.desc);
  final price;
  final int? type;
  final String? date;
  final String? pet;
  final String? time;
  final double? total;
  final String? appointID;
  final String? petId;
  final String desc;

  @override
  _Paymentscreen createState()=>_Paymentscreen();
}
class _Paymentscreen extends State<Paymentscreen>{
  int? t = 0;
  int price= 0;
  String title = '';
  String? p;
  String? pid;
  String? d;
  String? tt;
  double? to;
  String? appointID;
  String? aa;
  late String description;
  void initState() {
    super.initState();
    description = widget.desc;
    t = widget.type;
    d = widget.date;
    tt = widget.time;
    p = widget.pet;
    pid = widget.petId;
    to = widget.total;
     price= to!.toInt();

    appointID = widget.appointID;
    title = (t == 0) ? "Check-Up" : "Grooming"; //here var is call and set to
  }
  String _loadHTML(){
    return 'http://172.20.10.3:8000/price?id=$price';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: WebView(
          onPageStarted:(url) {
            if (url.contains('/success')) {
              print(url);
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Payment()));
            }
            if (url.contains('/cancel')) {
              Navigator.of(context).pop();
            }
          },
          onPageFinished:(url){
            if(url.contains('/success')){
              print(url);
              saveData();
              Navigator.push(context, MaterialPageRoute(builder: (context)=> Payment()));
            }
            if(url.contains('/cancel')) {
              Navigator.of(context).pop();
            }
          },

          javascriptMode: JavascriptMode.unrestricted,
          initialUrl: _loadHTML(),
          //Uri.dataFromString(_loadHTML(), mimeType: 'text/html').toString(),
        )
    );
  }
  Future<void> saveData() async {
    DocumentReference doc =
    await FirebaseFirestore.instance.collection('appointment').add({
      'workshiftID': appointID,
      'service': title + ": " + description,
      'petID': pid,
      'petOwnerID': getuser(),
      'totalPrice': totalss(t.toString())
    });

    await FirebaseFirestore.instance
        .collection("appointment")
        .doc(doc.id)
        .update({"appointmentID": doc.id});

    QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection('Work Shift')
        .where('appointmentID', isEqualTo: appointID)
        .get();

    List<QueryDocumentSnapshot> docs = snapshot.docs;
    for (var doc in docs) {
      if (doc.data() != null) {
        doc.reference.update({"status": "Booked"});
      }
    }
  }

  String? totalss(String m) {
    if (m == "0") {
      aa = "50";
    } else {
      aa = to.toString();
    }
    return aa;
  }
}

String getuser(){
  User? user = FirebaseAuth.instance.currentUser;
  return user!.uid.toString();
}

/* var Url= 'http://10.0.2.2:8000/pay';
var request = BraintreeDropInRequest(
    tokenizationKey: 'sandbox_mfm2pyg3_kjztn8zbdtwzvhhr',
    collectDeviceData: true,
    paypalRequest: BraintreePayPalRequest(
        amount: '1.00', displayName: 'MyPet'),
    cardEnabled: true);

BraintreeDropInResult? result = await BraintreeDropIn.start(request);
if (result != null) {
print(result.paymentMethodNonce.description);
print(result.paymentMethodNonce.nonce);

 final http.Response response = await http.post(Uri.tryParse(
                                     '$url?payment_method_nonce=${result.paymentMethodNonce.nonce}&device_data=${result.daviceData}'
                                     ));
                                     final payResult = jsonDecode(response.body);
                                     if (payResult['result']=='success') print('payment done');
*/