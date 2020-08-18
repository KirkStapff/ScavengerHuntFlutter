import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:kirk_app/intro_screen.dart';
import 'package:kirk_app/account_screen.dart';
import 'package:kirk_app/question_screen.dart';
import 'package:kirk_app/login_screen.dart';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:kirk_app/take_picture.dart';

Future<void> main() async {
  // Ensure that plugin services are initialized so that `availableCameras()`
  // can be called before `runApp()`
  WidgetsFlutterBinding.ensureInitialized();

  // Obtain a list of the available cameras on the device.
  final cameras = await availableCameras();

  // Get a specific camera from the list of available cameras.
  final firstCamera = cameras.first;

  runApp(MaterialApp(
    theme: ThemeData.dark().copyWith(
      textTheme: TextTheme(
        bodyText1: TextStyle(color: Colors.black54),
      ),
    ),
    home: TakePictureScreen(camera: firstCamera,),
    initialRoute: IntroScreen.id,
    routes: {
      IntroScreen.id: (context) => IntroScreen(),
      CreateAccountScreen.id: (context) => CreateAccountScreen(),
      QuestionScreen.id: (context) => QuestionScreen(),
      TakePictureScreen.id: (context) => TakePictureScreen(camera: firstCamera),
      LoginScreen.id: (context) => LoginScreen(),
    },
  )
  );
}

//class KirkApp extends StatelessWidget {
//
//  @override
//  Widget build(BuildContext context) {
//    return MaterialApp(
//      theme: ThemeData.dark().copyWith(
//        textTheme: TextTheme(
//          bodyText1: TextStyle(color: Colors.black54),
//        ),
//      ),
//      initialRoute: IntroScreen.id,
//      routes: {
//        IntroScreen.id: (context) => IntroScreen(),
//        CreateAccountScreen.id: (context) => CreateAccountScreen(),
//        QuestionScreen.id: (context) => QuestionScreen(),
////        ActiveChats.id: (context) => ActiveChats(),
//      },
//    );
//  }
//}
