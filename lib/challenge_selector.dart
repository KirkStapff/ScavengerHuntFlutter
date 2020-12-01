import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kirk_app/instructions.dart';
import 'package:kirk_app/account_screen_edit.dart';
import 'package:kirk_app/style_constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:kirk_app/storage.dart';
import 'package:kirk_app/login_screen.dart';
import 'package:kirk_app/pay_screen.dart';

class Challenge {
  int id;
  String imageLink;
  DateTime start;
  DateTime end;
  String price = "25.0";
  String rewards = '';
  String title;

  Challenge(this.id, this.imageLink, this.price, this.rewards, this.title);

  String toString() {
    return (id.toString() + imageLink);
  }
}

class ChallengeSelector extends StatelessWidget {
  static int order = 1;
  static int challengeN = 1;
  static List<int> paidStatus = [0, 0, 0, 0];
  static String price = "0.0";

  Future<List<Challenge>> getChallenges() async {
    List<Challenge> list = new List<Challenge>();
    var resp = await http.get("http://tlfbermuda.com/getchallenges.php");
    for (var data in json.decode(resp.body)["result"]) {
      list.add(Challenge(
        int.parse(data["ID"]),
        data["ImageLink"],
        data["Price"],
        data["Rewards"],
        data["Title"]
      ));
      //print(data.toString());
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {

    void relog(BuildContext context) async{

      if(await Storage.getUser() != null) {
        await LoginScreen.loginAccount(context, await Storage.getUser(), await Storage.getPass(), true, true);
      }
    }

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
              horizontal: MediaQuery.of(context).size.width * .015,
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
                            SizedBox(
                              height: MediaQuery.of(context).size.height * .07,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal:
                                  MediaQuery.of(context).size.width * .2),
                              child: Text(
                                'Choose a Challenge Below',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: .06 * MediaQuery.of(context).size.width,
                                  height: 1.5,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                  fontFamily: font,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * .04,
                            ),
                            Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Expanded(
                                      child: InkWell(
                                        onTap: () {
                                          ChallengeSelector.challengeN = 1;
                                          ChallengeSelector.price = snapshot.data[0].price;
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => PayScreen(
                                                  price: snapshot.data[0].price,
                                                  reward:
                                                  snapshot.data[0].rewards,
                                                )),
                                          );
                                        },
                                        child: Column(children:[Image.network(
                                            snapshot.data[0].imageLink,
                                            width: 175,
                                            height: 200,
                                            fit: BoxFit.fill),
                                        ])
                                      )),
                                  Expanded(
                                      child: InkWell(
                                        onTap: () {
                                          ChallengeSelector.challengeN = 2;
                                          ChallengeSelector.price = snapshot.data[1].price;
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => PayScreen(
                                                  price: snapshot.data[1].price,
                                                  reward:
                                                  snapshot.data[1].rewards,
                                                )),
                                          );
                                        },
                                        child: Column(children:[
                                          Image.network(
                                            snapshot.data[1].imageLink,
                                            width: 175,
                                            height: 200,
                                            fit: BoxFit.fill),
                                        ])
                                      )),
                                ]),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * .017,
                            ),
                            Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Expanded(
                                      child: InkWell(
                                        onTap: () {
                                          ChallengeSelector.challengeN = 3;
                                          ChallengeSelector.price = snapshot.data[2].price;
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => PayScreen(
                                                  price: snapshot.data[2].price,
                                                  reward:
                                                  snapshot.data[2].rewards,
                                                )),
                                          );
                                        },
                                        child: Column(children:[Image.network(
                                            snapshot.data[2].imageLink,
                                            width: 175,
                                            height: 200,
                                            fit: BoxFit.fill),
                                        ])
                                      )),
                                  Expanded(
                                      child: InkWell(
                                        onTap: () {
                                          ChallengeSelector.challengeN = 4;
                                          ChallengeSelector.price = snapshot.data[3].price;
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => PayScreen(
                                                  price: snapshot.data[3].price,
                                                  reward:
                                                  snapshot.data[3].rewards,
                                                )),
                                          );
                                        },
                                        child: Column(children:[Image.network(
                                            snapshot.data[3].imageLink,
                                            width: 175,
                                            height: 200,
                                            fit: BoxFit.fill),
                                        ])
                                      )),
                                ]),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * .16,
                            ),
                            Align(
                                alignment: Alignment.bottomCenter,
                                child: Column(children: [
                                  Center(
                                    child:Row(children: <Widget>[
                                      Container(
                                        alignment: Alignment.centerLeft,
                                        child: Padding(
                                          padding: EdgeInsets.only(left:30),
                                          child:Material(
                                            elevation: 5.0,
                                            color: Colors.blue[1000],
                                            borderRadius: BorderRadius.circular(60.0),
                                            child: MaterialButton(
                                              onPressed: () {
                                                Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                                                  return Instructions();
                                                }));
                                              },
                                              minWidth: MediaQuery.of(context).size.width * .23,
                                              height: MediaQuery.of(context).size.height * .05,
                                              child: Text("Instructions",
                                                style: TextStyle(
                                                  fontSize: .05 * MediaQuery.of(context).size.width,
                                                  fontFamily: font,
                                                  color: Colors.red[200],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Divider(),
                                      ),
                                      Container(
                                          alignment: Alignment.centerRight,
                                          child: Padding(
                                            padding: EdgeInsets.only(right:30),
                                            child:Material(
                                              elevation: 5.0,
                                              color: Colors.blue[1000],
                                              borderRadius: BorderRadius.circular(60.0),
                                              child: MaterialButton(
                                                onPressed: () {
                                                  relog(context);
                                                  Navigator.of(context)
                                                      .push(MaterialPageRoute(builder: (context) {
                                                    return EditAccountScreen();
                                                  }));
                                                },
                                                minWidth: MediaQuery.of(context).size.width * .23,
                                                height: MediaQuery.of(context).size.height * .05,
                                                child: Text("My Account",
                                                  style: TextStyle(
                                                    fontSize: .05 * MediaQuery.of(context).size.width,
                                                    fontFamily: font,
                                                    color: Colors.red[200],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                      ),
                                    ]),
                                  ),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height * .02,
                                  ),
                                ],)),
                          ],
                        );
                      }
                    }))));
  }

  static Future<dynamic> getPaidState() async{
    var url = "http://www.tlfbermuda.com/getpaid.php?ID="+LoginScreen.account_id;
    var resp = await http.get(url);
    int i = 0;
    print(paidStatus[0]);
    for(var val in json.decode(resp.body)){
      paidStatus[i++] = val;
    }
    print("ching"+paidStatus[0].toString());
    return paidStatus;
  }
}
