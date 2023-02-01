import 'dart:convert';

import 'package:marketer_jr/models/investor.dart';

class Company {
  String _id;
  final String _name;
  int _nShares;
  num _marketPrice;
  num _lastMarketPrice;

  List<Investor> _investors = [];

  Company(this._id, this._name, this._nShares, this._marketPrice,
      this._lastMarketPrice, this._investors);

  String getId() {
    return _id;
  }

  String getName() {
    return _name;
  }

  int getShareCount() {
    return _nShares;
  }

  num getMarketPrice() {
    return _marketPrice;
  }

  num getLastMarketPrice() {
    return _lastMarketPrice;
  }

  void addInvestor(Investor investor) {
    _investors.add(investor);
  }

  void removeInvestorByIndex(int index) {
    if (index >= _investors.length || index < 0) return;

    _investors.removeAt(index);
  }

  void removeInvestorByObject(Investor investor) {
    if (!_investors.contains(investor)) return;

    _investors.remove(investor);
  }

  Investor getInvestorByUserId(String id) {
    for (Investor investor in _investors) {
      if (investor.getUserId() == id) return investor;
    }
    return null;
  }

  int getInvestorIndexByUserId(String id) {
    for (int i = 0; i < _investors.length; i++)
      if (_investors[i].getUserId() == id) return i;
    return -1;
  }

  List<Investor> getInvestorsList() {
    return _investors;
  }

  void deltaShares(int delta) {
    if (delta >= _nShares) return;

    this._nShares += delta;
  }

  void deltaMarketPrice(num delta) {
    if (this._marketPrice + delta <= 0) return;

    this._lastMarketPrice = this._marketPrice;
    this._marketPrice += delta;
  }

  Map toJson() => {
        "_id": _id,
        "_name": _name,
        "_nShares": _nShares,
        "_marketPrice": _marketPrice,
        "_lastMarketPrice": _lastMarketPrice,
        "_investors": _investors.map((Investor investor) {
          return jsonEncode(investor.toJson());
        }).toList(),
      };

  static Company fromJson(Map json) {
    return Company(
        json["_id"],
        json["_name"],
        json["_nShares"] as int,
        json["_marketPrice"] as num,
        json["_lastMarketPrice"] as num,
        (jsonDecode(json["_investors"].toString()) as List).map((obj) {
          print(obj["_nShares"].runtimeType.toString());
          Map map = obj as Map;
          return Investor(map["_userId"].toString(), map["_nShares"] as int);
        }).toList());
  }
}
