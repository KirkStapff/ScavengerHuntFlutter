import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kirk_app/challenge_selector.dart';
import 'package:kirk_app/style_constants.dart';
import 'package:kirk_app/take_picture.dart';
import 'dart:convert';
import 'package:kirk_app/question_set.dart';
import 'leaderboard.dart';
import 'package:kirk_app/time_screen.dart';
import 'package:kirk_app/login_screen.dart';
import 'dart:io';

class Answer{
  String ans;

  Answer(String a){
    ans = a;
  }
}

class QuestionScreen extends StatelessWidget {
  static int starttime = 0;
  static int endtime = 0;
  static List<Answer> answers;
  static const String id = "question";
  List<Question> questions;

  QuestionScreen({Key key, @required this.questions}) {
    if(answers == null) {
      print("chingla");
      answers = new List<Answer>(questions.length);
      for (var i = 0; i < questions.length; i++) {
        answers[i] = (new Answer(""));
      }
    }
  }

  String textAnswer = '';

  final textAnswerController = TextEditingController();

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
                      height: MediaQuery.of(context).size.height * .12,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * .1),
                      child: Text(
                        "Question " + ChallengeSelector.order.toString(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: .105 * MediaQuery.of(context).size.width,
                          height: 1.5,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                          fontFamily: font,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .02,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * .06),
                      child: Text(
                        questions[ChallengeSelector.order - 1].question,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: .05 * MediaQuery.of(context).size.width,
                          height: 1.5,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                          fontFamily: font,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .05,
                    ),
                    Visibility(
                      visible: !questions[ChallengeSelector.order-1].textAnswer,
                      child: SizedBox(
                      height: MediaQuery.of(context).size.height * .32,
                    ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * .1),
                      child: Visibility(

                        visible: questions[ChallengeSelector.order - 1].textAnswer,
                        child: Padding(

                          padding: EdgeInsets.only(bottom:30),
                          child: TextFormField(
                          initialValue: answers[ChallengeSelector.order-1].ans,
                          maxLines: 9,
                          style: TextStyle(color: Colors.black, fontSize: 18),
                          //controller: textAnswerController,
                          onChanged: (value) {
                            textAnswer = value;
                          },
                          decoration: InputDecoration(

                            fillColor: Colors.white,
                            filled: true,
                            hintStyle: TextStyle(
                              color: Colors.black, height: MediaQuery.of(context).size.width * .004
                            ),
                            enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(),
                                borderRadius:
                                const BorderRadius.all(Radius.circular(1.0))),
                          ),
                        ),
                        ),
                      ),
                    ),
                    Align(
                        alignment: Alignment.bottomCenter,
                        child: Column(children: [
                      Center(
                        child:Row(children: <Widget>[
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: EdgeInsets.only(left:30),
                              child:Material(
                                elevation: 5.0,
                                color: Colors.blue[1000],
                                borderRadius: BorderRadius.circular(60.0),
                                child: MaterialButton(
                                  onPressed: () {
                                    if (questions[ChallengeSelector.order - 1].textAnswer && textAnswer!=""){
                                      answers[ChallengeSelector.order - 1].ans = textAnswer;
                                    }
                                    ChallengeSelector.order -= 1;
                                    if(ChallengeSelector.order < 1) {
                                      ChallengeSelector.order = questions.length;
                                    }
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => QuestionScreen(
                                            questions: questions,
                                          )),
                                    );
                                  },
                                  minWidth: MediaQuery.of(context).size.width * .23,
                                  height: MediaQuery.of(context).size.height * .05,
                                  child: Text("Last",
                                    style: TextStyle(
                                      fontSize: .05 * MediaQuery.of(context).size.width,
                                      fontFamily: font,
                                      color: Colors.red[200],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Divider(),
                          ),
                          Container(
                              alignment: Alignment.centerRight,
                              child: Padding(
                                padding: EdgeInsets.only(right:30),
                                child:Material(
                                  elevation: 5.0,
                                  color: Colors.blue[1000],
                                  borderRadius: BorderRadius.circular(60.0),
                                  child: MaterialButton(
                                    onPressed: () {

                                      if (questions[ChallengeSelector.order - 1].textAnswer && textAnswer!=""){
                                        answers[ChallengeSelector.order-1].ans = textAnswer;
                                      }
                                      ChallengeSelector.order += 1;
                                      if(ChallengeSelector.order > questions.length) {
                                        ChallengeSelector.order = 1;
                                      }
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => QuestionScreen(
                                              questions: questions,
                                            )),
                                      );
                                    },
                                    minWidth: MediaQuery.of(context).size.width * .23,
                                    height: MediaQuery.of(context).size.height * .05,
                                    child: Text("Next",
                                      style: TextStyle(
                                        fontSize: .05 * MediaQuery.of(context).size.width,
                                        fontFamily: font,
                                        color: Colors.red[200],
                                      ),
                                    ),
                                  ),
                                ),
                              )
                          ),
                        ]),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * .02,
                      ),
                      Visibility(
                        visible:!questions[ChallengeSelector.order - 1].textAnswer,
                        child:Padding(
                          padding: EdgeInsets.symmetric(horizontal: 0.0),
                          child: Material(
                            elevation: 5.0,
                            color: Colors.blue[1000],
                            borderRadius: BorderRadius.circular(60.0),
                            child: MaterialButton(
                              onPressed: () {
                                TakePictureScreen.holdQ = questions;
                                Navigator.pushNamed(context, "take_picture");
                              },
                              minWidth: MediaQuery.of(context).size.width * .5,
                              height: MediaQuery.of(context).size.height * .05,
                              child: Text(
                                "Found It!",
                                style: TextStyle(
                                  fontSize: .05 * MediaQuery.of(context).size.width,
                                  fontFamily: font,
                                  color: Colors.red[200],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * .02,
                      ),
                      Visibility(
                        visible: ChallengeSelector.order == questions.length,
                        child:Padding(
                          padding: EdgeInsets.symmetric(horizontal: 0.0),
                          child: Material(
                            elevation: 5.0,
                            color: Colors.blue[1000],
                            borderRadius: BorderRadius.circular(60.0),
                            child: MaterialButton(
                              onPressed: () {
                                if (questions[ChallengeSelector.order - 1].textAnswer){
                                  answers[ChallengeSelector.order- 1].ans = textAnswer;
                                }
                                endtime = (DateTime.now().microsecondsSinceEpoch/1000000).floor();
                                TimeScreen.holdQ = questions;
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => TimeScreen()),
                                );
                              },
                              minWidth: MediaQuery.of(context).size.width * .5,
                              height: MediaQuery.of(context).size.height * .05,
                              child: Text("Save",
                                style: TextStyle(
                                  fontSize: .05 * MediaQuery.of(context).size.width,
                                  fontFamily: font,
                                  color: Colors.red[200],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * .02,
                      ),
                    ],)),
                  ],
                ))));
  }
}
