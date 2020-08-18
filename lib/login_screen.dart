import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kirk_app/account_screen.dart';
import 'package:kirk_app/instructions.dart';
import 'package:kirk_app/style_constants.dart';
import 'dart:convert';
import 'dart:io';

class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailTextController = TextEditingController();
  final passWordTextController = TextEditingController();

  String teamname = '';
  String pass = '';

  @override
  Widget build(BuildContext context) {
    Future loginAccount(BuildContext buildContext) async {

      SecurityContext context = SecurityContext.defaultContext;

      ByteData file = await rootBundle.load('cert/WebCertificate.pem');
      if(false)
        context.setTrustedCertificatesBytes(file.buffer.asUint8List()); //ca.crt

      file = await rootBundle.load('cert/UserCertificate.pem');
      context.useCertificateChainBytes(file.buffer.asUint8List());//client.crt

      file = await rootBundle.load('cert/PrivateKey.pem');
      context.usePrivateKeyBytes(file.buffer.asUint8List(), password:'PinkForLife');//client.key

      var client = HttpClient(context: context);
      client.badCertificateCallback = (X509Certificate cert, String host, int port)=> true;

      // The rest of this code comes from your question.
      var uri = "https://tlfbermuda.com/login.php";

      const Latin1Codec latin1 = Latin1Codec();
      var appKey = '["'+teamname+'","'+pass+'"]';
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
      while(textBack.length % 4 != 0){
        textBack.add(0);
      }
      print(latin1.decode(textBack));
    }

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
                  Text('Some of the information you input is invalid.'),
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
                        height: 65,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15.0),
                        child: Text(
                          'Login',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 45.0,
                            fontFamily: 'Carter One',
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 100,
                      ),
                      Padding(
                          padding: EdgeInsets.symmetric(horizontal: 0.0),
                          child: TextField(
                            style: TextStyle(color: Colors.black),
                            controller: emailTextController,
                            onChanged: (value) {
                              teamname = value;
                            },
                            decoration: InputDecoration(
                              hintText: "Enter your team name",
                              hintStyle: TextStyle(color: Colors.black),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(),
                                  borderRadius:
                                  const BorderRadius.all(Radius.circular(1.0))),
                            ),
                          )),
                      SizedBox(
                        height: 25,
                      ),
                      TextField(
                        style: TextStyle(color: Colors.black),
                        obscureText: true,
                        controller: passWordTextController,
                        onChanged: (value) {
                          pass = value;
                        },
                        decoration: InputDecoration(
                          hintText: "Enter password",
                          hintStyle: TextStyle(color: Colors.black),
                          enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(),
                              borderRadius:
                              const BorderRadius.all(Radius.circular(1.0))),
                        ),
                      ),
                      SizedBox(
                        height: 175,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                        child: Material(
                          elevation: 5.0,
                          color: Colors.blue[1000],
                          borderRadius: BorderRadius.circular(60.0),
                          child: MaterialButton(
                            onPressed: () {
                              loginAccount(context);
                              Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (context) {
                                return Instructions();
                              }));
                            },
                            minWidth: 200.0,
                            height: 42.0,
                            child: Text(
                              'Login',
                              style: TextStyle(
                                fontSize: 15,
                                fontFamily: font,
                                color: Colors.red[200],
                              ),
                            ),
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
                              Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (context) {
                                return CreateAccountScreen();
                              }));
                            },
                            minWidth: 200.0,
                            height: 42.0,
                            child: Text(
                              'Register',
                              style: TextStyle(
                                fontSize: 15,
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