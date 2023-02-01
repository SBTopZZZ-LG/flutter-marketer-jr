class Investor {
  String _userId;
  int _nShares;

  Investor(this._userId, this._nShares);

  String getUserId() {
    return _userId;
  }

  int getNShares() {
    return _nShares;
  }

  void deltaShares(int delta) {
    _nShares += delta;
  }

  Map<String, Object> toJson() => {
        "_userId": _userId,
        "_nShares": _nShares,
      };

  static Investor fromJson(Map json) {
    print(json["_userId"]);
    print(int.parse(json["_nShares"]));
    return Investor(
        json["_userId"].toString(), int.parse(json["_nShares"].toString()));
  }
}
