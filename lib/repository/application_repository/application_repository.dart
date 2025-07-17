import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:lbef/data/network/NetworkApiService.dart';
import 'package:lbef/endpoints/application_endpoints.dart';
import 'package:lbef/model/application_model.dart';
import 'package:logger/logger.dart';
import '../../data/api_exception.dart';
import '../../data/api_response.dart';
import '../../utils/utils.dart';

class ApplicationRepository {
  final NetworkApiService _apiServices = NetworkApiService();
  var logger = Logger();
  Future<ApiResponse> createApplication(
      dynamic data, BuildContext context) async {
    try {
      logger.d(ApplicationEndpoints.application);
      final response = await _apiServices.getPostApiResponse(
        ApplicationEndpoints.application,
        data,
      );
      Utils.flushBarSuccessMessage(response['message'], context);
      return ApiResponse.completed(response);
    } on TimeoutException {
      return Utils.noInternet(
          "No internet connection. Please try again later.");
    } catch (e) {
      if (e is NoDataException) {
        logger.w("404 Error: $e");
        Utils.flushBarNOdata(e.toString(), context);
        return ApiResponse.error(e.toString());
      }
      logger.w(e);
      Utils.flushBarErrorMessage(e.toString(), context);
      return ApiResponse.error(e.toString());
    }
  }

  Future<ApplicationModel> applicationDetails(
      String applicationId, BuildContext context) async {
    try {
      final params = {"p1": applicationId};
      final encodedParams = base64Encode(utf8.encode(jsonEncode(params)));
      final endpoint = "${ApplicationEndpoints.application}/$encodedParams";
      if (kDebugMode) {
        logger.d(endpoint);
      }
      dynamic response = await _apiServices.getApiResponse(endpoint);
      ApplicationModel reportDetails = ApplicationModel.fromJson(response);
      logger.d("Application Details details: $reportDetails");
      return reportDetails;
    } on TimeoutException {
      Utils.noInternet("No internet connection. Please try again later.");
      throw Exception("No internet connection");
    } catch (error) {
      if (error is NoDataException) {
        logger.w("404 Error: $error");
        Utils.flushBarNOdata(error.toString(), context);
        throw Exception("Error : $error ");
      }
      logger.w(error);
      Utils.flushBarErrorMessage("$error", context);
      throw Exception("Error : $error ");
    }
  }

  Future<ApiResponse> updateApplication(
      dynamic data, BuildContext context) async {
    try {
      logger.d(ApplicationEndpoints.updateApplications);
      logger.d(data);
      final response = await _apiServices.getPutResponse(
        ApplicationEndpoints.updateApplications,
        data,
      );
      logger.d(response);
      Utils.flushBarSuccessMessage(response['message'], context);

      return ApiResponse.completed(response);
    } on TimeoutException {
      return Utils.noInternet(
          "No internet connection. Please try again later.");
    } catch (e) {
      if (e is NoDataException) {
        logger.w("404 Error: $e");
        Utils.flushBarNOdata(e.toString(), context);
        throw Exception("Error : $e ");
      }
      logger.w(e);
      Utils.flushBarErrorMessage(e.toString(), context);
      return ApiResponse.error(e.toString());
    }
  }

  Future<Map<String, dynamic>> fetchApplications(BuildContext context) async {
    if (kDebugMode) {
      logger.d(ApplicationEndpoints.application);
    }
    try {
      dynamic response =
          await _apiServices.getApiResponse(ApplicationEndpoints.application);
      if (response is List) {
        //todo change the model over herr
        List<ApplicationModel> applications =
            response.map((e) => ApplicationModel.fromJson(e)).toList();
        logger.d("applications List $applications");
        return {"applications": applications};
      } else {
        throw Exception("Unexpected response format: $response");
      }
    } on TimeoutException {
      return Utils.noInternet(
          "No internet connection. Please try again later.");
    } catch (error) {
      if (error is NoDataException) {
        logger.w("404 Error: $error");
        return {};
      }
      logger.w(error);
      return Utils.flushBarErrorMessage("$error", context);
    }
  }
}
