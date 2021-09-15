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
  bool _value = false;
 FirebaseFirestore firestoreInstance= FirebaseFirestore.instance;

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    _controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
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
    return Scaffold(
    backgroundColor: Color(0xFFF4E3E3),
    appBar: AppBar(
        title: Text('Add Schedule'),
    backgroundColor: Color(0xFFFF6B81),

    actions: <Widget>[
    IconButton(
    padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
    icon: const Icon(
    Icons.done,
    color: Colors.white,
    ),
    onPressed: () {
    final List<Appointment> appointments = <Appointment>[];
    if (_selectedAppointment != null) {
    _events.appointments!.removeAt(_events.appointments!
        .indexOf(_selectedAppointment));
    _events.notifyListeners(CalendarDataSourceAction.remove,
    <Appointment>[]..add(_selectedAppointment!));
    }
    int n;

    switch(selectedTime){
      case '1 Hour': n=60;break;
      case '30 Minutes':
      default:
        n=30;
        break;
    }
    int diff = _endDate.difference(_startDate).inMinutes;
    DateTime _appEnd =_startDate;
    for(int i=0;i<(diff/n);i++){
    appointments.add(Appointment(
    from: _appEnd,
   // to: _endDate,
      to: _appEnd.add(Duration(minutes: n)),
      description: _description,
    docName: _doc == '' ? '(No title)' : _doc,
      background: Color(0xFF9C4350),
    ));

  _events.appointments!.add(appointments[i]);


    firestoreInstance.collection("appointment ").add(
        {
          "appointmentID": "1111",
          "date": _startDate,
          "startTime" : _appEnd,
          "endTime" : _appEnd.add(Duration(minutes: n)),
          "description" : _description,
          "DrID" : _doc,
          "typeID" : "Check-up",
          "state" : "avaliable"
        });

     _appEnd = _appEnd.add(Duration(minutes: n));
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
            decoration: const InputDecoration(
              icon: Icon(Icons.person),
              hintText: 'Enter Doctor\'s name',
              labelText: 'Doctor',
              labelStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Color(0xFF52648B)),
              border: InputBorder.none,

            ),
      onChanged: (String value) {
        _doc = value;
      },

          ),
      const Divider(
        height: 1.0,
        thickness: 1,
      ),
    // starting date
    ListTile(

    title: Row(

    crossAxisAlignment: CrossAxisAlignment.center,
    children: <Widget>[
    Expanded(

    flex: 7,
    child: GestureDetector(

    child: TextFormField(

        enabled: false,
        textAlign: TextAlign.left,
        decoration: InputDecoration(
            border: InputBorder.none,
            labelText: DateFormat('EEE, MMM dd yyyy').format(_startDate),
            labelStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Color(0xFF52648B),
            )

        )
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
      const Divider(
        height: 1.0,
        thickness: 1,
      ),
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
        decoration: InputDecoration(
            border: InputBorder.none,
            labelText:    DateFormat('hh:mm a').format(_startDate),
            labelStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Color(0xFF52648B),))
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
      const Divider(
        height: 1.0,
        thickness: 1,
      ),
      //end Time
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
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                labelText:    DateFormat('hh:mm a').format(_endDate),
                                labelStyle: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  color: Color(0xFF52648B),))
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
      const Divider(
        height: 1.0,
        thickness: 1,
      ),
          TextFormField(

            decoration: const InputDecoration(
              icon: Icon(Icons.subject),
              hintText: 'Enter appointment description',
              labelText: 'Description',
              labelStyle: TextStyle(
                color: Color(0xFF52648B),
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
              border: InputBorder.none,
            ),
              onChanged: (String value) {
                _description = value;
              },
          ),
      const Divider(
        height: 1.0,
        thickness: 1,
      ),
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

            DropdownButton<String>(
                isExpanded: true,
                value: selectedTime,
               // icon: const Icon(Icons.arrow_circle_down),
                iconSize: 20,
                elevation: 16,
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
                          color: Color(0xFF52648B)),
                      ),

                    ),
                    value: _times[index],
                  ),
                ),
              ),
/* To be Added
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
          /*  GestureDetector(
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
              )), */
            ])
            : Container(),
      ])

      */
        ],




      ),
        )
    )
    );
  }
}