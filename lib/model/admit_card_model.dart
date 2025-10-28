class AdmitCardModel {
  int? examFormId;
  String? studentName;
  String? stuRollNo;
  String? stuUnivRollNo;
  String? courseShortName;
  String? semesterName;
  String? examName;
  String? examStart;
  String? instructions;
  String? venue;
  bool? allowPrint;
  List<Subjects>? subjects;

  AdmitCardModel(
      {this.examFormId,
        this.studentName,
        this.stuRollNo,
        this.stuUnivRollNo,
        this.courseShortName,
        this.semesterName,
        this.examName,
        this.examStart,
        this.instructions,
        this.venue,
        this.allowPrint,
        this.subjects});

  AdmitCardModel.fromJson(Map<String, dynamic> json) {
    examFormId = json['exam_form_id'];
    studentName = json['student_name'];
    stuRollNo = json['stu_roll_no'];
    stuUnivRollNo = json['stu_univ_roll_no'];
    courseShortName = json['course_short_name'];
    semesterName = json['semester_name'];
    examName = json['exam_name'];
    examStart = json['exam_start'];
    instructions = json['instructions'];
    venue = json['venue'];
    allowPrint = json['allowPrint'];
    if (json['subjects'] != null) {
      subjects = <Subjects>[];
      json['subjects'].forEach((v) {
        subjects!.add(new Subjects.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['exam_form_id'] = this.examFormId;
    data['student_name'] = this.studentName;
    data['stu_roll_no'] = this.stuRollNo;
    data['stu_univ_roll_no'] = this.stuUnivRollNo;
    data['course_short_name'] = this.courseShortName;
    data['semester_name'] = this.semesterName;
    data['exam_name'] = this.examName;
    data['exam_start'] = this.examStart;
    data['instructions'] = this.instructions;
    data['venue'] = this.venue;
    data['allowPrint'] = this.allowPrint;
    if (this.subjects != null) {
      data['subjects'] = this.subjects!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Subjects {
  int? formSubjectId;
  String? examType;
  String? examRoom;
  int? attendanceClearance;
  String? subjectCode;
  String? subjectName;
  String? regularDate;
  String? referralDate;
  String? retakeDate;
  String? regularTime;
  String? referralTime;
  String? retakeTime;

  Subjects(
      {this.formSubjectId,
        this.examType,
        this.examRoom,
        this.attendanceClearance,
        this.subjectCode,
        this.subjectName,
        this.regularDate,
        this.referralDate,
        this.retakeDate,
        this.regularTime,
        this.referralTime,
        this.retakeTime});

  Subjects.fromJson(Map<String, dynamic> json) {
    formSubjectId = json['form_subject_id'];
    examType = json['exam_type'];
    examRoom = json['exam_room'];
    attendanceClearance = json['attendance_clearance'];
    subjectCode = json['subject_code'];
    subjectName = json['subject_name'];
    regularDate = json['regular_date'];
    referralDate = json['referral_date'];
    retakeDate = json['retake_date'];
    regularTime = json['regular_time'];
    referralTime = json['referral_time'];
    retakeTime = json['retake_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['form_subject_id'] = this.formSubjectId;
    data['exam_type'] = this.examType;
    data['exam_room'] = this.examRoom;
    data['attendance_clearance'] = this.attendanceClearance;
    data['subject_code'] = this.subjectCode;
    data['subject_name'] = this.subjectName;
    data['regular_date'] = this.regularDate;
    data['referral_date'] = this.referralDate;
    data['retake_date'] = this.retakeDate;
    data['regular_time'] = this.regularTime;
    data['referral_time'] = this.referralTime;
    data['retake_time'] = this.retakeTime;
    return data;
  }
}
