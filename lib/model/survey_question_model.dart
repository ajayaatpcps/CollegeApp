class SurveyQnaModel {
  int? surveyId;
  int? branchId;
  int? sessionId;
  String? publishDate;
  String? expiryDate;
  String? status;
  String? branchName;
  String? sessionName;
  String? surveyKey;
  List<Questions>? lQuestions;
  int? iTotalQuestions;

  SurveyQnaModel(
      {this.surveyId,
        this.branchId,
        this.sessionId,
        this.publishDate,
        this.expiryDate,
        this.status,
        this.branchName,
        this.sessionName,
        this.surveyKey,
        this.lQuestions,
        this.iTotalQuestions});

  SurveyQnaModel.fromJson(Map<String, dynamic> json) {
    surveyId = json['survey_id'];
    branchId = json['branch_id'];
    sessionId = json['session_id'];
    publishDate = json['publish_date'];
    expiryDate = json['expiry_date'];
    status = json['status'];
    branchName = json['branch_name'];
    sessionName = json['session_name'];
    surveyKey = json['survey_key'];
    if (json['_questions'] != null) {
      lQuestions = <Questions>[];
      json['_questions'].forEach((v) {
        lQuestions!.add(new Questions.fromJson(v));
      });
    }
    iTotalQuestions = json['_total_questions'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['survey_id'] = this.surveyId;
    data['branch_id'] = this.branchId;
    data['session_id'] = this.sessionId;
    data['publish_date'] = this.publishDate;
    data['expiry_date'] = this.expiryDate;
    data['status'] = this.status;
    data['branch_name'] = this.branchName;
    data['session_name'] = this.sessionName;
    data['survey_key'] = this.surveyKey;
    if (this.lQuestions != null) {
      data['_questions'] = this.lQuestions!.map((v) => v.toJson()).toList();
    }
    data['_total_questions'] = this.iTotalQuestions;
    return data;
  }
}

class Questions {
  int? questionId;
  String? question;
  String? answerType;

  Questions({this.questionId, this.question, this.answerType});

  Questions.fromJson(Map<String, dynamic> json) {
    questionId = json['question_id'];
    question = json['question'];
    answerType = json['answer_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['question_id'] = this.questionId;
    data['question'] = this.question;
    data['answer_type'] = this.answerType;
    return data;
  }
}
