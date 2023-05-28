import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:osavici/adminpages/adminfunctions.dart';
import 'package:osavici/adminpages/adminlogin.dart';
import 'package:flutter/gestures.dart';

class AdminCreateStudentRecord extends StatefulWidget {
  AdminCreateStudentRecord({Key? key}) : super(key: key);
  final String title = "Create Student Record";

  // final authuser = FirebaseAuth.instance.currentUser!;

  @override
  State<AdminCreateStudentRecord> createState() => _AdminCreateStudentRecord();
}

class _AdminCreateStudentRecord extends State<AdminCreateStudentRecord> {
  _AdminCreateStudentRecord();

  final _admincreatestudentrecordformkey = GlobalKey<FormState>();

  final studentCourseFormController = TextEditingController();
  final studentYearFormController = TextEditingController();
  final studentEmailFormController = TextEditingController();
  final studentNameFormController = TextEditingController();
  final studentPreviousViolationFormController = TextEditingController();
  final studentIDFormController = TextEditingController(); 

  String createStudentCourse = "";
  int createStudentYear = 0;
  String createStudentEmail = "";
  String createStudentName = "";
  String createStudentPreviousViolations = "";
  String createStudentID = ""; 

  @override
  void dispose() {
    studentCourseFormController.dispose();
    studentEmailFormController.dispose();
    studentNameFormController.dispose();
    studentPreviousViolationFormController.dispose();
    studentIDFormController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
        appBar: AppBar(
          leading: const Padding(
            padding: EdgeInsets.fromLTRB(12, 0, 0, 0),
            child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "OSA Violation Management System",
                  style: TextStyle(fontSize: 30),
                )),
          ),
          leadingWidth: 1000,
          title: Text(widget.title),
          toolbarHeight: 70.0,
        ),
        body: Center(
          child: buildCreateStudentRecordForm(
              context,
              _admincreatestudentrecordformkey,
              studentCourseFormController,
              createStudentCourse,
              studentYearFormController, 
              createStudentYear,
              studentEmailFormController,
              createStudentEmail,
              studentNameFormController,
              createStudentName, 
              studentPreviousViolationFormController,
              createStudentPreviousViolations,
              studentIDFormController,
              createStudentID),
        ),);
  } 
}
