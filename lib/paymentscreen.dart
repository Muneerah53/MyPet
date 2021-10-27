import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'Payment.dart';


class Paymentscreen extends StatefulWidget{
  Paymentscreen(this.price);
  final price;

  @override
  _Paymentscreen createState()=>_Paymentscreen();
}
class _Paymentscreen extends State<Paymentscreen>{
  String _loadHTML(){
    return r'''...''';
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
            Navigator.push(context, MaterialPageRoute(builder: (context)=> Payment()));
          }
            if(url.contains('/cancel')) {
                  Navigator.of(context).pop();
            }
        },

        javascriptMode: JavascriptMode.unrestricted,
        initialUrl: 'http://172.20.10.3:8000/pay',
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
