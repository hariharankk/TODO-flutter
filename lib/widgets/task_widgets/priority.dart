import 'package:flutter/material.dart';
import 'package:todolist/models/global.dart';
import 'package:todolist/widgets/task_widgets/priority box.dart';

class PriorityPicker extends StatefulWidget {
  int selindex;
  final void Function(int change) onTap;
  PriorityPicker({required this.selindex, required this.onTap});
  @override
  _PriorityPickerState createState() => _PriorityPickerState();
}

class _PriorityPickerState extends State<PriorityPicker> {

  // Array list of items
  @override
  Widget build(BuildContext context) {
    return DropdownButton<dynamic>(
        value: widget.selindex,
        items: index.map((int index) {
          return DropdownMenuItem<dynamic>(value: index, child: box(index));
        }).toList(),
        onChanged: (newValue) {
          print('hari');
            widget.onTap;

        });
 }
}


