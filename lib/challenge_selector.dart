import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kirk_app/style_constants.dart';

class ChallengeSelector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
                  height: 40,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 45.0),
                  child: Text(
                    'Island Hunt',
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
                Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                          child: InkWell(
                            onTap: () {},
                            child: Image.asset('images/imgph.png',
                                width: 175, height: 200, fit: BoxFit.fill),
                          )),
                      Expanded(
                          child: InkWell(
                            onTap: () {},
                            child: Image.asset('images/imgph.png',
                                width: 175, height: 200, fit: BoxFit.fill),
                          )),
                    ]),
                Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                          child: InkWell(
                            onTap: () {},
                            child: Image.asset('images/imgph.png',
                                width: 175, height: 200, fit: BoxFit.fill),
                          )),
                      Expanded(
                          child: InkWell(
                            onTap: () {},
                            child: Image.asset('images/imgph.png',
                                width: 175, height: 200, fit: BoxFit.fill),
                          )),
                    ]),
                SizedBox(
                  height: 40,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 60.0),
                  child: Text(
                    'Choose a Challenge Above',
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
              ],
            ),
          )),
    );
  }
}
