import 'package:flutter/material.dart';


TextStyle appTitleStyle(double unitHeightValue) => TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 36.0 * unitHeightValue,
    );

TextStyle hintTextStyle(double unitHeightValue) => TextStyle(
      color: Colors.white70,
      fontSize: 18 * unitHeightValue,
    );

TextStyle labelStyle(double unitHeightValue) => TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 18 * unitHeightValue,
    );

BoxDecoration boxDecorationStyle() => BoxDecoration(
      color: Color(0xff57CBF2),
      borderRadius: BorderRadius.circular(10.0),
      boxShadow: [
        BoxShadow(
          color: Colors.black12,
          blurRadius: 6.0,
          offset: Offset(0, 2),
        ),
      ],
    );

BoxDecoration profileBoxDecorationStyle() => BoxDecoration(
      color: Color(0xff57CBF2),
      borderRadius: BorderRadius.circular(10.0),
      boxShadow: [
        BoxShadow(
          color: Colors.black12,
          blurRadius: 6.0,
          offset: Offset(0, 2),
        ),
      ],
    );

TextStyle cardTitleStyle(double unitHeightValue) => new TextStyle(
      fontWeight: FontWeight.bold,
      color: Colors.white,
      fontSize: 50 * unitHeightValue,
    );

TextStyle toDoListTileStyle(double unitHeightValue) => new TextStyle(
      fontWeight: FontWeight.bold,
      color: Colors.white,
      fontSize: 25 * unitHeightValue,
    );

TextStyle toDoListSubtitleStyle(double unitHeightValue) => new TextStyle(
      fontWeight: FontWeight.w300,
      color: Colors.white,
      fontSize: 17 * unitHeightValue,
    );

TextStyle taskListTitleStyle(double unitHeightValue) => new TextStyle(
      fontWeight: FontWeight.bold,
      color: Colors.white,
      fontSize: 50 * unitHeightValue,
    );

TextStyle loginTitleStyle(double unitHeightValue) => new TextStyle(
      fontWeight: FontWeight.bold,
      color: Colors.white,
      fontSize: 36 * unitHeightValue,
    );
TextStyle loginButtonStyle(double unitHeightValue) => new TextStyle(
      fontWeight: FontWeight.w700,
      color: Colors.white,
      fontSize: 26 * unitHeightValue,
    );

TextStyle registerButtonStyle(double unitHeightValue) => new TextStyle(
      fontWeight: FontWeight.bold,
      color: Colors.blue,
      fontSize: 26 * unitHeightValue,
    );


List<int> index =[0,1,2];
List<String> priorityText = ['Low', 'Mid', 'High'];
List<Color> priorityColor = [Colors.green, Colors.lightGreen, Colors.red];
