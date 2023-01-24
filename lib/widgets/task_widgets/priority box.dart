import 'package:flutter/material.dart';
import 'package:todolist/models/global.dart';

class  box extends StatelessWidget {
  final int index;
  final double height;
  final double width;
  box({required this.index, required this.height, required this.width});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
        child: Container(
          height: height,
          width: width,
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Center(
              child: Text(priorityText[index],
                style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold)),
              ),
          decoration: BoxDecoration(
            color: priorityColor[index],
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(width: 3, color: Colors.black),
          ),
        ),
      );
  }
}

