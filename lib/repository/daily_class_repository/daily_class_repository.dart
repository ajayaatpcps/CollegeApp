import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:lbef/data/network/NetworkApiService.dart';
import 'package:lbef/endpoints/class_report_endpoints.dart';
import 'package:lbef/model/dcr_detail_model.dart';
import 'package:lbef/model/dcr_model.dart';
import 'package:logger/logger.dart';
import '../../data/api_exception.dart';
import '../../utils/utils.dart';

class DailyClassRepository {
  final NetworkApiService _apiServices = NetworkApiService();
  var logger = Logger();

  Future<Map<String, dynamic>> fetchDailyClassReport(
      BuildContext context) async {
    if (kDebugMode) {
      logger.d(ClassReportEndpoints.getDcr);
    }
    try {
      dynamic response =
          await _apiServices.getApiResponse(ClassReportEndpoints.getDcr);
      if (response is List) {
        List<DCRModel> classReport =
            response.map((e) => DCRModel.fromJson(e)).toList();
        logger.d("daily class report List $classReport");
        return {"classReport": classReport};
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

  Future<DCRDetailModel> reportDetails(
      String subjectId, String facultyId, BuildContext context) async {
    try {
      final params = {"p1": subjectId, "p2": facultyId};
      final encodedParams = base64Encode(utf8.encode(jsonEncode(params)));
      final endpoint = "${ClassReportEndpoints.getDcr}/$encodedParams";
      if (kDebugMode) {
        logger.d(endpoint);
      }
      dynamic response = await _apiServices.getApiResponse(endpoint);
      DCRDetailModel reportDetails = DCRDetailModel.fromJson(response);
      logger.d("Report details: $reportDetails");
      return reportDetails;
    } on TimeoutException {
      Utils.noInternet("No internet connection. Please try again later.");
      throw Exception("No internet connection");
    } catch (error) {
      if (error is NoDataException) {
        logger.w("404 Error: $error");
        throw Exception("Error : $error ");
      }
      logger.w(error);
      Utils.flushBarErrorMessage("$error", context);
      throw Exception("Error : $error ");
    }
  }
}
