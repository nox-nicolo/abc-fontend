import 'dart:async';

import 'package:africa_beuty/core/constants/server_constants.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

enum NetworkConnectionState { online, offline, checking, recovered }

class NetworkStatusController extends ChangeNotifier {
  NetworkStatusController();

  static final NetworkStatusController instance = NetworkStatusController();

  NetworkConnectionState _state = NetworkConnectionState.online;
  Timer? _recoveredTimer;
  int _failureCount = 0;

  NetworkConnectionState get state => _state;
  bool get isOffline => _state == NetworkConnectionState.offline;
  bool get isChecking => _state == NetworkConnectionState.checking;
  bool get isRecovered => _state == NetworkConnectionState.recovered;

  void reportOnline() {
    _failureCount = 0;
    if (_state == NetworkConnectionState.online) return;
    _setState(NetworkConnectionState.recovered);
    _recoveredTimer?.cancel();
    _recoveredTimer = Timer(const Duration(seconds: 3), () {
      _setState(NetworkConnectionState.online);
    });
  }

  void reportOffline() {
    _failureCount += 1;
    if (_failureCount < 2 && _state == NetworkConnectionState.online) {
      return;
    }
    _recoveredTimer?.cancel();
    _setState(NetworkConnectionState.offline);
  }

  Future<bool> retry() async {
    _recoveredTimer?.cancel();
    _setState(NetworkConnectionState.checking);

    try {
      final uri = Uri.parse(ServerConstants.apiBaseUrl);
      final response = await http.head(uri).timeout(const Duration(seconds: 8));
      if (response.statusCode < 500) {
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
