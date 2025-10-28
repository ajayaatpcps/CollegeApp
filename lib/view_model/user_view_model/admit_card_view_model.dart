import 'package:flutter/cupertino.dart';
import 'package:lbef/model/profile_model.dart';
import 'package:lbef/repository/profile_repository/profile_repository.dart';
import 'package:lbef/utils/utils.dart';
import 'package:lbef/view_model/user_view_model/user_view_model.dart';
import 'package:logger/logger.dart';
import '../../data/api_response.dart';
import '../../resource/routes_name.dart';

class AdmitCardViewModel with ChangeNotifier {
  final ProfileRepository _myRepo = ProfileRepository();
  ApiResponse<ProfileModel> userData = ApiResponse.loading();
  ProfileModel? get currentUser => userData.data;
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  void setLoading(bool value) {
    _isLoading = value;
    Future.microtask(() => notifyListeners());
  }

  void setUser(ApiResponse<ProfileModel> response) {
    userData = response;
    Future.microtask(() => notifyListeners());
  }

  final _logger = Logger();
  Future<void> getAdmitCard(BuildContext context) async {
    setLoading(true);
    setUser(ApiResponse.loading());
    try {
      ProfileModel? user = await _myRepo.getUser(context);
      if (user != null) {
        await UserViewModel().saveWifiAccess(user.stuWifiAccess??'');
        setUser(ApiResponse.completed(user));
      } else {
        _logger.w('getUser returned null');
        Utils.flushBarErrorMessage(
            'Failed to fetch user: No user data', context);
        setUser(ApiResponse.error('No user data'));
      }
    } catch (e) {
      _logger.e('getUser error: $e');
      if (e.toString().contains('Unauthorized') ||
          e.toString().contains('401')) {
        Navigator.pushReplacementNamed(context, RoutesName.login);
      }
      setUser(ApiResponse.error(e.toString()));
    } finally {
      setLoading(false);
    }
  }


}
