part of event_calendar;

class appointmentForm extends StatefulWidget {
  @override
  appointmentFormState createState() {
    return appointmentFormState();
  }
}
// Create a corresponding State class. This class holds data related to the form.
class appointmentFormState extends State<appointmentForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  final _formKey = GlobalKey<FormState>();
  final _controller = TextEditingController();
  var _times = ['30 Minutes', '1 Hour'];
  String selectedTime = '30 Minutes';
  var _types = ['Check-Up', 'Grooming'];
  String selectedType = 'Check-Up';
  //bool _value = false;
 FirebaseFirestore firestoreInstance= FirebaseFirestore.instance;
 String title = _selectedAppointment == null ? "Add" : "Update";

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
        title: Text('$title Schedule',textAlign: TextAlign.center,
            style: TextStyle(color:Color(0XFFFF6B81))),
        backgroundColor: Colors.transparent,
    actions: <Widget>[
    IconButton(
      iconSize:34,
    padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
    icon: const Icon(
    Icons.done,
    color: Colors.white,
    ),
    onPressed: () async {
    final List<Appointment> appointments = <Appointment>[];

    //update
    if (_selectedAppointment != null) {
//update
      Appointment temp = Appointment(
          id:_selectedAppointment!.id,
          from: _startDate,
          to: _endDate,
          start: _startTime,
          end: _endTime,
          description: _description,
          docName: _doc == '' ? '(No title)' : _doc,
          background: Color(0xFF9C4350),
          type: _selectedAppointment!.type);

      firestoreInstance.collection("appointment ").doc(_id).update({
        "DrName" : _doc,
        "date": DateFormat('dd/MM/yyyy').format(_startDate),
        "startTime" : DateFormat.Hm().format(_startDate),
        "endTime" :  DateFormat.Hm().format(_endDate),
        "description" : _description,
       }); 

    _events.appointments!.removeAt(_events.appointments!
        .indexOf(_selectedAppointment));
    _events.notifyListeners(CalendarDataSourceAction.remove,
    <Appointment>[]..add(_selectedAppointment!));
      appointments.add(temp);
      _events.appointments!.add(temp);
    }

    //add
    else {
      int n = getTime();
      int type = getType();

      int diff = _endDate
          .difference(_startDate)
          .inMinutes;
      DateTime _appEnd = _startDate;
      for (int i = 0; i < (diff / n); i++) {

        DocumentReference doc = await firestoreInstance.collection(
            "appointment ").add(
            {
              "appointmentID": '',
              "DrName": _doc,
              "date": DateFormat('dd/MM/yyyy').format(_startDate),
              "startTime": DateFormat.Hm().format(_appEnd),
              "endTime": DateFormat.Hm().format(
                  _appEnd.add(Duration(minutes: n))),
              "description": _description,
              "state": "avaliable",
              "typeID": type
            });
        String _id = doc.id;
        await firestoreInstance.collection("appointment ").doc(_id).update(
            {"appointmentID": _id});

        appointments.add(Appointment(
            id: _id,
            from: _appEnd,
            to: _appEnd.add(Duration(minutes: n)),
            start: TimeOfDay.fromDateTime(_appEnd),
            // to: _endDate,
            end: TimeOfDay.fromDateTime(_appEnd.add(Duration(minutes: n))),
            description: _description,
            docName: _doc == '' ? '(No title)' : _doc,
            background: Color(0xFF9C4350),
            type: type,
        ));

        _events.appointments!.add(appointments[i]);
        _appEnd = _appEnd.add(Duration(minutes: n));

      }
    }

    _events.notifyListeners(
        CalendarDataSourceAction.add, appointments);
    _selectedAppointment = null;

    Navigator.pop(context);
    })
    ],
    ),
    body: Form(
      key: _formKey,
        child: Padding(
        padding: const EdgeInsets.all(20),
    child: ListView(
    children: <Widget>[
         // doc name to be turned into a select dropdown
    TextFormField(
      controller: TextEditingController(text: _doc),
      style: TextStyle(
        fontWeight: FontWeight.bold, fontSize: 18, color: Colors.blueGrey,
      ),
      decoration: InputDecoration(
        icon: Icon(Icons.person,),
        filled: true,
        fillColor: Colors.white,
        hintText: "Enter Doctor\'s name",
        labelText: "Doctor",
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
            borderSide: BorderSide(
              width: 0,
              style: BorderStyle.none,
            )
        ),
      ),

      onChanged: (String value) {
        _doc = value;
      },

          ),


      SizedBox(height: 10.0,),

    // starting date

    ListTile(

    title: Row(

    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
    Expanded(

    //flex: 7,
    child: GestureDetector(

    child: TextFormField(

        enabled: false,
        textAlign: TextAlign.left,
        style: TextStyle(
          fontWeight: FontWeight.bold, fontSize: 18, color: Colors.blueGrey,
        ),
        decoration: InputDecoration(
          icon: Icon(Icons.calendar_today,),
          filled: true,
          fillColor: Colors.white,
          labelText: DateFormat('EEE, MMM dd yyyy').format(_startDate),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0),
              borderSide: BorderSide(
                width: 0,
                style: BorderStyle.none,
              )
          ),
        ),


    ),

    onTap: () async {
    final DateTime? date = await showDatePicker(
    context: context,
    initialDate: _startDate,
    firstDate: DateTime(1900),
    lastDate: DateTime(2100),
    );

    if (date != null && date != _startDate) {
    setState(() {
    final Duration difference =
    _endDate.difference(_startDate);
    _startDate = DateTime(
    date.year,
    date.month,
    date.day,
    _startTime.hour,
    _startTime.minute,
    0);
    _endDate = _startDate.add(difference);
    _endTime = TimeOfDay(
    hour: _endDate.hour,
    minute: _endDate.minute);
    });
    }
    }),
    )])),

      SizedBox(height: 10.0,),

      // start time
      ListTile(
          title: Row(

              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(

                    flex: 7,
                    child: GestureDetector(
    child: TextFormField(
      enabled:false,
    textAlign: TextAlign.left,

        style: TextStyle(
          fontWeight: FontWeight.bold, fontSize: 18, color: Colors.blueGrey,
        ),
        decoration: InputDecoration(
          icon: Icon(Icons.access_time,),
          filled: true,
          fillColor: Colors.white,
          labelText:    "Start: "+DateFormat('hh:mm a').format(_startDate),
          labelStyle: TextStyle(color: Colors.blueGrey),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0),
              borderSide: BorderSide(
                width: 0,
                style: BorderStyle.none,
              )
          ),
        ),
    ),
    onTap: () async {
    final TimeOfDay? time = await showTimePicker(
    context: context,
    initialTime: TimeOfDay(
    hour: _startTime.hour,
    minute: _startTime.minute));

    if (time != null && time != _startTime) {
    setState(() {
    _startTime = time;
    final Duration difference =
    _endDate.difference(_startDate);
    _startDate = DateTime(
    _startDate.year,
    _startDate.month,
    _startDate.day,
    _startTime.hour,
    _startTime.minute,
    0);
    _endDate = _startDate.add(difference);
    _endTime = TimeOfDay(
    hour: _endDate.hour,
    minute: _endDate.minute);
    });
    }
    })),
    ])),

      SizedBox(height: 10.0,),

      //end Time
      ListTile(
          title: Row(

              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(

                    flex: 7,
                    child: GestureDetector(
                        child: TextFormField(

                            enabled:false,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18, color: Colors.blueGrey,
                            ),
                            decoration: InputDecoration(
                              icon: Icon(Icons.access_time,),
                              filled: true,
                              fillColor: Colors.white,
                              labelText:    "End: "+DateFormat('hh:mm a').format(_endDate),
                              labelStyle: TextStyle(color: Colors.blueGrey),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                  borderSide: BorderSide(
                                    width: 0,
                                    style: BorderStyle.none,
                                  )
                              ),
                            ),

                        ),
                        onTap: () async {
                          final TimeOfDay? time =
                          await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay(
                                  hour: _endTime.hour,
                                  minute: _endTime.minute));

                          if (time != null && time != _endTime) {
                            setState(() {
                              _endTime = time;
                              final Duration difference =
                              _endDate.difference(_startDate);
                              _endDate = DateTime(
                                  _endDate.year,
                                  _endDate.month,
                                  _endDate.day,
                                  _endTime.hour,
                                  _endTime.minute,
                                  0);
                              if (_endDate.isBefore(_startDate)) {
                                _startDate =
                                    _endDate.subtract(difference);
                                _startTime = TimeOfDay(
                                    hour: _startDate.hour,
                                    minute: _startDate.minute);
                              }
                            });
                          }
                        })),
              ])),


      SizedBox(height: 10.0,),

          //desc
          TextFormField(
            controller: TextEditingController(text: _description),

            style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 18, color: Colors.blueGrey,
            ),
            decoration: InputDecoration(
              icon: Icon(Icons.subject,),
              filled: true,
              fillColor: Colors.white,
              hintText: "Enter Description",
              labelText: "Description",
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: BorderSide(
                    width: 0,
                    style: BorderStyle.none,
                  )
              ),
            ),

              onChanged: (String value) {
                _description = value;
              },),
          SizedBox(height: 10.0,),


      Visibility(
          visible: _selectedAppointment==null,
   child: Wrap(


            children: <Widget>[

          Container(
           child:  Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 0, 0),
               child: Text("Average Appointment Duration",
                   textAlign: TextAlign.left,
             style:  TextStyle(
                 color: Color(0xFF52648B),
               fontWeight: FontWeight.bold,
               fontSize: 18)
           ))
          ),

    SizedBox(height: 10.0,),

    Container(
    padding: EdgeInsets.all(10),
    decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(20.0),
    color: Colors.white),
    child: DropdownButtonHideUnderline(
    child:
            DropdownButton<String>(
                style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 18, color: Colors.blueGrey),
                isExpanded: true,
                value: selectedTime,
               // icon: const Icon(Icons.arrow_circle_down),
                iconSize: 20,
                elevation: 8,
              //  underline: Container(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedTime = newValue!;
                  });
                },
                items: List.generate(
                  _times.length,
                      (index) => DropdownMenuItem(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                          _times[index],
                          style:  TextStyle(
                          color: Colors.blueGrey),
                      ),

                    ),
                    value: _times[index],
                  ),
                ),
            )),
    ),

              SizedBox(height: 10.0,),
      Container(
          child:  Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 0, 0),
              child: Text("Type:",
                  textAlign: TextAlign.left,
                  style:  TextStyle(
                      color: Color(0xFF52648B),
                      fontWeight: FontWeight.bold,
                      fontSize: 18)
              ))
      ),

              SizedBox(height: 10.0,),

              Container(
                padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                color: Colors.white),
          child: DropdownButtonHideUnderline(
            child:
     DropdownButton<String>(
       style: TextStyle(
         fontWeight: FontWeight.bold, fontSize: 18, color: Colors.blueGrey,
       ),
        isExpanded: true,
       value: selectedType,
        iconSize: 20,
        elevation: 8,
        onChanged: (String? newValue) {
          setState(() {
            selectedType = newValue!;
          });
        },
        items: List.generate(
          _types.length,
              (index) => DropdownMenuItem(

              child: Text(
                _types[index],
                style:  TextStyle(
                    color: Colors.blueGrey),
            ),
            value: _types[index],
          ),
        ),
      )),
        )
   ] )



 ),
        if(_selectedAppointment!=null)
          Align(
          alignment: Alignment.bottomRight,
          heightFactor: 5,
          child:

          FloatingActionButton(
            backgroundColor: const  Color(0xFF9C4350),
            foregroundColor: Colors.white,
            mini: true,
            onPressed: () async{

              firestoreInstance.collection("appointment ").doc(_selectedAppointment!.id)..delete();

              _events.appointments!.removeAt(_events.appointments!
                  .indexOf(_selectedAppointment));
              _events.notifyListeners(CalendarDataSourceAction.remove,
                  <Appointment>[]..add(_selectedAppointment!));



              _selectedAppointment=null;
              Navigator.pop(context);

            },
            child: Icon(Icons.delete),
          )
      )

        ],




      ),
        )


    ),

    );
  }

  int getTime() {
    switch(selectedTime){
      case '1 Hour': return 60
      ;
      case '30 Minutes':
      default:
        return 30;

    }

  }

  int getType() {
    switch(selectedType){
      case 'Grooming': return 1
      ;
      case 'Check-Up':
      default:
        return 0;
    }

  }


}


