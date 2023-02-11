import 'package:flutter/material.dart';
import 'package:todolist/models/global.dart';
import 'package:todolist/widgets/task_widgets/priority box.dart';

class PriorityPicker extends StatefulWidget {
  final void Function(int) onTap;
  final Color colors;
  PriorityPicker({required this.onTap, required this.colors});
  @override
  _PriorityPickerState createState() => _PriorityPickerState();
}

class _PriorityPickerState extends State<PriorityPicker> {
  late double unitHeightValue, unitWidthValue;


  // Array list of items
  @override
  Widget build(BuildContext context) {
    unitHeightValue = MediaQuery.of(context).size.height * 0.001;
    unitWidthValue = MediaQuery.of(context).size.width * 0.001;

    return PopupMenuButton<dynamic>(
        tooltip: 'முன்னுரிமை',
        padding: EdgeInsets.symmetric(
            vertical: 8 * unitHeightValue, horizontal: 8 * unitWidthValue),
        icon: Icon(Icons.priority_high,
            size: 32.0 * unitHeightValue, color: widget.colors),
        color: Colors.white,
        offset: Offset(0, 70 * unitHeightValue),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(15.0),
          ),
        ),
        onSelected: (value) {
          widget.onTap(value);
        },
        itemBuilder: (context) => index.map((int index) {
          return PopupMenuItem<dynamic>(value: index, child: box(index: index,height: unitHeightValue*boxlength,width: unitWidthValue*boxwidth,));
        }).toList(),
        );
 }
}


