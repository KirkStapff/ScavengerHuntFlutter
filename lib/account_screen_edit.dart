import 'dart:convert';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kirk_app/account_screen.dart';
import 'package:kirk_app/storage.dart';
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

class EditAccountScreen extends StatefulWidget {
  static const String id = 'edit_account';

  @override
  _EditAccountScreenState createState() => _EditAccountScreenState();
}

class _EditAccountScreenState extends State<EditAccountScreen> {
  final passTextController = TextEditingController();
  bool change_tname = false;
  bool change_fname = false;
  bool change_lname = false;
  bool change_email = false;
  bool change_tel = false;
  bool change_card = false;
  bool change_expm = false;
  bool change_expy = false;

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

    change_tname = false;
    change_fname = false;
    change_lname = false;
    change_email = false;
    change_tel = false;
    change_card = false;
    change_expm = false;
    change_expy = false;

    Future editAccount(BuildContext buildContext, Account account) async {
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
      var uri = "https://tlfbermuda.com/editaccount.php";

      const Base64Codec base64 = Base64Codec();
      const Latin1Codec latin1 = Latin1Codec();
      var appKey = '["' +
          (change_fname ? 'FirstName='+account.first+ ',': "")+
          (change_lname ? 'LastName='+account.last+ ',': "")+
          (change_tname ? 'TeamName='+account.team_name+ ',': "")+
          (change_email ? 'Email='+account.email+ ',': "")+
          (change_tel ? 'Tel='+account.tel+ ',': "")+
          (change_card ? 'CardNumber='+account.credit+ ',': "")+
          (change_expm ? 'ExpMonth='+account.expMon+ ',': "")+
          (change_expy ? 'ExpYear='+account.expYear+ ',': "")+
          '","'+account.password+'","'+LoginScreen.account_id;
      appKey += '"]';
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

    Future<void> _showMyDialog(String alert) async {
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
                  Text('\n'+alert),
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
      body: FutureBuilder( future: Storage.getUserData(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
        if(snapshot.data == null)
          return Center(child:Text("Loading..."));
          return Container(
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
                      'Edit Your Account',
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
                                child: TextFormField(
                                  style: TextStyle(
                                      color: Colors.black,
                                      height: MediaQuery.of(context).size.width * .004),
                                  initialValue: snapshot.data[0],
                                  onChanged: (value) {
                                    firstName = value;
                                    change_fname = true;
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
                                child: TextFormField(
                                  style: TextStyle(
                                      color: Colors.black,
                                      height: MediaQuery.of(context).size.width * .004),
                                  initialValue: snapshot.data[1],
                                  onChanged: (value) {
                                    lastName = value;
                                    change_lname = true;
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
                      child: TextFormField(
                        style: TextStyle(
                            color: Colors.black,
                            height: MediaQuery.of(context).size.width * .004),
                        initialValue: snapshot.data[2],
                        onChanged: (value) {
                          teamName = value;
                          print(teamName);
                          change_tname = true;
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
                      child: TextFormField(
                        style: TextStyle(
                            color: Colors.black,
                            height: MediaQuery.of(context).size.width * .004),
                        initialValue: snapshot.data[3],
                        onChanged: (value) {
                          print(eMail);
                          eMail = value;
                          change_email = true;
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
                      child: TextFormField(
                        style: TextStyle(
                            color: Colors.black,
                            height: MediaQuery.of(context).size.width * .004),
                        initialValue: snapshot.data[4],
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          WhitelistingTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(7)
                        ],
                        onChanged: (value) {
                          tel = value;
                          change_tel = true;
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
                      child: TextFormField(
                        style: TextStyle(
                            color: Colors.black,
                            height: MediaQuery.of(context).size.width * .004),
                        initialValue: snapshot.data[5],
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          WhitelistingTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(16)
                        ],
                        onChanged: (value) {
                          cardNumber = value;
                          change_card = true;
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
                                child: TextFormField(
                                  style: TextStyle(
                                      color: Colors.black,
                                      height: MediaQuery.of(context).size.width * .004),
                                  initialValue: snapshot.data[6],
                                  keyboardType: TextInputType.number,
                                  inputFormatters: <TextInputFormatter>[
                                    WhitelistingTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(2)
                                  ],
                                  onChanged: (value) {
                                    expMonth = value;
                                    change_expm = true;
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
                                child: TextFormField(
                                  style: TextStyle(
                                      color: Colors.black,
                                      height: MediaQuery.of(context).size.width * .004),
                                  initialValue: snapshot.data[7],
                                  keyboardType: TextInputType.number,
                                  inputFormatters: <TextInputFormatter>[
                                    WhitelistingTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(2)
                                  ],
                                  onChanged: (value) {
                                    expYear = value;
                                    change_expy = true;
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

                          ])),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * .02,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * .04),
                    child: Expanded(
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
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * .03,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 0.0),
                    child: Material(
                      elevation: 5.0,
                      color: Colors.blue[1000],
                      borderRadius: BorderRadius.circular(50.0),
                      child: MaterialButton(
                        onPressed: () {
                          errorFree = ((eMail.contains('@')) &&
                              (tel.length == 7 || !change_tel) &&
                              (cardNumber.length == 16 || !change_card) &&
                              expMonth.length == 2  || !change_expm &&
                              expYear.length == 2  || !change_expy);
                          if (errorFree && pass == snapshot.data[8]) {
                            Storage.storeUser(change_tname ? teamName:snapshot.data[2], snapshot.data[8], change_fname? firstName:snapshot.data[0], change_lname? lastName:snapshot.data[1], change_tname ? teamName:snapshot.data[2], change_email ? eMail:snapshot.data[3], change_tel ? tel:snapshot.data[4], change_card ? cardNumber:snapshot.data[5], change_expm ? expMonth:snapshot.data[6], change_expy ? expYear:snapshot.data[7]);
                            editAccount(
                                context,
                                new Account(change_fname? firstName:snapshot.data[0], change_lname? lastName:snapshot.data[1], change_tname ? teamName:snapshot.data[2], change_email ? eMail:snapshot.data[3],
                                    snapshot.data[8], change_tel ? tel:snapshot.data[4], change_card ? cardNumber:snapshot.data[5], change_expm ? expMonth:snapshot.data[6], change_expy ? expYear:snapshot.data[7], cvv));
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ChallengeSelector()),
                            );

                          } else if (!change_email && !change_tel && !change_card && !change_expm && !change_expy) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ChallengeSelector()),
                            );
                          }else{
                            if(pass != snapshot.data[8])
                              _showMyDialog("Password is incorrect");
                            if(!eMail.contains('@'))
                              _showMyDialog("Please enter valid email");
                          }
                        },
                        minWidth: MediaQuery.of(context).size.width * .5,
                        height: MediaQuery.of(context).size.height * .05,
                        child: Text(
                          'Done',
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
                    height: MediaQuery.of(context).size.height * .03,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 0.0),
                    child: Material(
                      elevation: 5.0,
                      color: Colors.blue[1000],
                      borderRadius: BorderRadius.circular(50.0),
                      child: MaterialButton(
                        onPressed: () {
                          Storage.logoutUser();
                          Navigator.pushNamed(context, LoginScreen.id);
                        },
                        minWidth: MediaQuery.of(context).size.width * .5,
                        height: MediaQuery.of(context).size.height * .05,
                        child: Text(
                          'Logout',
                          style: TextStyle(
                            fontSize: .05 * MediaQuery.of(context).size.width,
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
      )

    );
  }
}
