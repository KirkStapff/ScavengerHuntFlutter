import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kirk_app/question_screen.dart';
import 'package:kirk_app/style_constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:kirk_app/question_set.dart';
import 'package:kirk_app/pay_screen.dart';

class Challenge{
  int id;
  String imageLink;
  DateTime start;
  DateTime end;
  Challenge(this.id, this.imageLink);

  String toString(){
    return (id.toString() + imageLink);
  }
}

class ChallengeSelector extends StatelessWidget {

  static int order = 1;
  static int challengeN = 1;

  Future<List<Challenge>> getChallenges() async{
    List<Challenge> list = new List<Challenge>();
    var resp = await http.get("http://tlfbermuda.com/getchallenges.php");
    for(var data in json.decode(resp.body)["result"]){
      list.add(Challenge(int.parse(data["ID"]), data["ImageLink"]));
    }
    return list;
  }

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
                child: FutureBuilder(
                    future: getChallenges(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.data == null) {
                        return Container(child: Center(child: Text("Loading")));
                      } else {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              height: 15.0,
                              // ignore: missing_return
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
                                        onTap: () {
                                          ChallengeSelector.challengeN = 1;
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => PayScreen(challengeN: 1)),
                                          );
                                        },
                                        child: Image.network(snapshot.data[0].imageLink,
                                            width: 175, height: 200, fit: BoxFit.fill),
                                      )),
                                  Expanded(
                                      child: InkWell(
                                        onTap: () {
                                          ChallengeSelector.challengeN = 2;
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => PayScreen(challengeN: 2,)),
                                          );},
                                        child: Image.network(snapshot.data[1].imageLink,
                                            width: 175, height: 200, fit: BoxFit.fill),
                                      )),
                                ]),
                            Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Expanded(
                                      child: InkWell(
                                        onTap: () {
                                          ChallengeSelector.challengeN = 3;
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => PayScreen(challengeN: 3)),
                                          );
                                        },
                                        child: Image.network(snapshot.data[2].imageLink,
                                            width: 175, height: 200, fit: BoxFit.fill),
                                      )),
                                  Expanded(
                                      child: InkWell(
                                        onTap: () {
                                          ChallengeSelector.challengeN = 4;
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => PayScreen(challengeN: 4)),
                                          );
                                        },
                                        child: Image.network(snapshot.data[3].imageLink,
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
                        );
                      }
                    }
                )
            )
        )
    );
  }
}