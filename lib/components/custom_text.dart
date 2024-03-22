import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  CustomText(
      {super.key,
      required this.text,
      required this.color,
      required this.fsize,
      required this.fweight});

  String text;
  Color color;
  double fsize;
  FontWeight fweight;

  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: TextStyle(color: color, fontSize: fsize, fontWeight: fweight));
  }
}
