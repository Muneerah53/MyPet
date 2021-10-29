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
appointment? a;
double? price;
fbHelper fb = fbHelper();
  void initState() {
    super.initState();
a= widget.appoint;
price = a!.total;//here var is call and set to
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
              fb.saveData(a!);
              NotificationService.showNotifaction(
                  title: 'Success!',
                  body: 'Your appointment has been confirmed.');


              NotificationService.showScheduledNotifaction(
                  title: 'Reminder',
                  t: a!.getStart()
              );

              Navigator.push(context, MaterialPageRoute(builder: (context)=> Payment()));
            }
            if(url.contains('/cancel')) {
              Navigator.of(context).pop();
            }
          },

          javascriptMode: JavascriptMode.unrestricted,
          initialUrl: _loadHTML(),
        )
    );
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