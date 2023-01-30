import 'package:flutter/material.dart';

class DatePicker extends StatefulWidget {
  @override
  DatePickerState createState() => DatePickerState();
}

class DatePickerState extends State<DatePicker> {


  Future<Null> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime.now(),
      lastDate: DateTime(2022),);
    if (picked != null)
      setState(() {
      });
  }

  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: 00, minute: 00),
    );
    if (picked != null)
      setState(() {
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
            TextButton(onPressed: (){}, child: Text('Cancel',style: TextStyle(color: Colors.blue),)),
            Text('Details',style: TextStyle(color: Colors.black,fontSize: 10),),
            TextButton(onPressed: (){}, child: Text('Cancel',style: TextStyle(color: Colors.blue),))
          ],
        ),
        SizedBox(height: 5,),
        Container(
            padding: EdgeInsets.symmetric(horizontal: 15.0),
            decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
            ),
            child: TextField(
               keyboardType: TextInputType.multiline,
               maxLines: null,
               minLines: 4,
               decoration: InputDecoration(border: InputBorder.none,
                 enabledBorder:  UnderlineInputBorder(
                 borderSide: BorderSide(color: Colors.grey),)
               ),
               style: TextStyle(fontSize: 10,color: Colors.black),
              ),
           ),
           SizedBox(height: 5,),
           Container(
             padding: EdgeInsets.symmetric(horizontal: 15.0),
             decoration: BoxDecoration(
               color: Colors.white,
               borderRadius: BorderRadius.circular(10.0),
             ),

              child: Column(
                   children: [],
              ),
           ),
           SizedBox(height: 10,),
           Container(
             padding: EdgeInsets.symmetric(horizontal: 15.0),
             decoration: BoxDecoration(
               color: Colors.white,
               borderRadius: BorderRadius.circular(10.0),
             ),

             child: Container(),

           )
         ],
        ),
      ),
    );
  }
}