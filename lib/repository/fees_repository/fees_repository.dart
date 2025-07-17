import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:lbef/data/network/NetworkApiService.dart';
import 'package:lbef/endpoints/fees_endpoints.dart';
import 'package:lbef/model/fee_model.dart';
import 'package:logger/logger.dart';
import '../../data/api_exception.dart';
import '../../utils/utils.dart';

class FeesRepository {
  final NetworkApiService _apiServices = NetworkApiService();
  var logger = Logger();
  Future<FeeModel> feeDetails(
       BuildContext context) async {
    try {
      dynamic response =
          await _apiServices.getApiResponse(FeesEndpoints.getFee);
      logger.d( response);
      FeeModel reportDetails = FeeModel.fromJson(response);
      // logger.d("Fee Details details: $reportDetails");
      return reportDetails;
    } on TimeoutException {
      Utils.noInternet("No internet connection. Please try again later.");
      throw Exception("No internet connection");
    } catch (error) {
      logger.w(error);
      if (error is NoDataException) {
        logger.w("404 Error: $error");
        return Utils.flushBarNOdata("$error", context);
      }
      Utils.flushBarErrorMessage("$error", context);
      throw Exception("Error : $error ");
    }
  }
}
