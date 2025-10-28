import 'package:flutter/material.dart';
import 'package:lbef/resource/routes.dart';
import 'package:lbef/resource/routes_name.dart';
import 'package:lbef/view_model/application_files/application_view_model.dart';
import 'package:lbef/view_model/banner_view_model.dart';
import 'package:lbef/view_model/calender/event_calender_view_model.dart';
import 'package:lbef/view_model/class_routine/class_routine_view_model.dart';
import 'package:lbef/view_model/college_fees/college_fee_view_model.dart';
import 'package:lbef/view_model/daily_class_report/dcr_detail_view_model.dart';
import 'package:lbef/view_model/daily_class_report/dcr_view_model.dart';
import 'package:lbef/view_model/download_forms/download_forms_view_model.dart';
import 'package:lbef/view_model/notice_board/email_view_model.dart';
import 'package:lbef/view_model/notice_board/notice_board_view_model.dart';
import 'package:lbef/view_model/notice_board/sms_view_model.dart';
import 'package:lbef/view_model/survery_view_model.dart';
import 'package:lbef/view_model/theme_provider.dart';
import 'package:lbef/view_model/user_view_model/admit_card_view_model.dart';
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
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => AdmitCardViewModel()),

        ChangeNotifierProvider(create: (_) => BannerViewModel()),
        ChangeNotifierProvider(create: (_) => SurveryViewModel()),
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(create: (_) => ApplicationViewModel()),
        ChangeNotifierProvider(create: (_) => ClassRoutineViewModel()),
        ChangeNotifierProvider(create: (_) => DcrViewModel()),
        ChangeNotifierProvider(create: (_) => DcrDetailViewModel()),
        ChangeNotifierProvider(create: (_) => EmailViewModel()),
        ChangeNotifierProvider(create: (_) => SmsViewModel()),
        ChangeNotifierProvider(create: (_) => EventCalenderViewModel()),
        ChangeNotifierProvider(create: (_) => DownloadFormsViewModel()),
        ChangeNotifierProvider(create: (_) => NoticeBoardViewModel()),
        ChangeNotifierProvider(create: (_) => UserViewModel()),
        ChangeNotifierProvider(create: (_) => UserDataViewModel()),
        ChangeNotifierProvider(create: (_) => CollegeFeeViewModel()),
      ],
      child: Builder(
        builder: (context) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(
              textScaler: TextScaler.noScaling,
            ),
            child: Consumer<ThemeProvider>(
              builder: (context, themeProvider, child) {
                return MaterialApp(
                  title: 'PCPS',
                  debugShowCheckedModeBanner: false,
                  themeMode: themeProvider.themeMode,
                  theme: ThemeData(
                    useMaterial3: true,
                    fontFamily: 'Poppins',
                    brightness: Brightness.light,
                    colorScheme: ColorScheme.fromSeed(
                      seedColor: Colors.red,
                      brightness: Brightness.light,
                    ),
                    scaffoldBackgroundColor: Colors.white,
                    appBarTheme: const AppBarTheme(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      elevation: 0,
                    ),
                    iconTheme: const IconThemeData(color: Colors.black),
                    textTheme: const TextTheme(
                      bodyMedium: TextStyle(color: Colors.black),
                    ),
                  ),
                  darkTheme: ThemeData(
                    useMaterial3: true,
                    fontFamily: 'Poppins',
                    brightness: Brightness.dark,
                    colorScheme: ColorScheme.fromSeed(
                      seedColor: Colors.red,
                      brightness: Brightness.dark,
                    ),
                    scaffoldBackgroundColor: const Color(0xFF121212),
                    appBarTheme: const AppBarTheme(
                      backgroundColor: Color(0xFF1F1F1F),
                      foregroundColor: Colors.white,
                      elevation: 0,
                    ),
                    iconTheme: const IconThemeData(color: Colors.white),
                    textTheme: const TextTheme(
                      bodyMedium: TextStyle(color: Colors.white),
                    ),
                  ),
                  initialRoute: RoutesName.flash,
                  onGenerateRoute: Routes.generateRoute,
                );
              },
            ),
          );
        },
      ),
    );
  }
}
