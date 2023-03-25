import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class CommonLogo extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        // Image.network("https://pluspng.com/img-png/avengers-logo-png-avengers-logo-png-1376.png",width: 100,),
     Text(
  'Fuel Management System',
  style: TextStyle(
    color: const Color(0XFFF95A3B),
    fontSize: 32,
    fontStyle: FontStyle.italic,
    fontWeight: FontWeight.bold,
    letterSpacing: 1.5,
  ),
),
      Text(
  'Mobile Application',
  style: TextStyle(
    color: const Color(0XFFF95A3B),
    fontSize: 28,
    fontStyle: FontStyle.italic,
    fontWeight: FontWeight.bold,
    letterSpacing: 1.5,
  ),
),
      ],
    );
  }
}