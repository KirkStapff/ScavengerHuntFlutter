import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kirk_app/account_screen.dart';
import 'package:kirk_app/challenge_selector.dart';
import 'package:kirk_app/login_screen.dart';
import 'package:kirk_app/style_constants.dart';
import 'package:kirk_app/instructions.dart';
import 'package:kirk_app/challenge_selector.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'storage.dart';
import 'package:kirk_app/question_set.dart';
import 'package:kirk_app/question_screen.dart';

class PayFinised extends StatefulWidget {
  static const String id = 'intro';
  static List<Question> questions;
  PayFinised(List<Question> questions){
    PayFinised.questions = questions;
  }

  @override
  PayFinisedState createState() => PayFinisedState();
}

class PayFinisedState extends State<PayFinised> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("images/fullscreen.png"),
              fit: BoxFit.cover,
            )
        ),
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * .04,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: MediaQuery.of(context).size.height * .25,
                width: MediaQuery.of(context).size.width,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * .06),
                child: Text(
                  'Payment Complete',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: .08 * MediaQuery.of(context).size.width,
                    height: 1.5,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                    fontFamily: font,
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * .01,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * .03,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    vertical: MediaQuery.of(context).size.height * .02),
                child: Material(
                  elevation: 5.0,
                  color: Colors.blue[1000],
                  borderRadius: BorderRadius.circular(60.0),
                  child: MaterialButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                QuestionScreen(questions: PayFinised.questions)),
                      );
                    },
                    minWidth: MediaQuery.of(context).size.width * .5,
                    height: MediaQuery.of(context).size.height * .05,
                    child: Text(
                      'Next',
                      style: TextStyle(
                        fontSize: .045 * MediaQuery.of(context).size.width,
                        fontFamily: font,
                        color: Colors.red[200],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}