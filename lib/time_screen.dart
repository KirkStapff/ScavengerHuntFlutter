import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kirk_app/leaderboard.dart';
import 'package:kirk_app/question_screen.dart';
import 'package:kirk_app/style_constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:kirk_app/challenge_selector.dart';
import 'package:kirk_app/login_screen.dart';
import 'package:kirk_app/question_set.dart';
import 'dart:io';

class TimeScreen extends StatelessWidget {

  format(Duration d) => d.toString().split('.').first.padLeft(8, "0");

  static List<Question> holdQ;

  static Future sendAnswers(context) async {
    String answers = '["';
    for ( Answer answer in QuestionScreen.answers){
      answers += (answer.ans)+'","';
    }
    answers.substring(0, answers.length-2);
    answers += '"]';
    //print(answersList);
    var client = HttpClient(context: LoginScreen.sec_context);
    client.badCertificateCallback = (X509Certificate cert, String host, int port)=> true;

    // The rest of this code comes from your question.
    var uri = "https://tlfbermuda.com/setleaderboard.php?challenge="+ChallengeSelector.challengeN.toString();
    const Base64Codec base64 = Base64Codec(); const Latin1Codec latin1 = Latin1Codec();
    var appKey = '["'+LoginScreen.account_id+'","'+(QuestionScreen.endtime-QuestionScreen.starttime).toString()+'"]';
    print(appKey);
    //var bytes = latin1.encode(appKey);
    //appKey = base64.encode(bytes);
    var method = 'POST';

    var request = await client.openUrl(method,Uri.parse(uri));
    request.headers.contentLength = utf8.encode(answers).length;
    request.headers.set(HttpHeaders.authorizationHeader,
        appKey);
    request.headers.set(HttpHeaders.contentTypeHeader, "application/json; charset=UTF-8");
    request.write(answers);

    var response = await request.close();
    var textBack = new List<int>();
    textBack.addAll(await response.first);
    String r = latin1.decode(textBack);
    if(r != null  && r != ""){
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => LeaderBoard()),
      );
    }
  }

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
        child: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center,children: [
            Text(
            "Finish Time",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black, fontSize: 40, fontFamily: font),
          ),
            SizedBox(
              height: MediaQuery.of(context).size.height * .06,
            ),
            Text(
              format(Duration(seconds:(QuestionScreen.endtime-QuestionScreen.starttime))),
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black, fontSize: 40, fontFamily: font),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * .3,
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
                    sendAnswers(context);

                  },
                  minWidth: MediaQuery.of(context).size.width * .5,
                  height: MediaQuery.of(context).size.height * .05,
                  child: Text(
                    'Submit!',
                    style: TextStyle(
                      fontSize: .045 * MediaQuery.of(context).size.width,
                      fontFamily: font,
                      color: Colors.red[200],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  vertical: MediaQuery.of(context).size.height * .01),
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
                              QuestionScreen(
                                  questions: holdQ)),
                    );
                  },
                  minWidth: MediaQuery.of(context).size.width * .5,
                  height: MediaQuery.of(context).size.height * .05,
                  child: Text(
                    'Go Back',
                    style: TextStyle(
                      fontSize: .045 * MediaQuery.of(context).size.width,
                      fontFamily: font,
                      color: Colors.red[200],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * .08,
            ),
            Text("You must return to internet connection to submit, your finish time is now confirmed",
              style: TextStyle(color: Colors.black, fontSize: 18), textAlign: TextAlign.center,)
          ]
          ),

        ),
        ),
    );
  }
}
