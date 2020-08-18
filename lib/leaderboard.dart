import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kirk_app/style_constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:kirk_app/challenge_selector.dart';

class Person{
  String name;
  int score;

  Person(name, score){
    this.name=name;
    this.score=score;
  }
}



class LeaderBoard extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    Future<List<Person>> getLeaderboard(int i) async{
      var resp = await http.get("http://www.tlfbermuda.com/getleaderboard.php?challenge="+i.toString());
      List<Person> list = new List<Person>();
      print(resp.body);
      for(var p in json.decode(resp.body)){
        list.add(new Person(p["TeamName"], int.parse(p["Score"])));
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
      body: FutureBuilder(
        future: getLeaderboard(ChallengeSelector.challengeN),
    builder: (BuildContext context, AsyncSnapshot snapshot) {
    if (snapshot.data == null) {
    return Container(child: Center(child: Text("Loading")));
    } else {
      return Column(children: <Widget>[
    Flexible(
            child: ListView.separated(
          itemCount: snapshot.data.length,
          separatorBuilder: (context, int index) => Divider(
            height: 32,
            color: Colors.orange[900],
          ),
          itemBuilder: (context, int index) {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: InkWell(
                child: RichText(
                  text: TextSpan(
                    children: [
                      WidgetSpan(
                        child: Icon(
                          Icons.person,
                          color: Colors.orange[900],
                        ),
                      ),
                      TextSpan(
                        text: ' ${snapshot.data[index]} ',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontFamily: font,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
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
      ]);}},
    ));
  }
}
