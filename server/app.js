var paypal = require('paypal-rest-sdk');
var express = require('express');
var app = express();

const bodyParser = require("body-parser");
app.use(bodyParser.urlencoded({
    extended:false
}));
app.use(bodyParser.json())
var amount = 0;
paypal.configure({
    'mode': 'sandbox', //sandbox or live
    'client_id': 'AW-aLVh8jQcdMlCOA6VAHqUNBSK7WU-NCBBcr7NMsWNHhPy818KYEOFRsBO1VdPcGPyK9_q1_mEwuUxL',
    'client_secret': 'EBMmSjV6AMm-sj2xcdOVTtaxrnpRYPmGmMbyEGntbveHoP_a5CtiBW8znJFGQYFpxSv3LcYjEIi7f-5h'
});

app.get('/price', function(request, response) {
    console.log(request.body)
    amount = request.query.id; // $_GET["id"]
    console.log('id:'+amount);
     response.redirect('/pay');

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
                    "price": amount,
                    "currency": "USD",
                    "quantity": 1
                }]
            },
            "amount": {
                "currency": "USD",
                "total": amount
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
                "total": amount
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