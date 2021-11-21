import 'dart:core';
import 'dart:io';
import 'package:excel/excel.dart';
import 'package:fci_project/data/database.dart';
import 'package:fci_project/model/activity.dart';
import 'package:fci_project/model/course_activity.dart';
import 'package:fci_project/model/student.dart';
import 'package:fci_project/model/student_activity.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' hide Column, Alignment;
import 'package:flutter_share/flutter_share.dart';

class MyExcel {
  Future<void> saveInFile(List l) async {
    // var status = await Permission.manageExternalStorage.status;
    // if (!status.isGranted) {
    //   await Permission.storage.request();
    // }
    var path;
    if (Platform.isIOS) {
      var dir = await getApplicationDocumentsDirectory();
      print(dir.path);
      path = dir.path +
          "/" +
          (DateTime.now().millisecond / 1000).toString() +
          ".xlsx";
    } else {
      path = "/storage/emulated/0/Download" +
          "/" +
          (DateTime.now().millisecond / 1000).toString() +
          ".xlsx";
    }

    // var decoder = ExcelIt.createExcel();
    // var sheet = 'Sheet1';
    // decoder
    //   ..updateCell(
    //       sheet, CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: 0),"م احمد مدكور (متجوز اميرة جمعة ي كلاب )",
    //       wrap: TextWrapping.WrapText,);
    // List header=l[0].toJsonExcel().keys.toList();
    // for(int headerColumn=0;headerColumn<header.length;headerColumn++){
    //   decoder
    //     ..updateCell(
    //         sheet, CellIndex.indexByColumnRow(columnIndex: headerColumn, rowIndex: 1), header[headerColumn],
    //         wrap: TextWrapping.WrapText);
    // }
    // for(int row=0;row<l.length;row++){
    //   Map map=l[row].toJsonExcel();
    //  List data=map.values.toList();
    //   for(int column=0;column<data.length;column++){
    //     print (data);
    //     decoder
    //       ..updateCell(
    //           sheet, CellIndex.indexByColumnRow(columnIndex: column, rowIndex: row+2), data[column],
    //           wrap: TextWrapping.WrapText);
    //   }
    // }
    //
    // // ..updateCell(sheet, CellIndex.indexByString("A1"), "A1bh",
    // //     fontColorHex: "#FFFFFF", verticalAlign: VerticalAlign.Top)
    // // ..updateCell(sheet, CellIndex.indexByString("A2"), "A2",
    // //     backgroundColorHex: "#000000")
    // // ..updateCell(sheet, CellIndex.indexByString("E5"), "E5",
    // //     horizontalAlign: HorizontalAlign.Right);
    //
    // decoder.encode().then((onValue) {
    //   File(path)
    //     ..createSync(recursive: true)
    //     ..writeAsBytesSync(onValue);
    // }).then((_) async {
    // // Share.shareFiles(['$path'], text: 'Great picture');
    //   await FlutterShare.shareFile(title: "title", filePath: path);
    //
    // });
  }

