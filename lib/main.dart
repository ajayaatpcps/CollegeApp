import 'package:flutter/material.dart';
import 'package:khalti_flutter/khalti_flutter.dart'; // Add Khalti package
import 'package:lbef/resource/routes.dart';
import 'package:lbef/resource/routes_name.dart';
import 'package:lbef/screen/auth/login_page.dart';
import 'package:lbef/screen/navbar/student_navbar.dart';
import 'package:lbef/screen/student/class_routines/class_routines.dart';
import 'package:lbef/screen/student/dashboard/dashboard.dart';
import 'package:lbef/view_model/application_files/application_view_model.dart';
import 'package:lbef/view_model/calender/calender.dart';
import 'package:lbef/view_model/class_routine/class_routine_view_model.dart';
import 'package:lbef/view_model/college_fees/college_fee_view_model.dart';
import 'package:lbef/view_model/daily_class_report/dcr_detail_view_model.dart';
import 'package:lbef/view_model/daily_class_report/dcr_view_model.dart';
import 'package:lbef/view_model/download_forms/download_forms_view_model.dart';
import 'package:lbef/view_model/notice_board/notice_board_view_model.dart';
import 'package:lbef/view_model/user_view_model/auth_view_model.dart';
import 'package:lbef/view_model/user_view_model/current_user_model.dart';
import 'package:lbef/view_model/user_view_model/user_view_model.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(create: (_) => ApplicationViewModel()),
        ChangeNotifierProvider(create: (_) => ClassRoutineViewModel()),
        ChangeNotifierProvider(create: (_) => DcrViewModel()),
        ChangeNotifierProvider(create: (_) => DcrDetailViewModel()),
        ChangeNotifierProvider(create: (_) => CalenderViewModel()),
        ChangeNotifierProvider(create: (_) => DownloadFormViewModel()),
        ChangeNotifierProvider(create: (_) => NoticeBoardViewModel()),
        ChangeNotifierProvider(create: (_) => UserViewModel()),
        ChangeNotifierProvider(create: (_) => UserDataViewModel()),
        ChangeNotifierProvider(create: (_) => CollegeFeeViewModel()),
      ],
      child: Builder(
        builder: (context) {
          return KhaltiScope(
            publicKey: 'test_public_key_d5d9f63743584dc38753056b0cc737d5',
            builder: (context, navigatorKey) {
              return MediaQuery(
                data: MediaQuery.of(context).copyWith(
                  textScaler: TextScaler.noScaling,
                ),
                child: MaterialApp(
                  title: 'LBEF',
                  theme: ThemeData(
                    colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
                    useMaterial3: true,
                    fontFamily: 'poppins',
                  ),
                  debugShowCheckedModeBanner: false,
                  navigatorKey: navigatorKey,
                  supportedLocales: const [
                    Locale('en', 'US'),
                    Locale('ne', 'NP'),
                  ],
                  localizationsDelegates: const [
                    KhaltiLocalizations.delegate,
                  ],
                  home: const StudentNavbar(
                    index: 0,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}