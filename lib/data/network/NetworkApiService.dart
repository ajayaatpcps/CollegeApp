import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/utils.dart';
import '../api_exception.dart';
import 'BaseApiService.dart';

class NetworkApiService extends BaseApiServices {
  Future<Map<String, String>> _getHeaders() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();

    final headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.acceptHeader: "application/json"
    };
    final String? session = sp.getString('token');
    if (kDebugMode) {
      print('Token: $session');
    }
    if (session != null && session.isNotEmpty) {
      headers['Authorization'] = 'Bearer $session';
    }
    return headers;
  }

  @override
  Future getPutResponse(String url, dynamic data) async {
    dynamic responseJson;
    try {
      final headers = await _getHeaders();

      if (kDebugMode) {
        print(data);
        print(url);
      }
      final response = await http
          .put(
            Uri.parse(url),
            body: jsonEncode(data),
            headers: headers,
          )
          .timeout(const Duration(seconds: 10));
      final responseBody = jsonDecode(response.body);
      if (kDebugMode) {
        print(responseBody);
      }
      if (responseBody.containsKey('error')) {
        if (kDebugMode) {
          print('Response Body Error: ${responseBody['error']}');
        }
      }
      responseJson = returnResponse(response);
    } on SocketException {
      Utils.noInternet('No internet connection');
      throw FetchDataException("No Internet Connection");
    }
    return responseJson;
  }

  @override
  Future getApiResponse(String url) async {
    final headers = await _getHeaders();
    dynamic responseJson;

    try {
      final response = await http
          .get(Uri.parse(url), headers: headers)
          .timeout(const Duration(seconds: 10));

      var logger = Logger();
      logger.d(url);
      logger.d("RAW RESPONSE: ${response.body}");

      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException("No internet Connection");
    }
    return responseJson;
  }

  dynamic _safeDecode(String raw) {
    final cleaned = raw.trim();

    // If already valid JSON
    if (cleaned.startsWith('{') || cleaned.startsWith('[')) {
      return jsonDecode(cleaned);
    }

    // Remove PHP warnings / HTML before JSON
    final objStart = cleaned.indexOf('{');
    final listStart = cleaned.indexOf('[');

    int start = -1;
    if (objStart == -1) {
      start = listStart;
    } else if (listStart == -1) {
      start = objStart;
    } else {
      start = objStart < listStart ? objStart : listStart;
    }

    if (start == -1) {
      throw FetchDataException("Invalid server response");
    }

    final jsonPart = cleaned.substring(start);
    return jsonDecode(jsonPart);
  }

  @override
  Future<dynamic> getDeleteApiResponse(String url) async {
    dynamic responseJson;
    try {
      final headers = await _getHeaders();
      final response = await http
          .delete(
            Uri.parse(url),
            headers: headers,
          )
          .timeout(const Duration(seconds: 10));

      if (kDebugMode) {
        print('Response Status Code: ${response.statusCode}');
      }

      if (response.statusCode == 204 || response.body.isEmpty) {
        if (kDebugMode) {
          print('Empty response body with Status Code: ${response.statusCode}');
        }
        return {
          'status': response.statusCode,
          'message': 'No content returned from server',
        };
      }

      final responseBody = jsonDecode(response.body);

      if (kDebugMode) {
        print('Response Body: $responseBody');
      }

      responseBody['status'] = response.statusCode;

      if (responseBody.containsKey('error') && responseBody['error'] == true) {
        if (kDebugMode) {
          print('Response Body Error: ${responseBody['error']}');
        }
      }

      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException("No Internet Connection");
    } catch (e) {
      if (kDebugMode) {
        print("Exception: $e");
      }
      throw FetchDataException("Error During Communication!!$e");
    }
    return responseJson;
  }

  @override
  Future getPostApiResponse(String url, dynamic body) async {
    final headers = await _getHeaders();
    dynamic responseJson;
    try {
      Response response = await http
          .post(Uri.parse(url), headers: headers, body: jsonEncode(body))
          .timeout(const Duration(seconds: 10));
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException("No internet Connection");
    }
    return responseJson;
  }

  dynamic returnResponse(http.Response response, {BuildContext? context}) {
    dynamic responseBody;

    try {
      responseBody = _safeDecode(response.body);
    } catch (e) {
      throw FetchDataException("Invalid response from server");
    }

    String errorMessage = "Something went wrong";

    if (responseBody is Map && responseBody.containsKey('err')) {
      errorMessage = responseBody['err'];
    } else if (responseBody is Map && responseBody.containsKey('message')) {
      errorMessage = responseBody['message'];
    }

    switch (response.statusCode) {
      case 200:
      case 201:
        return responseBody;

      case 400:
        throw BadRequestException(errorMessage);

      case 401:
        throw UnAuthorizeException(errorMessage);

      case 403:
        throw FetchDataException("Forbidden: $errorMessage");

      case 404:
        throw NoDataException(errorMessage);

      case 410:
      case 500:
        throw FetchDataException(errorMessage);

      default:
        throw FetchDataException(
            'Error communicating with server. Status: ${response.statusCode}');
    }
  }

  @override
  Future putUrlResponse(String url) async {
    final headers = await _getHeaders();

    dynamic responseJson;
    try {
      Response response = await http
          .put(Uri.parse(url), headers: headers)
          .timeout(const Duration(seconds: 10));
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException("No internet Connection");
    }
    return responseJson;
  }

  @override
  Future postUrlResponse(String url) async {
    final headers = await _getHeaders();

    dynamic responseJson;
    try {
      Response response = await http
          .post(Uri.parse(url), headers: headers)
          .timeout(const Duration(seconds: 10));
      print(response.body);
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException("No internet Connection");
    }
    return responseJson;
  }
}
