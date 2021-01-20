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

  static Future<List<Person>> getLeaderboard() async {
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
          child:Column(children : [
          SizedBox(
            height: MediaQuery.of(context).size.height * .05,
          ),
          Text("Leaderboard", style:TextStyle(fontSize: 32, color: Colors.black)),

            SizedBox(height:MediaQuery.of(context).size.height * .65,
                child:FutureBuilder(
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

              ]);
            }
          },
        ),
            ),


          SizedBox(
            height: MediaQuery.of(context).size.height * .03,
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
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                    return LeaderBoard();
                  }));
                },
                minWidth: MediaQuery.of(context).size.width * .5,
                height: MediaQuery.of(context).size.height * .05,
                child: Text(
                  'Refresh',
                  style: TextStyle(
                    fontSize: .045 * MediaQuery.of(context).size.width,
                    fontFamily: font,
                    color: Colors.red[200],
                  ),
                ),
              ),
            ),
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
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                      return ChallengeSelector();
                    }));
                  },
                  minWidth: MediaQuery.of(context).size.width * .5,
                  height: MediaQuery.of(context).size.height * .05,
                  child: Text(
                    'Done',
                    style: TextStyle(
                      fontSize: .045 * MediaQuery.of(context).size.width,
                      fontFamily: font,
                      color: Colors.red[200],
                    ),
                  ),
                ),
              ),
            ),
        ])
    ));
  }
}
