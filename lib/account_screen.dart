import 'dart:convert';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kirk_app/account_finished.dart';
import 'package:kirk_app/challenge_selector.dart';
import 'package:kirk_app/instructions.dart';
import 'package:kirk_app/login_screen.dart';
import 'package:kirk_app/style_constants.dart';
import 'dart:io';
import 'package:url_launcher/url_launcher.dart';

class Account {
  String first;
  String last;
  String team_name;
  String email;
  String password;
  String tel;
  String credit;
  String expMon;
  String expYear;
  String CVV;

  Account(this.first, this.last, this.team_name, this.email, this.password,
      this.tel, this.credit, this.expMon, this.expYear, this.CVV);
}

class CreateAccountScreen extends StatefulWidget {
  static const String id = 'create_account';

  @override
  _CreateAccountScreenState createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final firstNameTextController = TextEditingController();
  final lastNameTextController = TextEditingController();
  final telTextController = TextEditingController();
  final eMailTextController = TextEditingController();
  final teamNameTextController = TextEditingController();
  final cardNumberTextController = TextEditingController();
  final expMonthTextController = TextEditingController();
  final expYearTextController = TextEditingController();
  final cvvTextController = TextEditingController();
  final passTextController = TextEditingController();
  final vPassTextController = TextEditingController();

  String teamName = '';
  String eMail = '';
  String tel = '';
  String cardNumber = '';
  String firstName = '';
  String lastName = '';
  String expMonth = '';
  String expYear = '';
  String cvv = '';
  String pass = '';
  String vPass = '';

  bool errorFree = false;
  bool checkedValue = false;

