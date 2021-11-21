class CourseActivity {
  CourseActivity({
      int courseID, 
      int activityID,
  String name}){
    _courseID = courseID;
    _activityID = activityID;
    this.name=name;
}

  CourseActivity.fromJson(dynamic json) {
    _courseID = json['course_id'];
    _activityID = json['activity_id'];
    name = json['name'];
  }
  int _courseID;
  int _activityID;
  String name;

  int get courseID => _courseID;
  int get activityID => _activityID;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['course_id'] = _courseID;
    map['activity_id'] = _activityID;
    return map;
  }

}