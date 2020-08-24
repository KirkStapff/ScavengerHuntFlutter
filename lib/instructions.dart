import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kirk_app/challenge_selector.dart';
import 'package:kirk_app/style_constants.dart';

class Instructions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("images/fullscreen.png"),
              fit: BoxFit.cover,
            )
        ),
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
                height: MediaQuery.of(context).size.height * .035,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * .06),
                child: Text(
                  'Instructions',
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
                height: MediaQuery.of(context).size.height * .03,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * .08),
                child: Text(
                  '1. Choose a challenge',
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
                height: MediaQuery.of(context).size.height * .03,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * .08),
                child: Text(
                  '2. Review the rewards and pay for the challenge '
                      'with your card on file',
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
                height: MediaQuery.of(context).size.height * .03,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * .08),
                child: Text(
                  '3. Using a phone with a working camera answer the questions',
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
                height: MediaQuery.of(context).size.height * .03,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * .08),
                child: Text(
                  '4. Stay with your team',
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
                height: MediaQuery.of(context).size.height * .03,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * .08),
                child: Text(
                  '5. The team who finishes fastest with the most correct answers'
                      ' wins',
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
                height: MediaQuery.of(context).size.height * .03,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * .08),
                child: Text(
                  'Be Safe!',
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
                height: MediaQuery.of(context).size.height * .01,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    vertical: MediaQuery.of(context).size.height * .02),
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
                    minWidth: MediaQuery.of(context).size.width * .5,
                    height: MediaQuery.of(context).size.height * .04,
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
            ],
          ),
        ),
      ),
    );
  }
}