/* To be Added
  }
    final AlertDialog dialog = AlertDialog(
      title: Text('Title'),
      contentPadding: EdgeInsets.zero,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (int i = 0; i < _weekdays.length; i++)
            ListTile(
              title: Text(
                '$_weekdays[i]',
              ),
              leading: Checkbox(
                value: checkedValue,
                onChanged: (newValue) {
                  setState(() {
                    checkedValue = newValue!;
                  });

                },
              ),
            ),

        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('ACTION 1'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('ACTION 2'),
        ),
      ],
    );
    */

/*
To be Added
      SwitchListTile(
        title: const Text('Recurring',style: TextStyle(
            color: Colors.blue,
            fontWeight: FontWeight.w800,
            fontSize: 20
        ),
        ),
        value: _value,
        activeColor: Colors.red,
        inactiveTrackColor: Colors.grey,
        onChanged: (bool value) {
          setState(() {
            _value = value;
            print(_value);
          });

        },
      ),

      Column(children: <Widget>[
        _value
            ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children:  [
              const Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    'NAME:',
                    style: TextStyle(
                        color: Colors.teal,
                        fontSize: 20,
                        fontWeight: FontWeight.w500),
                  )),
           TextButton(
                onPressed: () {
                  showDialog<void>(context: context, builder: (context) => dialog);
                },
                child: Text("SHOW DIALOG"),
              ),
           GestureDetector(
                 child: TextField(
                  enabled:false,
                onTap: () async {
                   await showDialog<void> (context: context, builder: (context) => dialog);
                    },
                decoration: const InputDecoration(
                    contentPadding:
                    EdgeInsets.all(20.0),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.teal, width: 2.0),
                    ),
                    hintText: 'Enter NAME'),
              )),
            ])

*/