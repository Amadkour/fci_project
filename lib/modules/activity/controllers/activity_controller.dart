import 'package:fci_project/core/utils/exel.dart';
import 'package:fci_project/data/database.dart';
import 'package:fci_project/model/activity.dart';
import 'package:fci_project/model/course_activity.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class ActivityController extends GetxController {
  RxList activities = [].obs;
  RxList courseActivities = [].obs;
  var activityController = TextEditingController().obs;
  RxInt courseId = 0.obs;
  RxBool enableEditCourseActivity=false.obs;
  RxInt courseActivityUpdateIndex=0.obs;
  RxInt activityUpdateIndex=0.obs;
  RxBool enableEditActivityName=false.obs;
  RxInt activityNameUpdateIndex=0.obs;

  @override
  void onInit() {
    super.onInit();
    activities.value = [];
    courseActivities.value = [];
    fetchActivity(); // fetchCourseActivity();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    // ProductDatabaseHelper.db.close();
  }

  fetchActivity() async {
    FCIDatabaseHelper.db
        .getActivityList()
        .then((activityList) => {activities.value = activityList});
  }
  fetchCourseActivity() async {
    FCIDatabaseHelper.db
        .getCourseActivityList(courseId.value)
        .then((courseActivityList) =>{courseActivities.value=courseActivityList});
  }
  addActivity(name) async {
    FCIDatabaseHelper.db
        .insertActivity(Activity(name: name))
        .then((value) => activities.add(Activity(id: value, name: name)));
  }
  exelStudentActivity(Activity activity,bool isShare) async {
    FCIDatabaseHelper.db
        .getStudentActivityList(courseId.value, activity.id)
        .then((studentActivityList) =>MyExcel().exelIt(activity.name, studentActivityList,isShare: isShare));
  }
  addCourseActivity({Activity activity}) async {
    FCIDatabaseHelper.db
        .insertCourseActivity(
            CourseActivity(courseID: courseId.value, activityID: activity.id))
        .then((value) => courseActivities.add(
            CourseActivity(courseID: courseId.value, activityID: activity.id,name: activity.name)));
  }

  insertActivity() {
    addActivity(activityController.value.text);
  }

  deleteActivity(Activity activity) {
    FCIDatabaseHelper.db
        .deleteActivity(activity)
        .then((value){
      FCIDatabaseHelper.db
          .deleteCourseActivity(CourseActivity(courseID: courseId.value,activityID: activity.id)).then((value) {
        activities.remove(activity);
        fetchCourseActivity();
      } );
         });
  }

  deleteCourseActivity(CourseActivity courseActivity) {
    FCIDatabaseHelper.db
        .deleteCourseActivity(courseActivity)
        .then((value) {courseActivities.remove(courseActivity);

    FCIDatabaseHelper.db
        .deleteAllStudentActivity(courseId: courseActivity.courseID,activityId: courseActivity.activityID);
    });
  }
  updateCourseActivity(CourseActivity courseActivity,int index,int oldActivityId) async {
    FCIDatabaseHelper.db
        .updateCourseActivity(courseActivity, oldActivityId)
        .then((value){ courseActivities.setAll(index,[courseActivity]);
        FCIDatabaseHelper.db.updateStudentActivityName(courseActivity.activityID, courseId.value, oldActivityId).then((value) =>  courseActivities.refresh());

    });
  }
  updateActivity(Activity activity,int index) async {
    FCIDatabaseHelper.db
        .updateActivity(activity)
        .then((value){ activities.setAll(index,[activity]);
       fetchCourseActivity();
    });
  }

}
