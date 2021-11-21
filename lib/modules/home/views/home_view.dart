import 'package:fci_project/core/utils/constant.dart';
import 'package:fci_project/core/utils/exel.dart';
import 'package:fci_project/core/widget/button.dart';
import 'package:fci_project/core/widget/text_field.dart';
import 'package:fci_project/data/localization/localization_service.dart';
import 'package:fci_project/model/course.dart';
import 'package:fci_project/routes/app_pages.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    LocalizationService l = LocalizationService();
    return
    Scaffold(
      appBar: AppBar(
        title: Text("Course".tr),
        centerTitle: true,
        actions: [
          TextButton(
              onPressed: () {
                controller.enableEditCourse.value =
                    !controller.enableEditCourse.value;
              },
              child: Obx(() => Text(
                    controller.enableEditCourse.value ? "Save".tr : "Edit".tr,
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  )))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: "CourseFloatTag1",
        child: Text("+"),
        onPressed: () {
          controller.courseController.value.text = "";
          Get.bottomSheet(
            Container(
                decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(20)),
                padding: EdgeInsets.all(20),
                height: Get.height,
                child: Column(
                  children: [
                    TextFieldTemplate((v) {}, controller.courseController.value,
                            context, 'Section Name'.tr)
                        .textField,
                    Container(
                      height: 50,
                      child: ButtonTemplate(() {
                        controller.insertCourse();
                        controller.courseController.value.clear();
                        Get.back();
                      },
                              SizedBox(
                                width: Get.width,
                                height: 50,
                                child: Center(
                                  child: Text(
                                    "Add",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                              context,
                              color: Get.theme.primaryColor)
                          .elevatedButton,
                    )
                  ],
                )),
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
                  if(controller.enableEditCourse.value == false) {
                    Get.toNamed(Routes.Activity, arguments: [
                      controller.courses[index].id,
                      controller.courses[index].name
                    ]);
                  }
                    },
                            controller.enableEditCourse.value == false
                                ? Center(
                                    child: Text(
                                    controller.courses[index].name,
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.visible,
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 25),
                                  )):
                                Stack(children: [
                                  Center(
                                      child: Text(
                                        controller.courses[index].name,
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
                                                      controller
                                                          .fetchAllStudentCourse(
                                                          index, true);
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
                                                      controller
                                                          .fetchAllStudentCourse(
                                                          index, false);
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
                                                      MyExcel().readExcelFile( controller
                                                          .courses[index].id);
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
                                                      controller.deleteCourse(
                                                          controller
                                                              .courses[index]);
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
                                                      controller.courseUpdateIndex
                                                          .value = index;
                                                      controller.courseController
                                                          .value.text =
                                                          controller
                                                              .courses[index]
                                                              .name;
                                                      Get.bottomSheet(
                                                          Card(
                                                            color: Colors.grey,
                                                            child: Column(
                                                              children: [
                                                                TextFieldTemplate(
                                                                        (v) {},
                                                                    controller
                                                                        .courseController
                                                                        .value,
                                                                    context,
                                                                    'Section Name'
                                                                        .tr)
                                                                    .textField,
                                                                ButtonTemplate(
                                                                        () {
                                                                      controller.updateCourse(
                                                                          Course(
                                                                              name: controller
                                                                                  .courseController
                                                                                  .value
                                                                                  .text,
                                                                              id: controller
                                                                                  .courses[controller
                                                                                  .courseUpdateIndex.value]
                                                                                  .id),
                                                                          controller
                                                                              .courseUpdateIndex
                                                                              .value);
                                                                      controller
                                                                          .courseController
                                                                          .value
                                                                          .clear();
                                                                      Get.back();
                                                                    },
                                                                    SizedBox(
                                                                      width: Get
                                                                          .width,
                                                                      height:
                                                                      50,
                                                                      child:
                                                                      Center(
                                                                        child:
                                                                        Text(
                                                                          "update",
                                                                          style:
                                                                          TextStyle(color: Colors.white),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    context,
                                                                    color: Get
                                                                        .theme
                                                                        .primaryColor)
                                                                    .elevatedButton
                                                              ],
                                                            ),
                                                          ),
                                                          backgroundColor:
                                                          Colors.grey);
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
                                                      Get.toNamed(Routes.Activity, arguments: [
                                                        controller.courses[index].id,
                                                        controller.courses[index].name
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
              itemCount: controller.courses.length,
            )),
      ),
      drawer:
      Stack(
          children: [
            Positioned(
              top: (Get.height / 2) - 250,
              right: LocalizationService.selectedLang !=
                  LocalizationService.langs.first.obs?Get.width-80:-120,
              left: LocalizationService.selectedLang !=
                  LocalizationService.langs.first.obs?-120:Get.width-80,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(colors:[Colors.yellow,Colors.orange,Colors.orange,Colors.red]),
                  color: Colors.white,

                ),
                padding: EdgeInsets.fromLTRB(5,20,5,20),
                height: 500,
                width: 500,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment:CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    TextButton(
                      onPressed: () {
                        if (LocalizationService.selectedLang ==
                            LocalizationService.langs.first.obs) {
                          l.changeLocale(LocalizationService.langs.last);
                          Get.back();
                        }
                        else {
                          l.changeLocale(LocalizationService.langs.first);
                          Get.back();
                        }
                      },
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                        Icon(Icons.language,color:Colors.white,),
                        SizedBox(width: 5,),
                        Text(LocalizationService.selectedLang.value.tr,style: TextStyle(color: Colors.white),)
                      ],),),
                    TextButton(
                      onPressed: () {
                        Get.changeTheme(
                            Get.isDarkMode ? ThemeData.light() : ThemeData
                                .dark());
                        Get.back();
                      },
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                        Icon(Icons.color_lens,color: Colors.white,),
                        SizedBox(width: 5,),
                        SizedBox(height: 20,
                            child: Text(Get.isDarkMode ? 'dark'.tr : 'Light'.tr,style: TextStyle(color: Colors.white),))
                      ],),),
                  ],
                ),
              ),
            ),
          ]
      )
    ,);
  }

  Widget bottomSheet;
}
