class Investor {
  final String _userId;
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
}