import 'package:fci_project/modules/activity/bindings/activity_binding.dart';
import 'package:fci_project/modules/activity/views/activity_view.dart';
import 'package:fci_project/modules/home/bindings/home_binding.dart';
import 'package:fci_project/modules/home/views/home_view.dart';
import 'package:fci_project/modules/student/bindings/activity_binding.dart';
import 'package:fci_project/modules/student/views/student_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

part 'app_routes.dart';

class AppPages {
  static const INITIAL = Routes.Course;

  static final routes = [
    GetPage(
      name: _Paths.Course,
      transition: Transition.zoom,
      transitionDuration: Duration(milliseconds: 750),      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.Activity,
      transition: Transition.zoom,
      transitionDuration: Duration(milliseconds: 750),
      page: () => ActivityView(),
      binding: ActivityBinding(),
    ),
    GetPage(
      name: _Paths.Student,
      transition: Transition.zoom,
      transitionDuration: Duration(milliseconds: 750),
      page: () => StudentView(),
      binding: StudentBinding(),
    ),
  ];
}
