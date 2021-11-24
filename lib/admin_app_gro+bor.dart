import 'package:MyPet/appointment_main.dart';
import 'package:MyPet/viewBoardingAdmin.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'admin_main.dart';
import 'admin_viewappts.dart';
import 'models/global.dart';

class M_GB extends StatefulWidget {
  const M_GB({Key? key}) : super(key: key);

  @override
  _M_GBState createState() => _M_GBState();
}

class _M_GBState extends State<M_GB> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar:  PreferredSize(
          preferredSize: Size.fromHeight(95.0), // here the desired height
    child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Icon(Icons.arrow_back_ios, color: Color(0xFF2F3542)),
                style: backButton), // <-- Button color// <-- Splash color

            bottom: TabBar(


              tabs: [
                Tab(child: Text('Grooming' , style: TextStyle(
                color:Color(0xffe57285),)),),
                Tab(child: Text('Boarding' ,   style: TextStyle(
                  color:Color(0xffe57285),)),),

              ],
              indicator: BoxDecoration(
                color: Color(0xFFF4E3E3),
                borderRadius: BorderRadius.circular(5),
                // color: _hasBeenPressed ? Color(0xffffffff) : Color(0xffff00a8),
              ),

                       ),

    //         title: Text('Appointment',   style: TextStyle(
    // color:Color(0xffe57285),)),
            //backgroundColor: Color(0xFFFFFFFF),
          ),),

          body: TabBarView(
            physics: BouncingScrollPhysics(),
            dragStartBehavior: DragStartBehavior.start,

            children: [
              AdminAppointments(),
              AdminBoardingAppointments(),

            ],
          ),
        ),
      ),
    );
  }
  }

