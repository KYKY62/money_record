import 'dart:convert';

import 'package:d_method/d_method.dart';
import 'package:http/http.dart' as http;

class AppRequest {
  static Future<Map?> gets(String url, {Map<String, String>? headers}) async {
    try {
      http.Response response = await http.get(Uri.parse(url), headers: headers);
      DMethod.printTitle('try - $url', response.body);
      Map responseBody = jsonDecode(response.body);
      return responseBody;
    } catch (e) {
      DMethod.printTitle('catch', e.toString());
      return null;
    }
  }

  static Future<Map?> post(String url, Object? body,
      {Map<String, String>? headers}) async {
    try {
      http.Response response = await http.post(
        Uri.parse(url),
        body: body,
        headers: headers,
      );
      DMethod.printTitle('try - $url', response.body);
      Map responseBody = jsonDecode(response.body);
      return responseBody;
    } catch (e) {
      DMethod.printTitle('catch', e.toString());
      return null;
    }
  }
}
