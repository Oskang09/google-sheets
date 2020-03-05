import 'dart:convert';
import 'dart:io';

class DefaultClient extends RequestClient {
  HttpClient _client;
  DefaultClient() {
    _client = HttpClient();
  }

  @override
  Future<String> request(String method, String url) async {
    HttpClientRequest request = await _client.getUrl(Uri.parse(url));
    HttpClientResponse response = await request.close();
    Stream<String> stream = response.transform(utf8.decoder);
    StringBuffer buffer = StringBuffer();

    await stream.listen(buffer.write).asFuture();
    return buffer.toString();
  }
}

abstract class RequestClient {
  Future<String> request(String method, String url);
}
