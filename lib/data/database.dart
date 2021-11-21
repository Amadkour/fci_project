import 'dart:collection';
import 'dart:io';
import 'package:fci_project/model/activity.dart';
import 'package:fci_project/model/course.dart';
import 'package:fci_project/model/course_activity.dart';
import 'package:fci_project/model/student.dart';
import 'package:fci_project/model/student_activity.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class FCIDatabaseHelper {
  static Database _productDb;
  static FCIDatabaseHelper _productDatabaseHelper;

  ///----------------(tables of DB)---------------///
  String courseTable = 'course';
  String activityTable = 'activity';
  String courseActivityTable = 'course_activity';
  String studentTable = 'student';
  String sectionTable = 'section';
  String studentActivityTable = 'activity_student';

  ///----------------(course attr)----------------///
  String courseId = 'id';
  String courseName = 'name';

  ///----------------(student attr)----------------///
  String studentId = 'id';
  String studentName = 'name';
  String studentLevel = 'level';
  String studentDept = 'dept';

  ///----------------(student activity attr)----------------///
  String stdId = 'student_id';
  String stdCourseId = 'course_id';
  String stdActivityId = 'activity_id';
  String degree = 'degree';
  String week = 'week';

  ///-------------(activity attr)-----------------///
  String activityId = 'id';
  String activityName = 'name';

  ///------------(course activity attr)----------///
  String actId = 'activity_id';
  String crsId = 'course_id';

  ///-------------(section attr)----------------///
  String sectionId = 'id';
  String sectionType = 'type';
  String sectionName = 'name';

  FCIDatabaseHelper._createInstance();

  static final FCIDatabaseHelper db = FCIDatabaseHelper._createInstance();

  factory FCIDatabaseHelper() {
    if (_productDatabaseHelper == null) {
      _productDatabaseHelper = FCIDatabaseHelper._createInstance();
    }
    return _productDatabaseHelper;
  }

  Future<Database> get database async {
    if (_productDb == null) {
      _productDb = await initializeDatabase();
    }
    return _productDb;
  }

  ///-----------------------------(course)-----------------------///
  Future<List<Map<String, dynamic>>> getCourseMapList() async {
    Database db = await this.database;
    var result = await db.query(courseTable, orderBy: "$courseName ASC");
    return result;
  }

  Future<int> insertCourse(Course course) async {
    Database db = await this.database;
    var result = await db.insert(courseTable, course.toJson());
    print(result);
    return result;
  }

  Future<int> updateCourse(Course course) async {
    var db = await this.database;
    var result = await db.update(courseTable, course.toJson(),
        where: '$courseId = ?', whereArgs: [course.id]);
    return result;
  }

  Future<int> deleteCourse(Course course) async {
    var db = await this.database;
    int result = await db
        .delete(courseTable, where: '$courseId = ?', whereArgs: [course.id]);
    return result;
  }

  Future<List<Course>> getCourseList() async {
    var productMapList = await getCourseMapList();
    int count = await getCount(courseTable);

    List<Course> productList = [];
    for (int i = 0; i < count; i++) {
      productList.add(Course.fromJson(productMapList[i]));
    }
    return productList;
  }
  Future<List> getStudentCourseMapList(
      courseId) async {
    Database db = await this.database;
    var result = await db.rawQuery(
        "select $studentTable.$studentName name, $activityTable.$activityName activity, $studentActivityTable.$degree degree"
            " from $studentActivityTable "
            " join $activityTable  ON $studentActivityTable.$stdActivityId = $activityTable.$activityId "
            " join $studentTable  ON $studentTable.$studentId = $studentActivityTable.$stdId "
            // "left join $courseActivityTable on $courseActivityTable.$actId = $studentActivityTable.$stdActivityId"
           " WHERE $studentActivityTable.$crsId = $courseId"
            // " Order By $activityTable.$studentName"
    );
    print(result);
    String name="";
    List l2=[];
    for(Map<String, dynamic> l in result){
      if(l['name']!=name){
        print(l['name']);
        l2.add({"name":l['name'],"degree":[l['degree']],"activity":[l['activity']]});
      }else{
        l2.setAll(l2.length-1,[{"name":name,"degree":l2.last['degree']+[l['degree']],"activity":l2.last['activity']+[l['activity']]}]);
      }
      name=l['name'];
    }
    print(l2);
    return l2;
  }
  ///-----------------------------(Activity)-----------------------///
  Future<List<Map<String, dynamic>>> getActivityMapList() async {
    Database db = await this.database;
    var result = await db.query(activityTable, orderBy: "$activityName ASC");
    return result;
  }

  Future<int> insertActivity(Activity activity) async {
    Database db = await this.database;
    var result = await db.insert(activityTable, activity.toJson());
    print(result);
    return result;
  }

  Future<int> updateActivity(Activity activity) async {
    var db = await this.database;
    var result = await db.update(activityTable, activity.toJson(),
        where: '$activityId = ?', whereArgs: [activity.id]);
    return result;
  }

  Future<int> deleteActivity(Activity activity) async {
    var db = await this.database;
    int result = await db.delete(activityTable,
        where: '$activityId = ?', whereArgs: [activity.id]);
    return result;
  }

  Future<List<Activity>> getActivityList() async {
    var mapList = await getActivityMapList();
    int count = await getCount(activityTable);
    List<Activity> list = [];
    for (int i = 0; i < count; i++) {
      list.add(Activity.fromJson(mapList[i]));
    }
    return list;
  }

  ///-----------------------------(Student)-----------------------///
  Future<List<Map<String, dynamic>>> getStudentMapList() async {
    Database db = await this.database;
    var result = await db.query(studentTable, orderBy: "$studentName ASC");
    print(result);
    return result;
  }
  Future<List<Map<String, dynamic>>> getSpecificStudentMapList(id) async {
    Database db = await this.database;
    var result = await db.query(studentTable, orderBy: "$studentName ASC",where: '$studentId = ?', whereArgs: [id]);
    print(result);
    return result;
  }
  Future<int> insertStudent(Student student) async {
    Database db = await this.database;
    var result = await db.insert(studentTable, student.toJson());
    return result;
  }

  Future<int> updateStudent(Student student) async {
    var db = await this.database;
    var result = await db.update(studentTable, student.toJson(),
        where: '$studentId = ?', whereArgs: [student.id]);
    return result;
  }

  Future<int> deleteStudent(Student student) async {
    var db = await this.database;
    int result = await db
        .delete(studentTable, where: '$studentId = ?', whereArgs: [student.id]);
    return result;
  }

  Future<List<Map<String, dynamic>>> updateStudentActivityName(
      int newActivityId, int courseId, int oldActivityId) async {
    var db = await this.database;
    var result = await db.rawQuery("UPDATE $studentActivityTable"
        " SET $stdActivityId =  $newActivityId "
        "WHERE $stdCourseId =  $courseId And "
        "$stdActivityId =  $oldActivityId ;");
    print(result);
    return result;
  }

  Future<List<Student>> getStudentList() async {
    var mapList = await getStudentMapList();
    List<Student> list = [];
    for (int i = 0; i < mapList.length; i++) {
      list.add(Student.fromJson(mapList[i]));
    }
    return list;
  }
  Future<Student> getStudent(int id) async {
    var mapList = await getSpecificStudentMapList(id);
    List<Student> list = [];
    for (int i = 0; i < mapList.length; i++) {
      list.add(Student.fromJson(mapList[i]));
    }
    return list.first;
  }

  ///-----------------------------(course Activity)-----------------------///
  Future<List<Map<String, dynamic>>> getCourseActivityMapList(courseId) async {
    Database db = await this.database;
    var result = await db.rawQuery(
        "select $activityTable.$activityName, $courseActivityTable.$crsId, $courseActivityTable.$actId"
        " from $activityTable left join $courseActivityTable ON $activityTable.$activityId = $courseActivityTable.$actId WHERE $courseActivityTable.$crsId = $courseId"
            " order by $activityTable.$activityName");
    return result;
  }

  Future<int> insertCourseActivity(CourseActivity courseActivity) async {
    Database db = await this.database;
    var result = await db.insert(courseActivityTable, courseActivity.toJson());
    print(result);
    print(courseActivity.toJson());
    return result;
  }

  Future<int> deleteCourseActivity(CourseActivity courseActivity) async {
    var db = await this.database;
    int result = await db.rawDelete(
        'DELETE FROM $courseActivityTable WHERE $crsId = ? AND $actId = ?',
        [courseActivity.courseID, courseActivity.activityID]);
    return result;
  }

  Future<List<Map<String, dynamic>>> updateCourseActivity(
      CourseActivity courseActivity, int oldActivityId) async {
    var db = await this.database;
    print(courseActivity.toJson());
    print(oldActivityId);
    var result = await db.rawQuery("UPDATE $courseActivityTable"
        " SET $actId =  ${courseActivity.activityID} "
        "WHERE $actId =  $oldActivityId And "
        "$crsId =  ${courseActivity.courseID} ;");
    print(result);
    return result;
  }

  Future<List<CourseActivity>> getCourseActivityList(courseId) async {
    var mapList = await getCourseActivityMapList(courseId);

    List<CourseActivity> list = [];
    for (int i = 0; i < mapList.length; i++) {
      list.add(CourseActivity.fromJson(mapList[i]));
    }
    return list;
  }

  ///-----------------------------(Student Activity)-----------------------///
  Future<List<Map<String, dynamic>>> getStudentActivityMapList(
      courseId, activityId) async {
    Database db = await this.database;
    var result = await db.rawQuery("select "
        "$studentTable.$studentName, "
        "$studentTable.$studentLevel, "
        "$studentActivityTable.$degree , "
        "$studentActivityTable.$week , "
        "$studentActivityTable.$stdId , "
        "$studentActivityTable.$stdCourseId , "
        "$studentActivityTable.$stdActivityId"
        " from $studentActivityTable left join  $studentTable ON $studentTable.$studentId = $studentActivityTable.$stdId "
        "WHERE $studentActivityTable.$stdCourseId = $courseId AND "
        "$studentActivityTable.$stdActivityId = $activityId "
        " order by $studentTable.$studentName");
    print("my Data is-----------------");
    print(result);
    print(courseId);
    print(activityId);
    print("my Data is-----------------");

    return result;
  }
  Future<List<Map<String, dynamic>>> getStudentOfCourseMapList(
      courseId) async {
    Database db = await this.database;
    var result = await db.rawQuery("select "
        "$studentTable.$studentName, "
        "$studentTable.$studentLevel, "
        "$studentActivityTable.$degree , "
        "$studentActivityTable.$week , "
        "$studentActivityTable.$stdId , "
        "$studentActivityTable.$stdCourseId , "
        "$studentActivityTable.$stdActivityId"
        " from $studentActivityTable left join  $studentTable ON $studentTable.$studentId = $studentActivityTable.$stdId "
        "WHERE $studentActivityTable.$stdCourseId = $courseId "
        " order by $studentTable.$studentName");
    return result;
  }

  Future<int> insertStudentActivity(StudentActivity studentActivity) async {
    Database db = await this.database;
    var result =
        await db.insert(studentActivityTable, studentActivity.toJsonDB());
    print("---------------------->>>>");
    print(studentActivity.toJsonDB());
    return result;
  }

  Future<int> deleteStudentActivity(StudentActivity studentActivity) async {
    var db = await this.database;
    int result = await db.rawDelete(
        'DELETE FROM $studentActivityTable WHERE $stdId = ? AND $stdCourseId = ? AND $stdActivityId = ?',
        [
          studentActivity.studentId,
          studentActivity.courseId,
          studentActivity.activityId
        ]);
    return result;
  }
  Future<int> deleteAllStudentActivity({courseId,activityId}) async {
    var db = await this.database;
    int result = await db.rawDelete(
        'DELETE FROM $studentActivityTable WHERE  $stdCourseId = ? AND $stdActivityId = ?',
        [
         courseId,
         activityId
        ]);
    print(result);
    return result;
  }

  Future<List<StudentActivity>> getStudentActivityList(
      courseId, activityId) async {
    var mapList = await getStudentActivityMapList(courseId, activityId);
    List<StudentActivity> list = [];
    for (int i = 0; i < mapList.length; i++) {
      list.add(StudentActivity.fromJson(mapList[i]));
print(mapList[i]);
    }
    return list;
  }
  Future<List<StudentActivity>> getStudentOfCourseList(
      courseId) async {
    var mapList = await getStudentOfCourseMapList(courseId);
    List<StudentActivity> list = [];
    for (int i = 0; i < mapList.length; i++) {
      list.add(StudentActivity.fromJson(mapList[i]));
print(mapList[i]);
    }
    return list;
  }

  Future<List<Map<String, dynamic>>> updateStudentDegree(
      StudentActivity studentActivity) async {
    var db = await this.database;
    var result = await db.rawQuery("UPDATE $studentActivityTable"
        " SET $degree =  ${studentActivity.degree} "
        "WHERE $stdId = ${studentActivity.studentId} And "
        "$stdCourseId = ${studentActivity.courseId} And "
        "$stdActivityId = ${studentActivity.activityId} ;");
    print(result);
    return result;
  }

  ///------------------------------(shared function)-----------------------///
  close() async {
    var db = await this.database;
    var result = db.close();
    return result;
  }

  Future<int> getCount(tableName) async {
    Database db = await this.database;
    List<Map<String, dynamic>> x =
        await db.rawQuery('SELECT COUNT (*) from $tableName');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  static Future _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  Future<Database> initializeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'fci.db12';
    var myDatabase = await openDatabase(path,
        version: 1, onCreate: _createDb, onConfigure: _onConfigure);
    return myDatabase;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute("CREATE TABLE $courseTable"
        "($courseId INTEGER PRIMARY KEY AUTOINCREMENT,"
        "$courseName TEXT)");
    await db.execute("CREATE TABLE $activityTable"
        "($activityId INTEGER PRIMARY KEY AUTOINCREMENT,"
        "$activityName TEXT)");
    await db.execute("CREATE TABLE $courseActivityTable"
        "($crsId INTEGER,"
        "$actId INTEGER)");
    await db.execute("CREATE TABLE $studentTable"
        "($studentId INTEGER PRIMARY KEY AUTOINCREMENT,"
        " $studentName TEXT,"
        " $studentDept TEXT,"
        "$studentLevel TEXT)");
    await db.execute("CREATE TABLE $studentActivityTable"
        "($stdId INTEGER,$stdActivityId INTEGER,$stdCourseId INTEGER,$degree INTEGER, "
        "$week INTEGER)");
  }
}
