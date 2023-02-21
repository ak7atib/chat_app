import 'package:chat_app/Compitites/MatreialBtn.dart';
import 'package:chat_app/Screeens/ChatScreen.dart';
import 'package:chat_app/Screeens/RegisterScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

class loginScreen extends StatefulWidget {
  static const id = "loginScreen";
  const loginScreen({Key? key}) : super(key: key);

  @override
  State<loginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<loginScreen> {
  String? email;
  String? password;
  FirebaseAuth auth = FirebaseAuth.instance;
  bool ShowSpinner = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ShowSpinner
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Colors.white, Colors.lightBlueAccent],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topRight)),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Flexible(
                      child: Container(
                        height: 300,
                        child: Image.asset("images/messenger.png"),
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    TextField(
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (value) {
                        email = value;
                      },
                      decoration: kTextFiledStyle.copyWith(
                          hintText: "Enter your Email"),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextField(
                      obscureText: true,
                      onChanged: (value) {
                        password = value;
                      },
                      decoration: kTextFiledStyle.copyWith(
                          hintText: "Enter your Password"),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    MyBtn(
                        text: "Login",
                        onPressed: () async {
                          if (email != null && password != null) {
                            setState(() {
                              ShowSpinner = true;
                            });
                            try {
                              final newUser =
                                  await auth.signInWithEmailAndPassword(
                                      email: email!, password: password!);

                              if (newUser != null) {
                                Navigator.pushNamed(context, chatScreen.id);
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text(
                                      "You are Logged in ${newUser.user!.email}"),
                                  backgroundColor: Colors.green,
                                ));
                              }
                            } catch (e) {
                              print(e);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      "The Email Adderss is already Logged in"),
                                ),
                              );
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("cheak the Email and the Password"),
                              backgroundColor: Colors.redAccent,
                            ));
                          }
                        },
                        color: Colors.lightBlueAccent),
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "If you not have account".toUpperCase(),
                          style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.w900,
                              fontSize: 16),
                        ),
                        IconButton(
                            onPressed: () {
                              Navigator.pushNamedAndRemoveUntil(
                                  context, registerScreen.id, (route) => false);
                            },
                            icon: Icon(Icons.app_registration_sharp))
                      ],
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
