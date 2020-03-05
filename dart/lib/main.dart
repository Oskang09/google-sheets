import 'dart:async';

import 'package:gstool/util.dart';

import 'client.dart';

class GoogleSheets<T> {
  String _url;
  RequestClient _client;
  bool _headerMode;
  Timer _timer;
  List<T> _values;

  List<T> get data => _values;
  String get _query => (_url.endsWith("/") ? "" : "/") + "export?format=csv";

  GoogleSheets(
    String url, {
    bool headerMode,
    Duration updateInterval,
    RequestClient client,
  }) {
    this._url = url;
    this._client = client;
    this._headerMode = headerMode;
    this._values = List();

    if (this._headerMode == null) {
      this._headerMode = false;
    }

    if (client == null) {
      this._client = DefaultClient();
    }

    if (updateInterval != null) {
      this._timer = Timer.periodic(updateInterval, this.update);
    }
  }

  Future<void> update(Timer timer) async {
    String response = await _client.request("GET", "$_url$_query");
    List<String> values = response.split("\r\n");
    List<String> headers = null;
    if (this._headerMode) {
      headers = values.first.split(",");
      values.removeAt(0);
    }
    this._values = applyValue<T>(values, headers);
  }

  void dispose() {
    if (this._timer != null) {
      this._timer.cancel();
    }
  }
}