  Future<void> generateExcel(String title, List header, List data,
      {bool isShare = false}) async {
    //Create a Excel document.
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
    var path;
    if (Platform.isIOS) {
      var dir = await getApplicationDocumentsDirectory();
      print(dir.path);
      path = dir.path +
          "/" +
          title.trim() +
          "(" +
          DateTime.now().day.toString() +
          "-" +
          DateTime.now().month.toString() +
          ")"
              ".xlsx";
    } else {
      path = "/storage/emulated/0/Download" +
          "/" +
          title +
          "(" +
          DateTime.now().day.toString() +
          "-" +
          DateTime.now().month.toString() +
          ").xlsx";
    }
    //Creating a workbook.
    final Workbook workbook = Workbook();
    //Accessing via index
    final Worksheet sheet = workbook.worksheets[0];
    sheet.showGridlines = true;
    sheet.name = title + "all grades";

    // Enable calculation for worksheet.
    sheet.enableSheetCalculations();

    sheet.getRangeByName('A1:H1').cellStyle.backColor = '#333F4F';
    sheet.getRangeByName('A1:H1').cellStyle.fontColor = '#FFFFFF';
    sheet.getRangeByName('A1:H1').cellStyle.hAlign = HAlignType.center;
    sheet.getRangeByName('A1:H1').cellStyle.fontSize = 30;
    sheet.getRangeByName('A1:H1').cellStyle.bold = true;
    sheet.getRangeByName('A1:H1').merge();
    sheet.getRangeByName('A1:H1').setText(title);

    ///-------------------------(header)----------------///
    int row = 2;
    List<String> allActivities = [];
    String background = '#333F4F';
    sheet.getRangeByIndex(row, 1).setText("Name");
    sheet.getRangeByIndex(row, 1).cellStyle.backColor = background;
    sheet.getRangeByIndex(row, 1).cellStyle.bold = true;
    sheet.getRangeByIndex(row, 1).cellStyle.fontSize = 20;
    sheet.getRangeByIndex(row, 1).columnWidth = 40;
    for (int i = 0; i < header.length; i++) {
      allActivities.add(header[i]['name']);
      sheet.getRangeByIndex(row, i + 2).setText(header[i]['name']);
      sheet.getRangeByIndex(row, i + 2).cellStyle.backColor = background;
      sheet.getRangeByIndex(row, i + 2).cellStyle.bold = true;
      sheet.getRangeByIndex(row, i + 2).cellStyle.fontSize = 20;
      sheet.getRangeByIndex(row, i + 2).columnWidth = 20;
    }

    for (int i = 0; i < data.length; i++) {
      List activities = data[i]['activity'];
      List degrees = data[i]['degree'];

      sheet.getRangeByIndex(row + 1 + i, 1).setText(data[i]['name']);
      sheet.getRangeByIndex(row + 1 + i, 1).cellStyle.fontSize = 15;
      sheet.getRangeByIndex(row + 1 + i, 1).columnWidth = 20;
      for (int j = 0; j < allActivities.length; j++) {
        sheet.getRangeByIndex(row + 1 + i, j + 2).setText(
            getDegree(allActivities[j], activities, degrees).toString());
        print(allActivities[j].toString());
        sheet.getRangeByIndex(row + 1 + i, j + 2).cellStyle.fontSize = 15;
        sheet.getRangeByIndex(row + 1 + i, i + 2).columnWidth = 20;
      }
    }

    //Save and launch the excel.
    final List<int> bytes = workbook.saveAsStream();
    //Dispose the document.
    workbook.dispose();
    File f = File(path);
    // f.create();
    // if (f.isAbsolute) f.delete(recursive: true);
    print("Saving.....");
    await f.writeAsBytes(bytes).then((value) async {
      if (isShare) await FlutterShare.shareFile(title: title, filePath: path);
    });
    //Save and launch the file.
  }

  ///======================================//
  Future<void> exelIt(String title, List data, {bool isShare}) async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
    var path;
    if (Platform.isIOS) {
      var dir = await getApplicationDocumentsDirectory();
      print(dir.path);
      path = dir.path +
          "/" +
          title +
          "(" +
          DateTime.now().day.toString() +
          "-" +
          DateTime.now().month.toString() +
          ").xlsx";
    } else {
      path = "/storage/emulated/0/Download" +
          "/" +
          title +
          "(" +
          DateTime.now().day.toString() +
          "-" +
          DateTime.now().month.toString() +
          ").xlsx";
    }
    //Creating a workbook.
    final Workbook workbook = Workbook();
    //Accessing via index
    final Worksheet sheet = workbook.worksheets[0];
    sheet.showGridlines = true;
    sheet.name = title + "all grades";

    // Enable calculation for worksheet.
    sheet.enableSheetCalculations();

    sheet.getRangeByName('A1:B1').cellStyle.backColor = '#FFF380';
    sheet.getRangeByName('A1:B1').cellStyle.fontColor = '#FFFFFF';
    sheet.getRangeByName('A1:B1').cellStyle.hAlign = HAlignType.center;
    sheet.getRangeByName('A1:B1').cellStyle.fontSize = 30;
    sheet.getRangeByName('A1:B1').cellStyle.bold = true;
    sheet.getRangeByName('A1:B1').merge();
    sheet.getRangeByName('A1:B1').setText(title);

    ///-------------------------(header)----------------///
    ///
    ///
    List header = data[0].toJsonExcel().keys.toList();
    String background = '#333F4F';
    int row = 2;

