import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class inHouse extends StatefulWidget {
  const inHouse({Key? key}) : super(key: key);

  @override
  _inHouseState createState() => _inHouseState();
}

class _inHouseState extends State<inHouse> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.fromLTRB(0, 50, 0, 60),
              child: Text(
                'Appointment',
                style: TextStyle(
                    color: Color(0xffe57285),
                    fontSize: 34,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.bold),
              ),
            ),
              SizedBox(height: 30),
              Container(
                  width: double.maxFinite,
                  child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection("appointment")
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData)
                          return const Text('loading');
                        if (snapshot.data!.docs.isEmpty)
                          return Padding(
                              padding: EdgeInsets.all(20),
                              child: const Text('Sorry, there are no services available',
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
                              String key;
                             return   key = (snapshot.data!)
                                  .docs[index]['service'];


                            });
                      })

              ),


          ],
        ),
      ),

    );
  }
}
