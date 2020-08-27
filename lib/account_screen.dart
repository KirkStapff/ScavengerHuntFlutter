import 'dart:convert';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    Future registerAccount(BuildContext buildContext, Account account) async {
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
          '","' +
          account.credit +
          '","' +
          account.CVV +
          '","' +
          account.expMon +
          '","' +
          account.expYear +
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
                height: MediaQuery.of(context).size.height * .015,
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
                            hintText: "Enter first name",
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
                            hintText: "Enter last name here",
                            hintStyle: TextStyle(color: Colors.black),
                            enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(width: 1.5),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(1.0))),
                          ),
                        )),
                      ])),
              SizedBox(
                height: MediaQuery.of(context).size.height * .01,
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
                      hintText: "Enter your team's name",
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
                height: MediaQuery.of(context).size.height * .01,
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
                      hintText: "Enter your email",
                      hintStyle: TextStyle(color: Colors.black),
                      enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(width: 1.5),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(1.0))),
                    ),
                  )),
              SizedBox(
                height: MediaQuery.of(context).size.height * .01,
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
                            hintText: "Enter password",
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
                            hintText: "Re-enter password",
                            hintStyle: TextStyle(color: Colors.black),
                            enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(width: 1.5),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(1.0))),
                          ),
                        )),
                      ])),
              SizedBox(
                height: MediaQuery.of(context).size.height * .01,
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
                      LengthLimitingTextInputFormatter(7)
                    ],
                    onChanged: (value) {
                      tel = value;
                    },
                    decoration: InputDecoration(
                      hintText: "Enter your phone #",
                      hintStyle: TextStyle(color: Colors.black),
                      enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(width: 1.5),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(1.0))),
                    ),
                  )),
              SizedBox(
                height: MediaQuery.of(context).size.height * .01,
              ),
              Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * .04),
                  child: TextField(
                    style: TextStyle(
                        color: Colors.black,
                        height: MediaQuery.of(context).size.width * .004),
                    controller: cardNumberTextController,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      WhitelistingTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(16)
                    ],
                    onChanged: (value) {
                      cardNumber = value;
                    },
                    decoration: InputDecoration(
                      hintText: "Enter your credit card number",
                      hintStyle: TextStyle(color: Colors.black),
                      enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(width: 1.5),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(1.0))),
                    ),
                  )),
              SizedBox(
                height: MediaQuery.of(context).size.height * .01,
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
                          controller: expMonthTextController,
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            WhitelistingTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(2)
                          ],
                          onChanged: (value) {
                            expMonth = value;
                          },
                          decoration: InputDecoration(
                            hintText: "Exp. Month",
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
                          controller: expYearTextController,
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            WhitelistingTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(2)
                          ],
                          onChanged: (value) {
                            expYear = value;
                          },
                          decoration: InputDecoration(
                            hintText: "Exp. Year",
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
                          controller: cvvTextController,
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            WhitelistingTextInputFormatter.digitsOnly,
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
                        )),
                      ])),
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
                      errorFree = (eMail.contains('@') &&
                          pass == vPass &&
                          tel.length == 7 &&
                          cardNumber.length == 16 &&
                          expMonth.length == 2 &&
                          expYear.length == 2 &&
                          cvv.length == 3);
                      if (errorFree && checkedValue) {
                        registerAccount(
                            context,
                            new Account(firstName, lastName, teamName, eMail,
                                pass, tel, cardNumber, expMonth, expYear, cvv));
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()),
                        );
                      } else {
                        _showMyDialog();
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
