import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kirk_app/challenge_selector.dart';
import 'package:kirk_app/login_screen.dart';
import 'package:kirk_app/storage.dart';
import 'package:kirk_app/style_constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:kirk_app/question_screen.dart';
import 'package:kirk_app/question_set.dart';
import 'dart:io';

class PayScreen extends StatelessWidget {
  static const String id = "pay";
  String price = '';
  String reward = '';
  String cvv = '';

  final cvvTextController = TextEditingController();

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
      var client = HttpClient(context: LoginScreen.sec_context);
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      // The rest of this code comes from your question.
      var uri = "https://tlfbermuda.com/sendpayment.php";
      const Latin1Codec latin1 = Latin1Codec();
      var appKey = '["' + LoginScreen.account_id + '","' + cvv + '","' +
          ChallengeSelector.price + '"]';
      //var bytes = latin1.encode(appKey);
      //appKey = base64.encode(bytes);
      var method = 'GET';
      print("2");
      var request = await client.openUrl(method, Uri.parse(uri));
      request.headers.contentLength = 0;
      request.headers.set(HttpHeaders.authorizationHeader, appKey);
      //request.write(data);
      var response = await request.close();
      var textBack = new List<int>();
      textBack.addAll(await response.first);
      var resCode = utf8.decode(textBack);
      print(resCode);
      if (resCode == "1") {
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
                  QuestionScreen(
                      questions: questions)),
        );
      } else {
        alert(context, "Credit Card Processing Error");
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

    Future setFinished() async {
      var client = HttpClient(context: LoginScreen.sec_context);
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;

      // The rest of this code comes from your question.
      var uri = "https://tlfbermuda.com/setpaid.php";

      const Base64Codec base64 = Base64Codec();
      const Latin1Codec latin1 = Latin1Codec();
      var appKey = '[' +
          ChallengeSelector.challengeN.toString() +
          ',' +
          LoginScreen.account_id +
          ',2]';
      print(appKey);
      //var bytes = latin1.encode(appKey);
      //appKey = base64.encode(bytes);
      var method = 'POST';

      var request = await client.openUrl(method, Uri.parse(uri));
      request.headers.contentLength = 0;
      request.headers.set(HttpHeaders.authorizationHeader, appKey);
      //request.write(data);
      var response = await request.close();
      var textBack = new List<int>();
      textBack.addAll(await response.first);
      print(latin1.decode(textBack));
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
                            'Possible Rewards: ' + reward,
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
                            'By clicking "Next" you consent to your stored credit '
                                    'card being charged \$' +
                                price +
                                ' dollars and understand that '
                                    'you may not receive a prize.',
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
                        FutureBuilder(future:Storage.getUserData(), builder:(BuildContext context, AsyncSnapshot snapshot2) {
                          if(snapshot2.data==null)
                            return Text("loading...", style:TextStyle(color:Colors.black, fontSize: 22));
                          return Text("From Card: "+snapshot2.data[5], style:TextStyle(color:Colors.black, fontSize: 22));
                        }),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * .03,
                        ),
                        Container(
                          width: 100,
                          child: TextField(
                            textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 25,
                                  color: Colors.black,
                                  height:
                                      MediaQuery.of(context).size.height * .0012 ),

                              controller: cvvTextController,
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                LengthLimitingTextInputFormatter(3)
                              ],
                              onChanged: (value) {
                                cvv = value;
                              },
                              decoration: InputDecoration(

                                hintText: "CVV",
                                hintStyle: TextStyle(color: Colors.black),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(width: 1.5),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(1.0))),
                              ),
                            ),
                        ),
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
                          height: MediaQuery.of(context).size.height * .06,
                        ),
                        Text("Once you pay you can leave any internet connection to complete the scavenger hunt",
                          style: TextStyle(color: Colors.black, fontSize: 15), textAlign: TextAlign.center,)
                      ],
                    ),
                  ),
                );
              }
            }));
  }

  static Future setPaidState(int state) async {
    var client = HttpClient(context: LoginScreen.sec_context);
    client.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;

    // The rest of this code comes from your question.
    var uri = "https://tlfbermuda.com/setpaid.php";

    const Base64Codec base64 = Base64Codec();
    const Latin1Codec latin1 = Latin1Codec();
    print(state.toString());
    var appKey = '[' +
        ChallengeSelector.challengeN.toString() +
        ',' +
        LoginScreen.account_id +
        ',' +
        state.toString() +
        ']';
    print(appKey);
    //var bytes = latin1.encode(appKey);
    //appKey = base64.encode(bytes);
    var method = 'POST';

    var request = await client.openUrl(method, Uri.parse(uri));
    request.headers.contentLength = 0;
    request.headers.set(HttpHeaders.authorizationHeader, appKey);
    //request.write(data);
    var response = await request.close();
    var textBack = new List<int>();
    textBack.addAll(await response.first);
    print(latin1.decode(textBack));
  }
}
