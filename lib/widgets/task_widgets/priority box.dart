import 'package:flutter/material.dart';
import 'package:todolist/models/global.dart';


Container box(int index) {
  print(index);
  return Container(
    padding: const EdgeInsets.all(8.0),
    height: 50,
    width: 80,
    child: Container(
      child: Center(
        child: Text(priorityText[index],
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold)),
      ),
      decoration: BoxDecoration(
        color: priorityColor[index],
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(width: 2, color: Colors.black),
      ),
    ),
  );
}
