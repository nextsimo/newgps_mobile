import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:newgps/src/models/account.dart';

class ApiService {
  final Client _client = Client();

  final String _baseUrl = 'https://api.newgps.ma/api';

  final Map<String, String> header = {
    'Content-Type': 'application/json',
    'Accept': 'application/json'
  };

  final Map<String, String> headerFile = {'Accept': 'application/json'};

  Future<Account?> login(
      {required String accountId, required String password}) async {
    Map<String, dynamic> body = {"accountId": accountId, "password": password};
    String res = await post(url: '/login', body: body);
    if (res.isEmpty) return null;
    Account? account = accountFromMap(res);
    return account;
  }

  Future<Account?> underAccountLogin(
      {required String accountId,
      required String password,
      required String underAccountLogin}) async {
    Map<String, dynamic> body = {
      "accountId": accountId,
      "password": password,
      "underAccount": underAccountLogin,
    };
    String res = await post(url: '/underlogin', body: body);
    if (res.isEmpty) return null;
    Account? account = accountFromMap(res);
    return account;
  }

  Future<String> post(
      {required String url,
      required Map<String, dynamic> body,
      Map<String, String> newHeader = const {}}) async {
    header.addAll(newHeader);

    try {
      Response response = await _client.post(Uri.parse(_baseUrl + url),
          body: json.encode(body), headers: header);

      debugPrint(_baseUrl + url);

      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint('$url succes');
        return response.body;
      }
      debugPrint('$url filed ${response.body}');
      return '';
    } catch (e) {
      debugPrint('$url failed $e');
      return '';
    }
  }

  Future<String> get(
      {required String url, Map<String, String> newHeader = const {}}) async {
    header.addAll(newHeader);

    try {
      Response response =
          await _client.get(Uri.parse(_baseUrl + url), headers: header);

      debugPrint(_baseUrl + url);

      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint('$url succes');
        return response.body;
      }
      debugPrint('$url filed ${response.body}');
      return '';
    } catch (e) {
      debugPrint('$url failed $e');
      return '';
    }
  }

  Future<Uint8List> postBytes(
      {required String url,
      required Map<String, dynamic> body,
      Map<String, String> newHeader = const {}}) async {
    try {
      Response response = await _client
          .post(Uri.parse(_baseUrl + url), body: json.encode(body), headers: {
        'Content-Type': 'application/octet-stream',
        'Accept': 'application/json',
      });

      log(_baseUrl + url);

      if (response.statusCode == 200) {
        log('$url succes');
        return response.bodyBytes;
      }
      return Uint8List(0);
    } catch (e) {
      debugPrint('$url failed $e');
      return Uint8List(0);
    }
  }

  Future<String> postFile(
      {required String url,
      required Map<String, dynamic> body,
      Map<String, String> newHeader = const {}}) async {
    headerFile.addAll(newHeader);

    try {
      Response response = await _client.post(Uri.parse(_baseUrl + url),
          body: json.encode(body), headers: headerFile);

      log(_baseUrl + url);

      if (response.statusCode == 200) {
        log('$url succes');
        return response.body;
      }
      log('$url filed ${response.body}');
      return '';
    } catch (e) {
      debugPrint('$url failed $e');
      return '';
    }
  }

  Future<String> simplePost(
      {required String url, required Map<String, dynamic> body}) async {
    try {
      Response response = await _client.post(
        Uri.parse(_baseUrl + url),
        body: json.encode(body),
        headers: header,
      );

      return response.body;
    } catch (e) {
      debugPrint('$url failed $e');
      return '';
    }
  }
}
