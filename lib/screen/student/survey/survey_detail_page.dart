import 'package:flutter/material.dart';
import 'package:lbef/utils/parse_date.dart';
import 'package:lbef/view_model/survery_view_model.dart';
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
    setState(() {
      _submitting = true;
    });

    final surveyDetails = vm.currentDetails;
    if (surveyDetails == null) return;

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

      // Refresh survey list and current survey details
      await vm.fetch(context); // Refresh the main survey list
      await vm.getSurveyDetails(surveyDetails.surveyKey!, context); // Refresh current survey details
    }

    setState(() {
      _submitting = false;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Survey Detail"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Consumer<SurveryViewModel>(
        builder: (context, vm, child) {
          if (vm.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final survey = vm.currentDetails;

          if (survey == null) {
            return const Center(
              child: Text("Failed to load survey details."),
            );
          }

          if (_submitted) {
            return const Center(
              child: Text(
                "✅ Thank you! Your feedback has been submitted successfully.",
                style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            );
          }

          final likertLabels = [
            "Strongly Disagree",
            "Disagree",
            "Neutral",
            "Agree",
            "Strongly Agree"
          ];

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Survey Meta Info
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Status: ${survey.status ?? '-'}"),
                      const SizedBox(height: 4),
                      Text(
                          "Publish: ${survey.publishDate!=null? parseDate(survey.publishDate.toString()): '-'} | Expiry: ${survey.expiryDate !=null? parseDate(survey.publishDate.toString()): '-'}"),
                      const SizedBox(height: 8),
                      Text(
                        "Total Questions: ${survey.lQuestions?.length ?? 0}",
                        style: const TextStyle(fontWeight: FontWeight.bold),
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
                   color: Colors.white,
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
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          const SizedBox(height: 12),
                          if (q.answerType == "Likert1to5")
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: List.generate(5, (i) {
                                return Column(
                                  children: [
                                    Radio<int>(
                                      value: i + 1,
                                      groupValue: _answers[q.questionId.toString()],
                                      onChanged: (val) =>
                                          _handleChange(q.questionId.toString(), val),
                                    ),
                                    Text(
                                      likertLabels[i],
                                      style: const TextStyle(fontSize: 10),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                );
                              }),
                            ),
                          if (q.answerType == "Likert1to10")
                            Wrap(
                              spacing: 8,
                              children: List.generate(10, (i) {
                                return Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Radio<int>(
                                      value: i + 1,
                                      groupValue: _answers[q.questionId.toString()],
                                      onChanged: (val) =>
                                          _handleChange(q.questionId.toString(), val),
                                    ),
                                    Text("${i + 1}", style: const TextStyle(fontSize: 12))
                                  ],
                                );
                              }),
                            ),
                          if (q.answerType == "SingleLine")
                            TextField(
                              onChanged: (val) =>
                                  _handleChange(q.questionId.toString as String, val),
                              decoration: const InputDecoration(
                                  hintText: "Type your answer..."),
                            ),
                          if (q.answerType == "MultiLine")
                            TextField(
                              onChanged: (val) =>
                                  _handleChange(q.questionId.toString(), val),
                              decoration: const InputDecoration(
                                  hintText: "Write your answer..."),
                              minLines: 3,
                              maxLines: 6,
                            ),
                        ],
                      ),
                    ),
                  );
                }).toList(),

                // Submit button
                Center(
                  child: ElevatedButton(
                    onPressed: _submitting ? null : _handleSubmit,
                    child: Text(_submitting ? "Submitting..." : "Submit Feedback"),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
