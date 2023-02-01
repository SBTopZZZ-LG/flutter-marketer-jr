import 'package:flutter/material.dart';

class Graph extends StatefulWidget {
  @override
  _GraphState createState() => _GraphState();
}

class _GraphState extends State<Graph> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        width: double.infinity,
        height: 200,
        padding: EdgeInsets.all(15),
        child: Text(
          "Graph",
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
