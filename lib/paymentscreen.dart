import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Payment.dart';
import 'appointment_object.dart';
import 'models/data.dart';
import 'models/notifaction_service.dart';


class Paymentscreen extends StatefulWidget{
  final appointment? appoint;


  Paymentscreen({this.appoint});

  @override
  _Paymentscreen createState()=>_Paymentscreen();
}
class _Paymentscreen extends State<Paymentscreen>{
  String img ="";
appointment? a;
double? price;
fbHelper fb = fbHelper();
  void initState() {
    super.initState();
a= widget.appoint;
    if (a!.type == "Check-Up"){
      img ='images/PBCheckUpStepthree.png';
    }
    else
      img ='images/PBGroomingStepFour.png';


price = a!.total;//here var is call and set to
  }
String _loadHTML(){
  return 'http://172.20.10.4:8000/price?id=$price';
}

  @override
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
            'Payment',
            style: TextStyle(
                color: Color(0XFFFF6B81),
                fontSize: 34,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(height: 20),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
                height: 40,
                fit: BoxFit.fill,
                image: new AssetImage(img))
          ],
        ),
                SizedBox(height: 20),

                Container(
                    constraints: BoxConstraints(
                      maxHeight: 550,
                      maxWidth: 350,
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        color: Color(0xffffffff)),
                    child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        child:
        WebView(
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
              if(a!.type.toString()=='Boarding')
                fb.saveBoarding(a!);



             else
                fb.saveData(a!);
                NotificationService.showNotifaction(
                    title: 'Success!',
                    body: 'Your appointment has been confirmed.');

              Navigator.push(context, MaterialPageRoute(builder: (context)=> Payment()));
            }
            if(url.contains('/cancel')) {
              Navigator.of(context).pop();
            }
          },

          javascriptMode: JavascriptMode.unrestricted,
          initialUrl: _loadHTML(),
        )
                    ))] ),  ));
  }
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