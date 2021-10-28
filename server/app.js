var paypal = require('paypal-rest-sdk');
var express = require('express');
var app = express();
paypal.configure({
    'mode': 'sandbox', //sandbox or live
    'client_id': 'AW-aLVh8jQcdMlCOA6VAHqUNBSK7WU-NCBBcr7NMsWNHhPy818KYEOFRsBO1VdPcGPyK9_q1_mEwuUxL',
    'client_secret': 'EBMmSjV6AMm-sj2xcdOVTtaxrnpRYPmGmMbyEGntbveHoP_a5CtiBW8znJFGQYFpxSv3LcYjEIi7f-5h'
});


app.get('/pay', (req, res) => {

    var create_payment_json = {
        "intent": "sale",
        "payer": {
            "payment_method": "paypal"
        },
        "redirect_urls": {
            "return_url": "http://172.20.10.3:8000/success",
            "cancel_url": "http://cancel.url"
        },
        "transactions": [{
            "item_list": {
                "items": [{
                    "name": "item",
                    "sku": "item",
                    "price": "1",
                    "currency": "USD",
                    "quantity": 1
                }]
            },
            "amount": {
                "currency": "USD",
                "total": "1"
            },
            "description": "This is the payment description."
        }]
    };


    paypal.payment.create(create_payment_json, function (error, payment) {
        if (error) {
            throw error;
        } else {
            console.log("Create Payment Response");
            console.log(payment);

            for (let i = 0; i < payment.links.length; i++) {
                if (payment.links[i].rel == "approval_url") {
                    res.redirect(payment.links[i].href);
                }
            }
        }
    });

});

app.get('/success', (req, res) => {

    var execute_payment_json = {
        "payer_id": req.query.PayerID,
        "transactions": [{
            "amount": {
                "currency": "USD",
                "total": "1"
            }
        }]
    };
    var paymentId = req.query.paymentId;

    paypal.payment.execute(paymentId, execute_payment_json, (error, payment) => {
        if (error) {
            console.log(error.response);
            throw error;
        } else {
            console.log("Get Payment Response");
            console.log(JSON.stringify(payment));
        }
    });
    res.send("thanks for using mypet");

});


app.listen(8000,'172.20.10.3' ,(req, res) => {

    console.log('server start');
});
