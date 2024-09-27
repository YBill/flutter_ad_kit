class AdLog {
  static const String _TAG = 'AdLogs';

  static bool showLogs = false;

  static void enableLogger() {
    showLogs = true;
  }

  static void i(String msg) {
    if (!showLogs) return;
    print('$_TAG - $msg');
    // LogI(tag: _TAG, msg);
  }

  static void e(String msg) {
    if (!showLogs) return;
    print('$_TAG - $msg');
    // LogE(tag: _TAG, msg);
  }
}
