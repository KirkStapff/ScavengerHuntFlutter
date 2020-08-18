import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kirk_app/challenge_selector.dart';
import 'package:kirk_app/style_constants.dart';

class Instructions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
                height: 15,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 45.0),
                child: Text(
                  'Instructions',
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
                height: 20,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.0),
                child: Text(
                  '1. Fill out Payment Form',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.0,
                    height: 1.5,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                    fontFamily: font,
                  ),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.0),
                child: Text(
                  '2. Choose a Challenge',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.0,
                    height: 1.5,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                    fontFamily: font,
                  ),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.0),
                child: Text(
                  '3. Using a phone with a working camera answer the questions',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.0,
                    height: 1.5,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                    fontFamily: font,
                  ),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.0),
                child: Text(
                  '4. Stay with your team',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.0,
                    height: 1.5,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                    fontFamily: font,
                  ),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.0),
                child: Text(
                  '5. The team who finishes fastest with the most correct answers'
                  ' wins',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.0,
                    height: 1.5,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                    fontFamily: font,
                  ),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.0),
                child: Text(
                  'Be Safe!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.0,
                    height: 1.5,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                    fontFamily: font,
                  ),
                ),
              ),
              SizedBox(
                height: 30.0,
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
                        return ChallengeSelector();
                      }));
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
