import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kirk_app/challenge_selector.dart';
import 'package:kirk_app/login_screen.dart';
import 'package:kirk_app/pay_finished.dart';
import 'package:kirk_app/storage.dart';
import 'package:kirk_app/style_constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:kirk_app/question_screen.dart';
import 'package:kirk_app/question_set.dart';
import 'dart:io';

import 'leaderboard.dart';

class PayScreen extends StatelessWidget {
  static const String id = "pay";
  String price = '';
  String reward = '';
  String cvv = '';
  String card = '';
  String expMon = '';
  String expYear = '';

  final cvvTextController = TextEditingController();
  final cardTextController = TextEditingController();
  final expmTextController = TextEditingController();
  final expyTextController = TextEditingController();

  PayScreen({Key key, this.price, this.reward}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    Future<void> alert(BuildContext context, String alrt) async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Invalid Information'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(alrt),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

    Future<bool> sendPayment(var questions) async {
      final http.Response response = await http.post(
        'https://apitest.authorize.net/xml/v1/request.api',
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<Object, Object>{
            "createTransactionRequest": {
              "merchantAuthentication": {
                "name": "8jz7Fs7zV3H",
                "transactionKey": "38jjKWmUu37m7647"
              },
              "transactionRequest": {
                "transactionType": "authCaptureTransaction",
                "amount": price,
                "payment": {
                  "creditCard": {
                    "cardNumber": card,
                    "expirationDate": "20"+expYear+"-"+expMon,
                    "cardCode": cvv
                  }
                },
                "processingOptions": {
                  "isSubsequentAuth": "true"
                },
                "authorizationIndicatorType": {
                  "authorizationIndicator": "final"
                }
              }
            }
        }),
      );
      var body = jsonDecode(response.body);
      print(body["transactionResponse"]["responseCode"]);
      if (int.parse(body["transactionResponse"]["responseCode"]) == 1) {
        QuestionScreen.starttime =
            (DateTime
                .now()
                .microsecondsSinceEpoch /
                1000000).floor();
        print("startTime:" +
            QuestionScreen.starttime.toString());
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  PayFinised(questions)),
        );
      } else {
        alert(context, "Credit Card Processing Error, Please try again later");
      }
    }

    Future<List<Question>> getQuestions(int challenge) async {
      var url = "http://www.tlfbermuda.com/getquestions.php?challenge=" +
          ChallengeSelector.challengeN.toString();
      var resp = await http.get(url);
      print(resp.body);
      var obj = json.decode(resp.body);

      ChallengeSelector.order = 1;

      List<Question> list = new List<Question>();
      for (var q in obj) {
        list.add(new Question(
            q["Question"], ("1".compareTo(q["TextAnswer"])) == 0, false));
        print(q.toString());
      }

      return list;
    }

    return Scaffold(
        body: FutureBuilder(
            future: getQuestions(ChallengeSelector.challengeN),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.data == null) {
                return Container(child: Center(child: Text("Loading")));
              } else {
                return Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                    image: AssetImage("images/fullscreen.png"),
                    fit: BoxFit.cover,
                  )),
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
                          height: MediaQuery.of(context).size.height * .09,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal:
                                  MediaQuery.of(context).size.width * .1),
                          child: Text(
                            "Price: " + "\$" + price,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: .1 * MediaQuery.of(context).size.width,
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
                              horizontal:
                                  MediaQuery.of(context).size.width * .06),
                          child: Text(
                            'Possible Prizes: ' + reward,
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
                          height: MediaQuery.of(context).size.height * .02,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal:
                                  MediaQuery.of(context).size.width * .06),
                          child: Text(
                            'By clicking "Next" you will be ' +
                                    'be charged \$',
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
                          height: MediaQuery.of(context).size.height * .06,
                        ),
                        Container(
                          width: 500,
                          child: TextField(
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 25,
                                color: Colors.black,
                                height:
                                MediaQuery.of(context).size.height * .0012 ),

                            controller: cardTextController,
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              LengthLimitingTextInputFormatter(16)
                            ],
                            onChanged: (value) {
                              card = value;
                            },
                            decoration: InputDecoration(

                              hintText: "Card Number",
                              hintStyle: TextStyle(color: Colors.black),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(width: 1.5),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(1.0))),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * .03,
                        ),
                        Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
                          Container(
                            width: 100,
                            child: TextField(
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                  height:
                                  MediaQuery.of(context).size.height * .0012 ),

                              controller: cvvTextController,
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                LengthLimitingTextInputFormatter(4)
                              ],
                              onChanged: (value) {
                                cvv = value;
                              },
                              decoration: InputDecoration(

                                hintText: "cvv",
                                hintStyle: TextStyle(color: Colors.black),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(width: 1.5),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(1.0))),
                              ),
                            ),
                          ),
                          Container(
                            width: 100,
                            child: TextField(
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                  height:
                                  MediaQuery.of(context).size.height * .0012 ),

                              controller: expmTextController,
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                LengthLimitingTextInputFormatter(2)
                              ],
                              onChanged: (value) {
                                expMon = value;
                              },
                              decoration: InputDecoration(

                                hintText: "Exp Mon",
                                hintStyle: TextStyle(color: Colors.black),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(width: 1.5),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(1.0))),
                              ),
                            ),
                          ),
                          Container(
                            width: 100,
                            child: TextField(
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                  height:
                                  MediaQuery.of(context).size.height * .0012 ),

                              controller: expyTextController,
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                LengthLimitingTextInputFormatter(2)
                              ],
                              onChanged: (value) {
                                expYear = value;
                              },
                              decoration: InputDecoration(

                                hintText: "Exp Year",
                                hintStyle: TextStyle(color: Colors.black),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(width: 1.5),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(1.0))),
                              ),
                            ),
                          ),
                        ]),

                        SizedBox(
                          height: MediaQuery.of(context).size.height * .01,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical:
                                  MediaQuery.of(context).size.width * .06),
                          child: Material(
                            elevation: 5.0,
                            color: Colors.blue[1000],
                            borderRadius: BorderRadius.circular(60.0),
                            child: MaterialButton(
                              onPressed: () {
                                QuestionScreen.answers = null;
                                sendPayment(snapshot.data);//
                              },
                              minWidth: 200.0,
                              height: 42.0,
                              child: Text(
                                'Next',
                                style: TextStyle(
                                  fontSize:
                                      .06 * MediaQuery.of(context).size.width,
                                  fontFamily: font,
                                  color: Colors.red[200],
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * .005,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical:
                              MediaQuery.of(context).size.width * .01),
                          child: Material(
                            elevation: 5.0,
                            color: Colors.blue[1000],
                            borderRadius: BorderRadius.circular(60.0),
                            child: MaterialButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => LeaderBoard()));
                              },
                              minWidth: 200.0,
                              height: 42.0,
                              child: Text(
                                'Leaderboard',
                                style: TextStyle(
                                  fontSize:
                                  .06 * MediaQuery.of(context).size.width,
                                  fontFamily: font,
                                  color: Colors.red[200],
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * .05,
                        ),
                        Text("Once you pay you can leave internet connection to complete the scavenger hunt",
                          style: TextStyle(color: Colors.black, fontSize: 15), textAlign: TextAlign.center,)
                      ],
                    ),
                  ),
                );
              }
            }));
  }
}
