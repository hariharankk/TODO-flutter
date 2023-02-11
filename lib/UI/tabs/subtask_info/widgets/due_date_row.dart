import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todolist/models/global.dart';
import 'package:todolist/remainder/remainder.dart';
import 'package:todolist/widgets/task_widgets/remainder_widget.dart';

class DueDateRow extends StatefulWidget {
  final viewmodel;

  DueDateRow(this.viewmodel);

  @override
  _DueDateRowState createState() => _DueDateRowState();
}

class _DueDateRowState extends State<DueDateRow> {
  late double unitHeightValue, unitWidthValue;

  @override
  Widget build(BuildContext context) {
    unitHeightValue = MediaQuery.of(context).size.height * 0.001;
    unitWidthValue = MediaQuery.of(context).size.width * 0.001;
    return Row(
      children: [
        SizedBox(width: 20 * unitWidthValue),
        GestureDetector(
          onTap: () => _showDatePicker(context),
          child: Row(
              children:[
                Icon(Icons.calendar_today,
                    color: Colors.blue, size: 20 * unitHeightValue),
                SizedBox(width: 5 * unitWidthValue),

                Text(
                  "நிலுவைத் தேதி: ${widget.viewmodel.deadline.month}/${widget.viewmodel.deadline.day}/${widget.viewmodel.deadline.year}",
                  style: labelStyle1(unitHeightValue),
                ),
              ]
          ),
        ),

        SizedBox(width: 20 * unitWidthValue),
        GestureDetector(
          onTap: () {
            showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (context) =>  DatePicker());
          },
          child: Row(
              children:<Widget>[
                Icon(Icons.calendar_today,
                    color: Colors.blue, size: 20 * unitHeightValue),
                SizedBox(width: 5 * unitWidthValue),
                Text('மீதியை அமைக்கவும்',style: labelStyle1(unitHeightValue))
              ]
          ),
        )
      ],
    );
  }

  void _showDatePicker(context) {
    // showCupertinoModalPopup is a built-in function of the cupertino library
    showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        height: 250 * unitHeightValue,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              height: 200 * unitHeightValue,
              child: CupertinoDatePicker(
                  initialDateTime: widget.viewmodel.deadline,
                  mode: CupertinoDatePickerMode.date,
                  onDateTimeChanged: (date) =>
                      widget.viewmodel.deadline = date),
            ),
            // Close the modal
            TextButton(
              child: Text(
                'முடிந்தது',
                style: TextStyle(
                    color: Colors.blue,
                    fontSize: 20 * unitHeightValue,
                    fontWeight: FontWeight.w600),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {});
              },
            )
          ],
        ),
      ),
    );
  }
}


class VisitorDueDateRow extends StatefulWidget {
  final viewmodel;

  VisitorDueDateRow(this.viewmodel);

  @override
  _VisitorDueDateRowState createState() => _VisitorDueDateRowState();
}

class _VisitorDueDateRowState extends State<VisitorDueDateRow> {
  late double unitHeightValue, unitWidthValue;

  @override
  Widget build(BuildContext context) {
    unitHeightValue = MediaQuery.of(context).size.height * 0.001;
    unitWidthValue = MediaQuery.of(context).size.width * 0.001;
    return Row(
      children: [
        SizedBox(width: 10 * unitWidthValue),
        Row(
          children:[
              Icon(Icons.calendar_today,
                  color: Colors.blue, size: 20 * unitHeightValue),
            SizedBox(width: 5 * unitWidthValue),

            Text(
              "நிலுவைத் தேதி: ${widget.viewmodel.deadline.month}/${widget.viewmodel.deadline.day}/${widget.viewmodel.deadline.year}",
              style: labelStyle1(unitHeightValue),
            ),
           ]
          ),
        SizedBox(width: 5 * unitWidthValue),
        GestureDetector(
          onTap: () {
              showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (context) =>  DatePicker());
          },
          child: Row(
            children:<Widget>[
                Icon(Icons.calendar_today,
                    color: Colors.blue, size: 20 * unitHeightValue),
                SizedBox(width: 5 * unitWidthValue),
                Text('மீதியை அமைக்கவும்',style: labelStyle1(unitHeightValue))
            ]
          ),
        )

      ],
    );
  }
}
