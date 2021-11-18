import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class appointment{
   String? id;
   String? type;
   String? date;
   String? petName;
   String? petId;
   String? time;
   double? total;
   String? appointID;
   String? desc;

   // save

   DateTime getStart(){

      String start = time!.trim().split('-').first;

      DateTime _date = DateFormat('EEE, MMM dd yyyy').parse(date!);

      DateTime _startTimeFormat = DateFormat("HH:mm").parse(
          start);
      TimeOfDay _start = TimeOfDay.fromDateTime(_startTimeFormat);

      DateTime _startDateTime = DateTime(
          _date.year,
          _date.month,
          _date.day,
          _start.hour,
          _start.minute,
          0);
      return _startDateTime;
   }

   DateTime getBoardingTime(String d){


      DateTime _date = DateFormat('EEE, MMM dd yyyy').parse(d);


      DateTime _startDateTime = DateTime(
          _date.year,
          _date.month,
          _date.day,
         12,
          0,
          0);
      return _startDateTime;
   }





String? info(){
   return "$id,$type,$date,$petName,$petId,$time,$total,$appointID,$desc";

}


}