import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kirk_app/forgot_pass_2.dart';
import 'package:kirk_app/style_constants.dart';
import 'package:kirk_app/instructions.dart';
import 'package:kirk_app/login_screen.dart';
import 'dart:convert';
import 'dart:io';

class ForgotPassScreen extends StatefulWidget {
  static const String id = 'forgot_pass_screen';
  static String eMail = '';
  static String code = "";
  @override
  _ForgotPassScreenState createState() => _ForgotPassScreenState();
}

class _ForgotPassScreenState extends State<ForgotPassScreen> {
  final emailTextController = TextEditingController();
  final passWordTextController = TextEditingController();

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
                  Text('The email you entered does not exist in the database'),
                  Text('\nPlease review your input and try again.'),
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


    Future forgot() async{
      var client = HttpClient(context: LoginScreen.sec_context);
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      // The rest of this code comes from your question.
      var uri = "https://tlfbermuda.com/forgotpassword.php";
      const Latin1Codec latin1 = Latin1Codec();
      var appKey = ForgotPassScreen.eMail;
      //var bytes = latin1.encode(appKey);
      //appKey = base64.encode(bytes);
      var method = 'GET';
      print("1");
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
      } else {
        ForgotPassScreen.code = utf8.decode(textBack);
        print(ForgotPassScreen.code);
        Navigator.of(context).pushNamed(ForgotPassScreen2.id);
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
                        style: TextStyle(color: Colors.black),
                        controller: emailTextController,
                        onChanged: (value) {
                          ForgotPassScreen.eMail = value;
                        },
                        decoration: InputDecoration(
                          hintText: "Enter your email address",
                          hintStyle: TextStyle(
                              color: Colors.black,
                              height: MediaQuery.of(context).size.width * .004),
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
                          forgot();
                        },
                        minWidth: MediaQuery.of(context).size.width * .5,
                        height: MediaQuery.of(context).size.height * .05,
                        child: Text(
                          'Get Code',
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
