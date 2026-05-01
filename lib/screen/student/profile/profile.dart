import 'package:flutter/material.dart';
import 'package:lbef/screen/student/calender/calender.dart';
import 'package:lbef/screen/student/class_routines/class_routines.dart';
import 'package:lbef/screen/student/notice/notice.dart';
import 'package:lbef/screen/student/profile/recover_password/recover_password.dart';
import 'package:lbef/screen/student/profile/widgets/build_list_tile.dart';
import 'package:lbef/screen/student/view_my_profile/view_my_profile.dart';
import 'package:lbef/services/biometric_service.dart';
import 'package:lbef/view_model/user_view_model/auth_view_model.dart';
import 'package:lbef/view_model/user_view_model/user_view_model.dart';
import 'package:lbef/widgets/Dialog/alert.dart';
import 'package:lbef/widgets/form_widget/btn/outlned_btn.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../constant/base_url.dart';
import '../../../resource/colors.dart';
import '../../../view_model/theme_provider.dart';
import '../../../view_model/user_view_model/current_user_model.dart';
import '../../../widgets/custom_shimmer.dart';
import 'changePassword/change_password.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _biometricAvailable = false;
  bool _biometricSetup = false;
  bool _biometricLoading = false; // prevents double-tap during API call

  @override
  void initState() {
    super.initState();
    _loadBiometricState();
  }

  /// Load whether device supports biometrics and whether the user has set it up.
  Future<void> _loadBiometricState() async {
    final available = await BiometricService.isAvailable();
    final setup = await BiometricService.isSetup();
    if (mounted) {
      setState(() {
        _biometricAvailable = available;
        _biometricSetup = setup;
      });
    }
  }

  /// Toggle ON: call GET /biometrics → save token securely.
  Future<void> _enableBiometric() async {
    setState(() => _biometricLoading = true);

    final success = await Provider.of<AuthViewModel>(context, listen: false)
        .setupBiometric(context);

    if (mounted) {
      setState(() {
        _biometricLoading = false;
        if (success) _biometricSetup = true;
      });
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Fingerprint login enabled!'),
            backgroundColor: Colors.green,
          ),
        );
      }
      // AuthViewModel already shows error snackbar on failure.
    }
  }

  /// Toggle OFF: ask for confirmation then clear saved token.
  Future<void> _disableBiometric(bool Isdark) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
          backgroundColor: Isdark
              ? Colors.black
              : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Disable Fingerprint Login?'),
        content: const Text(
            'You will need your password to log in next time.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Disable'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await BiometricService.clearToken();
      if (mounted) {
        setState(() => _biometricSetup = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Fingerprint login disabled.')),
        );
      }
    }
  }

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  Route _buildSlideRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;
        final tween =
        Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        return SlideTransition(
            position: animation.drive(tween), child: child);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Account Settings",
          style: TextStyle(fontFamily: 'poppins', fontSize: 20),
        ),
        automaticallyImplyLeading: false,
        actions: const [
          Image(
            image: AssetImage('assets/images/pcpsLogo.png'),
            width: 70,
            height: 50,
            fit: BoxFit.contain,
          ),
          SizedBox(width: 14),
          SizedBox(width: 14),
        ],
      ),
      body: Column(
        children: [
          // ── Profile header ──────────────────────────────────────────
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, child) {
              return Consumer<UserDataViewModel>(
                builder: (context, userDataViewModel, child) {
                  final user = userDataViewModel.currentUser;
                  final String image =
                      "${BaseUrl.imageDisplay}/html/profiles/students/${user?.stuProfilePath}/${user?.stuPhoto}";
                  Logger().d(image);

                  return Container(
                    color: themeProvider.isDarkMode
                        ? Colors.black
                        : Colors.grey[50],
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        SizedBox(
                          height: 100,
                          width: 100,
                          child: ClipOval(
                            child: Image.network(
                              image,
                              fit: BoxFit.cover,
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Center(
                                  child: CustomShimmerLoading(
                                    width: 100.0,
                                    height: 100.0,
                                    baseColor: Colors.grey[300]!,
                                    highlightColor: Colors.grey[100]!,
                                  ),
                                );
                              },
                              errorBuilder: (context, error, stackTrace) =>
                                  Container(
                                    width: 100,
                                    height: 100,
                                    color: AppColors.primary,
                                    child: const Center(
                                      child: Icon(Icons.school,
                                          color: Colors.white, size: 40),
                                    ),
                                  ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 30),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Hi',
                                  style: TextStyle(fontSize: 18)),
                              Text(
                                "${user?.stuFirstname ?? ''} ${user?.stuLastname ?? ''}",
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                user?.stuRollNo?.toString() ?? '',
                                style: const TextStyle(fontSize: 18),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),

          const SizedBox(height: 10),

          // ── Scrollable settings list ────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Consumer<ThemeProvider>(
                  builder: (context, themeProvider, child) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ── Settings ──────────────────────────────────
                        const Text('Settings',
                            style:
                            TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 5),
                        buildListTile(Icons.people_alt_outlined,
                            'View Profile', context, () {
                              Navigator.of(context).push(
                                  _buildSlideRoute(const ViewProfilePage()));
                            }),
                        const SizedBox(height: 15),

                        // ── Security Options ──────────────────────────
                        const Text('Security Options',
                            style:
                            TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 5),
                        buildListTile(
                            Icons.lock, 'Recover Password', context, () {
                          Navigator.of(context).push(
                              _buildSlideRoute(const RecoverPassword()));
                        }),
                        buildListTile(
                            Icons.lock, 'Change Password', context, () {
                          Navigator.of(context).push(
                              _buildSlideRoute(const ChangePassword()));
                        }),
                        buildListTile(Icons.lock_clock_outlined,
                            'Change Breo Password', context, () async {
                              final shouldExit = await showDialog<bool>(
                                context: context,
                                builder: (context) => Alert(
                                  icon: Icons.web,
                                  iconColor: AppColors.primary,
                                  title: 'Breo Password',
                                  content:
                                  'Are you sure you want to open Breo?',
                                  buttonText: 'Yes',
                                ),
                              );
                              if (shouldExit ?? false) {
                                _launchUrl('https://password.beds.ac.uk/');
                              }
                            }),
                        const SizedBox(height: 15),

                        // ── Academics ─────────────────────────────────
                        const Text('Academics',
                            style:
                            TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 5),
                        buildListTile(
                            Icons.schedule, 'Class Routine', context, () {
                          Navigator.of(context).push(
                              _buildSlideRoute(const ClassRoutines()));
                        }),
                        buildListTile(
                            Icons.laptop, 'E-vision access', context,
                                () async {
                              final shouldExit = await showDialog<bool>(
                                context: context,
                                builder: (context) => Alert(
                                  icon: Icons.web,
                                  iconColor: AppColors.primary,
                                  title: 'E-vision Access',
                                  content:
                                  'Are you sure you want to open E-vision?',
                                  buttonText: 'Yes',
                                ),
                              );
                              if (shouldExit ?? false) {
                                _launchUrl('https://evision.beds.ac.uk/');
                              }
                            }),
                        buildListTile(
                            Icons.web, 'Breo access', context, () async {
                          final shouldExit = await showDialog<bool>(
                            context: context,
                            builder: (context) => Alert(
                              icon: Icons.web,
                              iconColor: AppColors.primary,
                              title: 'Breo Access',
                              content:
                              'Are you sure you want to open Breo?',
                              buttonText: 'Yes',
                            ),
                          );
                          if (shouldExit == true) {
                            _launchUrl('https://breo.beds.ac.uk/');
                          }
                        }),

                        // ── Notice Board ──────────────────────────────
                        const Row(children: [
                          Text('Notice Board',
                              style:
                              TextStyle(fontWeight: FontWeight.bold)),
                        ]),
                        const SizedBox(height: 5),
                        buildListTile(
                            Icons.newspaper, 'Notice Board', context, () {
                          Navigator.of(context).push(
                              _buildSlideRoute(const NoticeBoard()));
                        }),
                        buildListTile(
                            Icons.calendar_month, 'Calender', context,
                                () {
                              Navigator.of(context).push(
                                  _buildSlideRoute(const CalendarScreen()));
                            }),
                        const SizedBox(height: 15),

                        // ── Support ───────────────────────────────────
                        const Text('Support',
                            style:
                            TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 5),

                        // Theme tile
                        ListTile(
                          leading: Icon(
                            Icons.color_lens,
                            color: themeProvider.isDarkMode
                                ? Colors.white
                                : Colors.black,
                            size: 24,
                          ),
                          title: const Text('Theme Mode'),
                          subtitle: Text(
                            themeProvider.themeMode == ThemeMode.light
                                ? 'Light'
                                : 'Dark',
                          ),
                          onTap: () {
                            showModalBottomSheet(
                                backgroundColor: themeProvider.isDarkMode
                            ? Colors.black
                                : Colors.white,
                              context: context,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(16)),
                              ),
                              builder: (context) => Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ListTile(
                                    leading:
                                    const Icon(Icons.light_mode),
                                    title: const Text('Light Mode'),
                                    onTap: () {
                                      themeProvider
                                          .setTheme(ThemeMode.light);
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  ListTile(
                                    leading:
                                    const Icon(Icons.dark_mode),
                                    title: const Text('Dark Mode'),
                                    onTap: () {
                                      themeProvider
                                          .setTheme(ThemeMode.dark);
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          tileColor: themeProvider.isDarkMode
                              ? Colors.black
                              : Colors.grey[50],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),

                        // ── Biometric tile ────────────────────────────
                        // Only shown when the device actually supports biometrics.
                        if (_biometricAvailable)
                          ListTile(
                            leading: _biometricLoading
                                ? SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.primary,
                              ),
                            )
                                : Icon(
                              Icons.fingerprint,
                              color: _biometricSetup
                                  ? AppColors.primary
                                  : Colors.grey,
                              size: 24,
                            ),
                            title: Text(
                              _biometricSetup
                                  ? 'Fingerprint Login'
                                  : 'Enable Fingerprint Login',
                            ),
                            subtitle: Text(
                              _biometricSetup ? 'Enabled' : 'Not set up',
                            ),
                            trailing: Switch(
                              value: _biometricSetup,
                              activeColor: AppColors.primary,
                              // Disable switch interaction while API call is in progress
                              onChanged: _biometricLoading
                                  ? null
                                  : (value) async {
                                if (value) {
                                  await _enableBiometric();
                                } else {
                                  await _disableBiometric(themeProvider.isDarkMode);
                                }
                              },
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            tileColor: themeProvider.isDarkMode
                                ? Colors.black
                                : Colors.grey[50],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),

                        // ── Sign Out ──────────────────────────────────
                        buildListTile(
                            Icons.logout, 'Sign Out', context, () async {
                          final bool? shouldLogout =
                          await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              backgroundColor: themeProvider.isDarkMode
                                  ? Colors.black
                                  : Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              title: const Row(
                                children: [
                                  Icon(Icons.exit_to_app,
                                      color: Colors.redAccent),
                                  SizedBox(width: 10),
                                  Text('Logout'),
                                ],
                              ),
                              content: const Text(
                                'Are you sure you want to logout?',
                                style: TextStyle(fontSize: 16),
                              ),
                              actionsPadding:
                              const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              actions: [
                                CustomOutlineButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(false),
                                  labelText: 'Cancel',
                                  width: size.width * 0.2,
                                  height: size.height * 0.04,
                                  buttonColor: Colors.red,
                                  textColor: Colors.red,
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primary,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(12),
                                    ),
                                  ),
                                  onPressed: () =>
                                      Navigator.of(context).pop(true),
                                  child: const Text('Logout'),
                                ),
                              ],
                            ),
                          );

                          if (shouldLogout == true) {
                            await Provider.of<UserViewModel>(context,
                                listen: false)
                                .remove(context);
                          }
                        }),

                        const SizedBox(height: 30),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}