    for (int headerColumn = 1; headerColumn <= header.length; headerColumn++) {
      sheet.getRangeByIndex(row, headerColumn).cellStyle.backColor = background;
      sheet.getRangeByIndex(row, headerColumn).cellStyle.bold = true;
      sheet.getRangeByIndex(row, headerColumn).cellStyle.fontSize = 20;
      sheet.getRangeByIndex(row, headerColumn).columnWidth = 40;
      sheet
          .getRangeByIndex(row, headerColumn)
          .setText(header[headerColumn - 1]);
    }

    ///-------------------------(body)----------------///
    ///
    ///
    String bodyBackground = '#FFFFFF';

    for (int bodyRow = 0; bodyRow < data.length; bodyRow++) {
      Map map = data[bodyRow].toJsonExcel();
      List row = map.values.toList();
      for (int bodyColumn = 1; bodyColumn <= row.length; bodyColumn++) {
        sheet.getRangeByIndex(bodyRow + 3, bodyColumn).cellStyle.backColor =
            bodyBackground;
        sheet.getRangeByIndex(bodyRow + 3, bodyColumn).cellStyle.bold = true;
        sheet.getRangeByIndex(bodyRow + 3, bodyColumn).cellStyle.fontSize = 20;
        sheet.getRangeByIndex(bodyRow + 3, bodyColumn).columnWidth = 40;
        sheet
            .getRangeByIndex(bodyRow + 3, bodyColumn)
            .setText(row[bodyColumn - 1].toString());
      }
    }

