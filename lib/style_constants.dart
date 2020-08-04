import 'package:flutter/material.dart';

const Color gradientStart = const Color(0xFFFFCC80);
const Color gradientEnd = const Color(0xFFEF6C00);

const iconSize = 30.0;
const radiusCircle = 32.0;
const font = 'Carter One';

const primaryGradients = BoxDecoration(
  gradient: LinearGradient(
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
    colors: [gradientStart, gradientEnd],
  ),
);

const textFieldDecoration = InputDecoration(
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  hintText: 'Type here...',
  hintStyle: TextStyle(color: Colors.black54),
  border: InputBorder.none,
);