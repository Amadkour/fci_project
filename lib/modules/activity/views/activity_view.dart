import 'package:fci_project/core/utils/constant.dart';
import 'package:fci_project/core/utils/exel.dart';
import 'package:fci_project/core/widget/button.dart';
import 'package:fci_project/core/widget/text_field.dart';
import 'package:fci_project/model/activity.dart';
import 'package:fci_project/model/course_activity.dart';
import 'package:fci_project/routes/app_pages.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/activity_controller.dart';

class ActivityView extends GetView<ActivityController> {
  @override
  Widget build(BuildContext context) {
    controller.courseId.value = Get.arguments[0];
    controller.fetchCourseActivity();
    print(controller.courseActivities);
    return Scaffold(
      appBar: AppBar(
        title: Text(Get.arguments[1]),
        centerTitle: true,
        actions: [
          TextButton(
              onPressed: () {
                controller.enableEditCourseActivity.value =
                    !controller.enableEditCourseActivity.value;
              },
              child: Obx(() => Text(
                    controller.enableEditCourseActivity.value ? "Save".tr : "Edit".tr,
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  )))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Text("+"),
        onPressed: () {
          controller.enableEditActivityName.value=false;
          controller.enableEditCourseActivity.value=false;
          controller.activityController.value.text="";
          Get.bottomSheet(
            Container(
                decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(20)
                ),
                padding: EdgeInsets.all(20),
                height: Get.height,
                child: Obx(() {
                  List<Activity> presentedActivity = getPresentedActivity();

                  return Column(
                    children: [
                      SizedBox(height: 30,child:
                      Row(
                        children: [
                          IconButton(
                              onPressed: () {}, icon: Icon(Icons.input)),
                          IconButton(
                            onPressed: () async {
                              MyExcel().saveInFile(
                                  controller.activities);
                            },
                            icon: Icon(Icons.outbond_outlined),
                            splashColor: Colors.blue,
                          ),
                          Spacer(flex: 1,),
                          InkWell(
                            onTap: () async {
                              controller.enableEditActivityName.value = !controller.enableEditActivityName.value;
                            },
                            child:  Text(controller.enableEditActivityName.value?"Save":"Edit",
                              style: TextStyle(fontSize: 20)
                              ,),
                            splashColor: Colors.blue,
                          ),
                        ],
                      )),
                      TextFieldTemplate((v) {
                        controller.activityController.refresh();
                      }, controller.activityController.value, context,
                              'Activity Name'.tr,
                              suffix: (presentedActivity.length == 0 || controller.enableEditActivityName.value) &&
                                      controller.activityController.value.text
                                          .isNotEmpty
                                  ? FloatingActionButton(
                                      child: controller.enableEditActivityName.value?Icon(Icons.update): Icon(Icons.add),
                                      mini: true,
                                      backgroundColor: Colors.blue,
                                      onPressed: () {
                                        if(controller.enableEditActivityName.value)
                                          controller.updateActivity(Activity(id: controller.activities[controller.activityUpdateIndex.value].id,name:controller.activityController.value.text), controller.activityUpdateIndex.value);
                                          else
                                        controller.insertActivity();
                                        controller.activityController.value
                                            .clear();
                                      },
                                    )
                                  : null)
                          .textField,
                      Flexible(
                        flex: 6,
                        child: drawList(presentedActivity, 50),
                      )
                    ],
                  );
                })),
          );
        },
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Obx(() => GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              semanticChildCount: 2,
              itemBuilder: (context, index) {
                return Obx(() => ButtonTemplate(() {
                      Get.toNamed(Routes.Student, arguments: [
                        controller.courseId.value,
                        controller.courseActivities.value[index].activityID,
                        Get.arguments[1],
                        controller.courseActivities.value[index].name,
                      ]);
                    },
                            controller.enableEditCourseActivity.value == false
                                ? Center(
                                    child: Text(
                                    controller.courseActivities[index].name,
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.visible,
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 25),
                                  ))
                                :
                            Stack(children: [
                              Center(
                                  child: Text(
                                    controller.courseActivities[index].name,
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.visible,
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 25),
                                  )),
                              Container(
                                margin: EdgeInsets.symmetric(vertical: 20),
                                color: Colors.black.withAlpha(200),
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                        children: [
                                          SizedBox(
                                              height: 30,
                                              width: 30,
                                              child: FloatingActionButton(
                                                heroTag: "CourseFloatTag2",
                                                backgroundColor:
                                                Colors.transparent,
                                                elevation: 0,
                                                onPressed: () {
                                                  controller.exelStudentActivity( controller.activities[index],true);
                                                },
                                                child: Icon(Icons.ios_share,size: 30,),
                                              )),
                                          SizedBox(
                                              height: 30,
                                              width: 30,
                                              child: FloatingActionButton(
                                                heroTag: "CourseFloatTag2",
                                                backgroundColor:
                                                Colors.transparent,
                                                elevation: 0,
                                                onPressed: () {
                                                  controller.exelStudentActivity( controller.activities[index],false);
                                                },
                                                child: Icon(
                                                  Icons.arrow_circle_up_outlined,size: 30,),
                                              )),
                                          SizedBox(
                                              height: 30,
                                              width: 30,
                                              child: FloatingActionButton(
                                                heroTag: "CourseFloatTag2",
                                                backgroundColor:
                                                Colors.transparent,
                                                elevation: 0,
                                                onPressed: () {
                                                  MyExcel().readActivityExcelFile( controller.courseId.value, controller.courseActivities[index].activityId);
                                                },
                                                child: Icon(
                                                  Icons.arrow_circle_down_outlined,size: 30,),
                                              )),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                        children: [
                                          SizedBox(
                                              height: 30,
                                              width: 30,
                                              child: FloatingActionButton(
                                                heroTag: "CourseFloatTag3",
                                                backgroundColor:
                                                Colors.transparent,
                                                elevation: 0,
                                                onPressed: () {
                                                  controller.deleteCourseActivity(
                                                    controller
                                                        .courseActivities[
                                                    index]);
                                                },
                                                child: Icon(Icons.delete,size: 30,),
                                              )),
                                          SizedBox(
                                              height: 30,
                                              width: 30,
                                              child: FloatingActionButton(
                                                heroTag: "CourseFloatTag4",
                                                backgroundColor:
                                                Colors.transparent,
                                                elevation: 0,
                                                onPressed: () {
                                                  controller
                                                      .courseActivityUpdateIndex
                                                      .value = index;
                                                  controller
                                                      .activityController
                                                      .value
                                                      .text =
                                                      controller
                                                          .courseActivities[
                                                      index]
                                                          .name;
                                                  Get.bottomSheet(
                                                    Container(
                                                        color: Colors.grey,
                                                        height: Get.height,
                                                        child: Obx(() {
                                                          List<Activity>
                                                          presentedActivity =
                                                          getPresentedActivity();

                                                          return Column(
                                                            children: [
                                                              TextFieldTemplate(
                                                                      (v) {
                                                                    controller
                                                                        .activityController
                                                                        .refresh();
                                                                  },
                                                                  controller
                                                                      .activityController
                                                                      .value,
                                                                  context,
                                                                  'Activity Name'
                                                                      .tr,
                                                                  suffix: presentedActivity.length == 0 &&
                                                                      controller.activityController.value.text.isNotEmpty
                                                                      ? FloatingActionButton(
                                                                    child: Icon(Icons.add),
                                                                    mini: true,
                                                                    backgroundColor: Colors.blue,
                                                                    onPressed: () {
                                                                      controller.insertActivity();
                                                                      controller.activityController.value.clear();
                                                                    },
                                                                  )
                                                                      : null)
                                                                  .textField,
                                                              Flexible(
                                                                flex: 6,
                                                                child: drawList(
                                                                    presentedActivity,
                                                                    50),
                                                              )
                                                            ],
                                                          );
                                                        })),
                                                  );
                                                },
                                                child: Icon(Icons.settings,size: 30,),
                                              )),
                                          SizedBox(
                                              height: 30,
                                              width: 30,
                                              child: FloatingActionButton(
                                                heroTag: "CourseFloatTag4",
                                                backgroundColor:
                                                Colors.transparent,
                                                elevation: 0,
                                                onPressed: () {
                                                  Get.toNamed(Routes.Student, arguments: [
                                                    controller.courseId.value,
                                                    controller.courseActivities.value[index].activityID,
                                                    Get.arguments[1],
                                                    controller.courseActivities.value[index].name,
                                                  ]);
                                                },
                                                child: Icon(Icons.remove_red_eye_sharp,size: 30,),
                                              ))
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],),
                            context,
                            color: Constant.myColors[index % 8])
                        .elevatedButton);
              },
              itemCount: controller.courseActivities.length,
            )),
        // CloseButton(onPressed: (){
        //   Get.offNamed(Routes.LOGIN);
        //   Get.snackbar("title", "message");
        // },),
      ),
    );
  }

