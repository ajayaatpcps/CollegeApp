import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../auth/login_page.dart';

class MyCollegeIntroScreen extends StatefulWidget {
  const MyCollegeIntroScreen({super.key});

  @override
  State<MyCollegeIntroScreen> createState() => _MyCollegeIntroScreenState();
}

class _MyCollegeIntroScreenState extends State<MyCollegeIntroScreen> {
  final introKey = GlobalKey<IntroductionScreenState>();

  void _onIntroEnd(context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isIntroCollege', true);
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );
  }

  Widget buildImage(String assetName, {double width = 250}) {
    return Image.asset('assets/images/lbef.png', width: width);
  }

  @override
  Widget build(BuildContext context) {
    var pageDecoration = const PageDecoration(
      titleTextStyle: TextStyle(
        fontSize: 26.0,
        fontWeight: FontWeight.bold,
        color: Colors.blue,
      ),
      bodyPadding: EdgeInsets.all(20),
      bodyTextStyle: TextStyle(fontSize: 18.0),
      imagePadding: EdgeInsets.only(top: 40.0),
      pageColor: Colors.white,
    );

    return SafeArea(
      child: IntroductionScreen(
        key: introKey,
        globalBackgroundColor: Colors.white,
        pages: [
          PageViewModel(
            title: "View Class Routine",
            body: "Stay organized with your daily schedule at your fingertips.",
            image: buildImage('routine.png'),
            decoration: pageDecoration,
          ),
          PageViewModel(
            title: "Apply for Leave",
            body:
                "Submit leave applications easily without paperwork or delay.",
            image: buildImage('leave.png'),
            decoration: pageDecoration,
          ),
          PageViewModel(
            title: "Track Fees & Class Report",
            body: "Stay updated with your fee status and academic performance.",
            image: buildImage('fees_report.png'),
            decoration: pageDecoration,
          ),
          PageViewModel(
            title: "Never Miss an Event",
            body:
                "Get notified about all upcoming college events and programs.",
            image: buildImage('events.png'),
            decoration: pageDecoration,
          ),
        ],
        onDone: () => _onIntroEnd(context),
        showSkipButton: true,
        skip: const Text('Skip'),
        next: const Icon(Icons.arrow_forward, color: Colors.blue),
        done: const Text("Get Started",
            style: TextStyle(fontWeight: FontWeight.w600, color: Colors.blue)),
        dotsDecorator: const DotsDecorator(
          activeColor: Colors.blue,
          size: Size(10.0, 10.0),
          activeSize: Size(22.0, 10.0),
          activeShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(25.0)),
          ),
        ),
      ),
    );
  }
}
