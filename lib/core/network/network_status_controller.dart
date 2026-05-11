import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';

enum NetworkConnectionState { online, offline, checking, recovered }

class NetworkStatusController extends ChangeNotifier {
  NetworkStatusController();

  static final NetworkStatusController instance = NetworkStatusController();

  NetworkConnectionState _state = NetworkConnectionState.online;
  Timer? _recoveredTimer;

  NetworkConnectionState get state => _state;
  bool get isOffline => _state == NetworkConnectionState.offline;
  bool get isChecking => _state == NetworkConnectionState.checking;
  bool get isRecovered => _state == NetworkConnectionState.recovered;

  void reportOnline() {
    if (_state == NetworkConnectionState.online) return;
    _setState(NetworkConnectionState.recovered);
    _recoveredTimer?.cancel();
    _recoveredTimer = Timer(const Duration(seconds: 3), () {
      _setState(NetworkConnectionState.online);
    });
  }

  void reportOffline() {
    _recoveredTimer?.cancel();
    _setState(NetworkConnectionState.offline);
  }

  Future<bool> retry() async {
    _recoveredTimer?.cancel();
    _setState(NetworkConnectionState.checking);

    try {
      final lookup = await InternetAddress.lookup(
        'example.com',
      ).timeout(const Duration(seconds: 5));
      final hasConnection =
          lookup.isNotEmpty && lookup.first.rawAddress.isNotEmpty;

      if (hasConnection) {
        reportOnline();
        return true;
      }
    } on Object {
      // Keep the UI in the offline state if the connectivity probe fails.
    }

    reportOffline();
    return false;
  }

  void _setState(NetworkConnectionState value) {
    if (_state == value) return;
    _state = value;
    notifyListeners();
  }

  @override
  void dispose() {
    _recoveredTimer?.cancel();
    super.dispose();
  }
}
