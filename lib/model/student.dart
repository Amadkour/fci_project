/// id : 0
/// name : ""
/// level : ""
/// dept : ""

class Student {
  Student({
      int id, 
      String name, 
      String level, 
      String dept,}){
    _id = id;
    _name = name;
    _level = level;
    _dept = dept;
}

  Student.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _level = json['level'];
    _dept = json['dept'];
  }
  int _id;
  String _name;
  String _level;
  String _dept;

  int get id => _id;
  String get name => _name;
  String get level => _level;
  String get dept => _dept;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['level'] = _level;
    map['dept'] = _dept;
    return map;
  }

}