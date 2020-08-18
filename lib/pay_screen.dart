import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kirk_app/challenge_selector.dart';
import 'package:kirk_app/style_constants.dart';
import 'package:kirk_app/take_picture.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:kirk_app/question_screen.dart';
import 'package:kirk_app/question_set.dart';
import 'leaderboard.dart';

class PayScreen extends StatelessWidget {
  static const String id = "pay";
  int challengeN = 1;

  PayScreen({Key key, this.challengeN}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    Future<List<Question>> getQuestions(int challenge) async{
      print("bow");
      var url = "http://www.tlfbermuda.com/getquestions.php?challenge="+challenge.toString();
      var resp = await http.get(url);
      var obj = json.decode(resp.body);
      ChallengeSelector.order = 1;
      print(resp.body);
      print(obj[0]["Question"]);
      List<Question> list = new List<Question>();
      for(var q in obj){
        list.add(new Question(q["Question"],("1".compareTo(q["TextAnswer"])) == 0));
      }
      print(list[0].question);
      return list;
    }

    return Scaffold(
        body: FutureBuilder(
            future: getQuestions(challengeN),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.data == null) {
                return Container(child: Center(child: Text("Loading")));
              } else {
                return Container(
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
                            "Pay 25",
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
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 16.0),
                          child: Material(
                            elevation: 5.0,
                            color: Colors.blue[1000],
                            borderRadius: BorderRadius.circular(60.0),
                            child: MaterialButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => QuestionScreen(questions: snapshot.data)),
                                );
                              },
                              minWidth: 200.0,
                              height: 42.0,
                              child: Text(
                                'Lets Go!',
                                style: TextStyle(
                                  fontSize: 15,
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
                );
              }
            }));
  }
}
