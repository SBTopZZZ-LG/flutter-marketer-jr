class CurrentUser {
  static final String _userId = "user123";
  static final String _deviceId = "device123";
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
    if (delta <= _availableBalance)
      _availableBalance -= delta;
  }
}