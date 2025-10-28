import 'package:flutter/material.dart';
import 'package:lbef/constant/base_url.dart';
import 'package:lbef/resource/colors.dart';
import 'package:lbef/screen/student/class_routines/class_routines.dart';
import 'package:lbef/screen/student/dashboard/display_security.dart';
import 'package:lbef/screen/student/identity_card/student_id_card.dart';
import 'package:lbef/screen/student/notice/notice.dart';
import 'package:lbef/screen/student/profile/changePassword/change_password.dart';
import 'package:lbef/screen/student/profile/recover_password/recover_password.dart';
import 'package:lbef/screen/student/survey/survey_page.dart';
import 'package:lbef/screen/student/view_my_profile/view_my_profile.dart';
import 'package:lbef/utils/navigate_to.dart';
import 'package:lbef/view_model/survery_view_model.dart';
import 'package:lbef/widgets/custom_shimmer.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../data/status.dart';
import '../../../../view_model/theme_provider.dart';
import '../../../../view_model/user_view_model/current_user_model.dart';
import '../../../admit_card/admit_card.dart';
import '../../calender/calender.dart';
import '../../download_forums/download_forums.dart';
import 'dashboard_card.dart';

class DashboardHead extends StatefulWidget {
  const DashboardHead({
    super.key,
  });

  @override
  State<DashboardHead> createState() => _DashboardHeadState();
}