    //Save and launch the excel.
    final List<int> bytes = workbook.saveAsStream();
    //Dispose the document.
    workbook.dispose();
    await File(path).writeAsBytes(bytes).then((value) async {
      if (isShare) await FlutterShare.shareFile(title: title, filePath: path);
    });
    //Save and launch the file.
  }

  String getDegree(String activity, List allStudentActivities, List degrees) {
    String degree = "0";
    for (int i = 0; i < allStudentActivities.length; i++) {
      if (activity.toLowerCase() ==
          allStudentActivities[i].toString().toString()) {
        degree = degrees[i].toString();
        break;
      }
    }
    return degree;
  }

  Future<void> readExcelFile(int courseId,
      {List<Student> students,
      List<StudentActivity> studentsCourse,
      List<Activity> activities,
      List<CourseActivity> courseActivities}) async {
    ///-------------------(get data from database)-------------------------//
    if (activities == null) {
      activities = await FCIDatabaseHelper.db.getActivityList();
    }
    if (courseActivities == null) {
      courseActivities =
          await FCIDatabaseHelper.db.getCourseActivityList(courseId);
    }
    if (studentsCourse == null) {
      studentsCourse =
          await FCIDatabaseHelper.db.getStudentOfCourseList(courseId);
    }
    if (students == null) {
      students = await FCIDatabaseHelper.db.getStudentList();
    }
    String filePath;

    FilePickerResult result = await FilePicker.platform.pickFiles();

    if (result != null) {
      filePath = result.files.single.path;
    } else {
      // User canceled the picker
    }
    var bytes = File(filePath).readAsBytesSync();
    var excel = Excel.decodeBytes(bytes);

    for (var table in excel.tables.keys) {
      Map<int, List<String>> mp = Map<int, List<String>>();
      int cols = excel.tables[table].maxCols;

      ///--------------(activities)------------------//
      List<int> activitiesId = [];
      List<dynamic> myactivities = excel.tables[table].rows[1].sublist(1, cols);
      print("------------------(Activities)-------------------");

      for (var activity in myactivities) {
        if (activity.toString() != "null") {
          List matchedActivity = activities
              .where((element) => element.name == activity.toString())
              .toList();
          if (matchedActivity.length == 0) {
            activitiesId.add(await FCIDatabaseHelper.db
                .insertActivity(Activity(name: activity.toString())));
          } else {
            activitiesId.add(matchedActivity.first.id);
          }
          List matchedActivity2 = courseActivities
              .where((element) => element.name == activity.toString())
              .toList();
          if (matchedActivity2.length == 0) {
            await FCIDatabaseHelper.db.insertCourseActivity(CourseActivity(
                courseID: courseId, activityID: activitiesId.last));
          }
        }
      }
      print("------------------(Acti)-------------------");
      for (var row in excel.tables[table].rows.sublist(2)) {
        int studentId;
        String studentName;
        for (int j = 0; j < cols; j++) {
          if (j == 0) {
            studentName = row[0].toString();
            if (studentName != "null") {
              List matchedActivity = students
                  .where((element) => element.name == studentName)
                  .toList();
              if (matchedActivity.length == 0) {
                print(studentName);
                studentId = await FCIDatabaseHelper.db
                    .insertStudent(Student(name: studentName));
              } else {
                studentId = matchedActivity.first.id;
              }
            }
          } else {
            print("student id is : $studentId");
            String degree = row[j].toString();
            if (degree != "null" && degree != "0") {
              List matchedStudent = studentsCourse
                  .where((element) => element.studentId == studentId)
                  .toList();
              if (matchedStudent.length == 0) {
                await FCIDatabaseHelper.db.insertStudentActivity(
                    StudentActivity(
                        studentId: studentId,
                        courseId: courseId,
                        name: studentName,
                        activityId: activitiesId[j - 1],
                        degree: int.parse(degree)));
              } else {
                await FCIDatabaseHelper.db.updateStudentDegree(StudentActivity(
                    studentId: studentId,
                    courseId: courseId,
                    name: studentName,
                    activityId: activitiesId[j - 2],
                    degree: int.parse(degree)));
              }
            }
          }
        }
        // print(mp);
      }
    }
  }
  Future<void> readActivityExcelFile(int courseId,int activityId,
      {List<Student> students,
      List<StudentActivity> studentsCourse,
      List<Activity> activities,
      List<CourseActivity> courseActivities}) async {
    ///-------------------(get data from database)-------------------------//
    if (activities == null) {
      activities = await FCIDatabaseHelper.db.getActivityList();
    }
    if (courseActivities == null) {
      courseActivities =
          await FCIDatabaseHelper.db.getCourseActivityList(courseId);
    }
    if (studentsCourse == null) {
      studentsCourse =
          await FCIDatabaseHelper.db.getStudentOfCourseList(courseId);
    }
    if (students == null) {
      students = await FCIDatabaseHelper.db.getStudentList();
    }
    String filePath;

    FilePickerResult result = await FilePicker.platform.pickFiles();

    if (result != null) {
      filePath = result.files.single.path;
    } else {
      // User canceled the picker
    }
    var bytes = File(filePath).readAsBytesSync();
    var excel = Excel.decodeBytes(bytes);

    for (var table in excel.tables.keys) {
      Map<int, List<String>> mp = Map<int, List<String>>();
      int cols = excel.tables[table].maxCols;

      ///--------------(activities)------------------//
      int activityId;
      String myActivity = excel.tables[table].rows[1][2];
      print("------------------(Activities)-------------------");
        if (myActivity.toString() != "null") {
          List matchedActivity = activities
              .where((element) => element.name == myActivity.toString())
              .toList();
          if (matchedActivity.length == 0) {
            activityId=await FCIDatabaseHelper.db
                .insertActivity(Activity(name: myActivity.toString()));
          } else {
    activityId=matchedActivity.first.id;
          }
          List matchedActivity2 = courseActivities
              .where((element) => element.name == myActivity.toString())
              .toList();
          if (matchedActivity2.length == 0) {
            await FCIDatabaseHelper.db.insertCourseActivity(CourseActivity(
                courseID: courseId, activityID: activityId));
          }
        }
      print("------------------(Acti)-------------------");
      for (var row in excel.tables[table].rows.sublist(2)) {
        int studentId;
        String studentName;

            studentName = row[0].toString();
            if (studentName != "null") {
              List matchedActivity = students
                  .where((element) => element.name == studentName)
                  .toList();
              if (matchedActivity.length == 0) {
                print(studentName);
                studentId = await FCIDatabaseHelper.db
                    .insertStudent(Student(name: studentName));
              } else {
                studentId = matchedActivity.first.id;
              }
            }

            String degree = row[1].toString();
            if (degree != "null" && degree != "0") {
              List matchedStudent = studentsCourse
                  .where((element) => element.studentId == studentId)
                  .toList();
              if (matchedStudent.length == 0) {
                await FCIDatabaseHelper.db.insertStudentActivity(
                    StudentActivity(
                        studentId: studentId,
                        courseId: courseId,
                        name: studentName,
                        activityId: activityId,
                        degree: int.parse(degree)));
              } else {
                await FCIDatabaseHelper.db.updateStudentDegree(StudentActivity(
                    studentId: studentId,
                    courseId: courseId,
                    name: studentName,
                    activityId: activityId,
                    degree: int.parse(degree)));
              }
          }
        }
        // print(mp);
      }
    }
}
