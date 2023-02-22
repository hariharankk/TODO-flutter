import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todolist/models/global.dart';
import 'package:todolist/remainder/remainder.dart';
//import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:convert';
import 'package:flutter/cupertino.dart';

class DatePicker extends StatefulWidget {
  @override
  DatePickerState createState() => DatePickerState();
}

class DatePickerState extends State<DatePicker> {
  String selectedDate = '', hour = '',repeat_text='ஒரு முறை';
  late double unitHeightValue, unitWidthValue;
 // NotificationService notificationService = NotificationService();
  DateTime? eventDate;
  TimeOfDay? eventTime;
  DateTime currentDate = DateTime.now();
  TimeOfDay currentTime = TimeOfDay.now();

  void selectEventDate() async {
    final today =
    DateTime(currentDate.year, currentDate.month, currentDate.day);
     if (repeat_text == 'தினசரி') {
      eventDate = today;
    } else if (repeat_text == 'வாரந்தோறும்') {
      CustomDayPicker(
        onDaySelect: (val) {
          print("$val: ${CustomDayPicker.weekdays[val]}");
          eventDate = today.add(
              Duration(days: (val - today.weekday + 1) % DateTime.daysPerWeek));
        },
      ).show(context);
    }
  }

 /* Future<void> onCreate() async {
    await notificationService.showNotification(
      0,
      '',
      "ஒரு புதிய நிகழ்வு உருவாக்கப்பட்டது.",
      jsonEncode({
        "title": '',
        "eventDate": DateFormat("EEEE, d MMM y").format(eventDate!),
        "eventTime": eventTime!.format(context),
      }),
    );

    await notificationService.scheduleNotification(
      1,
      '',
      "உங்கள் திட்டமிடப்பட்ட நிகழ்வுக்கான நினைவூட்டல் ${eventTime!.format(context)}",
      eventDate!,
      eventTime!,
      jsonEncode({
        "title": '',
        "eventDate": DateFormat("EEEE, d MMM y").format(eventDate!),
        "eventTime": eventTime!.format(context),
      }),
      getDateTimeComponents(),
    );

    resetForm();
  }

  void resetForm() {
    eventDate = null;
    eventTime = null;
    selectedDate='';
    hour = '';
  }

  DateTimeComponents? getDateTimeComponents() {
    if ( repeat_text == 'Daily') {
      return DateTimeComponents.time;
    } else if ( repeat_text == 'Weekly') {
      return DateTimeComponents.dayOfWeekAndTime;
    }
  }*/

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now().add(Duration(hours: 1)),
        firstDate: DateTime.now(),
        lastDate: DateTime(2100));

    if (picked != null)
      setState(() {
        eventDate=picked;
        var Format = DateFormat('dd/MM/yyyy');
        selectedDate = Format.format(picked);
      });
  }

 /* Future<void> cancelAllNotifications() async {
    await notificationService.cancelAllNotifications();
  }*/

  Widget _buildCancelAllButton() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: Colors.indigo[100],
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 24.0,
        vertical: 12.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "அனைத்து நினைவூட்டல்களையும் ரத்துசெய்",
            style: TextStyle(
              fontSize: 12.0,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          Icon(Icons.clear),
        ],
      ),
    );
  }
  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: 00, minute: 00),
    );
    if (picked != null)
      setState(() {
        eventTime= picked;
        hour = picked.format(context);
      });
  }

  @override
  Widget build(BuildContext context) {
    unitHeightValue = MediaQuery.of(context).size.height/4;
    unitWidthValue = MediaQuery.of(context).size.width/4;
    return SingleChildScrollView(
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(10),
        color: Colors.white60,
        child: Column(
          children: <Widget>[
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'ரத்து',
                      style: TextStyle(color: Colors.blue,fontSize: 12),
                    )),
                Text(
                  'விவரங்கள்',
                  style: TextStyle(color: Colors.black, fontSize: 20),
                ),
                TextButton(
                    onPressed: () {
     //                 onCreate();
                      SnackBar(
                        content: Text(
                          "மீதமுள்ளவை வெற்றிகரமாக உள்ளன",
                          textAlign: TextAlign.center,
                        ),
                        backgroundColor: Colors.green,
                      );
                      Navigator.pop(context);
                    },
                    child: Text(
                      'மீதியை அமைக்கவும்',
                      style: TextStyle(color: Colors.blue,fontSize: 12),
                    ))
              ],
            ),
            GestureDetector(
              onTap: () async {
                //await cancelAllNotifications();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("அனைத்து அறிவிப்புகளும் ரத்து செய்யப்பட்டன"),
                  ),
                );
              },
              child: _buildCancelAllButton(),
            ),
            SizedBox(
              height: 5,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                children: [
                  ListTile(
                    shape: Border(
                      bottom: BorderSide(color: Colors.grey),
                    ),
                    onTap: () {
                      _selectDate(context);
                    },
                    leading: Icon(
                      Icons.calendar_month,
                      color: Colors.red,
                      size: 40,
                    ),
                    title: Text(
                      'தேதி',
                      style: TextStyle(fontSize: 25, color: Colors.black),
                    ),
                    subtitle: Text(selectedDate,
                            style: TextStyle(fontSize: 15, color: Colors.black)),
                    trailing: Icon(
                      Icons.arrow_circle_right_sharp,
                      color: Colors.black,
                      size: 30,
                    ),
                  ),
                  ListTile(
                    shape: Border(
                      bottom: BorderSide(color: Colors.grey),
                    ),
                    onTap: () {
                      _selectTime(context);
                    },
                    leading: Icon(
                      Icons.access_time,
                      color: Colors.blue,
                      size: 40,
                    ),
                    title: Text('நேரம்',
                        style: TextStyle(fontSize: 25, color: Colors.black)),
                    subtitle:
                        Text(hour,
                            style: TextStyle(fontSize: 15, color: Colors.black)),

                    trailing: Icon(
                      Icons.arrow_circle_right_sharp,
                      color: Colors.black,
                      size: 30,
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: ListTile(
                shape: Border(
                  bottom: BorderSide(color: Colors.grey),
                ),
                onTap: () {
                  showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (context) =>  ListItems()).then((value){
                    setState(() {
                    if(value!=null ) {
                      repeat_text = value.toString();
                      selectEventDate();
                    }});
                  });
                },
                leading: Icon(
                  Icons.repeat,
                  color: Colors.grey,
                  size: 40,
                ),
                title: Text(
                  'மீண்டும் செய்யவும்',
                  style: TextStyle(fontSize: 25, color: Colors.black),
                ),
                subtitle: Text(repeat_text,
                    style: TextStyle(fontSize: 15, color: Colors.black)),
                trailing: Icon(
                  Icons.arrow_circle_right_sharp,
                  color: Colors.black,
                  size: 30,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ListItems extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final yourScrollController = ScrollController();
    return Scrollbar(
      controller: yourScrollController,
      child:       Container(
        height: MediaQuery.of(context).size.height * 0.25,
        decoration: new BoxDecoration(
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: ListView.separated(
            padding: const EdgeInsets.all(8),
            itemCount: popup_repeat.length,
              controller: yourScrollController,
            separatorBuilder: (BuildContext context,int index) {
              return Divider(color: Colors.grey,);
              },
            itemBuilder: (BuildContext context,int index) {
              return ListTile(
                  title: Text(popup_repeat[index],style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                  trailing: Icon(Icons.arrow_forward_outlined,color: Colors.black,),
                  onTap: (){
                    Navigator.pop(context,popup_repeat[index]);
                 }
                );
            }
          ),
        ),
      ),
    );
  }
}

class CustomDayPicker extends StatelessWidget {
  const CustomDayPicker({Key? key, required this.onDaySelect})
      : super(key: key);
  final ValueChanged<int> onDaySelect;

  Future<bool?> show(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => this,
    );
  }

  static final List<String> weekdays = [
    'திங்கள்',
    'செவ்வாய்',
    'புதன்',
    'வியாழன்',
    'வெள்ளி',
    'சனி',
    'ஞாயிறு',
  ];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("ஒரு நாளைத் தேர்ந்தெடுக்கவும்"),
      content: Wrap(
        direction: Axis.vertical,
        alignment: WrapAlignment.center,
        spacing: 15,
        children: [
          for (int index = 0; index < weekdays.length; index++)
            ElevatedButton(
              onPressed: () {
                onDaySelect(index);
                Navigator.pop(context);
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                  Colors.indigo,
                ),
              ),
              child: Text(weekdays[index]),
            ),
        ],
      ),
    );
  }
}