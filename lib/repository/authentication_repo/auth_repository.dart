import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:logger/logger.dart';
import '../../data/api_exception.dart';
import '../../data/api_response.dart';
import '../../data/network/AuthNetworkService.dart';
import '../../data/network/BaseApiService.dart';
import '../../data/network/NetworkApiService.dart';
import '../../endpoints/auth_endpoints.dart';
import '../../endpoints/profile_endpoints.dart';
import '../../model/user_model.dart';
import '../../utils/utils.dart';

class AuthRepository {
  final BaseApiServices _apiServices2 = NetworkApiService();
  var logger = Logger();
  final AuthNetworkApiService _apiServices = AuthNetworkApiService();

  Future<dynamic> login(dynamic data, {BuildContext? context}) async {
    try {
      logger.d(AuthEndPoints.authUrl);
      dynamic response = await _apiServices.getPostResponse(AuthEndPoints.authUrl, data, context: context);
      return ApiResponse.completed(UserModel.fromJson(response));
    } on TimeoutException {
      Utils.noInternet("No internet connection. Please try again later.");
      return ApiResponse.error("No internet connection. Please try again later.");
    } catch (e) {
      return ApiResponse.error(" ${e.toString()}");
    }
  }
  Future<bool> recover(BuildContext context, dynamic body) async {
    var logger=Logger();
    try {

      logger.d('Changing password via ${ProfileEndpoints.recover}');
      final response = await _apiServices.getPostApiResponse(
        ProfileEndpoints.recover,body
      );
      if (response == null) {
        logger.w('No response from changePassword API');
        Utils.flushBarErrorMessage("No response from server", context);
        return false;
      }

      logger.d('Change password response: $response');
      if ( response.containsKey('message')) {
        Utils.flushBarSuccessMessage(response['message'], context);
        return true;
      } else {

        logger.w('Change password failed');
        return false;
      }
    } on TimeoutException {
      logger.e('Timeout: No internet connection for changing password');
      Utils.flushBarErrorMessage("No internet connection. Please try again later.", context);
      return false;
    } catch (e) {
      if (e is NoDataException) {
        logger.w("404 Error: $e");
         Utils.flushBarNOdata(e.toString(), context);
         return false;
      }
      logger.e('changePassword error: $e');
      Utils.flushBarErrorMessage(e.toString(), context);
      return false;
    }
  }
  Future<dynamic> logout() async {
    try {
      final response =
      await _apiServices2.getDeleteApiResponse(AuthEndPoints.logoutUrl);
      return ApiResponse.completed(UserModel.fromJson(response));
    } on TimeoutException {
      Utils.noInternet("No internet connection. Please try again later.");
      return ApiResponse.error("No internet connection. Please try again later.");
    } catch (e) {
      return ApiResponse.error(e.toString());
    }
  }
}