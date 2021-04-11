import 'package:flutter/material.dart';

class History extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
          child: Container(
        width: double.infinity,
        height: 200,
        padding: EdgeInsets.all(15),
        child: Text(
          "History",
          textAlign: TextAlign.center,
        ),
      )),
    );
  }
}
