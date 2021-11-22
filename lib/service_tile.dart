import 'package:MyPet/service_model.dart';
import 'package:MyPet/service_update.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'admin_newServices.dart';
import 'models/global.dart';

class ServiceTile extends StatefulWidget {
  final ServiceModel serviceModel;
  Function initData;
  ServiceTile(this.serviceModel, this.initData);

  @override
  _ServiceTile createState() => _ServiceTile();
}

class _ServiceTile extends State<ServiceTile> {



  bool isLoading = true;
  updateService() async {
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => ServiceUpdate(widget.serviceModel)))
        .then((value) => widget.initData());

  }

  deleteService() async {
    await FirebaseFirestore.instance
        .collection("service")
        .doc(widget.serviceModel.serviceID)
        .delete();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("Service has been deleted."),
      backgroundColor: Colors.green,
    ));
    widget.initData();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Padding(

      padding: const EdgeInsets.all(8.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        margin: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 20.0),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [

              ListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${widget.serviceModel.serviceName}',style: petCardSubTitleStyle,),
                    Text('${widget.serviceModel.servicePrice} SR',style: petCardSubTitleStyle,),

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
                  ),  Padding(
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
                            deleteService();
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
}
// class addService extends StatelessWidget {
//   const addService({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 344,
//             height: 120,
//             child: ElevatedButton(
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) => new services()),
//                   );
//                 },
//                 child: Text('Add Service',
//                     style: TextStyle(
//                         fontStyle: FontStyle.italic,
//                         fontSize: 25,
//                         fontWeight: FontWeight.bold)),
//                 style: ButtonStyle(
//                   backgroundColor:
//                   MaterialStateProperty.all(Color(0XFFFF6B81)),
//                   shape: MaterialStateProperty.all(RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(20.0))),
//                 )),
//
//     );
//   }
// }