import 'package:flutter/material.dart';
import 'package:todolist/models/global.dart';
import 'package:todolist/widgets/task_widgets/priority box.dart';

class PriorityPicker extends StatefulWidget {
  int selindex;
  PriorityPicker({required this.selindex});
  @override
  _PriorityPickerState createState() => _PriorityPickerState();
}

class _PriorityPickerState extends State<PriorityPicker> {

  // Array list of items

  @override
  Widget build(BuildContext context) {
    return DropdownButton<dynamic>(
        value: widget.selindex,
        icon: Icon(Icons.arrow_downward),
        iconSize: 26,
        elevation: 16,
        style: TextStyle(
          color: Colors.deepPurple,
          fontSize: 23.0,
        ),
        items: index.map((int index) {
          return DropdownMenuItem<dynamic>(value: index, child: box(index));
        }).toList(),
        onChanged: (newValue) {
          setState(() {
            //widget.selindex = newValue;
          });
        });
 }
}


