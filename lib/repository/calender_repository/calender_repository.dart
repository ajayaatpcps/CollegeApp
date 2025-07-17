import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:lbef/data/network/NetworkApiService.dart';
import 'package:lbef/endpoints/notice_board_endpoints.dart';
import 'package:lbef/model/event_model.dart';
import 'package:logger/logger.dart';
import '../../data/api_exception.dart';
import '../../utils/utils.dart';

class CalendarRepository {
  final NetworkApiService _apiServices = NetworkApiService();
  final Logger _logger = Logger();

  Future<Map<String, dynamic>> fetchEventCalendar({
    required String filter,
    required String date,
    String? type,
    required BuildContext context,
  }) async {
    _logger.d('Fetching events with filter=$filter, date=$date, type=$type');

    try {
      final Map<String, String> params = {
        'p1': filter,
        'p2': date,
      };
      if (type != null && type.isNotEmpty) {
        params['p3'] = type;
      }
      final encoded = base64Encode(utf8.encode(jsonEncode(params)));
      final endpoint = '${NoticeBoardEndpoints.fetchEvent}/$encoded';
      _logger.d('GET $endpoint');
      final response = await _apiServices.getApiResponse(endpoint);
      if (response is List) {
        final calendar = response
            .map((e) => EventModel.fromJson(e as Map<String, dynamic>))
            .toList();
        return {'calendar': calendar};
      } else {
        throw Exception('Unexpected response format: $response');
      }
    } on TimeoutException {
      Utils.noInternet('No internet connection. Please try again later.');
      throw Exception("No internet connection");
    } catch (error, stack) {
      if (error is NoDataException ) {
        _logger.w("404 Error: $error");
        return {};
      }
      _logger.w('Error fetching calendar', error: error, stackTrace: stack);
      Utils.flushBarErrorMessage('$error', context);
      throw Exception("No internet connection");
    }
  }
  Future<Map<String, dynamic>> fetchDayWise({
    required String filter,
    required String date,
    String? type,
    required BuildContext context,
  }) async {
    _logger.d('Fetching events with filter=$filter, date=$date, type=$type');

    try {
      final Map<String, String> params = {
        'p1': filter,
        'p2': date,
      };
      if (type != null && type.isNotEmpty) {
        params['p3'] = type;
      }
      final encoded = base64Encode(utf8.encode(jsonEncode(params)));
      final endpoint = '${NoticeBoardEndpoints.fetchEvent}/$encoded';
      _logger.d('GET $endpoint');
      final response = await _apiServices.getApiResponse(endpoint);
      if (response is List) {
        final calendar = response
            .map((e) => EventModel.fromJson(e as Map<String, dynamic>))
            .toList();
        return {'calendar': calendar};
      } else {
        throw Exception('Unexpected response format: $response');
      }
    } on TimeoutException {
      Utils.noInternet('No internet connection. Please try again later.');
      throw Exception("No internet connection");
    } catch (error, stack) {
      if (error is NoDataException ) {
        _logger.w("404 Error: $error");
        return {};
      }
      _logger.w('Error fetching calendar', error: error, stackTrace: stack);
      Utils.flushBarErrorMessage('$error', context);
      throw Exception("No internet connection");
    }
  }

  Future<EventModel> eventModel(String eventId, BuildContext context) async {
    try {
      final params = {"p1": eventId};
      final encodedParams = base64Encode(utf8.encode(jsonEncode(params)));
      final endpoint = "${NoticeBoardEndpoints.fetchEvent}/$encodedParams";
      if (kDebugMode) {
        _logger.d(endpoint);
      }
      dynamic response = await _apiServices.getApiResponse(endpoint);
      EventModel reportDetails = EventModel.fromJson(response);
      _logger.d("Application Details details: $reportDetails");
      return reportDetails;
    } on TimeoutException {
      Utils.noInternet("No internet connection. Please try again later.");
      throw Exception("No internet connection");
    } catch (error) {

      _logger.w(error);
      Utils.flushBarErrorMessage("$error", context);
      throw Exception("Error : $error ");
    }
  }
}
