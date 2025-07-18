import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:lbef/data/network/NetworkApiService.dart';
import 'package:lbef/endpoints/notice_board_endpoints.dart';
import 'package:lbef/model/email_notice_model.dart';
import 'package:lbef/model/notice_model.dart';
import 'package:lbef/model/sms_model.dart';
import 'package:logger/logger.dart';
import '../../data/api_exception.dart';
import '../../utils/utils.dart';

class NoticeBoardRepository {
  final NetworkApiService _apiServices = NetworkApiService();
  var logger = Logger();

  Future<NoticeModel> applicationDetails(
      String applicationId, BuildContext context) async {
    try {
      final params = {"p1": applicationId};
      final encodedParams = base64Encode(utf8.encode(jsonEncode(params)));
      final endpoint = "${NoticeBoardEndpoints.fetch}/$encodedParams";
      if (kDebugMode) {
        logger.d(endpoint);
      }
      dynamic response = await _apiServices.getApiResponse(endpoint);
      NoticeModel reportDetails = NoticeModel.fromJson(response);
      logger.d("Application Details details: $reportDetails");
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

  Future<Map<String, dynamic>> fetchnotices(BuildContext context) async {
    if (kDebugMode) {
      logger.d(NoticeBoardEndpoints.fetch);
    }
    try {
      dynamic response =
          await _apiServices.getApiResponse(NoticeBoardEndpoints.fetch);
      if (response is List) {
        //todo change the model over herr
        List<NoticeModel> notices =
            response.map((e) => NoticeModel.fromJson(e)).toList();
        logger.d("notices List $notices");
        return {"notices": notices};
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

  Future<EmailNoticeModel> emailDetails(
      String emailId, BuildContext context) async {
    try {
      final params = {"p1": emailId};
      final encodedParams = base64Encode(utf8.encode(jsonEncode(params)));
      final endpoint = "${NoticeBoardEndpoints.fetchEmail}/$encodedParams";
      if (kDebugMode) {
        logger.d(endpoint);
      }
      dynamic response = await _apiServices.getApiResponse(endpoint);
      EmailNoticeModel reportDetails = EmailNoticeModel.fromJson(response);
      logger.d("Application Details details: $reportDetails");
      return reportDetails;
    } on TimeoutException {
      Utils.noInternet("No internet connection. Please try again later.");
      throw Exception("No internet connection");
    } catch (error) {
      logger.w(error);
      if (error is NoDataException) {
        logger.w("404 Error: $error");
        throw Exception("Error : $error ");
      }
      Utils.flushBarErrorMessage("$error", context);
      throw Exception("Error : $error ");
    }
  }

  Future<Map<String, dynamic>> fetchEmails(BuildContext context) async {
    if (kDebugMode) {
      logger.d(NoticeBoardEndpoints.fetch);
    }
    try {
      dynamic response =
          await _apiServices.getApiResponse(NoticeBoardEndpoints.fetchEmail);
      if (response is List) {
        //todo change the model over herr
        List<EmailNoticeModel> notices =
            response.map((e) => EmailNoticeModel.fromJson(e)).toList();
        logger.d("notices List $notices");
        return {"notices": notices};
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

  Future<Map<String, dynamic>> fetchSms(BuildContext context) async {
    if (kDebugMode) {
      logger.d(NoticeBoardEndpoints.fetchSms);
    }
    try {
      dynamic response =
          await _apiServices.getApiResponse(NoticeBoardEndpoints.fetchSms);
      if (response is List) {
        //todo change the model over herr
        List<SmsModel> notices =
            response.map((e) => SmsModel.fromJson(e)).toList();
        logger.d("notices List $notices");
        return {"notices": notices};
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
