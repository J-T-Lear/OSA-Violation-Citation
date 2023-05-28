import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:osavici/adminpages/adminfunctions.dart';
import 'package:osavici/adminpages/adminlogin.dart';
import 'package:flutter/gestures.dart';

class AdminUpdateStudentRecord extends StatefulWidget {
  final String studentrecordid;
  AdminUpdateStudentRecord({Key? key, required this.studentrecordid})
      : super(key: key);
  final String title = "Update Student Record";

  // final authuser = FirebaseAuth.instance.currentUser!;

  @override
  State<AdminUpdateStudentRecord> createState() => _AdminUpdateStudentRecord();
}

class _AdminUpdateStudentRecord extends State<AdminUpdateStudentRecord> {
  _AdminUpdateStudentRecord();

  final _adminupdatestudentrecordformkey = GlobalKey<FormState>();

  final studentCourseFormController = TextEditingController();
  final studentYearFormController = TextEditingController();
  final studentEmailFormController = TextEditingController();
  final studentNameFormController = TextEditingController();
  final studentPreviousViolationFormController = TextEditingController();
  final studentIDFormController = TextEditingController();

  String updateStudentCourse = "";
  int updateStudentYear = 0;
  String updateStudentEmail = "";
  String oldStudentName = "";
  String updateStudentName = "";
  String updateStudentPreviousViolations = "";
  String oldStudentID = "";
  String updateStudentID = "";

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
        child: StreamBuilder<Student>(
            stream: retrieveStudent(studentrecordid: widget.studentrecordid),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                print(snapshot.error);
                return Center(
                  child: Column(
                    children: [
                      const Text('Something went wrong'),
                      const SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                        child: const Text("Go Back"),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      )
                    ],
                  ),
                );
              }
              if (snapshot.hasData) {
                final student = snapshot.data!;
                String studentrecordID = student.id;
                oldStudentID = student.studentid;
                oldStudentName = student.name;
                studentCourseFormController.text = student.course;
                studentYearFormController.text = student.year.toString();
                studentEmailFormController.text = student.studentemail;
                studentNameFormController.text = student.name;
                studentPreviousViolationFormController.text =
                    student.previousViolations.toString();
                studentIDFormController.text = student.studentid;

                return buildUpdateStudentRecordFormAdmin(
                    context,
                    studentrecordID,
                    _adminupdatestudentrecordformkey,
                    studentCourseFormController,
                    updateStudentCourse,
                    studentYearFormController,
                    updateStudentYear,
                    studentEmailFormController,
                    updateStudentEmail,
                    studentNameFormController,
                    oldStudentName,
                    updateStudentName,
                    studentPreviousViolationFormController,
                    updateStudentPreviousViolations,
                    studentIDFormController,
                    oldStudentID,
                    updateStudentID);
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            }),
      ),
    );
  }

  signOutAdmin() {
    ////Find a way to merge this with other signout function
    print(
        "There was an attempt to logout"); ////in adminlogin page and move to adminfunctions
    FirebaseAuth.instance.signOut();
    if (!context.mounted) return;
    // Navigator.of(context).popUntil((route) => route.isFirst);
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => const AdminLoginPage()));
  }
}
