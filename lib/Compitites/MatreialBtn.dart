import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyBtn extends StatelessWidget {
  MyBtn(
      {Key? key,
      required this.text,
      required this.onPressed,
      required this.color})
      : super(key: key);

  String text;
  Function() onPressed;
  Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 10),
      child: Material(
        elevation: 5,
        color: color,
        borderRadius: BorderRadius.all(Radius.circular(30)),
        child: MaterialButton(
          height: 50,
          onPressed: onPressed,
          child: Text(
            "$text",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
