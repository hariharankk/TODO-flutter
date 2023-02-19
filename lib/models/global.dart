import 'package:flutter/material.dart';


TextStyle appTitleStyle(double unitHeightValue) => TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 36.0 * unitHeightValue,
    );

TextStyle appTitleStyle1(double unitHeightValue) => TextStyle(
  color: Colors.blue,
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

TextStyle labelStyle1(double unitHeightValue) => TextStyle(
  color: Colors.blue,
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
      color: Colors.blue,
      fontSize: 25 * unitHeightValue,
    );

TextStyle toDoListTiletimeStyle(double unitHeightValue) => new TextStyle(
  color: Colors.blue,
  fontSize: 25 * unitHeightValue,
);

TextStyle toDoListTilesubtimeStyle(double unitHeightValue) => new TextStyle(
  color: Colors.blue,
  fontSize: 15 * unitHeightValue,
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
List<String> priorityText = ['குறைந்த', 'நடுத்தர', 'உயர்'];
List<Color> priorityColor = [Colors.green, Colors.lightGreen, Colors.red];

const boxlength = 50;
const boxwidth = 200;


const kMessageContainerDecoration = BoxDecoration(
  border: Border(
    top: BorderSide(color: Colors.white, width: 2.0),
  ),
);

const kMessageTextFieldDecoration = InputDecoration(
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  hintText: 'உங்கள் செய்தியை இங்கே உள்ளிடவும்...',
  border: InputBorder.none,
);

const kSendButtonTextStyle = TextStyle(
  color: Colors.blue,
  fontWeight: FontWeight.bold,
  fontSize: 18.0,
);

List<String> popup_repeat = ['One-Time','Daily','Weekly'];

List<String> group_permissions = ['பார்வையாளர்','தொழிலாளி','நிர்வாகம்'];