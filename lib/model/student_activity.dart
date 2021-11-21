/// student_id : 0
/// course_id : 0
/// activity_id : 0
/// degree : 0
/// week : 0

class StudentActivity {
  StudentActivity(
      {int studentId,
      int courseId,
      int activityId,
      int degree=0,
      int week=1,
      String name,
      String label}) {
    _studentId = studentId;
    _courseId = courseId;
    _activityId = activityId;
    _degree = degree;
    _week = week;
    _name = name;
    _label = label;
  }

  StudentActivity.fromJson(dynamic json) {
    _studentId = json['student_id']??0;
    _courseId = json['course_id']??0;
    _activityId = json['activity_id']??0;
    _degree = json['degree']??0;
    _week = json['week']??0;
    _name = json['name']??'';
    _label = json['label']??'';
  }

  int _studentId;
  int _courseId;
  int _activityId;
  int _degree;
  int _week;
  String _name;
  String _label;

  int get studentId => _studentId;

  int get courseId => _courseId;

  int get activityId => _activityId;

  int get degree => _degree;

  int get week => _week;

  String get name => _name;

  String get label => _label;

  Map<String, dynamic> toJsonDB() {
    final map = <String, dynamic>{};
    map['student_id'] = _studentId;
    map['course_id'] = _courseId;
    map['activity_id'] = _activityId;
    map['degree'] = _degree;
    map['week'] = _week;
    return map;
  }Map<String, dynamic> toJsonExcel() {
    final map = <String, dynamic>{};
    map['student_id'] = _studentId;
    map['course_id'] = _courseId;
    map['activity_id'] = _activityId;
    map['degree'] = _degree;
    map['week'] = _week;
    map['name'] = _name;
    map['label'] = _label;
    return map;
  }
}
