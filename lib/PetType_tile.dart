import 'package:MyPet/PetType_model.dart';
import 'package:MyPet/PetType_update.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:MyPet/storage/storage.dart';


import 'models/global.dart';

class PetTypeTile extends StatefulWidget {
  late final PetType petType;
  late Function initData;
  PetTypeTile(this.petType, this.initData);

  @override
  _PetTypeTile createState() => _PetTypeTile();
}

class _PetTypeTile extends State<PetTypeTile> {
  final Storage _storage = Storage();
  late Future<String> _url;
  bool isLoading = true;
  updateService() async {
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => PetTypeUpdate(widget.petType)))
        .then((value) => widget.initData());

  }



  @override
  void initState() {
    super.initState();
   _url =  _storage.downloadURL(widget.petType.petTypeName+'.jpg');
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        margin: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 0),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              ListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [

                    FutureBuilder(
                      future: _url,
                      builder: (context, AsyncSnapshot<String> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.done && snapshot.hasData)
                          return CircleAvatar(
                            radius: 35,
                              foregroundImage: Image.network(snapshot.data!).image,);

                        if (snapshot.connectionState ==
                            ConnectionState.waiting)
                          return  CircleAvatar( radius: 35,backgroundColor: Color(0xffe57285).withOpacity(0.8),
                              child: CircularProgressIndicator(color: Colors.white,));

                        return  CircleAvatar( radius: 35,foregroundImage:  AssetImage("images/logo4.png"));
                      },
                    ),
                    SizedBox(width: 15,),
                    Text('${widget.petType.petTypeName}',style: petCardSubTitleStyle,),
                  ],
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: SizedBox(
                        height:36, //height of button
                        width:106,
                        child: ElevatedButton(
                          onPressed: () {
                            updateService();
                          },
                          child: Text('Edit'),
                          style: ElevatedButton.styleFrom(
                            primary: Color(0xFFE7F2EC),//change background color of button
                            onPrimary: Colors.black,//change text color of button
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),

                            ),
                            elevation: 0.0,
                            shadowColor: Colors.transparent,
                          ),)),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: SizedBox(
                        height:36, //height of button
                        width:63,
                        child: ElevatedButton(
                          onPressed: () {

                          },
                          child: Text(''),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.white,//change background color of button
                            onPrimary: Colors.black,//change text color of button
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),

                            ),
                            elevation: 0.0,
                            shadowColor: Colors.transparent,
                          ),)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: SizedBox(
                        height:36, //height of button
                        width:106, //width of button
                        child: ElevatedButton(
                          onPressed: () {
                            showAlert(context,"Are you sure you want to delete this pet type?");
                          },
                          child: Text('Delete'),
                          style: ElevatedButton.styleFrom(
                            primary: Color(0xFFF3BFBD),//change background color of button
                            onPrimary: Colors.black,//change text color of button
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 0.0,
                            shadowColor: Colors.transparent,
                          ),)

                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
  showAlert(BuildContext context,String message) {
    showDialog(

      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          content: Text(message),
          actions: <Widget>[
            FlatButton(
                child: Text("YES"),
                onPressed: () async {

                  await FirebaseFirestore.instance
                      .collection("PetTypes")
                      .doc(widget.petType.petTypeID)
                      .delete();


                      Navigator.pop(context, true);

                  widget.initData();
                }),


            FlatButton(
              child: Text("CANCEL"),
              onPressed: () {

                //Put your code here which you want to execute on Cancel button click.
                Navigator.pop(context, false);

              },
            ),
          ],
        );
      },
    ).then((exit) {
      if (exit == null) return;

      if (exit) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Pet type deleted successfully"),
          backgroundColor:Colors.green,),);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Pet type has not been deleted "),
          backgroundColor:Colors.orange,),);
      }
    },
    );
  }
}