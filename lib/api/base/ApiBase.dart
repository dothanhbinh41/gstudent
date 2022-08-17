import 'dart:convert';

import 'package:http/http.dart';

const String apiUrl = 'socket.edutalk.edu.vn';
// const String apiUrl = 'staging-game.edutalk.edu.vn';
// const String apiUrl = 'beta-game.edutalk.edu.vn';
// const String base = 'beta.api-app.edutalk.edu.vn';
const String base = 'api-app.edutalk.edu.vn';

Future<Response> httpFullPost(String path, String token, dto) {
  return post(Uri.http(apiUrl, path),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        // ignore: unnecessary_brace_in_string_interps
        'Authorization': 'Bearer ${token}'
      },
      body: jsonEncode(dto));
}

Future<Response> httpFullPostQueryParams(
    String path, String token, dto, queryParameters) {
  return post(Uri.http(apiUrl, path, queryParameters),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        // ignore: unnecessary_brace_in_string_interps
        'Authorization': 'Bearer ${token}'
      },
      body: jsonEncode(dto));
}

Future<Response> httpFullPostFormDaa(String path, String token, dto) {
  return post(Uri.http(apiUrl, path),
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
        // ignore: unnecessary_brace_in_string_interps
        'Authorization': 'Bearer ${token}'
      },
      body: dto);
}

Future<Response> httpPostFormData(String path, String token, dto) {
  return post(Uri.http(apiUrl, path),
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
        // ignore: unnecessary_brace_in_string_interps
        'Authorization': 'Bearer ${token}'
      },
      body: dto);
}

Future<Response> httpPost(String path, dto) {
  return post(Uri.http(apiUrl, path),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(dto));
}

Future<Response> httpHeadersPost(String path, String token, dto) {
  return post(Uri.http(apiUrl, path),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer {$token}'
      },
      body: jsonEncode(dto));
}

Future<Response> httpHeaderPost(
    String path, dto, Map<String, String> sheaders) {
  sheaders.addEntries([
    MapEntry('Content-Type', 'application/json; charset=UTF-8'),
    MapEntry('Origin', 'edutalk.edu.vn'),
    MapEntry('Access-Control-Allow-Origin', 'edutalk.edu.vn'),
  ]);
  return post(Uri.http(apiUrl, path), headers: sheaders, body: jsonEncode(dto));
}

Future<Response> httpGet(String path, dto) {
  return get(Uri.http(apiUrl, path), headers: <String, String>{
    'Content-Type': 'application/json; charset=UTF-8'
  });
}

Future<Response> httpFullGet(
    String path, Map<String, dynamic> queryParameters, String token) {
  return get(Uri.http(apiUrl, path, queryParameters), headers: <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
    // ignore: unnecessary_brace_in_string_interps
    'Authorization': 'Bearer ${token}'
  });
}

Future<Response> httpGetSingle(String path) {
  return get(Uri.http(apiUrl, path), headers: <String, String>{
    'Content-Type': 'application/json; charset=UTF-8'
  });
}

Future<Response> httpHeaderGet(String path, String token) {
  return get(Uri.http(apiUrl, path), headers: <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
    'Authorization': 'Bearer $token'
  });
}

Future<Response> httpFullPut(String path, queryParameters, String token) {
  return put(Uri.http(apiUrl, path),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        // ignore: unnecessary_brace_in_string_interps
        'Authorization': 'Bearer ${token}',
      },
      body: jsonEncode(queryParameters));
}
