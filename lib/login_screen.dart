import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kirk_app/account_screen.dart';
import 'package:kirk_app/instructions.dart';
import 'package:kirk_app/style_constants.dart';
import 'package:encrypt/encrypt.dart' as Enc;
import 'storage.dart';
import 'dart:convert';
import 'dart:io';

import 'forgot_pass_screen.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';
  static String teamname;
  static String account_id;
  static SecurityContext sec_context;

  @override
  _LoginScreenState createState() => _LoginScreenState();

  static Future<bool> loginAccount(BuildContext buildContext, String user, String pass, bool quick, bool relog) async {

    LoginScreen.sec_context = SecurityContext.defaultContext;

    ByteData file = await rootBundle.load('cert/WebCertificate.pem');
    if (false)
      LoginScreen.sec_context
          .setTrustedCertificatesBytes(file.buffer.asUint8List()); //ca.crt

    file = await rootBundle.load('cert/UserCertificate.pem');
    LoginScreen.sec_context
        .useCertificateChainBytes(file.buffer.asUint8List()); //client.crt

    file = await rootBundle.load('cert/PrivateKey.pem');
    LoginScreen.sec_context.usePrivateKeyBytes(file.buffer.asUint8List(),
        password: 'PinkForLife'); //client.key
    var client = HttpClient(context: LoginScreen.sec_context);
    client.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    // The rest of this code comes from your question.
    var uri = "https://tlfbermuda.com/login.php";
    const Latin1Codec latin1 = Latin1Codec();
    var appKey = '["' + user + '","' + pass + '"]';
    //var bytes = latin1.encode(appKey);
    //appKey = base64.encode(bytes);
    var method = 'GET';
    var request = await client.openUrl(method, Uri.parse(uri));
    request.headers.contentLength = 0;
    request.headers.set(HttpHeaders.authorizationHeader, appKey);
    //request.write(data);
    var response = await request.close();
    var textBack = new List<int>();
    textBack.addAll(await response.first);
    var success = latin1.decode(textBack);
    print(success);
    if (success.indexOf("0") == 0 && !quick) {
      _showMyDialog(buildContext);
      return Future(() => false);
    }if(success.compareTo("0") == 0){
      print('2');
      return Future(() => false);
    } else if ( !relog ) {
      print('3');
      var udata = jsonDecode(latin1.decode(textBack));
      print(udata);
      LoginScreen.account_id = udata[0];
      Navigator.of(buildContext).push(MaterialPageRoute(builder: (context) {
        Storage.storeUser(user, pass, udata[2], udata[3], user, udata[4], udata[5]);
        return Instructions();
      }));
      return Future(() => true);
    }else{
      print('4');
      var udata = jsonDecode(utf8.decode(textBack));
      LoginScreen.account_id = udata[0];
      print(udata[2]);
      Storage.storeUser(user, pass, udata[2], udata[3], user, udata[4], udata[5]);
    }
  }

  static Future<void> _showMyDialog(BuildContext context) async {
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

}

class _LoginScreenState extends State<LoginScreen> {
  final emailTextController = TextEditingController();
  final passWordTextController = TextEditingController();

  String teamname = '';
  String pass = '';

  @override
  Widget build(BuildContext context) {


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
                    height: MediaQuery.of(context).size.height * .09,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * .06),
                    child: Text(
                      'Island Hunt',
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
                    height: MediaQuery.of(context).size.height * .10,
                  ),
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: 0.0),
                      child: TextField(
                        style: TextStyle(
                          fontSize: 18,
                            color: Colors.black,
                            height: MediaQuery.of(context).size.width * .004),
                        controller: emailTextController,
                        onChanged: (value) {
                          teamname = value;
                        },
                        decoration: InputDecoration(
                          hintText: "Enter your team name",
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
                        style: TextStyle(
                          fontSize: 18,
                            color: Colors.black,
                            height: MediaQuery.of(context).size.width * .004),
                        obscureText: true,
                        controller: passWordTextController,
                        onChanged: (value) {
                          pass = value;
                        },
                        decoration: InputDecoration(
                          hintText: "Enter password",
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
                    height: MediaQuery.of(context).size.height * .09,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 0.0),
                    child: Material(
                      elevation: 5.0,
                      color: Colors.blue[1000],
                      borderRadius: BorderRadius.circular(60.0),
                      child: MaterialButton(
                        onPressed: () {
                          LoginScreen.loginAccount(context, teamname, pass, false, false);
                        },
                        minWidth: MediaQuery.of(context).size.width * .5,
                        height: MediaQuery.of(context).size.height * .05,
                        child: Text(
                          'Login',
                          style: TextStyle(
                            fontSize: .06 * MediaQuery.of(context).size.width,
                            fontFamily: font,
                            color: Colors.red[200],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * .018,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 0.0),
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
                        minWidth: MediaQuery.of(context).size.width * .5,
                        height: MediaQuery.of(context).size.height * .05,
                        child: Text(
                          'Register',
                          style: TextStyle(
                            fontSize: .06 * MediaQuery.of(context).size.width,
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
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 0.0),
                    child: Material(
                      elevation: 5.0,
                      color: Colors.blue[1000],
                      borderRadius: BorderRadius.circular(60.0),
                      child: MaterialButton(
                        onPressed: () {
                          Navigator.pushNamed(context, ForgotPassScreen.id);
                        },
                        minWidth: MediaQuery.of(context).size.width * .5,
                        height: MediaQuery.of(context).size.height * .05,
                        child: Text(
                          'Forgot My Password',
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
