import 'package:fci_project/core/utils/constant.dart';
import 'package:fci_project/core/utils/exel.dart';
import 'package:fci_project/core/widget/button.dart';
import 'package:fci_project/core/widget/text_field.dart';
import 'package:fci_project/model/student.dart';
import 'package:fci_project/model/student_activity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/student_controller.dart';

class StudentView extends GetView<StudentController> {
   int studentID;
   int updateStudentIndex = 0;

  @override
  Widget build(BuildContext context) {
    controller.courseId.value = Get.arguments[0];
    controller.activityId.value = Get.arguments[1];
    controller.fetchStudentActivity(); // fetchCourseActivity();

    return Scaffold(
        appBar:  PreferredSize(
            preferredSize: Size.fromHeight(200), // here the desired height
            child: Stack(
              children: [
                Positioned(
                  top: 30,
                    child: Container(
                      width: Get.width,
                      height: 230,
                      color: Colors.grey[100],
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Spacer(flex: 2,),
                              Container(
                                margin: EdgeInsets.only(top: 0, right: 20),
                                padding: EdgeInsets.all(10),

                                decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.all(Radius.circular(10))),
                                child: InkWell(
                                    child: Text("Add All".tr,
                                      style:TextStyle(color: Colors.white),
                      ),
                                    onTap: () {
                                      controller.addAll();
                                    }),
                              ),

                              Padding(
                                padding: const EdgeInsets.only(left:18.0),
                                child: Obx(() => InkWell(
                                  onTap:  () {
                                    if (controller.enableDegreeEditing.value)
                                      controller.enableDegreeEditing.value = false;
                                    else if (controller.enableStudentActivityEditing.value) {
                                      controller.enableStudentActivityEditing.value = false;
                                    } else if (controller.enableDegreeEditing.value == false)
                                      controller.enableDegreeEditing.value = true;
                                    else if (controller.enableStudentActivityEditing.value ==
                                        false)
                                      controller.enableStudentActivityEditing.value = true;
                                  },
                                  child: Container(
                                      margin: EdgeInsets.only(top: 0, right: 20),
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          color: Colors.red,
                                          borderRadius: BorderRadius.all(Radius.circular(10))),
                                      child: Text(controller.enableDegreeEditing.value ||
                                          controller.enableStudentActivityEditing.value
                                          ? "Save".tr
                                          : "Edit".tr,
                                      style:TextStyle(color: Colors.white)),
                                      ),
                                )),
                              ),
                              Spacer(flex: 1,),

                            ],
                          ),
                          SizedBox(height: 5,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Spacer(flex: 2,),
                              Container(
                                margin: EdgeInsets.only(top: 0, right: 20),
                                padding: EdgeInsets.all(10),

                                decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.all(Radius.circular(10))),
                                child: InkWell(
                                    child: Text("+1".tr,
                                      style:TextStyle(color: Colors.white),
                      ),
                                    onTap: () {
                                      controller.plusAll();
                                    }),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 0, right: 20),
                                padding: EdgeInsets.all(10),

                                decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.all(Radius.circular(10))),
                                child: InkWell(
                                    child: Text("1".tr,
                                      style:TextStyle(color: Colors.white),
                      ),
                                    onTap: () {
                                      controller.one();
                                    }),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 0, right: 20),
                                padding: EdgeInsets.all(10),

                                decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.all(Radius.circular(10))),
                                child: InkWell(
                                    child: Text("0".tr,
                                      style:TextStyle(color: Colors.white),
                      ),
                                    onTap: () {
                                      controller.zero();
                                    }),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 0, right: 20),
                                padding: EdgeInsets.all(10),

                                decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.all(Radius.circular(10))),
                                child: InkWell(
                                    child: Text("-1".tr,
                                      style:TextStyle(color: Colors.white),
                                    ),
                                    onTap: () {
                                      controller.minusAll();
                                    }),
                              ),
                              Spacer(flex: 1,),

                            ],
                          ),
                          SizedBox(height: 70,),
                          Container(
                            height: 30,
                            margin: EdgeInsets.only(bottom: 20, left: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(Get.arguments[2].toString().capitalize,
                                    style:
                                    TextStyle(fontSize: 20, color: Colors.black)),
                                Text(
                                  Get.arguments[3].toString().capitalize,
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    )),
                Positioned(
                  child: Transform(
                    alignment: FractionalOffset.bottomLeft,
                    transform: new Matrix4.identity()
                      ..rotateZ(-10 * 3.1415927 / 180),
                    child: Container(
                      height: 200,
                      width: 100,
                      decoration: BoxDecoration(
                          color: Colors.blue[100].withAlpha(150),
                          borderRadius:
                          BorderRadius.only(bottomLeft: Radius.circular(50))),
                    ),
                  ),
                  right: 0,
                ),
                Positioned(
                  child: Container(
                    height: 200,
                    width: 100,
                    decoration: BoxDecoration(
                        color: Colors.blueAccent,
                        borderRadius:
                        BorderRadius.only(bottomLeft: Radius.circular(50))),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top:28.0),
                          child: FloatingActionButton(
                            isExtended: true,
                            heroTag: "studentFloatTag",
                            backgroundColor: Colors.black45,
                            child: Text("+", style: TextStyle(fontSize: 30)),
                            onPressed: () {
                              Get.bottomSheet(
                                Container(
                                  decoration: BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius: BorderRadius.circular(20)),
                                  padding: EdgeInsets.all(20),
                                  height: Get.height * 3 / 4,
                                  child: Obx(
                                        () {
                                      List<Student> presentedStudent = getPresentedStudent();

                                      return controller.enableAddStudent.value == false
                                          ? Column(
                                        children: [
                                          Row(
                                            children: [
                                              IconButton(
                                                  onPressed: () {},
                                                  icon: Icon(Icons.input)),
                                              IconButton(
                                                onPressed: () async {
                                                  MyExcel().saveInFile(
                                                      controller.studentsActivity);
                                                },
                                                icon: Icon(Icons.outbond_outlined),
                                                splashColor: Colors.blue,
                                              ),
                                              Spacer(
                                                flex: 1,
                                              ),
                                              InkWell(
                                                onTap: () async {
                                                  controller.enableEditStudent.value =
                                                  !controller.enableEditStudent.value;
                                                },
                                                child: Text(
                                                  controller.enableEditStudent.value
                                                      ? "Save"
                                                      : "Edit",
                                                  style: TextStyle(fontSize: 20),
                                                ),
                                                splashColor: Colors.blue,
                                              ),
                                            ],
                                          ),

                                          /// name field
                                          TextFieldTemplate((v) {
                                            controller.studentNameController.refresh();
                                          }, controller.studentNameController.value,
                                              context, 'Search by username',
                                              suffix: (presentedStudent.length == 0) &&
                                                  controller.studentNameController
                                                      .value.text.isNotEmpty
                                                  ? FloatingActionButton(
                                                heroTag: "studentFloatTag2",
                                                child: Icon(Icons.add),
                                                mini: true,
                                                backgroundColor: Colors.blue,
                                                onPressed: () {
                                                  controller.enableAddStudent
                                                      .value = true;
                                                  controller.enableAddStudent
                                                      .refresh();
                                                  presentedStudent =
                                                      getPresentedStudent();
                                                },
                                              )
                                                  : null,
                                              canArabic: true)
                                              .textField,

                                          ///list of all students
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Flexible(
                                            flex: 1,
                                            child: drawStudentList(presentedStudent, 50),
                                          ),
                                        ],
                                      )
                                          : Column(
                                        children: [
                                          /// name field
                                          TextFieldTemplate(
                                                  (v) {},
                                              controller.studentNameController.value,
                                              context,
                                              'Student Name',
                                              canArabic: true)
                                              .textField,

                                          /// label fiel
                                          TextFieldTemplate(
                                                  (v) {},
                                              controller.studentDeptController.value,
                                              context,
                                              'Student Label'.tr)
                                              .textField,

                                          /// Dept field
                                          TextFieldTemplate(
                                                  (v) {},
                                              controller.studentLevelController.value,
                                              context,
                                              'Student Label'.tr)
                                              .textField,

                                          ///insert Student button
                                          ButtonTemplate(() async {
                                            if (studentID == null) {
                                              controller.addStudentActivity(student:  await controller.insertStudent());
                                            } else {
                                              controller.updateStudent(
                                                  Student(
                                                    id: studentID,
                                                    name: controller
                                                        .studentNameController.value.text,
                                                    dept: controller
                                                        .studentDeptController.value.text,
                                                    level: controller
                                                        .studentLevelController.value.text,
                                                  ),
                                                  updateStudentIndex);
                                            }
                                            controller.enableStudentActivityEditing.value =
                                            false;
                                            controller.studentNameController.value.clear();
                                            controller.enableAddStudent.value = false;
                                          },
                                              SizedBox(
                                                width: Get.width,
                                                height: 50,
                                                child: Center(
                                                  child: Text(
                                                    "Add",
                                                    style:
                                                    TextStyle(color: Colors.white),
                                                  ),
                                                ),
                                              ),
                                              context,
                                              color: Get.theme.primaryColor)
                                              .elevatedButton,
                                        ],
                                      );
                                    },
                                  ),
                                ),
                                isScrollControlled: true,
                              );
                            },
                          ),
                        )

                      ],
                    ),
                  ),
                  right: 0,
                ),
                Positioned(
                  left: 10,
                  child:  Container(
                    margin: EdgeInsets.only(top: 130, left: 20,right: 20),
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: TextFieldTemplate((v) {
                      controller.searchController.refresh();
                    }, controller.searchController.value, context,
                        'Search by Name...',
                        suffix: Icon(Icons.search,size: 20,color: Colors.grey,), canArabic: true)
                        .textField,
                  ),
                  right: 0,
                )
              ],
            )),
        body:  Padding(
              padding: EdgeInsets.all(10),
              child: Obx(() {
                  List<dynamic> presentedStudent =
                  getPresentedStudentActivity();
                return
                ListView.builder(
                    itemBuilder: (context, index) {
                      return ButtonTemplate(
                              () {},
                              SizedBox(
                                width: Get.width,
                                child: Obx(
                                  () => Directionality(
                                    textDirection:
                                        Get.locale.languageCode == "ar"
                                            ? TextDirection.ltr
                                            : TextDirection.rtl,
                                    child: controller
                                            .enableDegreeEditing.value
                                        ? Row(
                                            mainAxisSize:
                                                MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.only(
                                                        left: 8.0,
                                                        right: 4),
                                                child: SizedBox(
                                                    height: 30,
                                                    width: 30,
                                                    child:
                                                        FloatingActionButton(
                                                      heroTag:
                                                          "studentFloatTag3",
                                                      backgroundColor:
                                                          Colors.green,
                                                      elevation: 0,
                                                      onPressed: () {
                                                        StudentActivity
                                                            student =
                                                            presentedStudent[
                                                                index];
                                                        controller.updateStudentDegree(
                                                            StudentActivity(
                                                                studentId:
                                                                    student
                                                                        .studentId,
                                                                courseId:
                                                                    student
                                                                        .courseId,
                                                                activityId:
                                                                    student
                                                                        .activityId,
                                                                name: student
                                                                    .name,
                                                                week: student
                                                                    .week,
                                                                degree:
                                                                    student.degree +
                                                                        1),
                                                            index);
                                                      },
                                                      child: Text("+"),
                                                    )),
                                              ),
                                              Text(
                                                (index + 1).toString() +
                                                    " - ",
                                                textAlign:
                                                    TextAlign.center,
                                                style: TextStyle(
                                                    color: Colors.blue,
                                                    fontSize: 15),
                                              ),
                                              Flexible(
                                                flex: 2,
                                                fit: FlexFit.tight,
                                                child: Text(
                                                  presentedStudent[index]
                                                      .name,
                                                  // textAlign: TextAlign.left,
                                                  // overflow: TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 15),
                                                ),
                                              ),
                                              drawDegree(
                                                  presentedStudent[index]
                                                      .degree),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.only(
                                                        right: 8.0),
                                                child: SizedBox(
                                                    height: 30,
                                                    width: 30,
                                                    child:
                                                        FloatingActionButton(
                                                      heroTag:
                                                          "studentFloatTag4",
                                                      elevation: 0,
                                                      backgroundColor:
                                                          presentedStudent[index]
                                                                      .degree ==
                                                                  0
                                                              ? Colors.red[
                                                                  100]
                                                              : Colors
                                                                  .red,
                                                      onPressed: () {
                                                        StudentActivity
                                                            student =
                                                            presentedStudent[
                                                                index];
                                                        if (student
                                                                .degree >
                                                            0) {
                                                          controller.updateStudentDegree(
                                                              StudentActivity(
                                                                  studentId:
                                                                      student
                                                                          .studentId,
                                                                  courseId:
                                                                      student
                                                                          .courseId,
                                                                  activityId:
                                                                      student
                                                                          .activityId,
                                                                  name: student
                                                                      .name,
                                                                  week: student
                                                                      .week,
                                                                  degree:
                                                                      student.degree -
                                                                          1),
                                                              index);
                                                        }
                                                      },
                                                      child: Text("-"),
                                                    )),
                                              )
                                            ],
                                          )
                                        : controller
                                                .enableStudentActivityEditing
                                                .value
                                            ? Row(
                                                mainAxisSize:
                                                    MainAxisSize.min,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment
                                                        .center,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets
                                                                .only(
                                                            left: 8.0,
                                                            right: 4),
                                                    child: SizedBox(
                                                        height: 30,
                                                        width: 30,
                                                        child:
                                                            FloatingActionButton(
                                                          heroTag:
                                                              "studentFloatTag5",
                                                          backgroundColor:
                                                              Colors.red,
                                                          elevation: 0,
                                                          onPressed: () {
                                                            controller.deleteStudentActivity(
                                                                presentedStudent[
                                                                    index]);
                                                          },
                                                          child: Icon(Icons
                                                              .delete),
                                                        )),
                                                  ),
                                                  Text(
                                                    (index + 1)
                                                            .toString() +
                                                        " - ",
                                                    textAlign:
                                                        TextAlign.center,
                                                    style: TextStyle(
                                                        color:
                                                            Colors.blue,
                                                        fontSize: 15),
                                                  ),
                                                  Flexible(
                                                    flex: 2,
                                                    fit: FlexFit.tight,
                                                    child: Text(
                                                      presentedStudent[
                                                              index]
                                                          .name,
                                                      // textAlign: TextAlign.left,
                                                      // overflow: TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                          color: Colors
                                                              .black,
                                                          fontSize: 15),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets
                                                                .only(
                                                            right: 8.0),
                                                    child: SizedBox(
                                                        height: 30,
                                                        width: 30,
                                                        child:
                                                            FloatingActionButton(
                                                          heroTag:
                                                              "studentFloatTag6",
                                                          backgroundColor:
                                                              Colors
                                                                  .green,
                                                          elevation: 0,
                                                          onPressed: () {
                                                            StudentActivity
                                                                student =
                                                                presentedStudent[
                                                                    index];
                                                            controller.updateStudentDegree(
                                                                StudentActivity(
                                                                    studentId: student
                                                                        .studentId,
                                                                    courseId: student
                                                                        .courseId,
                                                                    activityId: student
                                                                        .activityId,
                                                                    name: student
                                                                        .name,
                                                                    week: student
                                                                        .week,
                                                                    degree:
                                                                        student.degree + 1),
                                                                index);
                                                          },
                                                          child: Icon(Icons
                                                              .account_circle),
                                                        )),
                                                  )
                                                ],
                                              )
                                            : Row(
                                                mainAxisSize:
                                                    MainAxisSize.min,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment
                                                        .center,
                                                children: [
                                                  Text(
                                                    (index + 1)
                                                            .toString() +
                                                        " - ",
                                                    textAlign:
                                                        TextAlign.center,
                                                    style: TextStyle(
                                                        color:
                                                            Colors.blue,
                                                        fontSize: 15),
                                                  ),
                                                  Flexible(
                                                    flex: 2,
                                                    fit: FlexFit.tight,
                                                    child: Text(
                                                      presentedStudent[
                                                              index]
                                                          .name,
                                                      // textAlign: TextAlign.left,
                                                      style: TextStyle(
                                                          color: Colors
                                                              .black,
                                                          fontSize: 15),
                                                    ),
                                                  ),
                                                  Flexible(
                                                    flex: 1,
                                                    fit: FlexFit.tight,
                                                    child: drawDegree(
                                                        controller
                                                            .studentsActivity[
                                                                index]
                                                            .degree),
                                                  ),
                                                ],
                                              ),
                                  ),
                                ),
                              ),
                              context, onLongPress: () {
                        controller.enableStudentActivityEditing.value =
                            true;
                      }, padding: EdgeInsets.fromLTRB(3, 3, 3, 2))
                          .elevatedButton;
                    },
                    itemCount: presentedStudent.length,
                  );})));
  }

  Widget drawStudentList(List list, int height) => Padding(
      padding: EdgeInsets.all(3),
      child: ListView.builder(
        itemBuilder: (context, index) {
          return ButtonTemplate(
                  () {
                    controller.addStudentActivity(student: list[index]);
                  },
                  controller.enableEditStudent.value == false
                      ? Container(
                          height: 50,
                          child: Center(
                              child: Text(
                            list[index].name,
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.black, fontSize: 25),
                          )),
                        )
                      : Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: SizedBox(
                                  height: 30,
                                  width: 30,
                                  child: FloatingActionButton(
                                    heroTag: "studentFloatTag6",
                                    backgroundColor: Colors.green,
                                    elevation: 0,
                                    onPressed: () {
                                      controller.enableEditStudent.value =
                                          false;
                                      controller.enableAddStudent.value = true;
                                      Student s = list[index];
                                      controller.studentNameController.value
                                          .text = s.name;
                                      controller.studentDeptController.value
                                          .text = s.dept;
                                      controller.studentLevelController.value
                                          .text = s.level;
                                      studentID = s.id;
                                      updateStudentIndex = index;
                                    },
                                    child: Icon(Icons.settings),
                                  )),
                            ),
                            Flexible(
                              flex: 2,
                              fit: FlexFit.tight,
                              child: Text(
                                list[index].name, textAlign: TextAlign.right,
                                // overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: Colors.black, fontSize: 20),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: SizedBox(
                                  height: 30,
                                  width: 30,
                                  child: FloatingActionButton(
                                    heroTag: "studentFloatTag8",
                                    elevation: 0,
                                    backgroundColor: Colors.red,
                                    onPressed: () {
                                      controller.deleteStudent(
                                          controller.students[index]);
                                    },
                                    child: Text("-"),
                                  )),
                            )
                          ],
                        ),
                  context,
                  onLongPress: () {
                    controller.enableEditStudent.value = true;
                  },
                  padding: EdgeInsets.fromLTRB(3, 3, 3, 2),
                  color: Constant.myColors[index % 8])
              .elevatedButton;
        },
        itemCount: list.length,
      ));

  Widget drawDegree(int length) {
    double size = 15;
    List<Widget> col = [];
    for (int i = 0; i < length; i += 5) {
      List<Widget> row = [];
      if (i < length - 4) {
        row.add(Icon(
          Icons.check_circle_rounded,
          size: size,
          color: Colors.green,
        ));
        row.add(Icon(
          Icons.check_circle_rounded,
          size: size,
          color: Colors.green,
        ));
        row.add(Icon(
          Icons.check_circle_rounded,
          size: size,
          color: Colors.green,
        ));
        row.add(Icon(
          Icons.check_circle_rounded,
          size: size,
          color: Colors.green,
        ));
        row.add(Icon(
          Icons.check_circle_rounded,
          size: size,
          color: Colors.green,
        ));
      } else if (i < length - 3) {
        row.add(Icon(
          Icons.check_circle_rounded,
          size: size,
          color: Colors.green,
        ));
        row.add(Icon(
          Icons.check_circle_rounded,
          size: size,
          color: Colors.green,
        ));
        row.add(Icon(
          Icons.check_circle_rounded,
          size: size,
          color: Colors.green,
        ));
        row.add(Icon(
          Icons.check_circle_rounded,
          size: size,
          color: Colors.green,
        ));
        row.add(SizedBox(
          height: size,
          width: size,
        ));
      } else if (i < length - 2) {
        row.add(Icon(
          Icons.check_circle_rounded,
          size: size,
          color: Colors.green,
        ));
        row.add(Icon(
          Icons.check_circle_rounded,
          size: size,
          color: Colors.green,
        ));
        row.add(Icon(
          Icons.check_circle_rounded,
          size: size,
          color: Colors.green,
        ));
        row.add(SizedBox(
          height: size,
          width: size,
        ));
        row.add(SizedBox(
          height: size,
          width: size,
        ));
      } else if (i < length - 1) {
        row.add(Icon(
          Icons.check_circle_rounded,
          size: size,
          color: Colors.green,
        ));
        row.add(Icon(
          Icons.check_circle_rounded,
          size: size,
          color: Colors.green,
        ));
        row.add(SizedBox(
          height: size,
          width: size,
        ));
        row.add(SizedBox(
          height: size,
          width: size,
        ));
        row.add(SizedBox(
          height: size,
          width: size,
        ));
      } else if (i < length) {
        row.add(Icon(
          Icons.check_circle_rounded,
          size: size,
          color: Colors.green,
        ));
        row.add(SizedBox(
          height: size,
          width: size,
        ));
        row.add(SizedBox(
          height: size,
          width: size,
        ));
        row.add(SizedBox(
          height: size,
          width: size,
        ));
        row.add(SizedBox(
          height: size,
          width: size,
        ));
      }
      col.add(Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: row,
      ));
    }
    return Column(
      children: col,
    );
  }

  List<Student> getPresentedStudent() {
    return controller.students.where((element) {
      if (controller.studentNameController.value.text.isEmpty) {
        return true;
      } else if (element.name.toString().toLowerCase().contains(
          controller.studentNameController.value.text.toLowerCase())) {
        return true;
      } else {
        return false;
      }
    }).toList();
  }

  List<dynamic> getPresentedStudentActivity() {
    return controller.studentsActivity.where((element) {
      if (controller.searchController.value.text.isEmpty) {
        return true;
      } else if (element.name
          .toString()
          .toLowerCase()
          .contains(controller.searchController.value.text.toLowerCase())) {
        return true;
      } else {
        return false;
      }
    }).toList();
  }
}
