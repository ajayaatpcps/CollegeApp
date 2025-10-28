import 'package:flutter/material.dart';
import 'package:lbef/model/notice_model.dart';
import 'package:lbef/model/survey_model.dart';
import 'package:lbef/model/survey_question_model.dart';
import 'package:lbef/repository/notice_board/notice_board_repository.dart';
import 'package:lbef/repository/survey_repository/survey_repository.dart';
import 'package:logger/logger.dart';
import '../../data/api_response.dart';

class SurveryViewModel with ChangeNotifier {
  final SurveyRepository _myrepo = SurveyRepository();
  final List<SurveyModel> _notices = [];
  List<SurveyModel>? get notices => _notices;
  ApiResponse<SurveyQnaModel> userData = ApiResponse.loading();
  ApiResponse<SurveyQnaModel> appDetails = ApiResponse.loading();
  SurveyQnaModel? get currentDetails => appDetails.data;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void setDetails(ApiResponse<SurveyQnaModel> response) {
    _logger.i('Setting : ${response.status}');
    appDetails = response;
    notifyListeners();
  }

  final _logger = Logger();
  void setLoading(bool value) {
    _isLoading = value;
    Future.microtask(() => notifyListeners());
  }

  Future<void> fetch(BuildContext context) async {
    if (_isLoading) return;
    setLoading(true);
    try {
      _notices.clear();
      final Map<String, dynamic> response =
      await _myrepo.fetchSurvey(context);
      _notices.addAll(response['survey']);
      notifyListeners();
    } catch (error) {
      userData = ApiResponse.error("Unexpected error: $error");
    } finally {
      setLoading(false);
    }
  }

  Future<void> getSurveyDetails(
      String key, BuildContext context) async {
    if (_isLoading) {
      _logger.w('Fetch already in progress. Ignoring duplicate call.');
      return;
    }
    setLoading(true);
    try {
      final SurveyQnaModel dcr =
      await _myrepo.details(key, context);
      if (dcr != null) {
        _logger.i('DCR details fetched successfully');
        setDetails(ApiResponse.completed(dcr));
      } else {
        _logger.w('No DCR data available');
        setDetails(ApiResponse.error('No data available'));
      }
    } catch (error, stackTrace) {
      _logger.e('Error fetching DCR details',
          error: error, stackTrace: stackTrace);
      setDetails(ApiResponse.error('Error fetching data: $error'));
    } finally {
      setLoading(false);
    }
  }
  Future<bool> submit(dynamic data, BuildContext context) async {
    try {
      _logger.d(data);
      final response = await _myrepo.create(data, context);
      if (response != null) {
        notifyListeners();
        return true;
      } else {
        return false;
      }
    } catch (error) {
      return false;
    }
  }

}
