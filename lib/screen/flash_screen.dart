import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lbef/screen/auth/login_page.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/status.dart';
import '../resource/routes_name.dart';
import '../view_model/user_view_model/current_user_model.dart';
import '../widgets/no_internet_wrapper.dart';
import 'introduction_screen/introduction_screen.dart';
import 'navbar/student_navbar.dart';

class FlashScreen extends StatefulWidget {
  const FlashScreen({super.key});

  @override
  State<FlashScreen> createState() => _FlashScreenState();
}

class _FlashScreenState extends State<FlashScreen> {
  @override
  void initState() {
    super.initState();
    _startSplashScreen();
  }

  Future<void> _startSplashScreen() async {
    await Future.delayed(const Duration(seconds: 2));
    await _checkAuthentication();
  }

  Future<void> _checkAuthentication() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    final prefs = await SharedPreferences.getInstance();
    final String? session = sp.getString('token');

    var logger = Logger();
    logger.d(session);
    final bool hasSeenIntro = prefs.getBool('isIntroCollege') ?? false;
    if (!hasSeenIntro) {
      await prefs.setBool('hasSeenIntro', false);
    }
    if (hasSeenIntro == false) {
      Navigator.of(context).push(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const MyCollegeIntroScreen(),
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
      );
      return;
    }
    if (session != null) {
      final userDataViewModel =
          Provider.of<UserDataViewModel>(context, listen: false);
      await userDataViewModel.getUser(context);
      final user = userDataViewModel.currentUser;

      if (userDataViewModel.userData.status == Status.ERROR || user == null) {
        _navigateTo(const LoginPage());
      } else {
        _navigateTo(const StudentNavbar());
      }
    } else {
      _navigateTo(const LoginPage());
    }
  }

  void _navigateTo(Widget route) {
    // Future.microtask(() {
    //   Navigator.pushReplacementNamed(context, route);
    // });
    Navigator.of(context).pushAndRemoveUntil(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            NoInternetWrapper(child: route),
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
  }

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Center(
        child: Image.asset(
          'assets/images/pcpsLogo.png',
          height: 300,
        ),
      ),
    );
  }
}
