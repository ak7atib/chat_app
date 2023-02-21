import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:chat_app/Compitites/MatreialBtn.dart';
import 'package:chat_app/Screeens/LoginScreen.dart';
import 'package:chat_app/Screeens/RegisterScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

class welcomeScreen extends StatefulWidget {
  static const id = "welcomeScreen";

  const welcomeScreen({Key? key}) : super(key: key);

  @override
  State<welcomeScreen> createState() => _welcomeScreenState();
}

class _welcomeScreenState extends State<welcomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  Duration duration = Duration(seconds: 1);
  late Animation animation;

  @override
  void initState() {
    controller = AnimationController(vsync: this, duration: duration);
    controller.forward();
    // controller.addListener(() {
    //   print("===============${controller.value}");
    //   setState(() {});
    // });

    // animation = ColorTween(begin: Colors.lightBlue, end: Colors.white)
    //     .animate(controller);

    animation =
        CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn);

    // CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn);
    animation.addListener(() {
      print(animation.value);
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
          Colors.white.withOpacity(animation.value),
          Colors.lightBlueAccent.withOpacity(animation.value)
        ], begin: Alignment.bottomCenter, end: Alignment.topRight)),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Hero(
                    tag: "logo",
                    child: Container(
                      height: controller.value * 100,
                      child: Image.asset("images/messenger.png"),
                    ),
                  ),
                  AnimatedTextKit(
                    animatedTexts: [
                      WavyAnimatedText(("Messenger"),
                          textStyle: TextStyle(
                              fontSize: 45, fontWeight: FontWeight.w900),
                          speed: Duration(milliseconds: 300)),
                    ],
                    onTap: () {
                      print("Tap Event");
                    },
                  ),
                ],
              ),
              SizedBox(
                height: 40,
              ),
              MyBtn(
                text: "Login",
                color: Colors.lightBlueAccent,
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, loginScreen.id, (route) => false);
                },
              ),
              MyBtn(
                text: "Register",
                color: Colors.lightBlueAccent,
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, registerScreen.id, (route) => false);
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
