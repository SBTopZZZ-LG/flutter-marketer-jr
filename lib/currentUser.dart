class CurrentUser {
  static String _userId = "user123";
  static String _deviceId = "device123";
  static num _availableBalance = 50000;

  static String getUserId() {
    return _userId;
  }

  static String getDeviceId() {
    return _deviceId;
  }

  static num getAvailableBalance() {
    return _availableBalance;
  }

  static void addBalance(num delta) {
    _availableBalance += delta;
  }

  static void subtractBalance(num delta) {
    if (delta <= _availableBalance) _availableBalance -= delta;
  }

  static Map toJson() => {
        "_userId": _userId,
        "_deviceId": _deviceId,
        "_availableBalance": _availableBalance,
      };

  static void loadFromJson(Map json) {
    _userId = json["_userId"];
    _deviceId = json["_deviceId"];
    _availableBalance = json["_availableBalance"];
  }
}
