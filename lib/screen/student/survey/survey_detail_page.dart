import 'package:flutter/material.dart';
import 'package:lbef/utils/parse_date.dart';
import 'package:lbef/view_model/survery_view_model.dart';
import 'package:lbef/widgets/form_widget/custom_button.dart';
import 'package:lbef/view_model/theme_provider.dart';
import 'package:provider/provider.dart';

class SurveyDetailPage extends StatefulWidget {
  final String surveyKey;
  const SurveyDetailPage({super.key, required this.surveyKey});

  @override
  State<SurveyDetailPage> createState() => _SurveyDetailPageState();
}

class _SurveyDetailPageState extends State<SurveyDetailPage> {
  final Map<String, dynamic> _answers = {};
  bool _submitted = false;
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<SurveryViewModel>(context, listen: false)
          .getSurveyDetails(widget.surveyKey, context);
    });
  }

  void _handleChange(String questionId, dynamic value) {
    setState(() {
      _answers[questionId] = value;
    });
  }

  Future<void> _handleSubmit() async {
    final vm = Provider.of<SurveryViewModel>(context, listen: false);
    final surveyDetails = vm.currentDetails;

    if (surveyDetails == null) return;

    final unanswered = surveyDetails.lQuestions
        ?.where((q) =>
    !_answers.containsKey(q.questionId.toString()) ||
        _answers[q.questionId.toString()] == null)
        .toList() ??
        [];

    if (unanswered.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please answer all questions before submitting."),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    setState(() {
      _submitting = true;
    });

    final payload = {
      "survey_key": surveyDetails.surveyKey,
      "answers": _answers.entries
          .map((e) => {"question_id": e.key, "answer": e.value})
          .toList()
    };

    final success = await vm.submit(payload, context);

    if (success) {
      setState(() {
        _submitted = true;
      });

      await vm.fetch(context);
      await vm.getSurveyDetails(surveyDetails.surveyKey!, context);
    }

    setState(() {
      _submitting = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 400;

    return Consumer2<SurveryViewModel, ThemeProvider>(
      builder: (context, vm, themeProvider, child) {
        return Scaffold(
          backgroundColor:
          themeProvider.isDarkMode ? Colors.black : Colors.white,
          appBar: AppBar(
            title: const Text("Survey Detail"),
            backgroundColor:
            themeProvider.isDarkMode ? Colors.black : Colors.white,
            foregroundColor:
            themeProvider.isDarkMode ? Colors.white : Colors.black,
            leading: IconButton(
              icon: Icon(Icons.arrow_back,
                  color: themeProvider.isDarkMode ? Colors.white : Colors.black),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          body: vm.isLoading
              ? const Center(child: CircularProgressIndicator())
              : Builder(builder: (context) {
            final survey = vm.currentDetails;
            if (survey == null) {
              return Center(
                  child: Text(
                    "Failed to load survey details.",
                    style: TextStyle(
                        color: themeProvider.isDarkMode
                            ? Colors.white70
                            : Colors.black),
                  ));
            }

            if (_submitted) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    "✅ Thank you! Your feedback has been submitted successfully.",
                    style: const TextStyle(
                        color: Colors.green, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Survey Info
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Status: ${survey.status ?? '-'}",
                          style: TextStyle(
                              color: themeProvider.isDarkMode
                                  ? Colors.white70
                                  : Colors.black),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Publish: ${survey.publishDate != null ? parseDate(survey.publishDate.toString()) : '-'}"
                              " | Expiry: ${survey.expiryDate != null ? parseDate(survey.expiryDate.toString()) : '-'}",
                          style: TextStyle(
                              fontSize: isSmallScreen ? 12 : 14,
                              color: themeProvider.isDarkMode
                                  ? Colors.white70
                                  : Colors.black),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Total Questions: ${survey.lQuestions?.length ?? 0}",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: themeProvider.isDarkMode
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Questions
                  ...?survey.lQuestions?.asMap().entries.map((entry) {
                    final index = entry.key;
                    final q = entry.value;
                    return Card(
                      color: themeProvider.isDarkMode
                          ? Colors.grey[900]
                          : Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      margin: const EdgeInsets.only(bottom: 16),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${index + 1}. ${q.question ?? ''}",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: isSmallScreen ? 14 : 16,
                                color: themeProvider.isDarkMode
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                            const SizedBox(height: 12),

                            // Likert 1 to 5
                            if (q.answerType == "Likert1to5")
                              Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 6),
                                    child: Text(
                                      "Strongly Disagree → Strongly Agree",
                                      style: TextStyle(
                                        fontSize:
                                        isSmallScreen ? 10 : 12,
                                        color: themeProvider.isDarkMode
                                            ? Colors.white60
                                            : Colors.grey[700],
                                      ),
                                    ),
                                  ),
                                  Wrap(
                                    alignment: WrapAlignment.spaceBetween,
                                    spacing: 8,
                                    children: List.generate(5, (i) {
                                      return Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Radio<int>(
                                            value: i + 1,
                                            groupValue: _answers[q
                                                .questionId
                                                .toString()],
                                            onChanged: (val) =>
                                                _handleChange(
                                                    q.questionId
                                                        .toString(),
                                                    val),
                                          ),
                                          Text(
                                            "${i + 1}",
                                            style: TextStyle(
                                                fontSize:
                                                isSmallScreen ? 10 : 12,
                                                color: themeProvider
                                                    .isDarkMode
                                                    ? Colors.white70
                                                    : Colors.black),
                                          ),
                                        ],
                                      );
                                    }),
                                  ),
                                ],
                              ),

                            // Likert 1 to 10
                            if (q.answerType == "Likert1to10")
                              Wrap(
                                spacing: 6,
                                runSpacing: 4,
                                children: List.generate(10, (i) {
                                  return Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Radio<int>(
                                        value: i + 1,
                                        groupValue: _answers[
                                        q.questionId.toString()],
                                        onChanged: (val) => _handleChange(
                                            q.questionId.toString(),
                                            val),
                                      ),
                                      Text("${i + 1}",
                                          style: TextStyle(
                                              fontSize:
                                              isSmallScreen ? 10 : 12,
                                              color: themeProvider
                                                  .isDarkMode
                                                  ? Colors.white70
                                                  : Colors.black)),
                                    ],
                                  );
                                }),
                              ),

                            // Text Inputs
                            if (q.answerType == "SingleLine")
                              TextField(
                                onChanged: (val) => _handleChange(
                                    q.questionId.toString(), val),
                                decoration: InputDecoration(
                                  hintText: "Type your answer...",
                                  border: const OutlineInputBorder(),
                                  fillColor: themeProvider.isDarkMode
                                      ? Colors.grey[800]
                                      : Colors.white,
                                  filled: true,
                                ),
                                style: TextStyle(
                                    color: themeProvider.isDarkMode
                                        ? Colors.white
                                        : Colors.black),
                              ),
                            if (q.answerType == "MultiLine")
                              TextField(
                                onChanged: (val) => _handleChange(
                                    q.questionId.toString(), val),
                                decoration: InputDecoration(
                                  hintText: "Write your answer...",
                                  border: const OutlineInputBorder(),
                                  fillColor: themeProvider.isDarkMode
                                      ? Colors.grey[800]
                                      : Colors.white,
                                  filled: true,
                                ),
                                minLines: 3,
                                maxLines: 6,
                                style: TextStyle(
                                    color: themeProvider.isDarkMode
                                        ? Colors.white
                                        : Colors.black),
                              ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),

                  const SizedBox(height: 20),

                  // Submit Button
                  Center(
                    child: CustomButton(
                      text: _submitting
                          ? "Submitting..."
                          : "Submit Feedback",
                      onPressed: _submitting ? () {} : _handleSubmit,
                      isLoading: _submitting,
                      btnwid: isSmallScreen ? size.width * 0.9 : 300,
                    ),
                  ),
                ],
              ),
            );
          }),
        );
      },
    );
  }
}
