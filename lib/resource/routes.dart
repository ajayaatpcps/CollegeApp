import 'package:flutter/material.dart';
import 'package:lbef/resource/routes_name.dart';
import 'package:lbef/screen/auth/login_page.dart';
import 'package:lbef/screen/auth/unauthorised.dart';
import 'package:lbef/screen/flash_screen.dart';
import 'package:lbef/screen/navbar/student_navbar.dart';
import 'package:lbef/widgets/no_internet_wrapper.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutesName.flash:
        return MaterialPageRoute(
          builder: (BuildContext context) => const FlashScreen(),
        );

      case RoutesName.login:
        return MaterialPageRoute(
          builder: (BuildContext context) => const LoginPage(),
        );

      case RoutesName.student:
        return MaterialPageRoute(
            builder: (BuildContext context) => const NoInternetWrapper(
                  child: StudentNavbar(index: 0),
                ));
      case RoutesName.unauthorised:
        return MaterialPageRoute(
          builder: (BuildContext context) => const UnauthorisedPage(),
        );
      default:
        return MaterialPageRoute(
          builder: (BuildContext context) => const UnauthorisedPage(),
        );
    }
  }
}
