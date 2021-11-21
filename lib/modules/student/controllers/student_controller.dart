import 'package:fci_project/data/database.dart';
import 'package:fci_project/model/student.dart';
import 'package:fci_project/model/student_activity.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class StudentController extends GetxController {
  RxList students = [].obs;
  List<StudentActivity> studentsCourse = [];
  RxList studentsActivity = [].obs;
  var searchController = TextEditingController().obs;
  var studentNameController = TextEditingController().obs;
  var studentLevelController = TextEditingController().obs;
  var studentDeptController = TextEditingController().obs;
  RxInt courseId = 0.obs;
  RxInt activityId = 0.obs;
  RxInt studentId = 0.obs;
  RxInt week = 1.obs;
  RxInt degree = 0.obs;
  RxInt level = 0.obs;
  RxString dept = "".obs;

  RxBool enableDegreeEditing = false.obs;
  RxBool enableAddStudent = false.obs;
  RxBool enableEditStudent = false.obs;
  RxBool enableStudentActivityEditing = false.obs;

  @override
  void onInit() {
    super.onInit();
    students.value = [];
    studentsActivity.value = [];
    fetchStudent();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    // ProductDatabaseHelper.db.close();
  }

  fetchStudent() async {
    FCIDatabaseHelper.db
        .getStudentList()
        .then((studentList) => {students.value = studentList});
  }

  fetchStudentCourse() async {
    studentsCourse = await FCIDatabaseHelper.db
        .getStudentOfCourseList(courseId);
  }

  fetchStudentActivity() async {
    FCIDatabaseHelper.db
        .getStudentActivityList(courseId.value, activityId)
        .then((studentActivityList) {
      studentsActivity.value = studentActivityList;
      for (int i = 0; i < studentsActivity.length; i++) {
        students.removeWhere((element) =>
        element.id == studentsActivity[i].studentId);
      }
    });
  }

  Future<Student> addStudent(Student student) async {
    Student s;
    int id = await FCIDatabaseHelper.db
        .insertStudent(Student(
        name: student.name, level: student.level, dept: student.dept));
    s = Student(
        id: id,
        name: student.name,
        level: student.level,
        dept: student.dept);
    students.refresh();
    students.add(s);
    return s;
  }

  updateStudent(Student student, int index) async {
    FCIDatabaseHelper.db
        .updateStudent(student)
        .then((value) => fetchStudent());
  }

  addStudentActivity({Student student}) async {
    FCIDatabaseHelper.db
        .insertStudentActivity(StudentActivity(
        studentId: student.id,
        courseId: courseId.value,
        activityId: activityId.value,
        degree: degree.value,
        week: week.value))
        .then((value) {
      studentsActivity.add(StudentActivity(
          studentId: student.id,
          courseId: courseId.value,
          activityId: activityId.value,
          degree: degree.value,
          week: week.value,
          name: student.name,
          label: student.level));
      students.remove(student);
    });
  }

  Future<Student> insertStudent() async {
    return await addStudent(Student(
        level: studentLevelController.value.text,
        dept: studentDeptController.value.text,
        name: studentNameController.value.text));
  }

  deleteStudent(Student student) {
    FCIDatabaseHelper.db
        .deleteStudent(student)
        .then((value) => students.remove(student));
  }

  deleteStudentActivity(StudentActivity studentActivity) {
    FCIDatabaseHelper.db
        .deleteStudentActivity(studentActivity)
        .then((value) => studentsActivity.remove(studentActivity));
  }

  updateStudentDegree(StudentActivity studentActivity, int index) {
    FCIDatabaseHelper.db.updateStudentDegree(studentActivity).then((value) {
      // studentsActivity.remove(index);
      studentsActivity.setAll(index, [studentActivity]);
    });
  }

  Future<void> addAll() async {
    await fetchStudentCourse();
    for (int i = 0; i < studentsCourse.length; i++) {
      if (studentsActivity
          .where((element) => studentsCourse[i].studentId == element.studentId)
          .toList()
          .length == 0) {
        addStudentActivity(student: await FCIDatabaseHelper.db.getStudent(
            studentsCourse[i].studentId)
        );
      }
    }
  }

  Future<void> plusAll() async {
    for (int i = 0; i < studentsActivity.length; i++) {
      updateStudentDegree(StudentActivity(
        studentId: studentsActivity[i].studentId,
        courseId: studentsActivity[i].courseId,
        name: studentsActivity[i].name,
        label: studentsActivity[i].label,
        degree: studentsActivity[i].degree + 1,
      ), i);
    }
  }

  Future<void> minusAll() async {
    for (int i = 0; i < studentsActivity.length; i++) {
      updateStudentDegree(StudentActivity(
        studentId: studentsActivity[i].studentId,
        courseId: studentsActivity[i].courseId,
        name: studentsActivity[i].name,
        label: studentsActivity[i].label,
        degree: studentsActivity[i].degree > 0
            ? studentsActivity[i].degree - 1
            : studentsActivity[i].degree,
      ), i);
    }
  }

  Future<void> one() async {
    for (int i = 0; i < studentsActivity.length; i++) {
      updateStudentDegree(StudentActivity(
        studentId: studentsActivity[i].studentId,
        courseId: studentsActivity[i].courseId,
        name: studentsActivity[i].name,
        label: studentsActivity[i].label,
        degree: 1,
      ), i);
    }
  }

  Future<void> zero() async {
    for (int i = 0; i < studentsActivity.length; i++) {
      updateStudentDegree(StudentActivity(
        studentId: studentsActivity[i].studentId,
        courseId: studentsActivity[i].courseId,
        name: studentsActivity[i].name,
        label: studentsActivity[i].label,
        degree: 0,
      ), i);
    }
  }
}