  @override
  Widget build(BuildContext context) {
    Future<String> registerAccount(BuildContext buildContext, Account account) async {
      SecurityContext context = SecurityContext.defaultContext;

      ByteData file = await rootBundle.load('cert/WebCertificate.pem');
      if (false)
        context.setTrustedCertificatesBytes(file.buffer.asUint8List()); //ca.crt

      file = await rootBundle.load('cert/UserCertificate.pem');
      context.useCertificateChainBytes(file.buffer.asUint8List()); //client.crt

      file = await rootBundle.load('cert/PrivateKey.pem');
      context.usePrivateKeyBytes(file.buffer.asUint8List(),
          password: 'PinkForLife'); //client.key

      var client = HttpClient(context: context);
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;

      // The rest of this code comes from your question.
      var uri = "https://tlfbermuda.com/register.php";

      const Base64Codec base64 = Base64Codec();
      const Latin1Codec latin1 = Latin1Codec();
      var appKey = '["' +
          account.first +
          '","' +
          account.last +
          '","' +
          account.team_name +
          '","' +
          account.password +
          '","' +
          account.email +
          '","' +
          account.tel +
          '"]';
      //var bytes = latin1.encode(appKey);
      //appKey = base64.encode(bytes);
      var method = 'POST';

      var request = await client.openUrl(method, Uri.parse(uri));
      request.headers.contentLength = 0;
      request.headers.set(HttpHeaders.authorizationHeader,
          base64.encode(latin1.encode(appKey)));
      //request.write(data);
      var response = await request.close();
      var textBack = new List<int>();
      textBack.addAll(await response.first);
      while (textBack.length % 4 != 0) {
        textBack.add(0);
      }
      var resp = latin1.decode(textBack);
      return Future(() => resp);
    }

    Future<void> _showMyDialog(String s) async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Something Wrong'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(s),
                  Text('\nPlease try again'),
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

    _launchURL() async {
      const url = 'https://wwsl.dev/agiftforagape.dev/foh-privacy-policy/';
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
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
          horizontal: 0.0,
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
                    horizontal: MediaQuery.of(context).size.width * .04),
                child: Text(
                  'Create an Account',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: .065 * MediaQuery.of(context).size.width,
                    fontFamily: 'Carter One',
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * .03,
              ),
              Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * .04),
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                            child: TextField(
                          style: TextStyle(
                              color: Colors.black,
                              height: MediaQuery.of(context).size.width * .004),
                          controller: firstNameTextController,
                          onChanged: (value) {
                            firstName = value;
                          },
                          decoration: InputDecoration(
                            hintText: "First name",
                            hintStyle: TextStyle(color: Colors.black),
                            enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(width: 1.5),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(1.0))),
                          ),
                        )),
                        SizedBox(
                          width: 20,
                        ),
                        Expanded(
                            child: TextField(
                          style: TextStyle(
                              color: Colors.black,
                              height: MediaQuery.of(context).size.width * .004),
                          controller: lastNameTextController,
                          onChanged: (value) {
                            lastName = value;
                          },
                          decoration: InputDecoration(
                            hintText: "Last name",
                            hintStyle: TextStyle(color: Colors.black),
                            enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(width: 1.5),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(1.0))),
                          ),
                        )),
                      ])),
              SizedBox(
                height: MediaQuery.of(context).size.height * .02,
              ),
              Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * .04),
                  child: TextField(
                    style: TextStyle(
                        color: Colors.black,
                        height: MediaQuery.of(context).size.width * .004),
                    controller: teamNameTextController,
                    onChanged: (value) {
                      teamName = value;
                    },
                    decoration: InputDecoration(
                      hintText: "Team name",
                      hintStyle: TextStyle(
                        color: Colors.black,
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(width: 1.5),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(1.0))),
                    ),
                  )),
              SizedBox(
                height: MediaQuery.of(context).size.height * .02,
              ),
              Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * .04),
                  child: TextField(
                    style: TextStyle(
                        color: Colors.black,
                        height: MediaQuery.of(context).size.width * .004),
                    controller: eMailTextController,
                    onChanged: (value) {
                      eMail = value;
                    },
                    decoration: InputDecoration(
                      hintText: "Email",
                      hintStyle: TextStyle(color: Colors.black),
                      enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(width: 1.5),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(1.0))),
                    ),
                  )),
              SizedBox(
                height: MediaQuery.of(context).size.height * .02,
              ),
              Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * .04),
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                            child: TextField(
                          style: TextStyle(
                              color: Colors.black,
                              height: MediaQuery.of(context).size.width * .004),
                          obscureText: true,
                          controller: passTextController,
                          onChanged: (value) {
                            pass = value;
                          },
                          decoration: InputDecoration(
                            hintText: "Password",
                            hintStyle: TextStyle(color: Colors.black),
                            enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(width: 1.5),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(1.0))),
                          ),
                        )),
                        SizedBox(
                          width: 20,
                        ),
                        Expanded(
                            child: TextField(
                          style: TextStyle(
                              color: Colors.black,
                              height: MediaQuery.of(context).size.width * .004),
                          obscureText: true,
                          controller: vPassTextController,
                          onChanged: (value) {
                            vPass = value;
                          },
                          decoration: InputDecoration(
                            hintText: "Verify password",
                            hintStyle: TextStyle(color: Colors.black),
                            enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(width: 1.5),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(1.0))),
                          ),
                        )),
                      ])),
              SizedBox(
                height: MediaQuery.of(context).size.height * .02,
              ),
              Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * .04),
                  child: TextField(
                    style: TextStyle(
                        color: Colors.black,
                        height: MediaQuery.of(context).size.width * .004),
                    controller: telTextController,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      WhitelistingTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(10)
                    ],
                    onChanged: (value) {
                      tel = value;
                    },
                    decoration: InputDecoration(
                      hintText: "Phone Number: 441-123-4567",
                      hintStyle: TextStyle(color: Colors.black),
                      enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(width: 1.5),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(1.0))),
                    ),
                  )),
              SizedBox(
                height: MediaQuery.of(context).size.height * .02,
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 0.0),
                child: Material(
                  elevation: 5.0,
                  color: Colors.blue[1000],
                  borderRadius: BorderRadius.circular(50.0),
                  child: MaterialButton(
                    onPressed: () {
                      if (!(eMail.contains("@") && eMail.contains("."))){
                        _showMyDialog("Email is not valid");
                      }else if (tel.length < 10){
                        _showMyDialog("Phone number is not valid, must be 10 digits");
                      }else if(pass.compareTo(vPass) != 0){
                        _showMyDialog("Password and Verify Password do not match");
                      }else if(!checkedValue){
                        _showMyDialog("You must accept the privacy policy below");
                      }else{
                        registerAccount(
                            context,
                            new Account(firstName, lastName, teamName, eMail,
                                pass, tel, cardNumber, expMonth, expYear, cvv)).then((value) =>
                                value.indexOf("400") == 0 ?
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AccountFinised()))
                              : value.indexOf("200") == 0 ? _showMyDialog("Team name is already taken")
                              : value.indexOf("201") == 0 ? _showMyDialog("Email is already in use")
                              : value.indexOf("202") == 0 ? _showMyDialog("Phone number is already in use")
                              : _showMyDialog("Server Error "+value.toString())
                        );
                      }
                    },
                    minWidth: MediaQuery.of(context).size.width * .5,
                    height: MediaQuery.of(context).size.height * .05,
                    child: Text(
                      'Next',
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
                height: MediaQuery.of(context).size.height * .01,
              ),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 0.0),
                  child: Theme(
                      data: ThemeData(unselectedWidgetColor: Colors.red),
                      child: CheckboxListTile(
                        activeColor: Colors.green,
                        title: RichText(
                            text: TextSpan(children: [
                          TextSpan(
                              text:
                                  "By ticking this box you agree to have your credit card"
                                  "info securely stored by Island Hunt and agree to our ",
                              style: TextStyle(
                                fontSize: 15,
                                fontFamily: font,
                                color: Colors.black,
                              )),
                          TextSpan(
                            text: 'privacy policy',
                            style: TextStyle(
                              fontSize: 15,
                              fontFamily: font,
                              fontStyle: FontStyle.italic,
                              color: Colors.blue,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                _launchURL();
                              },
                          ),
                        ])),
                        value: checkedValue,
                        onChanged: (newValue) {
                          setState(() {
                            checkedValue = newValue;
                          });
                        },
                        controlAffinity: ListTileControlAffinity
                            .leading, //  <-- leading Checkbox
                      ))),
            ],
          ),
        ),
      ),
    );
  }
}
