import 'package:marketer_jr/models/actionHistory.dart';
import 'package:marketer_jr/models/company.dart';
import 'package:marketer_jr/models/investment.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dart:convert';

import '../currentUser.dart';

void saveData(List<Investment> investments, List<Company> companies,
    List<ActionItem> history) {
  _save("investments", investments.map((Investment investment) {
    return jsonEncode(investment.toJson());
  }).toList());

  _save("companies", companies.map((Company company) {
  return jsonEncode(company.toJson());
  }).toList());

  _save("history", history.map((ActionItem actionItem) {
  return jsonEncode(actionItem.toJson());
  }).toList());

  _save("currentUser", [jsonEncode(CurrentUser.toJson())]);
}

void getData(Function callback) {
  _read("currentUser", (List<String> currentUserArray) {
    CurrentUser.loadFromJson(jsonDecode(currentUserArray[0]));
  });

  //Investments
  _read("investments", (List<String> investments) {
    //Companies
    _read("companies", (List<String> companies) {
        //History
        _read("history", (List<String> history) {
          callback(investments.map((String e) {
            return Investment.fromJson(jsonDecode(e) as Map<String, Object>);
          }).toList(), companies.map((String e) {
            return Company.fromJson(jsonDecode(e) as Map<String, Object>);
          }).toList(), history.map((String e) {
            return ActionItem.fromJson(jsonDecode(e) as Map<String, Object>);
          }).toList());
        });
      });
  });
}

Object _read(String key, Function callback) async {
  final prefs = await SharedPreferences.getInstance();
  final value = prefs.getStringList(key);
  callback(value);
}
_save(String key, List<String> value) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setStringList(key, value);
}