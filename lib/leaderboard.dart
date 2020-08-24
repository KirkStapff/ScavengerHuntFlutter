import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kirk_app/style_constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:kirk_app/challenge_selector.dart';
import 'package:kirk_app/login_screen.dart';
import 'dart:io';

class Person {
  String name;
  int score;
  int pos;

  Person(pos, name, score) {
    this.pos = pos;
    this.name = name;
    this.score = score;
  }
}

class LeaderBoard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future<List<Person>> getLeaderboard() async {
      var resp = await http.get(
          "http://www.tlfbermuda.com/getleaderboard.php?challenge=" +
              ChallengeSelector.challengeN.toString());
      List<Person> list = new List<Person>();
      print(resp.body);
      var i = 1;
      for (var p in json.decode(resp.body)) {
        list.add(new Person(i++, p["TeamName"], int.parse(p["Score"])));
      }
      return list;
    }

    return Scaffold(
        appBar: new AppBar(
          title: Text(
            'Leaderboard',
            style: TextStyle(
              fontFamily: font,
              fontSize: 26.0,
              color: Colors.white,
            ),
          ),
          elevation: 0.0,
        ),
        backgroundColor: Colors.white12,
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
            child: FutureBuilder(
              future: getLeaderboard(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.data == null) {
                  return Container(child: Center(child: Text("Loading")));
                } else {
                  return Column(children: <Widget>[
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .03,
                    ),
                    Flexible(
                        child: ListView.separated(
                      itemCount: snapshot.data.length,
                      separatorBuilder: (context, int index) => Divider(
                        height: MediaQuery.of(context).size.height * .05,
                        color: Colors.black,
                      ),
                      itemBuilder: (context, int index) {
                        return Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal:
                                  MediaQuery.of(context).size.width * .05),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              RichText(
                                  text: TextSpan(
                                text: ' ${snapshot.data[index].pos} ',
                                style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.width * .06,
                                  fontFamily: font,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                ),
                              )),
                              RichText(
                                  text: TextSpan(
                                text: ' ${snapshot.data[index].name} ',
                                style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.width * .06,
                                  fontFamily: font,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                ),
                              )),
                              RichText(
                                text: TextSpan(
                                    text: ' ${snapshot.data[index].score} ',
                                    style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              .06,
                                      fontFamily: font,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black,
                                    )),
                              ),
                            ],
                          ),
                        );
                      },
                    )),
//        Expanded(
//          child: Align(
//            alignment: FractionalOffset.bottomCenter,
//            child: Material(
//              elevation: 5.0,
//              color: Colors.blue[1000],
//              borderRadius: BorderRadius.circular(60.0),
//              child: MaterialButton(
//                onPressed: () {},
//                minWidth: 200.0,
//                height: 42.0,
//                child: Text(
//                  'Refresh',
//                  style: TextStyle(
//                    fontSize: 15,
//                    fontFamily: font,
//                    color: Colors.red[200],
//                  ),
//                ),
//              ),
//            ),
//          ),
//        ),
//        SizedBox(
//          height: 25.0,
//        ),
                  ]);
                }
              },
            )));
  }
}
