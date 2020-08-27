import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kirk_app/forgot_pass_screen.dart';
import 'package:kirk_app/login_screen.dart';
import 'package:kirk_app/style_constants.dart';
import 'package:kirk_app/login_screen.dart';
import 'dart:convert';
import 'dart:io';

class ForgotPassScreen2 extends StatefulWidget {
  static const String id = 'forgot_pass_screen_2';

  @override
  _ForgotPassScreen2State createState() => _ForgotPassScreen2State();
}

class _ForgotPassScreen2State extends State<ForgotPassScreen2> {
  final codeTextController = TextEditingController();
  final passTextController = TextEditingController();
  final vPassTextController = TextEditingController();

  String code = '';
  String pass = '';
  String vPass = '';

  bool errorFree = false;

  @override
  Widget build(BuildContext context) {


    Future<void> _showMyDialog() async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Invalid Information'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(
                      "The code you entered is incorrect or your passwords don't match or are too short"),
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

    Future reset() async{
      var client = HttpClient(context: LoginScreen.sec_context);
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      // The rest of this code comes from your question.
      var uri = "https://tlfbermuda.com/resetpassword.php";
      const Latin1Codec latin1 = Latin1Codec();
      var appKey = '["'+ForgotPassScreen.eMail+'","'+pass+'"]';
      //var bytes = latin1.encode(appKey);
      //appKey = base64.encode(bytes);
      var method = 'GET';
      print(appKey);
      var request = await client.openUrl(method, Uri.parse(uri));
      request.headers.contentLength = 0;
      request.headers.set(HttpHeaders.authorizationHeader, appKey);
      //request.write(data);
      var response = await request.close();
      var textBack = new List<int>();
      textBack.addAll(await response.first);
      var success = utf8.decode(textBack);
      if (success.compareTo("0") == 0) {
        _showMyDialog();
        print(success);
      } else {
        print(success);
        Navigator.of(context).pushNamed(LoginScreen.id);
      }
    }

    return Scaffold(
        body: Container(
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
                        horizontal: MediaQuery.of(context).size.width * .06),
                    child: Text(
                      'Forgot My Password',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: .105 * MediaQuery.of(context).size.width,
                        fontFamily: 'Carter One',
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * .05,
                  ),
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: 0.0),
                      child: TextField(
                        style: TextStyle(
                            color: Colors.black,
                            height: MediaQuery.of(context).size.width * .004),
                        controller: codeTextController,
                        onChanged: (value) {
                          code = value;
                        },
                        decoration: InputDecoration(
                          hintText: "Enter the code sent to your email",
                          hintStyle: TextStyle(color: Colors.black),
                          enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(width: 1.5),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(1.0))),
                        ),
                      )),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * .03,
                  ),
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: 0.0),
                      child: TextField(
                        obscureText: true,
                        style: TextStyle(
                            color: Colors.black,
                            height: MediaQuery.of(context).size.width * .004),
                        controller: passTextController,
                        onChanged: (value) {
                          pass = value;
                        },
                        decoration: InputDecoration(
                          hintText: "Enter your new password",
                          hintStyle: TextStyle(color: Colors.black),
                          enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(width: 1.5),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(1.0))),
                        ),
                      )),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * .03,
                  ),
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: 0.0),
                      child: TextField(
                        obscureText: true,
                        style: TextStyle(
                            color: Colors.black,
                            height: MediaQuery.of(context).size.width * .004),
                        controller: vPassTextController,
                        onChanged: (value) {
                          vPass = value;
                        },
                        decoration: InputDecoration(
                          hintText: "Verify your new password",
                          hintStyle: TextStyle(color: Colors.black),
                          enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(width: 1.5),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(1.0))),
                        ),
                      )),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * .05,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 0.0),
                    child: Material(
                      elevation: 5.0,
                      color: Colors.blue[1000],
                      borderRadius: BorderRadius.circular(60.0),
                      child: MaterialButton(
                        onPressed: () {
                          errorFree = (pass.length > 3 && pass == vPass && ForgotPassScreen.code == code);
                          if (errorFree) {
                            reset();
                          } else {
                            _showMyDialog();
                          }
                        },
                        minWidth: MediaQuery.of(context).size.width * .5,
                        height: MediaQuery.of(context).size.height * .05,
                        child: Text(
                          'Submit',
                          style: TextStyle(
                            fontSize: .045 * MediaQuery.of(context).size.width,
                            fontFamily: font,
                            color: Colors.red[200],
                          ),
                        ),
                      ),
                    ),
                  ),
                ]))));
  }
}
