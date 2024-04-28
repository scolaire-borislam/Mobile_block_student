class Programme {
   String progCode;
   String progProvider;
   String faculty;
   String progName;
   String? area;
   String? duration;
   String? entryReqEng;
   String? entryReqGeneral;
   String? entryReqOther;
   String? modeOfStudy;
   String? progDesc;
   String? img1;
   String? img2;
   String? y1TuitionFee;
   String? y2TuitionFee;
   String? y3TuitionFee;
   String? featured;

  Programme({
    required this.progCode,
    required this.progProvider,
    required this.faculty,
    required this.progName,
    this.area,
    this.duration,
    this.entryReqEng,
    this.entryReqGeneral,
    this.entryReqOther,
    this.modeOfStudy,
    this.progDesc,
    this.img1,
    this.img2,
    this.y1TuitionFee,
    this.y2TuitionFee,
    this.y3TuitionFee,
    this.featured,
  });

  factory Programme.fromJson(Map<String, dynamic> json) {
    return Programme(
      progCode: json['prog_code'],
      progProvider: json['prog_provider'],
      faculty: json['faculty'],
      progName: json['prog_name'],
      area: json['area'],
      duration: json['duration'],
      entryReqEng: json['entry_req_eng'],
      entryReqGeneral: json['entry_req_general'],
      entryReqOther: json['entry_req_other'],
      modeOfStudy: json['mode_of_study'],
      progDesc: json['prog_desc'],
      img1: json['img1'],
      img2: json['img2'],
      y1TuitionFee: json['y1_tuition_fee'],
      y2TuitionFee: json['y2_tuition_fee'],
      y3TuitionFee: json['y3_tuition_fee'],
      featured: json['featured'],
    );
  }
}