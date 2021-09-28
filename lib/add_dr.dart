
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class docList extends StatefulWidget {
  @override
  docListState createState() {
    return docListState();
  }
}
// Create a corresponding State class. This class holds data related to the form.
class docListState extends State<docList> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  final _dformKey = GlobalKey<FormState>();
  final _controller = TextEditingController();
  //bool _value = false;
  FirebaseFirestore firestoreInstance= FirebaseFirestore.instance;
  String title = "Doctors List";
String _doc ='';
late String _selectedID;


  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    _controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Color(0xFFF4E3E3),
      appBar: AppBar(
        elevation:0,
        title: Text('$title',textAlign: TextAlign.center,
            style: TextStyle(color:Color(0XFFFF6B81))),
        backgroundColor: Colors.transparent,
        /* actions: <Widget>[
          IconButton(
              iconSize:34,
              padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
              icon: const Icon(
                Icons.done,
                color: Color(0xFF7F3557),
              ),
              onPressed: () async {
                if (_formKey.currentState!.validate()) {

                      DocumentReference doc = await firestoreInstance.collection(
                          "Dr").add(
                          {
                            "DrName": _doc,
                          });
                      String _id = doc.id;
                      await firestoreInstance.collection("Dr").doc(_id).update(
                          {"DrID": _id});

                    }
    Navigator.pop(context);
                  }
      )]), */
      ),
      body:  Padding(
            padding: const EdgeInsets.all(20),
            child: ListView(
              children: <Widget>[


                ElevatedButton(
                  onPressed: () {
                   dialog();
                  },
                  child:Padding(
                      padding: EdgeInsets.all(8.0),
                      child:
                      Text("+ Add Doctor", style:
                      TextStyle(fontSize: 18))),
                style: ButtonStyle(
                    backgroundColor:
                    MaterialStateProperty.all(Color(0XFFFF6B81)),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)))


                ),
                ),

                // doc name to be turned into a select dropdown



                SizedBox(height: 10.0,),


          StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('Dr').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const Text('loading');
                if (snapshot.data!.docs.isEmpty) return Padding(
                    padding: EdgeInsets.all(20),
                    child: const Text('No Added Doctors', style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.grey), textAlign: TextAlign.center));

                return ListView.builder(
                    shrinkWrap: true, scrollDirection: Axis.vertical,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      return OutlinedButton(
                          style: OutlinedButton.styleFrom(
                              padding: EdgeInsets.all(0),
                              side: BorderSide(color: Colors.transparent)),
                          child: Card(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0)),
                              child: Container(
                                padding: EdgeInsets.only(top: 20, bottom: 20),
                                margin: EdgeInsets.only(left: 20, right: 20),
                               // width: 160,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50.0),
                                ),
                                child:
                                Container(
                                  // margin: EdgeInsets.only(top: 10),
                                  child: ListTile(
                                    title: Text(
                                        (snapshot.data!).docs[index]['DrName']
                                        //,style: statusStyles[document['species']]
                                        , style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        color: Color(0XFF2F3542))),

                                  ),),
                              )
                          ) // changeTimeSelected(index),
                          , onPressed: () {
                            _doc =  (snapshot.data!).docs[index]['DrName'];
                            _selectedID = (snapshot.data!).docs[index]['DrID'];
                        dialog();
                      }

                      );
                    }

                );
              } ),

 ],




            ),
          )




    );
  }

  dialog(){
    bool newDr = _doc == '';
    String _oldName = _doc;
    String btnTxt = newDr ? 'Add' : 'Update';
    return  showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Color(0xFFE3D9D9),
            elevation: 0,
            content: Stack(
              children: <Widget>[
    Positioned(
            top: -15,  right: -15,

                child :IconButton(
                      iconSize:34,
                     // padding: const EdgeInsets.fromLTRB(9, 0, 9, 0),
                      icon: const Icon(
                        Icons.close,
                        color: Color(0xFF7F3557),
                      ),
                      onPressed: () {
                        _doc ='';
                        Navigator.of(context).pop();
                      }
                  ),
                )
            ,
                Form(
                  key: _dformKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      SizedBox(height: 20.0,),
                      Padding(
                        padding: EdgeInsets.fromLTRB(8,20,8,8),
                        child:  TextFormField(
                          controller: TextEditingController(text: _doc),
                          style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18, color: Colors.blueGrey,
                          ),
                          decoration: InputDecoration(
                            icon: Icon(Icons.person,),
                            filled: true,
                            fillColor: Colors.white,
                            hintText: "Enter Doctor\'s name",
                            labelText: "Name",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                                borderSide: BorderSide(
                                  width: 0,
                                  style: BorderStyle.none,
                                )
                            ),
                          ),

                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter name';
                            }
                            return null;
                          },

                          onChanged: (String value) {
                            _doc = value;
                          },

                        ),
                      ),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget> [
                    Padding(
                    padding: const EdgeInsets.all(8.0),
                      child:
                        ElevatedButton(
                          child: Text("$btnTxt",
                              style:
                              TextStyle(fontSize: 18)),
                            style: ButtonStyle(
                              backgroundColor:
                              MaterialStateProperty.all(Color(0XFF2F3542)),
                              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0))),
                            ),
                          onPressed: () {
                            if (_dformKey.currentState!.validate()) {
                              if(newDr)
                                saveDr(_doc);
                              else updateDr(_doc, _oldName);
                              Navigator.of(context).pop();
                            }
                          },
                        )),

                       Visibility(
                            visible: !newDr,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child:
                              ElevatedButton(
                                child: Text("Delete",
                                    style:
                                    TextStyle(fontSize: 18)),
                                style: ButtonStyle(
                                  backgroundColor:
                                  MaterialStateProperty.all(Colors.red),
                                  shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              20.0))),
                                ),
                                onPressed: () {
                                  deleteDr(_oldName);

                                  Navigator.of(context).pop();
                                },
                              )),
                       )
                  ]
                        )

                    ],
                  ),
                ),
              ],
            ),
          );
        });

  }





  Future<void> updateDr(String doc, String oldName) async {
firestoreInstance
        .collection('Dr')
        .doc(_selectedID)
        .update({
      "DrName": _doc,
    });

    QuerySnapshot<Map<String, dynamic>> snapshot = await firestoreInstance
        .collection('appointment ')
        .where('DrName', isEqualTo: oldName)
        .get();

    List<QueryDocumentSnapshot> docs = snapshot.docs;
    for (var doc in docs) {
      if (doc.data() != null) {
        doc.reference.update({"DrName": _doc});
      }
    }

_doc = '';
  }


  Future<void> saveDr(String doc) async {
    DocumentReference doc = await firestoreInstance.collection(
          "Dr").add(
          {
            "DrName": _doc,
          });

    String _id = doc.id;
    await firestoreInstance.collection("Dr").doc(_id).update(
        {"DrID": _id});
  }

  Future<void> deleteDr(String oldName) async {
    firestoreInstance.collection("Dr").doc(_selectedID).delete();

    QuerySnapshot<Map<String, dynamic>> snapshot = await firestoreInstance
        .collection('appointment ')
        .where('DrName', isEqualTo: oldName)
        .get();

    List<QueryDocumentSnapshot> docs = snapshot.docs;
    for (var doc in docs) {
      if (doc.data() != null) {
        doc.reference.delete();
      }


      _selectedID='';
    }


  }




}
