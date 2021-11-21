import 'package:fci_project/modules/home/controllers/dialog_controller.dart';
import 'package:fci_project/modules/home/controllers/dialogcontroller_controller.dart';
import 'package:get/get.dart';


import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DialogController>(
      () => DialogController(),
    );
    Get.lazyPut<DialogcontrollerController>(
      () => DialogcontrollerController(),
    );
    Get.lazyPut<HomeController>(
      () => HomeController(),
    );
  }
}
