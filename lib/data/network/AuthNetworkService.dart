import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:logger/logger.dart';
import '../../model/user_model.dart';
import '../../utils/utils.dart';
import '../../view_model/user_view_model/user_view_model.dart';
import '../api_exception.dart';
import 'package:http/http.dart' as http;

class AuthNetworkApiService {
  Future<Map<String, String>> _getHeaders() async {
    final headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.acceptHeader: "application/json"
    };
    return headers;
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
  Future getPostResponse(String url, dynamic data,
      {BuildContext? context}) async {
    dynamic responseJson;
    try {
      var logger = Logger();
      final headers = await _getHeaders();
      final response = await http
          .post(
        Uri.parse(url),
        body: jsonEncode(data),
        headers: headers,
      )
          .timeout(const Duration(seconds: 10));
      final responseBody = jsonDecode(response.body);
      logger.d(responseBody);
      UserModel user = UserModel.fromJson(responseBody);
      await UserViewModel().saveUser(user);
      logger.d(user.token);
      responseJson = returnResponse(response, context: context);
    } on SocketException {
      throw FetchDataException("No Internet Connection");
    }
    return responseJson;
  }

  dynamic returnResponse(http.Response response, {BuildContext? context}) {
    final responseBody = jsonDecode(response.body);
    String errorMessage = "Something went wrong";
    var logger = Logger();
    logger.d(response.statusCode);

    if (responseBody is Map && responseBody.containsKey('err')) {
      errorMessage = responseBody['err'];
    } else if (responseBody is Map && responseBody.containsKey('message')) {
      errorMessage = responseBody['message'];
    }
    logger.d(errorMessage);
    switch (response.statusCode) {
      case 200:
        return responseBody;
      case 201:
        return responseBody;
      case 400:
        Utils.noInternet(errorMessage);
        throw BadRequestException(errorMessage);
      case 401:
        throw BadRequestException(errorMessage);
      case 402:
        throw UnAuthorizeException(errorMessage);
      case 403:
        throw FetchDataException(errorMessage);
      case 404:
        throw FetchDataException("Not Found: $errorMessage");
      case 500:
        throw FetchDataException("Internal Server Error: $errorMessage");
      default:
        if (context != null) {
          Utils.noInternet(errorMessage);
        }
        throw FetchDataException(
            'Error communicating with the server. Status code: ${response.statusCode}');
    }
  }
}
