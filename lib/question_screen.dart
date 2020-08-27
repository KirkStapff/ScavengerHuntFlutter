import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kirk_app/challenge_selector.dart';
import 'package:kirk_app/style_constants.dart';
import 'package:kirk_app/take_picture.dart';
import 'dart:convert';
import 'package:kirk_app/question_set.dart';
import 'leaderboard.dart';
import 'package:kirk_app/leaderboard.dart';
import 'package:kirk_app/login_screen.dart';
import 'dart:io';

class QuestionScreen extends StatelessWidget {
  static int starttime = 0;
  static int endtime = 0;
  static List<String> answers;
  static const String id = "question";
  int questionN = 1;
  List<Question> questions;

  static List<String> answer;

  QuestionScreen({Key key, @required this.questions}) : super(key: key);

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
                      height: MediaQuery.of(context).size.height * .045,
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
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * .1),
                      child: Visibility(
                        visible: questions[ChallengeSelector.order - 1].textAnswer,
                        child: TextField(
                          maxLines: 12,
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
                              answers[ChallengeSelector.challengeN] = textAnswer;
                              if (ChallengeSelector.order == questions.length) {
                                sendAnswers();
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
                          minWidth: MediaQuery.of(context).size.width * .5,
                          height: MediaQuery.of(context).size.height * .05,
                          child: Text(
                            !questions[ChallengeSelector.order - 1].textAnswer
                                ? "Found It!"
                                : "Submit!",
                            style: TextStyle(
                              fontSize: .05 * MediaQuery.of(context).size.width,
                              fontFamily: font,
                              color: Colors.red[200],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .02,
                    ),
                  ],
                ))));
  }

  static Future sendAnswers() async {
    endtime = (DateTime.now().microsecondsSinceEpoch/10000000).floor();
    print("endTime:"+endtime.toString());
    String answers = jsonEncode(QuestionScreen.answers);
    print(answers);
    var client = HttpClient(context: LoginScreen.sec_context);
    client.badCertificateCallback = (X509Certificate cert, String host, int port)=> true;

    // The rest of this code comes from your question.
    var uri = "https://tlfbermuda.com/setleaderboard.php?challenge="+ChallengeSelector.challengeN.toString();
    const Base64Codec base64 = Base64Codec(); const Latin1Codec latin1 = Latin1Codec();
    var appKey = '["'+LoginScreen.account_id+'","'+(QuestionScreen.endtime-QuestionScreen.starttime).toString()+'","'+answers+'"]';
    print(appKey);
    //var bytes = latin1.encode(appKey);
    //appKey = base64.encode(bytes);
    var method = 'POST';

    var request = await client.openUrl(method,Uri.parse(uri));
    request.headers.contentLength = 0;
    request.headers.set(HttpHeaders.authorizationHeader,
        appKey);
    //request.write(data);
    var response = await request.close();
    var textBack = new List<int>();
    textBack.addAll(await response.first);
    print(latin1.decode(textBack));
  }
}
