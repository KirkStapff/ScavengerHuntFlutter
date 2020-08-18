import 'dart:convert';

class Question{
  String question;
  bool textAnswer;


  Question(String qu, bool an){
    this.question = qu;
    this.textAnswer = an;
  }
}