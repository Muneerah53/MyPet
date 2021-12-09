import 'package:MyPet/petProfile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class inHouse extends StatefulWidget {
  const inHouse({Key? key}) : super(key: key);

  @override
  _inHouseState createState() => _inHouseState();
}



class _inHouseState extends State<inHouse> {
  Map<String, String > PetAppList = {};
  Map<String, String > PetsList = {};
  List<String> pets = <String>[];


  //CollectionReference stream1 = FirebaseFirestore.instance.collection('appointment');

  // late DocumentSnapshot document ;


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
      child: Center(
        child: Column(
          children: [

            Container(
              margin: const EdgeInsets.fromLTRB(0, 0, 0, 30),
              child: Text(
                'Pets In House',
                style: TextStyle(
                    color: Color(0xffe57285),
                    fontSize: 34,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.bold),
              ),
            ),
              Container(
                  width: double.maxFinite,
                  child: StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection("pets")
                                .snapshots(),

                            builder: (context, snapshot) {
                              if (!snapshot.hasData)
                                return const Text('loading');
                              if (snapshot.data!.docs.isEmpty)
                                return Padding(
                                    padding: EdgeInsets.all(0),
                                    child: const Text(
                                        'Sorry, there are no services available',
                                        style: TextStyle(
                                            color: const Color(0xFF552648B),
                                            fontSize: 20,
                                            fontStyle: FontStyle.italic,
                                            fontWeight: FontWeight.bold))
                                );
                              return ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  scrollDirection: Axis.vertical,
                                  itemCount: snapshot.data!.docs.length,
                                  itemBuilder: (context, index) {

                                    String key = (snapshot.data!).docs[index]['petId'];
                                    PetsList[key] = (snapshot.data!).docs[index]['name'];


                                    return new Container(
                                      height: 0,
                                    );
                                  });
                            })



              ),

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
            child: const Text(
                'Sorry, there are no services available',
                style: TextStyle(
                    color: const Color(0xFF552648B),
                    fontSize: 20,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold))
        );

      return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          scrollDirection: Axis.vertical,
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            String key = (snapshot.data!)
                .docs[index]['petID'];
            PetAppList[key] = (snapshot.data!).docs[index]['workshiftID'];
            int i = getPets()!.length-1;
            getPets();

              return new ListTile(
               // margin: EdgeInsets.only(left:10,right:20,bottom: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all( Radius.circular(10),
                  ),),
              title: Text( " \n"  + "       "+getPets()![i]+"\n"+ "       "+(snapshot.data!).docs[index]['service'] +'\n',style: TextStyle(
                  color: Color(0XFF52648B),
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
                textAlign: TextAlign.left,),
                  onTap: (){
                 // g(document);
                Navigator.push(context,MaterialPageRoute(builder:(context) {
                  return pet(getPets()![i]);

                } ));}

            );
          }
      );

    }))
,

          ],
        ),
      ),

    ));
  }
  List<String> getPets() {

    PetAppList.forEach((key, value) {
      String id = key;
   //String PN = value;
  PetsList.forEach((key, value) {
    if(id == key){
pets.add(value);
    }

  });

   });

 return pets;
  }

}
