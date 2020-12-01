import 'dart:convert';

class Question{
  String question;
  bool textAnswer;
  bool tokenExpired;


  Question(String qu, bool an, bool te){
    this.question = qu;
    this.textAnswer = an;
    this.tokenExpired = te;
  }
}