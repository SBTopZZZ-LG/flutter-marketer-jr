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
}