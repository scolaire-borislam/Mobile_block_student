class Application {
  String? uid;  // pk
  String? appId; //sk
  String surname;
  String givenName;
  String idDocNo;
  String gender;
  DateTime dob;
  String email;
  String mobileContact;
  String contractAddress;
  bool? SEN;
  String? senDetail;
  String progCode;
  String progName;
  String progProvider;
  String? modeOfStudy;
  String? entryYear;
  String? intakeTerms;

  String? hkdseCertPath;
  String? otherCertPath;
  String? photoPath;
  String? idDocPath;
  String? educationQualification1;
  String? educationQualification2;
  String? educationQualification3;
  String? professionalQualification1;
  String? professionalQualification2;
  String? professionalQualification3;
  String? createDate;
  String? status;

  Application({
    this.uid,
    this.appId,
    required this.surname,
    required this.givenName,
    required this.idDocNo,
    required this.gender,
    required this.dob,
    required this.email,
    required this.mobileContact,
    required this.contractAddress,
    this.SEN,
    required this.progCode,
    required this.progName,
    required this.progProvider,
    this.modeOfStudy,
    this.entryYear,
    this.senDetail,
    this.intakeTerms,
    this.hkdseCertPath,
    this.otherCertPath,
    this.photoPath,
    this.idDocPath,
    this.educationQualification1,
    this.educationQualification2,
    this.educationQualification3,
    this.professionalQualification1,
    this.professionalQualification2,
    this.professionalQualification3,
    this.createDate,
    this.status,
  });

  static DateTime parseDateTimeFromString(String dateTimeString) {
    print(dateTimeString);
    String year = dateTimeString.substring(0, 4);
    String month = dateTimeString.substring(4, 6);
    String day = dateTimeString.substring(6, 8);
    String hour = dateTimeString.substring(9, 11);
    String minute = dateTimeString.substring(11, 13);
    String second = dateTimeString.substring(13, 15);

    DateTime dateTime = DateTime.parse("$year$month$day-$hour$minute$second");

    return dateTime;
  }

  factory Application.fromJson(Map<String, dynamic> json) {
    print(json);
    Application app = Application(
      uid: json['pk'] !=null ? json['pk'] as String? : '',
      appId: json['sk'] !=null ? json['sk'] as String? : '',
      surname: json['surname'] !=null ? json['surname'] as String :'',
      givenName: json['given_name'] !=null ? json['given_name'] as String :'',
      idDocNo: json['id_doc_no'] !=null ? json['id_doc_no'] as String : '',
      gender:json['gender'] !=null?  json['gender'] as String :'',
      dob: DateTime.tryParse(json['dob'] as String) ?? DateTime.now(),
      //dob:  DateTime.now(),
      email: json['email'] !=null?  json['email'] as String : '',
      mobileContact: json['mobile'] !=null ? json['mobile'] as String :'',
      contractAddress: json['address'] !=null?  json['address'] as String : '',
      SEN: json['SEN'] !=null?  json['SEN'] as bool? : false,
      senDetail: json['sen_detail'] !=null?  json['sen_detail'] as String? :'',
      progCode: json['prog_code'] !=null?  json['prog_code'] as String :'',
      progName: json['prog_name'] !=null? json['prog_name'] as String :'',
      progProvider: json['prog_provider'] !=null?  json['prog_provider'] as String:'' ,
      modeOfStudy: json['mode_of_study'] !=null?  json['mode_of_study'] as String?:'',
      entryYear: json['entry_year'] !=null?   json['entry_year'] as String? :'',
      intakeTerms: json['intake_terms'] !=null? json['intake_terms'] as String? :'',
      hkdseCertPath: json['hkdse_cert_url'] !=null? json['hkdse_cert_url'] as String? :'',
      otherCertPath: json['other_cert_url'] !=null? json['other_cert_url'] as String? :'',
      photoPath: json['photo_path'] !=null? json['photo_path'] as String? : null,
      idDocPath: json['id_doc_path'] !=null? json['id_doc_path'] as String? : null,
      educationQualification1: json['education_qualification1'] !=null? json['education_qualification1'] as String? :null,
      educationQualification2: json['education_qualification2'] !=null? json['education_qualification2'] as String? : null,
      educationQualification3: json['education_qualification3'] !=null? json['education_qualification3'] as String? : null,
      professionalQualification1: json['professional_qualification1'] !=null? json['professional_qualification1'] as String? : null,
      professionalQualification2: json['professional_qualification2'] !=null? json['professional_qualification2'] as String? : null,
      professionalQualification3: json['professional_qualification3'] !=null? json['professional_qualification3'] as String? : null,
      //createDate: json['create_date'] != null ? Application.parseDateTimeFromString(json['create_date'] as String) : null,
      //createDate: DateTime.tryParse(json['create_date'] as String) ,
      //createDate: DateTime.parse((json['create_date'] as String).substring(0, 8) + 'T' + (json['create_date'] as String).substring(9, 15)),
      createDate: json['create_date'] !=null? json['create_date'] as String? : null,
      //createDate: '',
      status: json['status'] != null ? json['status'] as String? : null ,
    );
    return app;
  }



  Map<String, dynamic> toJsonMap() {
    final Map<String, dynamic> json = {
      'surname': surname,
      'given_name': givenName,
      'id_doc_no': idDocNo,
      'gender': gender,
      'dob': dob.toIso8601String(),
      'email': email,
      'mobile': mobileContact,
      'address': contractAddress,

      'prog_code': progCode,
      'prog_name': progName,
      'prog_provider': progProvider,

    };

    // Add optional fields if they are not empty or null

    if (SEN != null) json['SEN'] = SEN;
    if (modeOfStudy != null) json['mode_of_study'] = modeOfStudy;
    if (entryYear != null) json['entry_year'] = entryYear;
    if (senDetail != null) json['sen_detail'] = senDetail;
    if (intakeTerms != null) json['intake_terms'] = intakeTerms;
    if (hkdseCertPath != null) json['hkdse_cert_path'] = hkdseCertPath;
    if (otherCertPath != null) json['other_cert_path'] = otherCertPath;
    if (photoPath != null) json['photo_path'] = photoPath;
    if (idDocPath != null) json['id_doc_path'] = idDocPath;
    if (educationQualification1 != null) json['education_qualification1'] = educationQualification1;
    if (educationQualification2 != null) json['education_qualification2'] = educationQualification2;
    if (educationQualification3 != null) json['education_qualification3'] = educationQualification3;
    if (professionalQualification1 != null) json['professional_qualification1'] = professionalQualification1;
    if (professionalQualification2 != null) json['professional_qualification2'] = professionalQualification2;
    if (professionalQualification3 != null) json['professional_qualification3'] = professionalQualification3;
    //if (createDate != null) json['create_date'] = createDate!.toIso8601String();
    if (createDate != null) json['create_date'] = createDate;
    if (status != null) json['status'] = status;
    if (appId != null) json['sk'] = appId;
    if (uid != null) json['pk'] = uid;

    return json;
  }


  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;

    final Application otherApp = other as Application;

    return
      uid == otherApp.uid &&
      appId == otherApp.appId &&
        surname == otherApp.surname &&
        givenName == otherApp.givenName &&
        idDocNo == otherApp.idDocNo &&
        gender == otherApp.gender &&
        dob == otherApp.dob &&
        email == otherApp.email &&
        mobileContact == otherApp.mobileContact &&
        contractAddress == otherApp.contractAddress &&
        SEN == otherApp.SEN &&
        senDetail == otherApp.senDetail &&
        progCode == otherApp.progCode &&
        progName == otherApp.progName &&
        progProvider == otherApp.progProvider &&
        modeOfStudy == otherApp.modeOfStudy &&
        entryYear == otherApp.entryYear &&
        intakeTerms == otherApp.intakeTerms &&
        hkdseCertPath == otherApp.hkdseCertPath &&
        otherCertPath == otherApp.otherCertPath &&
        photoPath == otherApp.photoPath &&
        idDocPath == otherApp.idDocPath &&
        educationQualification1 == otherApp.educationQualification1 &&
        educationQualification2 == otherApp.educationQualification2 &&
        educationQualification3 == otherApp.educationQualification3 &&
        professionalQualification1 == otherApp.professionalQualification1 &&
        professionalQualification2 == otherApp.professionalQualification2 &&
        professionalQualification3 == otherApp.professionalQualification3 &&
        createDate == otherApp.createDate &&
        status == otherApp.status;
  }

  @override
  int get hashCode {
    return Object.hashAll([
      uid,
      appId,
      surname,
      givenName,
      idDocNo,
      gender,
      dob,
      email,
      mobileContact,
      contractAddress,
      SEN,
      senDetail,
      progCode,
      progName,
      progProvider,
      modeOfStudy,
      entryYear,
      intakeTerms,
      hkdseCertPath,
      otherCertPath,
      photoPath,
      idDocPath,
      educationQualification1,
      educationQualification2,
      educationQualification3,
      professionalQualification1,
      professionalQualification2,
      professionalQualification3,
      createDate,
      status,
    ]);
  }


}