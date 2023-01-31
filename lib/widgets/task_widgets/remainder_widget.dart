import 'package:flutter/material.dart';
import 'package:popover/popover.dart';
import 'package:intl/intl.dart';
import 'package:todolist/models/global.dart';

class DatePicker extends StatefulWidget {
  @override
  DatePickerState createState() => DatePickerState();
}

class DatePickerState extends State<DatePicker> {
  String selectedDate = '', hour = '',repeat_text='Never';
  late double unitHeightValue, unitWidthValue;

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now().add(Duration(hours: 1)),
        firstDate: DateTime.now(),
        lastDate: DateTime(2100));

    if (picked != null)
      setState(() {
        var Format = DateFormat('dd/MM/yyyy');
        selectedDate = Format.format(picked);
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
                      'Cancel',
                      style: TextStyle(color: Colors.blue),
                    )),
                Text(
                  'Details',
                  style: TextStyle(color: Colors.black, fontSize: 30),
                ),
                TextButton(
                    onPressed: () {},
                    child: Text(
                      'Set Remainder',
                      style: TextStyle(color: Colors.blue),
                    ))
              ],
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
                      'Date',
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
                    title: Text('Time',
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
                  showPopover(
                    context: context,
                    bodyBuilder: (context) =>  ListItems(),
                    direction: PopoverDirection.top,
                    height: unitHeightValue,
                    width: unitWidthValue,
                  ).then((value){
                    setState(() {
                      repeat_text=value.toString();
                    });
                  });
                },
                leading: Icon(
                  Icons.repeat,
                  color: Colors.grey,
                  size: 40,
                ),
                title: Text(
                  'Repeat',
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
    );
  }
}