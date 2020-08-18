import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kirk_app/challenge_selector.dart';
import 'package:kirk_app/style_constants.dart';
import 'package:kirk_app/take_picture.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:kirk_app/question_set.dart';
import 'leaderboard.dart';
import 'package:kirk_app/leaderboard.dart';

class QuestionScreen extends StatelessWidget {
  static const String id = "question";
  int questionN = 1;
  List<Question> questions;

  QuestionScreen({Key key, @required this.questions}) : super(key: key);

  String textAnswer = '';

  final textAnswerController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            height: MediaQuery.of(context).size.height,
            color: Colors.white,
            padding: EdgeInsets.symmetric(
              horizontal: 24.0,
            ),
            child: SingleChildScrollView(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  height: 15.0,
                  width: 400.0,
                ),
                SizedBox(
                  height: 25,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    "Question " + ChallengeSelector.order.toString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 45.0,
                      height: 1.5,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                      fontFamily: font,
                    ),
                  ),
                ),
                SizedBox(
                  height: 25.0,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 0),
                  child: Text(
                    questions[ChallengeSelector.order - 1].question,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20.0,
                      height: 1.5,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                      fontFamily: font,
                    ),
                  ),
                ),
                SizedBox(
                  height: 25.0,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Visibility(
                    visible: questions[ChallengeSelector.order - 1].textAnswer,
                    child: TextField(
                      maxLines: 5,
                      style: TextStyle(color: Colors.black),
                      controller: textAnswerController,
                      onChanged: (value) {
                        textAnswer = value;
                      },
                      decoration: InputDecoration(
                        fillColor: Colors.grey[300],
                        filled: true,
                        hintText: "Enter your answer here",
                        hintStyle: TextStyle(
                          color: Colors.black,
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(1.0))),
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: true,
                  child: SizedBox(
                    height: questions[ChallengeSelector.order - 1].textAnswer
                        ? MediaQuery.of(context).size.height * .13
                        : MediaQuery.of(context).size.height * .20,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 0.0),
                  child: Material(
                    elevation: 5.0,
                    color: Colors.blue[1000],
                    borderRadius: BorderRadius.circular(60.0),
                    child: MaterialButton(
                      onPressed: () {
                        TakePictureScreen.holdQ = questions;
                        if (!questions[ChallengeSelector.order - 1].textAnswer)
                          Navigator.pushNamed(context, "take_picture");
                        else {
                          if (ChallengeSelector.order == questions.length) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LeaderBoard()),
                            );
                          } else {
                            ChallengeSelector.order += 1;
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => QuestionScreen(
                                        questions: questions,
                                      )),
                            );
                          }
                        }
                      },
                      minWidth: 200.0,
                      height: 42.0,
                      child: Text(
                        !questions[ChallengeSelector.order - 1].textAnswer
                            ? "Found It!"
                            : "Submit!",
                        style: TextStyle(
                          fontSize: 15,
                          fontFamily: font,
                          color: Colors.red[200],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 25.0,
                ),
              ],
            ))));
  }
}
