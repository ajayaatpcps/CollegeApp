class SurveyModel {
  int? surveyId;
  int? branchId;
  int? sessionId;
  String? publishDate;
  String? expiryDate;
  String? status;
  String? branchName;
  String? sessionName;
  int? totalQuestions;
  List<SubjectsPending>? subjectsPending;

  SurveyModel(
      {this.surveyId,
        this.branchId,
        this.sessionId,
        this.publishDate,
        this.expiryDate,
        this.status,
        this.branchName,
        this.sessionName,
        this.totalQuestions,
        this.subjectsPending});

  SurveyModel.fromJson(Map<String, dynamic> json) {
    surveyId = json['survey_id'];
    branchId = json['branch_id'];
    sessionId = json['session_id'];
    publishDate = json['publish_date'];
    expiryDate = json['expiry_date'];
    status = json['status'];
    branchName = json['branch_name'];
    sessionName = json['session_name'];
    totalQuestions = json['total_questions'];
    if (json['subjects_pending'] != null) {
      subjectsPending = <SubjectsPending>[];
      json['subjects_pending'].forEach((v) {
        subjectsPending!.add(new SubjectsPending.fromJson(v));
      });
    }
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
    data['total_questions'] = this.totalQuestions;
    if (this.subjectsPending != null) {
      data['subjects_pending'] =
          this.subjectsPending!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SubjectsPending {
  int? subjectId;
  String? sectionId;
  String? subjectName;
  String? subjectCode;
  String? semesterName;
  int? facultyPlanId;
  int? facultyId;
  String? facultyName;
  String? sessionName;
  String? surveyKey;

  SubjectsPending(
      {this.subjectId,
        this.sectionId,
        this.subjectName,
        this.subjectCode,
        this.semesterName,
        this.facultyPlanId,
        this.facultyId,
        this.facultyName,
        this.sessionName,
        this.surveyKey});

  SubjectsPending.fromJson(Map<String, dynamic> json) {
    subjectId = json['subject_id'];
    sectionId = json['section_id'];
    subjectName = json['subject_name'];
    subjectCode = json['subject_code'];
    semesterName = json['semester_name'];
    facultyPlanId = json['faculty_plan_id'];
    facultyId = json['faculty_id'];
    facultyName = json['faculty_name'];
    sessionName = json['session_name'];
    surveyKey = json['survey_key'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['subject_id'] = this.subjectId;
    data['section_id'] = this.sectionId;
    data['subject_name'] = this.subjectName;
    data['subject_code'] = this.subjectCode;
    data['semester_name'] = this.semesterName;
    data['faculty_plan_id'] = this.facultyPlanId;
    data['faculty_id'] = this.facultyId;
    data['faculty_name'] = this.facultyName;
    data['session_name'] = this.sessionName;
    data['survey_key'] = this.surveyKey;
    return data;
  }
}