class _DashboardHeadState extends State<DashboardHead> {
  late final TextEditingController _controller;
  String searchQuery = '';

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);

    if (!await launchUrl(
      uri,
      mode: LaunchMode.externalApplication, // 👈 Forces system browser
    )) {
      throw Exception('Could not launch $url');
    }
  }

  final List<Map<String, dynamic>> allCards = [
    {
      'text': 'Class Routines',
      'icon': Icons.schedule,
      'className': const ClassRoutines()
    },
    {
      'text': 'Admit Card',
      'icon': Icons.laptop,
      'className': const AdmitCard()
    },

    {
      'text': 'Notice',
      'icon': Icons.notifications,
      'className': const NoticeBoard()
    },
    {
      'text': 'Calendar',
      'icon': Icons.calendar_month,
      'className': const CalendarScreen()
    },

    {
      'text': "Download forms",
      'icon': Icons.assignment,
      'className': const DownloadForums()
    },

    {'text': 'Security', 'icon': Icons.lock, 'alert': true},
  ];

  List<Map<String, dynamic>> filteredCards = [];

  @override
  void initState() {
    super.initState();

    _controller = TextEditingController();
    filteredCards = List.from(allCards);
  }

  void filterCards(String query) {
    final lowercaseQuery = query.toLowerCase();
    setState(() {
      searchQuery = query;
      if (query.isEmpty) {
        filteredCards = List.from(allCards);
      } else {
        filteredCards = allCards
            .where((card) =>
                (card['text'] as String).toLowerCase().contains(lowercaseQuery))
            .toList();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Column(
      children: [

        SizedBox(
          height: 345,
          child: Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: SizedBox(
                  height: size.height * 0.38,
                  child: SizedBox(
                    width: size.width * 0.4,
                    height: size.height * 0.15,
                    child: Image.asset('assets/images/content.png',
                        fit: BoxFit.cover),
                  ),
                ),
              ),
              Positioned(
                top: size.height * -0.04,
                left: size.width * 0.04,
                child: SizedBox(
                  width: size.width * 0.5,
                  height: size.height * 0.3,
                  child: Image.asset(
                    'assets/images/lbef_white.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              Consumer<UserDataViewModel>(
                builder: (context, userDataViewModel, child) {
                  final user = userDataViewModel.currentUser;
                  if (userDataViewModel.isLoading) {
                    return Positioned(
                      bottom: 90,
                      left: 20,
                      child: Shimmer.fromColors(
                        baseColor: Colors.grey.shade300,
                        highlightColor: Colors.grey.shade100,
                        child: Container(
                          width: 120,
                          height: 50,
                          color: Colors.grey,
                        ),
                      ),
                    );
                  } else if (userDataViewModel.userData.status ==
                      Status.ERROR) {
                    return const Positioned(
                      bottom: 90,
                      left: 24,
                      child: Text(
                        'Hi,\n Unexpected issue!!',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 24),
                      ),
                    );
                  } else if (user == null) {
                    String? getFirstWordsOrShrink(String? input) {
                      if (input == null || input.trim().isEmpty) return input;
                      List<String> words = input.trim().split(RegExp(r'\s+'));
                      if (words.length < 2) return words[0];
                      String twoWords = '${words[0]} ${words[1]}';
                      if (twoWords.length > 30) {
                        return words[0];
                      }
                      return twoWords;
                    }

                    String? name = getFirstWordsOrShrink("Unknown");
                    return Positioned(
                      bottom: 90,
                      left: 20,
                      child: Text(
                        'Hi,\n $name !!',
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 24),
                      ),
                    );
                  } else {
                    String? getFirstWordsOrShrink(String? input) {
                      if (input == null || input.trim().isEmpty) return input;
                      List<String> words = input.trim().split(RegExp(r'\s+'));
                      if (words.length < 2) return words[0];
                      String twoWords = '${words[0]} ${words[1]}';
                      if (twoWords.length > 30) {
                        return words[0];
                      }
                      return twoWords;
                    }

                    String? name = getFirstWordsOrShrink(user.stuFirstname);
                    return Positioned(
                      bottom: 90,
                      left: 24,
                      child: Text(
                        'Hi, $name !!',
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 26),
                      ),
                    );
                  }
                },
              ),
              Positioned(
                top: size.height * 0.08,
                right: size.width * 0.08,
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            const NoticeBoard(),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          const begin = Offset(1.0, 0.0);
                          const end = Offset.zero;
                          const curve = Curves.easeInOut;
                          var tween = Tween(begin: begin, end: end)
                              .chain(CurveTween(curve: curve));
                          var offsetAnimation = animation.drive(tween);
                          return SlideTransition(
                            position: offsetAnimation,
                            child: child,
                          );
                        },
                      ),
                    );
                  },
                  child: const Icon(Icons.notifications,
                      size: 32, color: Colors.white),
                ),
              ),
              Consumer<UserDataViewModel>(
                builder: (context, userDataViewModel, child) {
                  final user = userDataViewModel.currentUser;

                  String? image =
                      "${BaseUrl.imageDisplay}/html/profiles/students/${user?.stuProfilePath}/${user?.stuPhoto}";
                  var logger = Logger();
                  logger.d(image);
                  return Positioned(
                    bottom: 90,
                    right: 24,
                    child: SizedBox(
                      height: 100,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          image,
                          width: 90,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CustomShimmerLoading(
                                width: 90,
                                height: 100,
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[100]!,
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                            width: 90,
                            height: 100,
                            color: Colors.white,
                            child: Center(
                              child: Icon(
                                Icons.school,
                                color: AppColors.primary,
                                size: 40,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              Positioned(
                bottom: 0,
                left: 20,
                right: 20,
                child: Consumer<ThemeProvider>(
                    builder: (context, provider, child) {
                  return TextField(
                    controller: _controller,
                    onChanged: filterCards,
                    decoration: InputDecoration(
                      hintText: 'Looking for...',
                      filled: true,
                      fillColor:
                          provider.isDarkMode ? Colors.black : Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide.none,
                      ),
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: searchQuery.isNotEmpty
                          ? Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    _controller.clear();
                                    filterCards('');
                                  },
                                  child: const Icon(Icons.clear,
                                      color: Colors.grey),
                                ),
                                const SizedBox(width: 8),
                                GestureDetector(
                                  onTap: () {
                                    filterCards(_controller.text);
                                  },
                                  child: Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: AppColors.primary,
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    child: const Icon(Icons.search,
                                        color: Colors.white),
                                  ),
                                ),
                                const SizedBox(width: 6),
                              ],
                            )
                          : GestureDetector(
                              onTap: () {
                                filterCards(_controller.text);
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 2),
                                child: Container(
                                  width: 45,
                                  decoration: BoxDecoration(
                                    color: AppColors.primary,
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: const Icon(Icons.search,
                                      color: Colors.white, size: 26),
                                ),
                              ),
                            ),
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10,),
        Consumer<SurveryViewModel>(
          builder: (context, viewModel, child) {
            final totalPendingSubjects = viewModel.notices
                ?.fold<int>(
              0,
                  (sum, survey) => sum + (survey.subjectsPending?.length ?? 0),
            ) ?? 0;

            if (viewModel.isLoading || totalPendingSubjects == 0) {
              return const SizedBox.shrink(); // No pending subjects to show
            }
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
              child: InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                      const SurveyPage(),
                      transitionsBuilder: (context, animation, secondaryAnimation, child) {
                        const begin = Offset(0.0, 1.0); // Slide from bottom
                        const end = Offset.zero;
                        const curve = Curves.easeInOut;

                        var tween = Tween(begin: begin, end: end)
                            .chain(CurveTween(curve: curve));
                        var offsetAnimation = animation.drive(tween);

                        return SlideTransition(
                          position: offsetAnimation,
                          child: child,
                        );
                      },
                    ),
                  );

                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue[600],
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 6,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.book,
                        color: Colors.white,
                        size: 28,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Feedback Survey Available",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "$totalPendingSubjects subjects pending for feedback.",
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.85),
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),

        Padding(
          padding: const EdgeInsets.all(16.0),
          child: filteredCards.isEmpty
              ? const Text("No results found.")
              : GridView.count(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  crossAxisCount: 4,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.85,
                  children: filteredCards.map((card) {
                    return InkWell(
                      onTap: () {
                        if (card.containsKey('alert') == true) {
                          showDialog(
                            context: context,
                            builder: (context) => DisplaySecurity(
                                text: 'Security options',
                                show: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const SizedBox(height: 20),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            Navigator.of(context).push(
                                              PageRouteBuilder(
                                                pageBuilder: (context,
                                                        animation,
                                                        secondaryAnimation) =>
                                                    const RecoverPassword(),
                                                transitionsBuilder: (context,
                                                    animation,
                                                    secondaryAnimation,
                                                    child) {
                                                  const begin =
                                                      Offset(1.0, 0.0);
                                                  const end = Offset.zero;
                                                  const curve =
                                                      Curves.easeInOut;
                                                  var tween = Tween(
                                                          begin: begin,
                                                          end: end)
                                                      .chain(CurveTween(
                                                          curve: curve));
                                                  var offsetAnimation =
                                                      animation.drive(tween);
                                                  return SlideTransition(
                                                    position: offsetAnimation,
                                                    child: child,
                                                  );
                                                },
                                              ),
                                            );
                                          },
                                          child: Column(
                                            children: [
                                              Container(
                                                height: 80,
                                                width: 80,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  border: Border.all(
                                                    color:
                                                        const Color(0xff868484),
                                                    width: 0.4,
                                                  ),
                                                  color: Colors.white,
                                                ),
                                                child: Padding(
                                                  padding: EdgeInsets.all(8.0),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(
                                                        Icons.lock_reset,
                                                        size: 33,
                                                        color:
                                                            AppColors.primary,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              const SizedBox(
                                                width: 70,
                                                child: Text(
                                                  'Recover Password',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontSize: 11,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            Navigator.of(context).push(
                                              PageRouteBuilder(
                                                pageBuilder: (context,
                                                        animation,
                                                        secondaryAnimation) =>
                                                    const ChangePassword(),
                                                transitionsBuilder: (context,
                                                    animation,
                                                    secondaryAnimation,
                                                    child) {
                                                  const begin =
                                                      Offset(1.0, 0.0);
                                                  const end = Offset.zero;
                                                  const curve =
                                                      Curves.easeInOut;
                                                  var tween = Tween(
                                                          begin: begin,
                                                          end: end)
                                                      .chain(CurveTween(
                                                          curve: curve));
                                                  var offsetAnimation =
                                                      animation.drive(tween);
                                                  return SlideTransition(
                                                    position: offsetAnimation,
                                                    child: child,
                                                  );
                                                },
                                              ),
                                            );
                                          },
                                          child: Column(
                                            children: [
                                              Container(
                                                height: 80,
                                                width: 80,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  border: Border.all(
                                                    color:
                                                        const Color(0xff868484),
                                                    width: 0.4,
                                                  ),
                                                  color: Colors.white,
                                                ),
                                                child: Padding(
                                                  padding: EdgeInsets.all(8.0),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(
                                                        Icons.lock_clock_sharp,
                                                        color:
                                                            AppColors.primary,
                                                        size: 33,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              const SizedBox(
                                                width: 70,
                                                child: Text(
                                                  'Change Password',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontSize: 11,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                )),
                          ); // Show alert dialog
                        } else if (card.containsKey('className')) {
                          Navigator.of(context).push(
                            SlideRightRoute(page: card['className']),
                          );
                        } else if (card.containsKey('link')) {
                          _launchUrl(card['link']);
                        }
                      },
                      child: DashboardCard(
                        text: card['text']!,
                        icon: card['icon'],
                      ),
                    );
                  }).toList(),
                ),
        ),
      ],
    );
  }
}
