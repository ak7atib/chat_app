import 'package:flutter/material.dart';

InputDecoration kTextFiledStyle = InputDecoration(
  hintText: "Enter your Email",
  contentPadding: EdgeInsets.symmetric(horizontal: 20),
  enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.blue, width: 2),
      borderRadius: BorderRadius.circular(50)),
  border:
      OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(30))),
  focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.blue, width: 2),
      borderRadius: BorderRadius.all(Radius.circular(30))),
);

const MessageTextField = InputDecoration(
    contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
    hintText: "Typer Your Message.....",
    border: InputBorder.none);

const MessageContainerStyle = BoxDecoration(
  border: Border(
    top: BorderSide(color: Colors.lightBlueAccent, width: 2.0),
  ),
);