  Widget bottomSheet;

  Widget drawList(List list, int height) => Padding(
      padding: EdgeInsets.all(20),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        semanticChildCount: 2,
        itemBuilder: (context, index) {
          return ButtonTemplate(() {
            print(controller.enableEditCourseActivity.value);
            print(controller.courseActivityUpdateIndex.value);
            if (controller.enableEditCourseActivity.value == false)
              controller.addCourseActivity(activity: list[index]);
            else
              controller.updateCourseActivity(
                  CourseActivity(
                      courseID: controller.courseId.value,
                      activityID: list[index].id,
                      name: list[index].name),
                  controller.courseActivityUpdateIndex.value,
                  controller
                      .courseActivities[
                          controller.courseActivityUpdateIndex.value]
                      .activityID);
            controller.enableEditCourseActivity.value=false;
            Get.toNamed(Routes.Activity, arguments: [list[index].id]);
          },
                  Container(
                    height: 200,
                    width: 200,
                    child: Center(
                      child: controller.enableEditActivityName.value == false
                          ? Center(
                              child: Text(
                              list[index].name,
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.visible,
                              style:
                                  TextStyle(color: Colors.black, fontSize: 25),
                            ))
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Spacer(
                                  flex: 2,
                                ),
                                Text(
                                  list[index].name,
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.visible,
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 25),
                                ),
                                Spacer(
                                  flex: 1,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                    color: Colors.black.withAlpha(150),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [

                                      SizedBox(
                                          height: 30,
                                          width: 30,
                                          child: FloatingActionButton(
                                            backgroundColor: Colors.transparent,
                                            elevation: 0,
                                            onPressed: () {
                                              controller.deleteActivity(
                                                  controller.activities[index]);

                                            },
                                            child: Icon(Icons.delete),
                                          )),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      SizedBox(
                                          height: 30,
                                          width: 30,
                                          child: FloatingActionButton(
                                            backgroundColor: Colors.transparent,
                                            elevation: 0,
                                            onPressed: () {
                                              controller.activityUpdateIndex
                                                  .value = index;
                                              controller.activityController
                                                      .value.text =
                                                  controller
                                                      .courseActivities[index]
                                                      .name;
                                            },
                                            child: Icon(Icons.settings),
                                          ))
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                    ),
                  ),
                  context,
                  color: Constant.myColors[index % 8])
              .elevatedButton;
        },
        itemCount: list.length,
      ));

  List<Activity> getPresentedActivity() {
    return controller.activities.where((element) {
      if (controller.activityController.value.text.isEmpty) {
        return true;
      } else if (element.name
          .toString()
          .toLowerCase()
          .contains(controller.activityController.value.text.toLowerCase())) {
        return true;
      } else {
        return false;
      }
    }).toList();
  }
}
