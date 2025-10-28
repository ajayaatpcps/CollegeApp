import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lbef/screen/auth/login_page.dart';
import 'package:logger/logger.dart';
import 'package:pdf/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../model/user_model.dart';

class UserViewModel with ChangeNotifier {
  Future<bool> saveUser(UserModel user) async {
    var logger = Logger();
    if (kDebugMode) {
      logger.d(user.token);
    }
    final SharedPreferences sp = await SharedPreferences.getInstance();
    bool sessionSaved = await sp.setString('token', user.token.toString());
    logger.d(sessionSaved);

    return sessionSaved;
  }
  Future<bool> saveWifiAccess(String access) async {
    var logger = Logger();
    final SharedPreferences sp = await SharedPreferences.getInstance();
    bool wifiAccess = await sp.setString('access', access.toString());
    logger.d(access.toString());
    return wifiAccess;
  }
  Future<bool> remove(BuildContext context) async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    await sp.remove('token');
    Navigator.of(context).pushAndRemoveUntil(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const LoginPage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;
          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);
          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
      ),
      (route) => false, // Remove all previous routes
    );
    notifyListeners();
    return true;
  }

  Future<bool> isAuthenticated() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getString('token') != null;
  }
}
