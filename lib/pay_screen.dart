import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kirk_app/challenge_selector.dart';
import 'package:kirk_app/login_screen.dart';
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

  PayScreen({Key key, this.price, this.reward})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future<List<Question>> getQuestions(int challenge) async {
      var url = "http://www.tlfbermuda.com/getquestions.php?challenge=" +
          challenge.toString();
      var resp = await http.get(url);
      var obj = json.decode(resp.body);

      ChallengeSelector.order = 1;

      List<Question> list = new List<Question>();
      for (var q in obj) {
        list.add(
            new Question(q["Question"], ("1".compareTo(q["TextAnswer"])) == 0));
        print(q.toString());
      }

      return list;
    }

    Future setFinished() async{
      var client = HttpClient(context: LoginScreen.sec_context);
      client.badCertificateCallback = (X509Certificate cert, String host, int port)=> true;

      // The rest of this code comes from your question.
      var uri = "https://tlfbermuda.com/setpaid.php";

      const Base64Codec base64 = Base64Codec(); const Latin1Codec latin1 = Latin1Codec();
      var appKey = '['+ChallengeSelector.challengeN.toString()+','+LoginScreen.account_id+',2]';
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
                          height: MediaQuery.of(context).size.height * .045,
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
                          height: MediaQuery.of(context).size.height * .1,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal:
                              MediaQuery.of(context).size.width * .06),
                          child: Text(
                            'By clicking "Next" you consent to your credit '
                                'card stored on file being charged ' +
                                price +
                                ' dollars and understand that there is a chance '
                                    'you may not receive a reward.',
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
                          height: MediaQuery.of(context).size.height * .2,
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
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => QuestionScreen(
                                          questions: snapshot.data)),
                                );
                              },
                              minWidth: 200.0,
                              height: 42.0,
                              child: Text(
                                'Next',
                                style: TextStyle(
                                  fontSize:
                                  .05 * MediaQuery.of(context).size.width,
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

  static Future setPaidState(int state) async{
    var client = HttpClient(context: LoginScreen.sec_context);
    client.badCertificateCallback = (X509Certificate cert, String host, int port)=> true;

    // The rest of this code comes from your question.
    var uri = "https://tlfbermuda.com/setpaid.php";

    const Base64Codec base64 = Base64Codec(); const Latin1Codec latin1 = Latin1Codec();
    print(state.toString());
    var appKey = '['+ChallengeSelector.challengeN.toString()+','+LoginScreen.account_id+','+state.toString()+']';
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
