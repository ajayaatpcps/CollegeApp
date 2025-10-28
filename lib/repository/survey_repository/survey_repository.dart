import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:lbef/data/api_response.dart';
import 'package:lbef/data/network/NetworkApiService.dart';
import 'package:lbef/endpoints/survey_endpoints.dart';
import 'package:lbef/model/survey_model.dart';
import 'package:lbef/model/survey_question_model.dart';
import 'package:logger/logger.dart';
import '../../data/api_exception.dart';
import '../../utils/utils.dart';

class SurveyRepository {
  final NetworkApiService _apiServices = NetworkApiService();
  var logger = Logger();

  Future<SurveyQnaModel> details(
      String key, BuildContext context) async {
    try {

      final endpoint = "${SurveyEndpoints.fetch}/$key";
      if (kDebugMode) {
        logger.d(endpoint);
      }
      dynamic response = await _apiServices.getApiResponse(endpoint);
      SurveyQnaModel reportDetails = SurveyQnaModel.fromJson(response);
      logger.d("Survey Details details: $reportDetails");
      return reportDetails;
    } on TimeoutException {
      Utils.noInternet("No internet connection. Please try again later.");
      throw Exception("No internet connection");
    } catch (error) {
      logger.w(error);
      Utils.flushBarErrorMessage("$error", context);
      throw Exception("Error : $error ");
    }
  }
  Future<ApiResponse> create(
      dynamic data, BuildContext context) async {
    try {
      logger.d(SurveyEndpoints.create);
      final response = await _apiServices.getPostApiResponse(
        SurveyEndpoints.create,
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

  Future<Map<String, dynamic>> fetchSurvey(BuildContext context) async {
    try {
      dynamic response = await _apiServices.getApiResponse(SurveyEndpoints.fetch);

      List<SurveyModel> surveyList = [];

      if (response is List) {
        surveyList = response.map((e) => SurveyModel.fromJson(e)).toList();
      } else if (response is Map<String, dynamic>) {
        surveyList = [SurveyModel.fromJson(response)];
      } else {
        throw Exception("Unexpected response format: $response");
      }

      logger.d("survey List $surveyList");
      return {"survey": surveyList};
    } on TimeoutException {
      return Utils.noInternet("No internet connection. Please try again later.");
    } catch (error) {
      if (error is NoDataException) {
        logger.w("404 Error: $error");
        return {};
      }
      logger.w(error);
      Utils.flushBarErrorMessage("$error", context);
      return {};
    }
  }




}
