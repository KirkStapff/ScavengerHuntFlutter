import 'package:flutter/material.dart';
import 'package:kirk_app/intro_screen.dart';
import 'package:kirk_app/account_screen.dart';

void main() => runApp(KirkApp());

class KirkApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        textTheme: TextTheme(
          bodyText1: TextStyle(color: Colors.black54),
        ),
      ),
      initialRoute: IntroScreen.id,
      routes: {
        IntroScreen.id: (context) => IntroScreen(),
        CreateAccountScreen.id: (context) => CreateAccountScreen(),
//        ChatScreen.id: (context) => ChatScreen(),
//        ActiveChats.id: (context) => ActiveChats(),
      },
    );
  }
}
