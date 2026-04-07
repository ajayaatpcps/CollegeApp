import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:flutter/material.dart';
import 'package:lbef/resource/colors.dart';
import 'package:lbef/screen/student/daily_class_report/daily_class_report.dart';
import 'package:lbef/screen/student/dashboard/dashboard.dart';
import 'package:lbef/screen/student/profile/profile.dart';
import 'package:lbef/screen/student/student_fees/student_fees.dart';
import 'package:lbef/widgets/Dialog/alert.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../view_model/theme_provider.dart';
import '../../view_model/user_view_model/current_user_model.dart';
import '../student/application/application.dart';

class StudentNavbar extends StatefulWidget {
  final int? index;
  const StudentNavbar({super.key, this.index = 0});

  @override
  State<StudentNavbar> createState() => _StudentNavbarState();
}

class _StudentNavbarState extends State<StudentNavbar> {
  int _selectedIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.index ?? 0;
    _pageController = PageController(initialPage: _selectedIndex);
    // Fetch user data then check profile status
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      fetch();
      _checkProfileStatus();
    });
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

  /// Checks profile_status; if incomplete, show blocking dialog
  void _checkProfileStatus() async {
    final profileViewModel =
        Provider.of<UserDataViewModel>(context, listen: false);

    final profile = await profileViewModel.getStudentProfile(context);

    if (!mounted) return;

    if (profile != null && profile.profileStatus?.toLowerCase() != 'complete') {
      _showIncompleteProfileDialog();
    }
  }

  void _showIncompleteProfileDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => PopScope(
        canPop: false,
        child: AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          icon: const Icon(Icons.account_circle_outlined,
              color: Colors.orange, size: 52),
          title: const Text(
            'Complete Your Profile',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Your profile is incomplete. Please complete it to access the app.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.orange.withOpacity(0.3)),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.lightbulb_outline,
                            color: Colors.orange, size: 16),
                        SizedBox(width: 6),
                        Text(
                          'Tips for best experience',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: Colors.orange,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    _TipRow(
                      icon: Icons.computer,
                      text: 'Use a PC/laptop for a better form experience.',
                    ),
                    SizedBox(height: 4),
                    _TipRow(
                      icon: Icons.wifi,
                      text: 'Ensure a stable internet connection.',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              const Text(
                'You will be redirected to PCPS Life website.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
          actionsAlignment: MainAxisAlignment.center,
          actionsPadding: const EdgeInsets.only(bottom: 16),
          actions: [
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 28, vertical: 13),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              icon: const Icon(Icons.open_in_browser, size: 20),
              label: const Text(
                'Go to PCPS Life',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
              onPressed: () => _launchProfileUrl(),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchProfileUrl() async {
    final Uri url = Uri.parse('https://pcpslife.patancollege.edu.np');
    try {
      await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'Could not open browser. Please visit pcpslife.patancollege.edu.np manually.'),
          ),
        );
      }
    }
  }

  final List<Widget> _pages = const [
    Dashboard(),
    DailyClassReport(),
    Application(),
    StudentFees(),
    ProfilePage()
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

class _TipRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _TipRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 15, color: Colors.grey[700]),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: TextStyle(fontSize: 12, color: Colors.grey[700]),
          ),
        ),
      ],
    );
  }
}
