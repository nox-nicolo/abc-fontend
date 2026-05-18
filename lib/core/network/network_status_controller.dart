import 'dart:async';

import 'package:africa_beuty/core/constants/server_constants.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

enum NetworkConnectionState {
  online,
  offline,
  serverUnreachable,
  checking,
  recovered,
}

class NetworkStatusController extends ChangeNotifier {
  NetworkStatusController({
    http.Client? client,
    Uri? serverProbeUri,
    Uri? internetProbeUri,
  }) : _client = client ?? http.Client(),
       _serverProbeUri =
           serverProbeUri ?? Uri.parse(ServerConstants.apiBaseUrl),
       _internetProbeUri = internetProbeUri ?? Uri.parse('https://example.com');

  static final NetworkStatusController instance = NetworkStatusController();

  final http.Client _client;
  final Uri _serverProbeUri;
  final Uri _internetProbeUri;
  NetworkConnectionState _state = NetworkConnectionState.online;
  Timer? _recoveredTimer;
  int _failureCount = 0;

  NetworkConnectionState get state => _state;
  bool get isOffline => _state == NetworkConnectionState.offline;
  bool get isServerUnreachable =>
      _state == NetworkConnectionState.serverUnreachable;
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
    _setState(NetworkConnectionState.serverUnreachable);
  }

  Future<bool> retry() async {
    _recoveredTimer?.cancel();
    _setState(NetworkConnectionState.checking);

    if (await _probe(_serverProbeUri)) {
      reportOnline();
      return true;
    }

    if (await _probe(_internetProbeUri)) {
      _failureCount = 0;
      _setState(NetworkConnectionState.serverUnreachable);
      return false;
    }

    _failureCount = 0;
    _setState(NetworkConnectionState.offline);
    return false;
  }

  Future<bool> _probe(Uri uri) async {
    try {
      final response = await _client
          .head(uri)
          .timeout(const Duration(seconds: 8));
      return response.statusCode < 500;
    } on Object {
      try {
        final response = await _client
            .get(uri)
            .timeout(const Duration(seconds: 8));
        return response.statusCode < 500;
      } on Object {
        return false;
      }
    }
  }

  void _setState(NetworkConnectionState value) {
    if (_state == value) return;
    _state = value;
    notifyListeners();
  }

  @override
  void dispose() {
    _recoveredTimer?.cancel();
    _client.close();
    super.dispose();
  }
}
