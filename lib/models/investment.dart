class Investment {
  final String _companyId;
  final String _userId;
  num _spentPrice;
  int _nShares;

  Investment(this._userId, this._companyId, this._spentPrice, this._nShares);

  String getCompanyId() {
    return _companyId;
  }

  String getUserId() {
    return _userId;
  }

  num getTotalAmount() {
    return _spentPrice;
  }

  int getShareCount() {
    return _nShares;
  }

  void deltaTotalAmount(num delta) {
    _spentPrice += delta;
  }

  void deltaShareCount(int delta) {
    _nShares += delta;
  }

  Map toJson() => {
        "_companyId": _companyId,
        "_userId": _userId,
        "_spentPrice": _spentPrice,
        "_nShares": _nShares,
      };

  static Investment fromJson(Map json) {
    return Investment(json["_userId"], json["_companyId"], json["_spentPrice"],
        json["_nShares"]);
  }
}
