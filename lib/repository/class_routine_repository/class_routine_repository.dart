import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:lbef/data/network/NetworkApiService.dart';
import 'package:lbef/endpoints/routine_endpoints.dart';
import 'package:lbef/model/routine_model.dart';
import 'package:logger/logger.dart';
import '../../data/api_exception.dart';
import '../../utils/utils.dart';

class ClassRoutineRepository {
  final NetworkApiService _apiServices = NetworkApiService();
  var logger = Logger();
  Future<RoutineModel> fetchClassRoutine(BuildContext context) async {
    if (kDebugMode) {
      logger.d(RoutineEndpoints.getRoutine);
    }
    try {
      dynamic response =
          await _apiServices.getApiResponse(RoutineEndpoints.getRoutine);
      RoutineModel routineData = RoutineModel.fromJson(response);
      logger.d("Report details: $routineData");
      return routineData;
    } on TimeoutException {
      return Utils.noInternet(
          "No internet connection. Please try again later.");
    } catch (error) {
      if (error is NoDataException) {
        logger.w("404 Error: $error");
        throw Exception("Error : $error ");
      }
      logger.w(error);
      return Utils.flushBarErrorMessage("$error", context);
    }
  }
}
