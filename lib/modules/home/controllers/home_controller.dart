import 'package:fci_project/core/utils/exel.dart';
import 'package:fci_project/data/database.dart';
import 'package:fci_project/model/course.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  RxList courses =[].obs;
  var courseController = TextEditingController().obs;
  RxBool enableEditCourse=false.obs;
  RxInt courseUpdateIndex=0.obs;
  @override
  void onInit() {
    super.onInit();
    courses.value = [];
    fetchCourses();
  }
  @override
  void onReady() {
    super.onReady();
  }
  @override
  void onClose() {
    // ProductDatabaseHelper.db.close();
  }
  fetchCourses() async {
    FCIDatabaseHelper.db
        .getCourseList()
        .then((courseList) => {courses.value = courseList});
  }
  fetchAllStudentCourse(index,bool isShare) async {
    FCIDatabaseHelper.db
        .getStudentCourseMapList(courses[index].id).then((value) async {
          MyExcel().generateExcel(courses[index].name,await FCIDatabaseHelper.db.getCourseActivityMapList(courses[index].id),value,isShare: isShare);
    });
  }
  addCourses(name) async {
    FCIDatabaseHelper.db
        .insertCourse(Course(name: name))
        .then((value) => courses.add(Course(id:value,name: name)));
  }
  updateCourse(Course course,int index) async {
    FCIDatabaseHelper.db
        .updateCourse(course)
        .then((value){ courses.setAll(index,[course]);
    courses.refresh();
    });
  }
  insertCourse() {
    print(courseController.value.text);
    addCourses(courseController.value.text);
  }
  deleteCourse(Course course){
    FCIDatabaseHelper.db
        .deleteCourse(course).then((value) => courses.remove(course));
  }


}
