const functions = require("firebase-functoins");
    
const braintree = require('braintree');
const getway = new braintree.BraintreeGateway({

environment : braintree.Environment.Sandbox,
merchantId : 'kjztn8zbdtwzvhhr',
publicKey : 'm5vzy2pjw9gj6njj',
privateKey: '423ef94d3649661308cd602811073a6b',

});
exports.paypalPayment = functions.https.onRequest(async (req, res)=>{
    const nonceFromTheClient = req.body.payment_method_nonce;
    const deviceData = req.body.device_data;

    gateway.transaction.sale({
        amount: '1.00',
        PaymentMethodNonce: nonceFromTheClient,
        deviceData: deviceData,
        Options: {
            submitFromSettlement: true
        }
        ,
        },(err, result) => {
            if (err!=null){
                console.log(err);
            }
            else{
                res.json({
                    result:'success'
                });
            }
        }

    );
});