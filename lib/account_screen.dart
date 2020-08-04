import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kirk_app/instructions.dart';
import 'package:kirk_app/style_constants.dart';

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
                height: 15,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.0),
                child: Text(
                  'Create an Account',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 25.0,
                    fontFamily: 'Carter One',
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                        child: TextField(
                          style: TextStyle(color: Colors.black),
                          controller: firstNameTextController,
                          onChanged: (value) {
                            firstName = value;
                          },
                          decoration: InputDecoration(
                            hintText: "Enter first name",
                            hintStyle: TextStyle(color: Colors.black),
                            enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(),
                                borderRadius:
                                const BorderRadius.all(Radius.circular(1.0))),
                          ),
                        )),
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                        child: TextField(
                          style: TextStyle(color: Colors.black),
                          controller: lastNameTextController,
                          onChanged: (value) {
                            lastName = value;
                          },
                          decoration: InputDecoration(
                            hintText: "Enter last name here",
                            hintStyle: TextStyle(color: Colors.black),
                            enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(),
                                borderRadius:
                                const BorderRadius.all(Radius.circular(1.0))),
                          ),
                        )),
                  ]),
              SizedBox(
                height: 20.0,
              ),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 0.0),
                  child: TextField(
                    style: TextStyle(color: Colors.black),
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
                          borderSide: const BorderSide(),
                          borderRadius:
                          const BorderRadius.all(Radius.circular(1.0))),
                    ),
                  )),
              SizedBox(
                height: 10.0,
              ),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 0.0),
                  child: TextField(
                    style: TextStyle(color: Colors.black),
                    controller: eMailTextController,
                    onChanged: (value) {
                      eMail = value;
                    },
                    decoration: InputDecoration(
                      hintText: "Enter your email",
                      hintStyle: TextStyle(color: Colors.black),
                      enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(),
                          borderRadius:
                          const BorderRadius.all(Radius.circular(1.0))),
                    ),
                  )),
              SizedBox(
                height: 10.0,
              ),
              Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                        child: TextField(
                          style: TextStyle(color: Colors.black),
                          obscureText: true,
                          controller: passTextController,
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
                        )),
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                        child: TextField(
                          style: TextStyle(color: Colors.black),
                          obscureText: true,
                          controller: vPassTextController,
                          onChanged: (value) {
                            vPass = value;
                          },
                          decoration: InputDecoration(
                            hintText: "Re-enter password",
                            hintStyle: TextStyle(color: Colors.black),
                            enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(),
                                borderRadius:
                                const BorderRadius.all(Radius.circular(1.0))),
                          ),
                        )),
                  ]),
              SizedBox(
                height: 10.0,
              ),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 0.0),
                  child: TextField(
                    style: TextStyle(color: Colors.black),
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
                          borderSide: const BorderSide(),
                          borderRadius:
                          const BorderRadius.all(Radius.circular(1.0))),
                    ),
                  )),
              SizedBox(
                height: 10.0,
              ),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 0.0),
                  child: TextField(
                    style: TextStyle(color: Colors.black),
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
                          borderSide: const BorderSide(),
                          borderRadius:
                          const BorderRadius.all(Radius.circular(1.0))),
                    ),
                  )),
              SizedBox(
                height: 10.0,
              ),
              Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                        child: TextField(
                          style: TextStyle(color: Colors.black),
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
                                borderSide: const BorderSide(),
                                borderRadius:
                                const BorderRadius.all(Radius.circular(1.0))),
                          ),
                        )),
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                        child: TextField(
                          style: TextStyle(color: Colors.black),
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
                                borderSide: const BorderSide(),
                                borderRadius:
                                const BorderRadius.all(Radius.circular(1.0))),
                          ),
                        )),
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                        child: TextField(
                          style: TextStyle(color: Colors.black),
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
                                borderSide: const BorderSide(),
                                borderRadius:
                                const BorderRadius.all(Radius.circular(1.0))),
                          ),
                        )),
                  ]),
              SizedBox(
                height: 10.0,
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Material(
                  elevation: 5.0,
                  color: Colors.blue[1000],
                  borderRadius: BorderRadius.circular(60.0),
                  child: MaterialButton(
                    onPressed: () {
                      errorFree = (eMail.contains('@') &&
                          pass == vPass &&
                          tel.length == 7 &&
                          cardNumber.length == 16 &&
                          expMonth.length == 2 &&
                          expYear.length == 2 &&
                          cvv.length == 3);

                      if (errorFree) {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) {
                          return Instructions();
                        }));
                      } else {
                        _showMyDialog();
                      }
                    },
                    minWidth: 200.0,
                    height: 42.0,
                    child: Text(
                      'Next',
                      style: TextStyle(
                        fontSize: 15,
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
      ),
    );
  }
}
