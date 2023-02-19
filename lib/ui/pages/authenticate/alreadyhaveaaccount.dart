import 'package:flutter/material.dart';

class AlreadyHaveAnAccountCheck extends StatelessWidget {
  final bool login;
  final VoidCallback press;
  const AlreadyHaveAnAccountCheck({
    this.login = true,
    required this.press,
  }) ;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          login ? "கணக்கு இல்லையா? " : "ஏற்கனவே ஒரு கணக்கு உள்ளதா? ", // Don’t have an Account ? "  //Already have an Account ?
          style: const TextStyle(
            fontSize: 13,
          ),
        ),
        GestureDetector(
          onTap: press ,
          child: Text(
            login ? "பதிவு செய்யவும்" : "உள்நுழையவும்",
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold
            ),
          ),
        )
      ],
    );
  }
}
