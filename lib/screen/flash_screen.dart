import 'dart:async';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/status.dart';
import '../resource/routes_name.dart';
import '../view_model/user_view_model/current_user_model.dart';

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
    final bool hasSeenIntro = prefs.getBool('isIntro') ?? false;
    final String? session = sp.getString('token');
    if (!hasSeenIntro) {
      await prefs.setBool('hasSeenIntro', false);
    }
    var logger = Logger();
    logger.d(session);
    // if(hasSeenIntro==false){
    //   Navigator.of(context).push(
    //     PageRouteBuilder(
    //       pageBuilder: (context, animation, secondaryAnimation) =>
    //       const LoginPage(),
    //       transitionsBuilder:
    //           (context, animation, secondaryAnimation, child) {
    //         const begin = Offset(1.0, 0.0);
    //         const end = Offset.zero;
    //         const curve = Curves.easeInOut;
    //         var tween =
    //         Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
    //         var offsetAnimation = animation.drive(tween);
    //         return SlideTransition(
    //           position: offsetAnimation,
    //           child: child,
    //         );
    //       },
    //     ),
    //   );
    //   return;
    // }
    if (session != null) {
      final userDataViewModel =
          Provider.of<UserDataViewModel>(context, listen: false);
      await userDataViewModel.getUser(context);
      final user = userDataViewModel.currentUser;

      if (userDataViewModel.userData.status == Status.ERROR || user == null) {
        _navigateTo(RoutesName.login);
      } else {
        _navigateTo(RoutesName.student);
      }
    } else {
      _navigateTo(RoutesName.login);
    }
  }

  void _navigateTo(String route) {
    Future.microtask(() {
      Navigator.pushReplacementNamed(context, route);
    });
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
