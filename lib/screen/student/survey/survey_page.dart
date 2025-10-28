import 'package:flutter/material.dart';
import 'package:lbef/resource/colors.dart';
import 'package:lbef/screen/student/survey/survey_detail_page.dart';
import 'package:lbef/view_model/survery_view_model.dart';
import 'package:lbef/widgets/no_data/no_data_widget.dart';
import 'package:provider/provider.dart';

class SurveyPage extends StatefulWidget {
  const SurveyPage({super.key});

  @override
  State<SurveyPage> createState() => _SurveyPageState();
}

class _SurveyPageState extends State<SurveyPage> {
  @override
  void initState() {
    super.initState();
    // Fetch surveys when the page loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<SurveryViewModel>(context, listen: false).fetch(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Survey",
          style: TextStyle(fontFamily: 'poppins', fontSize: 18),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: AppColors.primary),
          onPressed: () => Navigator.pop(context),
          iconSize: 18,
        ),
        actions: const [
          Image(
            image: AssetImage('assets/images/pcpsLogo.png'),
            width: 70,
            height: 50,
            fit: BoxFit.contain,
          ),
          SizedBox(width: 14),
        ],
      ),
      body: SafeArea(
        child: Consumer<SurveryViewModel>(
          builder: (context, viewModel, child) {
            if (viewModel.isLoading) {
              // Loading state with simple shimmer
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: GridView.builder(
                  itemCount: 4,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 1.2),
                  itemBuilder: (context, index) => Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              );
            }

            final surveyList = viewModel.notices ?? [];

            // No data or empty
            if (surveyList.isEmpty ||
                surveyList.every((s) => s.subjectsPending == null || s.subjectsPending!.isEmpty)) {
              return Center(child: BuildNoData(MediaQuery.of(context).size, "No active surveys available",Icons.question_answer));
            }

            // Flatten all subjectsPending from all surveys
            final subjects = surveyList
                .expand((s) => s.subjectsPending ?? [])
                .toList();

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.builder(
                itemCount: subjects.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.2,
                ),
                itemBuilder: (context, index) {
                  final subject = subjects[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        PageRouteBuilder(
                          pageBuilder: (context, animation, secondaryAnimation) =>
                          SurveyDetailPage(surveyKey: subject.surveyKey  ?? ''),
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
                        color: Colors.blue.shade500,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: const [
                          BoxShadow(
                              color: Colors.black26,
                              blurRadius: 4,
                              offset: Offset(0, 2))
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            subject.subjectName ?? '',
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "${subject.facultyName ?? ''} • ${subject.sectionId ?? ''} • ${subject.subjectCode ?? ''}",
                            style: TextStyle(
                                color: Colors.white.withOpacity(0.85),
                                fontSize: 12),
                          ),
                          const Align(
                            alignment: Alignment.bottomRight,
                            child: Icon(
                              Icons.check_circle,
                              color: Colors.white,
                              size: 24,
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
