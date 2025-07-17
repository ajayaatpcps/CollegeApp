import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:lbef/data/network/NetworkApiService.dart';
import 'package:lbef/endpoints/download_forms_endpoints.dart';
import 'package:lbef/model/downloadModel.dart';
import 'package:logger/logger.dart';
import '../../data/api_exception.dart';
import '../../utils/utils.dart';

class DownloadForumsRepository {
  final NetworkApiService _apiServices = NetworkApiService();
  var logger = Logger();
  Future<Map<String, dynamic>> getDocuments(BuildContext context) async {
    if (kDebugMode) {
      logger.d(DownloadFormsEndpoints.getForms);
    }
    try {
      dynamic response =
          await _apiServices.getApiResponse(DownloadFormsEndpoints.getForms);
      if (response is List) {
        List<DownloadModel> downloads =
            response.map((e) => DownloadModel.fromJson(e)).toList();
        logger.d("daily class report List $downloads");
        return {"downloads": downloads};
      } else {
        throw Exception("Unexpected response format: $response");
      }
    } on TimeoutException {
      return Utils.noInternet(
          "No internet connection. Please try again later.");
    } catch (error) {
      if (error is NoDataException) {
        logger.w("404 Error: $error");
        return Utils.flushBarNOdata("$error", context);

      }
      logger.w(error);
      return Utils.flushBarErrorMessage("$error", context);
    }
  }
}
