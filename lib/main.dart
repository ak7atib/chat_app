import 'package:chat_app/Screeens/ChatScreen.dart';
import 'package:chat_app/Screeens/LoginScreen.dart';
import 'package:chat_app/Screeens/RegisterScreen.dart';
import 'package:chat_app/Screeens/WelcomeScreen.dart';
import 'package:chat_app/constants.dart';
import 'package:chat_app/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'Screeens/Notifications.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  print('User granted permission: ${settings.authorizationStatus}');

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Got a message whilst in the foreground!');
    print('Message data: ${message.data}');

    if (message.notification != null) {
      print('Message also contained a notification: ${message.notification}');
    }
  });

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  void getFcm() async {
    final fcmToken = await FirebaseMessaging.instance.getToken();
    print("fcm=================================: $fcmToken");
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    getFcm();
    return MaterialApp(initialRoute: welcomeScreen.id, routes: {
      welcomeScreen.id: (context) => welcomeScreen(),
      loginScreen.id: (context) => loginScreen(),
      registerScreen.id: (context) => registerScreen(),
      chatScreen.id: (context) => chatScreen(),
      NotificationsScreen.id: (context) => NotificationsScreen()
    });
  }
}
