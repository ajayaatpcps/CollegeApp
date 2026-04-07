class StudentProfileModel {
  int? studentId;
  String? stuFirstname;
  String? stuMiddlename;
  String? stuLastname;

  String? stuFirstnameNp;
  String? stuMiddlenameNp;
  String? stuLastnameNp;

  String? stuGender;
  String? studentStatus;
  String? profileStatus;

  String? stuRollNo;
  String? stuUnivRollNo;

  String? stuMobile;
  String? stuEmail;

  String? stuFatherName;
  String? stuMotherName;

  String? stuDateBirthBs;
  String? stuBirthPlace;
  String? stuBloodGroup;
  String? stuCaste;
  String? stuEthnicity;
  String? stuReligion;
  String? stuGroup;
  String? stuNationality;

  String? stuResCity;
  String? stuResState;
  String? stuResCountry;

  String? stuPerAdd;

  String? stuGurName;
  String? stuGurMobile;
  String? stuGurEmail;
  String? stuGurRelation;
  String? stuGurAdd;

  StudentProfileModel();

  StudentProfileModel.fromJson(Map<String, dynamic> json) {
    studentId = json['student_id'];

    stuFirstname = json['stu_firstname'];
    stuMiddlename = json['stu_middlename'];
    stuLastname = json['stu_lastname'];

    stuFirstnameNp = json['stu_firstname_np'];
    stuMiddlenameNp = json['stu_middlename_np'];
    stuLastnameNp = json['stu_lastname_np'];

    stuGender = json['stu_gender'];
    studentStatus = json['student_status'];
    profileStatus = json['profile_status'];

    stuRollNo = json['stu_roll_no'];
    stuUnivRollNo = json['stu_univ_roll_no'];

    stuMobile = json['stu_mobile'];
    stuEmail = json['stu_email'];

    stuFatherName = json['stu_father_name'];
    stuMotherName = json['stu_mother_name'];

    stuDateBirthBs = json['stu_date_birth_bs'];
    stuBirthPlace = json['stu_birth_place'];
    stuBloodGroup = json['stu_blood_group'];
    stuCaste = json['stu_caste'];
    stuEthnicity = json['stu_ethnicity'];
    stuReligion = json['stu_religion'];
    stuGroup = json['stu_group'];
    stuNationality = json['stu_nationality'];

    stuResCity = json['stu_res_city'];
    stuResState = json['stu_res_state'];
    stuResCountry = json['stu_res_country'];

    stuPerAdd = json['stu_per_add'];

    stuGurName = json['stu_gur_name'];
    stuGurMobile = json['stu_gur_mobile'];
    stuGurEmail = json['stu_gur_email'];
    stuGurRelation = json['stu_gur_relation'];
    stuGurAdd = json['stu_gur_add'];
  }

  Map<String, dynamic> toJson() {
    return {
      'student_id': studentId,
      'stu_firstname': stuFirstname,
      'stu_middlename': stuMiddlename,
      'stu_lastname': stuLastname,
      'stu_firstname_np': stuFirstnameNp,
      'stu_middlename_np': stuMiddlenameNp,
      'stu_lastname_np': stuLastnameNp,
      'stu_gender': stuGender,
      'student_status': studentStatus,
      'profile_status': profileStatus,
      'stu_roll_no': stuRollNo,
      'stu_univ_roll_no': stuUnivRollNo,
      'stu_mobile': stuMobile,
      'stu_email': stuEmail,
      'stu_father_name': stuFatherName,
      'stu_mother_name': stuMotherName,
      'stu_date_birth_bs': stuDateBirthBs,
      'stu_birth_place': stuBirthPlace,
      'stu_blood_group': stuBloodGroup,
      'stu_caste': stuCaste,
      'stu_ethnicity': stuEthnicity,
      'stu_religion': stuReligion,
      'stu_group': stuGroup,
      'stu_nationality': stuNationality,
      'stu_res_city': stuResCity,
      'stu_res_state': stuResState,
      'stu_res_country': stuResCountry,
      'stu_per_add': stuPerAdd,
      'stu_gur_name': stuGurName,
      'stu_gur_mobile': stuGurMobile,
      'stu_gur_email': stuGurEmail,
      'stu_gur_relation': stuGurRelation,
      'stu_gur_add': stuGurAdd,
    };
  }
}
