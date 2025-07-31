import 'package:flutter/material.dart';
import 'package:lbef/screen/student/calender/calender.dart';
import 'package:lbef/screen/student/class_routines/class_routines.dart';
import 'package:lbef/screen/student/notice/notice.dart';
import 'package:lbef/screen/student/profile/recover_password/recover_password.dart';

import 'package:lbef/screen/student/profile/widgets/build_list_tile.dart';
import 'package:lbef/screen/student/view_my_profile/view_my_profile.dart';
import 'package:lbef/view_model/user_view_model/user_view_model.dart';
import 'package:lbef/widgets/form_widget/btn/outlned_btn.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../constant/base_url.dart';
import '../../../resource/colors.dart';
import '../../../view_model/theme_provider.dart';
import '../../../view_model/user_view_model/current_user_model.dart';
import '../../../widgets/Dialog/alert.dart';
import '../../../widgets/custom_shimmer.dart';
import 'changePassword/change_password.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    Future<void> _launchUrl(String url) async {
      final Uri uri = Uri.parse(url);

      if (!await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      )) {
        throw Exception('Could not launch $url');
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Account Settings",
          style: TextStyle(fontFamily: 'poppins', fontSize: 20),
        ),
        automaticallyImplyLeading: false,
        actions: const [
          Image(
            image: AssetImage('assets/images/lbef.png'),
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
          Consumer<ThemeProvider>(builder: (context, themeProvider, child) {
            return Container(child: Consumer<UserDataViewModel>(
              builder: (context, userDataViewModel, child) {
                final user = userDataViewModel.currentUser;

                String? image =
                    "${BaseUrl.imageDisplay}/html/profiles/students/${user?.stuProfilePath}/${user?.stuPhoto}";
                var logger = Logger();
                logger.d(image);

                return Container(
                  color:
                      themeProvider.isDarkMode ? Colors.black : Colors.grey[50],
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
                            loadingBuilder: (context, child, loadingProgress) {
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
                                child: Icon(
                                  Icons.school,
                                  color: Colors.white,
                                  size: 40,
                                ),
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
                            const Text(
                              'Hi',
                              style: TextStyle(fontSize: 18),
                            ),
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
            ));
          }),
          const SizedBox(height: 10),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    const Row(
                      children: [
                        Text(
                          'Settings',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    buildListTile(
                        Icons.people_alt_outlined, 'View Profile', context, () {
                      Navigator.of(context)
                          .push(_buildSlideRoute(const ViewProfilePage()));
                    }),
                    const SizedBox(
                      height: 15,
                    ),
                    const Row(
                      children: [
                        Text(
                          'Security Options',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),

                    buildListTile(Icons.lock, 'Recover Password', context, () {
                      Navigator.of(context)
                          .push(_buildSlideRoute(const RecoverPassword()));
                    }),

                    buildListTile(Icons.lock, 'Change Password', context, () {
                      Navigator.of(context)
                          .push(_buildSlideRoute(const ChangePassword()));
                    }),
                    const SizedBox(
                      height: 15,
                    ),
                    const Row(
                      children: [
                        Text(
                          'Academics',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    // buildListTile(
                    //     Icons.picture_as_pdf, 'Print Admit Card', () {}),
                    buildListTile(Icons.schedule, 'Class Routine', context, () {
                      Navigator.of(context)
                          .push(_buildSlideRoute(const ClassRoutines()));
                    }),

                    buildListTile(Icons.laptop, 'Apspace', context,
                        () async {
                      final shouldExit = await showDialog<bool>(
                        context: context,
                        builder: (context) => Alert(
                          icon: Icons.web,
                          iconColor: AppColors.primary,
                          title: 'E-vision Access',
                          content: 'Are you sure you want to open E-vision?',
                          buttonText: 'Yes',
                        ),
                      );
                      if (shouldExit ?? false) {
                        _launchUrl('https://apspace.apu.edu.my/login');
                      }
                    }),
                    buildListTile(Icons.laptop, 'University E-library', context,
                            () async {
                          final shouldExit = await showDialog<bool>(
                            context: context,
                            builder: (context) => Alert(
                              icon: Icons.web,
                              iconColor: AppColors.primary,
                              title: 'E-libraries Access',
                              content: 'Are you sure you want to open E-libraries?',
                              buttonText: 'Yes',
                            ),
                          );
                          if (shouldExit ?? false) {
                            _launchUrl('https://library.apu.edu.my/apu-e-databases/');
                          }
                        }),
                    buildListTile(Icons.web, 'University Moodle', context, () async {
                      final shouldExit = await showDialog<bool>(
                        context: context,
                        builder: (context) => Alert(
                          icon: Icons.web,
                          iconColor: AppColors.primary,
                          title: 'University Moodle',
                          content: 'Are you sure you want to open University Moodle?',
                          buttonText: 'Yes',
                        ),
                      );
                      if (shouldExit == true) {
                        _launchUrl('https://lms2.apiit.edu.my/');
                      }
                    }),
                    // buildListTile(Icons.event, 'Events', () {
                    //   Navigator.of(context)
                    //       .push(_buildSlideRoute(const Event()));
                    // }),
                    // buildListTile(Icons.people, 'Teachers', () {
                    //   Navigator.of(context)
                    //       .push(_buildSlideRoute(const TeachersPage()));
                    // }),
                    // const SizedBox(
                    //   height: 15,
                    // ),
                    const Row(
                      children: [
                        Text(
                          'Notice Board',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    buildListTile(Icons.newspaper, 'Notice Board', context, () {
                      Navigator.of(context)
                          .push(_buildSlideRoute(const NoticeBoard()));
                    }),
                    buildListTile(Icons.calendar_month, 'Calender', context,
                        () {
                      Navigator.of(context)
                          .push(_buildSlideRoute(const CalendarScreen()));
                    }),
                    // buildListTile(Icons.event, 'Event', () {
                    //   Navigator.of(context)
                    //       .push(_buildSlideRoute(const AcademicCalender()));
                    // }),
                    const SizedBox(
                      height: 15,
                    ),
                    const Row(
                      children: [
                        Text(
                          'Support',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    // buildListTile(Icons.info, 'About', () {}),
                    // buildListTile(Icons.help_outline, 'Help', () {}),
                    // buildListTile(Icons.call, 'Contact', () {}),
                    Consumer<ThemeProvider>(
                      builder: (context, themeProvider, child) {
                        return Column(
                          children: [
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
                                  context: context,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(16)),
                                  ),
                                  builder: (context) {
                                    return Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        ListTile(
                                          leading: const Icon(Icons.light_mode),
                                          title: const Text('Light Mode'),
                                          onTap: () {
                                            themeProvider
                                                .setTheme(ThemeMode.light);
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        ListTile(
                                          leading: const Icon(Icons.dark_mode),
                                          title: const Text('Dark Mode'),
                                          onTap: () {
                                            themeProvider
                                                .setTheme(ThemeMode.dark);
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    );
                                  },
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
                            buildListTile(Icons.logout, 'Sign Out', context,
                                () async {
                              bool? shouldLogout = await showDialog<bool>(
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
                                  actionsPadding: const EdgeInsets.symmetric(
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
                          ],
                        );
                      },
                    ),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Route _buildSlideRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;
        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);
        return SlideTransition(position: offsetAnimation, child: child);
      },
    );
  }
}
