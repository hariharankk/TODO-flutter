import 'package:flutter/material.dart';
import 'package:todolist/models/global.dart';
import 'package:todolist/widgets/task_widgets/priority box.dart';

class PriorityPicker extends StatefulWidget {
  int selindex;
  Color color;
  final void Function(int) onTap;
  PriorityPicker({required this.selindex, required this.onTap, required this.color});
  @override
  _PriorityPickerState createState() => _PriorityPickerState();
}

class _PriorityPickerState extends State<PriorityPicker> {
  late int currentSelectedValue;
  // Array list of items
  @override
  Widget build(BuildContext context) {
    return DropdownButton<dynamic>(
        value: widget.selindex,
        icon: Icon(Icons.arrow_downward,color:widget.color ),//darkGreenBlue,),
        iconSize: 26,
        underline: Container(
          height: 2,
          color: widget.color,
        ),
        items: index.map((int index) {
          return DropdownMenuItem<dynamic>(value: index, child: box(index));
        }).toList(),
        onChanged: (newValue) {
          setState(() {
            currentSelectedValue = newValue;
          });
            widget.onTap(currentSelectedValue);
        });
 }
}


