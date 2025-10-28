import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lbef/repository/notice_board/notice_board_repository.dart';

class BannerViewModel with ChangeNotifier {
  final NoticeBoardRepository _myrepo = NoticeBoardRepository();
  final List<String> _banner = [];
  List<String>? get banner => _banner;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void setLoading(bool value) {
    _isLoading = value;
    Future.microtask(() => notifyListeners());
  }

  Future<void> fetch(BuildContext context) async {
    if (_isLoading) return;
    setLoading(true);
    try {
      final Map<String, dynamic> response = await _myrepo.fetchEmails(context);
      _banner.addAll(response['banner']);
      notifyListeners();
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
    } finally {
      setLoading(false);
    }
  }
}
