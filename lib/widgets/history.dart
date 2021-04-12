import 'package:flutter/material.dart';
import 'package:marketer_jr/models/actionHistory.dart';

class History extends StatefulWidget {
  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
          child: Container(
        width: double.infinity,
        height: 200,
        padding: EdgeInsets.all(10),
        child: ListView.builder(itemBuilder: (context, index) {
          return ListTile(title: FittedBox(child: Text(ActionHistory.getActionFromIndex(ActionHistory.getLength() - (index + 1)).getAction())),);
          }, itemCount: ActionHistory.getLength(),),
      ),),
    );
  }
}
