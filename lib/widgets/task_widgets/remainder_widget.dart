import 'package:flutter/material.dart';

class DatePicker extends StatefulWidget {
  @override
  DatePickerState createState() => DatePickerState();
}

class DatePickerState extends State<DatePicker> {
  String selectedDate='', hour='';


  Future<Null> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now().add(Duration(hours: 1)),
        firstDate: DateTime.now(),
        lastDate: DateTime(2100));

    if (picked != null)
      setState(() {
        selectedDate = picked.toString();
      });
  }

  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: 00, minute: 00),
    );
    if (picked != null)
      setState(() {
        hour = picked.format(context);
      });
  }
  @override
  Widget build(BuildContext context) {
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
                onPressed: (){
                  Navigator.pop(context);
                },
                child: Text('Cancel',style: TextStyle(color: Colors.blue),)
            ),
            Text('Details',style: TextStyle(color: Colors.black,fontSize: 30),),
            TextButton(
                onPressed: (){},
                child: Text('Set Remainder',style: TextStyle(color: Colors.blue),)
            )
          ],
         ),
        SizedBox(height: 5,),
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
                       leading: Icon(Icons.calendar_month,color: Colors.red,size: 40,),
                       title: Text('Date',style: TextStyle(fontSize: 25,color: Colors.black),),
                       subtitle: selectedDate != '' ? Text(selectedDate,style: TextStyle(fontSize: 15,color: Colors.black)):Text(''),
                       trailing: Icon(Icons.arrow_circle_right_sharp,color: Colors.black,size: 30,),
                       ),
                     ListTile(
                       shape: Border(
                         bottom: BorderSide(color: Colors.grey),
                       ),
                       onTap: () {
                         _selectTime(context);
                         },
                       leading: Icon(Icons.access_time,color: Colors.blue,size: 40,),
                       title: Text('Time',style: TextStyle(fontSize: 25,color: Colors.black)),
                       subtitle: hour != '' ? Text(hour,style: TextStyle(fontSize: 15,color: Colors.black)):Text(''),
                       trailing: Icon(Icons.arrow_circle_right_sharp,color: Colors.black,size: 30,),
                     )

                   ],
              ),
           ),
           SizedBox(height: 10,),
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

               },
               leading: Icon(Icons.repeat,color: Colors.grey,size: 40,),
               title: Text('Repeat',style: TextStyle(fontSize: 25,color: Colors.black),),
               subtitle: Text('pick when to repeat', style: TextStyle(fontSize: 15,color: Colors.black)),
               trailing: Icon(Icons.arrow_circle_right_sharp,color: Colors.black,size: 30,),
             ),

           )
         ],
        ),
      ),
    );
  }
}