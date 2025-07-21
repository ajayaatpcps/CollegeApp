import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:flutter/material.dart';
import 'package:lbef/resource/colors.dart';
import 'package:lbef/screen/faculty/faculty_class_report/faculty_class_report.dart';
import 'package:lbef/screen/faculty/faculty_profile/faculty_profile.dart';
import 'package:lbef/screen/faculty/faculty_routine/faculty_routine.dart';
import 'package:lbef/screen/student/daily_class_report/daily_class_report.dart';
import 'package:lbef/screen/student/dashboard/dashboard.dart';
import 'package:lbef/screen/student/profile/profile.dart';
import 'package:lbef/screen/student/student_fees/student_fees.dart';
import 'package:lbef/widgets/Dialog/alert.dart';
import 'package:provider/provider.dart';
import '../../view_model/theme_provider.dart';
import '../../view_model/user_view_model/current_user_model.dart';
import '../faculty/faculty_dashboard/faculty_dashboard.dart';
import '../student/application/application.dart';

class FacultyNavbar extends StatefulWidget {
  final int? index;
  const FacultyNavbar({super.key, this.index = 0});

  @override
  State<FacultyNavbar> createState() => _FacultyNavbarState();
}

class _FacultyNavbarState extends State<FacultyNavbar> {
  int _selectedIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    fetch();
    _selectedIndex = widget.index ?? 0;
    _pageController = PageController(initialPage: _selectedIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void fetch() async {
    await Provider.of<UserDataViewModel>(context, listen: false)
        .getUser(context);
  }

  final List<Widget> _pages = const [
    FacultyDashboard(),
    FacultyClassReport(),
    FacultyRoutine(),
    FacultyRoutine(),
    FacultyProfile()
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final shouldExit = await showDialog<bool>(
          context: context,
          builder: (context) => Alert(
            icon: Icons.exit_to_app,
            iconColor: AppColors.primary,
            title: 'Exit App',
            content: 'Are you sure you want to exit the app?',
            buttonText: 'Yes',
          ),
        );
        return shouldExit ?? false;
      },
      child: Scaffold(
          body: PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            children: _pages,
          ),
          bottomNavigationBar:
          Consumer<ThemeProvider>(builder: (context, provider, child) {
            return CurvedNavigationBar(
              index: _selectedIndex,
              backgroundColor: Colors.transparent,
              color: provider.isDarkMode ? Colors.black : Colors.white,
              buttonBackgroundColor: Colors.white,
              height: 70,
              animationCurve: Curves.easeInOut,
              animationDuration: const Duration(milliseconds: 400),
              items: [
                CurvedNavigationBarItem(
                  child: SizedBox(
                    height: 35,
                    width: 35,
                    child: Icon(Icons.dashboard,
                        color: _selectedIndex == 0
                            ? Colors.blue
                            : (provider.isDarkMode
                            ? Colors.white
                            : Colors.black)),
                  ),
                  label: 'Home',
                  labelStyle: TextStyle(
                      fontSize: 12,
                      color: provider.isDarkMode ? Colors.white : Colors.black),
                ),
                CurvedNavigationBarItem(
                    child: SizedBox(
                      height: 35,
                      width: 35,
                      child: Icon(
                        Icons.assignment_outlined,
                        color: _selectedIndex == 1
                            ? Colors.blue
                            : (provider.isDarkMode
                            ? Colors.white
                            : Colors.black),
                        size: 24,
                      ),
                    ),
                    label: 'DCR',
                    labelStyle: TextStyle(
                        fontSize: 12,
                        color:
                        provider.isDarkMode ? Colors.white : Colors.black)),
                CurvedNavigationBarItem(
                    child: SizedBox(
                      height: 35,
                      width: 35,
                      child: Icon(
                        Icons.outgoing_mail,
                        color: _selectedIndex == 2
                            ? Colors.blue
                            : (provider.isDarkMode
                            ? Colors.white
                            : Colors.black),
                        size: 25,
                      ),
                    ),
                    label: 'Application',
                    labelStyle: TextStyle(
                        fontSize: 12,
                        color:
                        provider.isDarkMode ? Colors.white : Colors.black)),
                CurvedNavigationBarItem(
                    child: SizedBox(
                      height: 35,
                      width: 35,
                      child: Icon(
                        Icons.payments_outlined,
                        color: _selectedIndex == 3
                            ? Colors.blue
                            : (provider.isDarkMode
                            ? Colors.white
                            : Colors.black),
                        size: 25,
                      ),
                    ),
                    label: 'Fees',
                    labelStyle: TextStyle(
                        fontSize: 12,
                        color:
                        provider.isDarkMode ? Colors.white : Colors.black)),
                CurvedNavigationBarItem(
                    child: SizedBox(
                      height: 35,
                      width: 35,
                      child: Icon(
                        Icons.person_outline,
                        color: _selectedIndex == 4
                            ? Colors.blue
                            : (provider.isDarkMode
                            ? Colors.white
                            : Colors.black),
                        size: 25,
                      ),
                    ),
                    label: 'Profile',
                    labelStyle: TextStyle(
                        fontSize: 12,
                        color:
                        provider.isDarkMode ? Colors.white : Colors.black)),
              ],
              onTap: (index) {
                _pageController.animateToPage(
                  index,
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeInOut,
                );
              },
            );
          })),
    );
  }
}
