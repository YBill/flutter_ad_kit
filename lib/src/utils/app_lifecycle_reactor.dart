import 'package:google_mobile_ads/google_mobile_ads.dart';

/// Listens for app foreground events.
class AppLifecycleReactor {
  AppLifecycleReactor();

  void listenToAppStateChanges(Function(bool isForeground) callback) {
    AppStateEventNotifier.startListening();
    AppStateEventNotifier.appStateStream.forEach((state) {
      _onAppStateChanged(state, callback);
    });
  }

  void _onAppStateChanged(AppState appState, Function(bool isForeground) callback) {
    callback(appState == AppState.foreground);
  }
}
