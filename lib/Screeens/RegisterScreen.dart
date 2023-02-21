import 'package:chat_app/Compitites/MatreialBtn.dart';
import 'package:chat_app/Screeens/ChatScreen.dart';
import 'package:chat_app/Screeens/LoginScreen.dart';
import 'package:chat_app/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class registerScreen extends StatefulWidget {
  static const id = "registerScreen";
  const registerScreen({Key? key}) : super(key: key);

  @override
  State<registerScreen> createState() => _registerScreenState();
}

class _registerScreenState extends State<registerScreen> {
  String? email;
  String? password;
  FirebaseAuth auth = FirebaseAuth.instance;

  void getRegisteration() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
      }
    });
  }

  @override
  void initState() {
    getRegisteration();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
                decoration:
                    kTextFiledStyle.copyWith(hintText: "Enter your Email"),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                obscureText: true,
                onChanged: (value) {
                  password = value;
                },
                decoration:
                    kTextFiledStyle.copyWith(hintText: "Enter your Password"),
              ),
              SizedBox(
                height: 30,
              ),
              MyBtn(
                  text: "Registirtion",
                  onPressed: () async {
                    if (email != null && password != null) {
                      try {
                        final newUser =
                            await auth.createUserWithEmailAndPassword(
                                email: email!.trim(), password: password!);

                        if (newUser != null) {
                          Navigator.pushNamedAndRemoveUntil(
                              context, chatScreen.id, (routye) => false);
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                                "You are Registered in ${newUser.user!.email}"),
                            backgroundColor: Colors.green,
                          ));
                        }
                      } catch (e) {
                        print(e);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: Colors.lightBlue,
                            content: Text(
                                "!!..The Email Adderss is already Registered"),
                          ),
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                          "Enter the Email and the Password to Registreation",
                          style: TextStyle(fontSize: 14),
                        ),
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
                    "If you have account!!..".toUpperCase(),
                    style: TextStyle(
                        color: Colors.blue,
                        fontSize: 15,
                        fontWeight: FontWeight.w900),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(
                          context, loginScreen.id, (route) => false);
                    },
                    icon: Icon(Icons.login_sharp),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
