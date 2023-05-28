import 'dart:convert';
import 'dart:js';
import 'package:jiffy/jiffy.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:osavici/adminpages/adminadminlist.dart';
import 'package:osavici/adminpages/admincreateadmin.dart';
import 'package:osavici/adminpages/adminupdateadmin.dart';

import 'package:osavici/main.dart';
import 'package:osavici/studentpages/studentfunctions.dart';

import 'package:osavici/adminpages/adminlogin.dart';

import 'package:osavici/adminpages/adminviolationlist.dart';
import 'package:osavici/adminpages/adminupdateviolationrecord.dart';

import 'package:osavici/adminpages/adminstudentlist.dart';
import 'package:osavici/adminpages/admincreatestudentrecord.dart';
import 'package:osavici/adminpages/adminupdatestudentrecord.dart';

import 'package:osavici/adminpages/adminviolationtypelist.dart';
import 'package:osavici/adminpages/admincreateviolationtype.dart';
import 'package:osavici/adminpages/adminupdateviolationtype.dart';

import 'package:osavici/adminpages/adminguardlist.dart';
import 'package:osavici/adminpages/admincreateguard.dart';
import 'package:osavici/adminpages/adminupdateguard.dart';

import 'package:osavici/adminpages/admingenerateqr.dart';
import 'package:osavici/adminpages/adminviolationwarninglist.dart';
import 'package:osavici/adminpages/adminviolationhistorylist.dart';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qr_flutter/qr_flutter.dart';

//Note, replace auth adminuser implementation with actual firebase function when there is time

int timesstudentquerycalled = 0;

List<String> violationtypes = <String>[];

////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////Routing  Code////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                    //
//                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////

gotoadminloginpage(BuildContext context) {
  Navigator.push(
      context, MaterialPageRoute(builder: (context) => const AdminLoginPage()));
}

///////////////////LIST PAGES///////////////////

gotoadminstudentlistpage(BuildContext context, String adminemail) {
  Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => AdminStudentList(adminEmail: adminemail)));
}

gotoadminviolationlistpage(BuildContext context, String adminemail) {
  Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => AdminViolationList(adminEmail: adminemail)));
}

gotoadminviolationwarninglistpage(BuildContext context, String adminemail) {
  fixRobertosMistakes();
  getlistofviolationtype();
  Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              AdminViolationWarningList(adminEmail: adminemail)));
}

gotoadminviolationhistorylistpage(BuildContext context, String adminemail) {
  Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              AdminViolationHistoryList(adminEmail: adminemail)));
}

gotoadminviolationtypelistpage(BuildContext context, String adminemail) {
  Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              AdminViolationTypeList(adminEmail: adminemail)));
}

gotoadminadminlistpage(BuildContext context, String adminemail) {
  Navigator.push(
      context,
      MaterialPageRoute(
          builder: ((context) => AdminAdminList(adminEmail: adminemail))));
}

gotoadminguardlistpage(BuildContext context, String adminemail) {
  Navigator.push(
      context,
      MaterialPageRoute(
          builder: ((context) => AdminGuardList(adminEmail: adminemail))));
}

////////////////////////////
///Firebase auth function///
////////////////////////////
///
///////////////////LIST PAGES///////////////////
///
// gotoadminloginpage(BuildContext context) {
//   Navigator.push(
//       context, MaterialPageRoute(builder: (context) => const AdminLoginPage()));
// }
///gotoadminstudentlistpage(BuildContext context) {
//   Navigator.push(
//       context, MaterialPageRoute(builder: (context) => AdminStudentList()));
// }
///
// gotoadminviolationlistpage(BuildContext context) {
//   Navigator.push(
//       context, MaterialPageRoute(builder: (context) => AdminViolationList()));
// }

// gotoadminviolationtypelistpage(BuildContext context) {
//   Navigator.push(context,
//       MaterialPageRoute(builder: (context) => AdminViolationTypeList()));
// }

// gotoadminadminlistpage(BuildContext context) {
//   Navigator.push(
//       context, MaterialPageRoute(builder: ((context) => AdminAdminList())));
// }

/////////////////UPDATE PAGES///////////////////

gotoadminupdateviolationrecordpage(
    BuildContext context, String violationrecordid) {
  Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              AdminUpdateViolationRecord(violationid: violationrecordid)));
}

gotoadminupdatestudentrecordpage(BuildContext context, String studentrecordid) {
  Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              AdminUpdateStudentRecord(studentrecordid: studentrecordid)));
}

gotoadminupdateviolationtypepage(BuildContext context, String violationtypeid) {
  Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => AdminUpdateViolationTypeRecord(
              violationtypeid: violationtypeid)));
}

gotoadminupdateadminpage(BuildContext context, String adminid) {
  Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => AdminUpdateAdminRecord(adminid: adminid)));
}

gotoadminupdateguardpage(BuildContext context, String guardid) {
  Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => AdminUpdateGuardRecord(guardid: guardid)));
}

///////////////////CREATE PAGES///////////////////

gotoadmincreateviolationtypepage(BuildContext context) {
  Navigator.push(context,
      MaterialPageRoute(builder: ((context) => AdminCreateViolationType())));
}

gotoadmincreatestudentrecordpage(BuildContext context) {
  Navigator.push(context,
      MaterialPageRoute(builder: (context) => AdminCreateStudentRecord()));
}

gotoadmincreateadminpage(BuildContext context) {
  Navigator.push(
      context, MaterialPageRoute(builder: ((context) => AdminCreateAdmin())));
}

gotoadmincreateguardpage(BuildContext context) {
  Navigator.push(
      context, MaterialPageRoute(builder: ((context) => AdminCreateGuard())));
}

///////////////////CREATE QR CODE PAGE///////////////////

gotoadmincreateqrcodepage(BuildContext context, String studentrecordid) {
  Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              AdminGenerateQRCode(studentrecordid: studentrecordid)));
}

////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////Student  Code////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                    //
//                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////

class Student {
  String id;
  final String studentid;
  final String name;
  final String course;
  final int year;
  final String studentpassword;
  final String studentemail;
  final int previousViolations;

  Student({
    this.id = "",
    required this.studentid,
    required this.name,
    required this.course,
    required this.year,
    required this.studentpassword,
    required this.studentemail,
    required this.previousViolations,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'studentID': studentid,
        'name': name,
        'course': course,
        'year': year,
        'password': studentpassword,
        'email': studentemail,
        'previousViolation': previousViolations,
      };

  static Student fromJson(Map<String, dynamic> json) => Student(
      id: json['id'],
      studentid: json['studentID'],
      name: json['name'],
      course: json['course'],
      year: json['year'],
      studentpassword: json['password'],
      studentemail: json['email'],
      previousViolations: json['previousViolation']);

  static Student mapDocSnapshot(querySnapshot) => Student(
        id: querySnapshot.value['id'],
        studentid: querySnapshot.value['studentID'],
        name: querySnapshot.value['name'],
        course: querySnapshot.value['course'],
        year: querySnapshot.value['year'],
        studentpassword: querySnapshot.value['password'],
        studentemail: querySnapshot.value['email'],
        previousViolations: querySnapshot.value['previousViolation'],
      );
}

Stream<List<Student>> readStudents() => FirebaseFirestore.instance
    .collection('Students')
    .snapshots()
    .map((snapshot) =>
        snapshot.docs.map((doc) => Student.fromJson(doc.data())).toList());

Stream<List<Student>> searchStudents(
        {required String searchcategory, required String adminsearchkey}) =>
    FirebaseFirestore.instance
        .collection('Students')
        .where(searchcategory, isEqualTo: adminsearchkey)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Student.fromJson(doc.data())).toList());

//Add User to Student collection
Future createUser(
    {required String studentid,
    required String name,
    required String course,
    required int year,
    required String studentpassword,
    required String studentemail,
    required int previousViolations}) async {
  final docUser = FirebaseFirestore.instance.collection('Students').doc();

  final student = Student(
    id: docUser.id,
    studentid: studentid,
    name: name,
    course: course,
    year: year,
    studentpassword: studentpassword,
    studentemail: studentemail,
    previousViolations: previousViolations,
  );

  final json = student.toJson();

  await docUser.set(json);
}

Widget buildStudentTile(Student student) => ListTile(
      //Method for generating list tiles
      //key: ValueKey(violation.id),
      title: Align(
        alignment: Alignment.centerLeft,
        child: Column(
          children: [
            const Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                "Name :",
                style: TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                student.name,
                style: const TextStyle(
                  fontSize: 32.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
      subtitle: Align(
        alignment: Alignment.centerLeft,
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Column(children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text("ID Number : ${student.studentid}"),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Course : ${student.course}"),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Year : ${student.year}"),
                    ),
                  ]),
                ),
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text("Email : ${student.studentemail}"),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                            "Number of Warning Violations : ${student.previousViolations}"),
                      ),
                    ],
                  ),
                ),
                Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(2, 0, 2, 0),
                      child: ElevatedButton(
                          onPressed: () {
                            gotoadminupdatestudentrecordpage(
                                NavigationService.navigatorKey.currentContext!,
                                student.id);
                            print(student.id);
                          },
                          child: const Text("Update")),
                    )),
                Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(2, 0, 2, 0),
                      child: ElevatedButton(
                          onPressed: () {
                            gotoadmincreateqrcodepage(
                                NavigationService.navigatorKey.currentContext!,
                                student.id);
                            print(student.id);
                          },
                          child: const Text("QR Code")),
                    )),
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            const Divider(
              thickness: 2,
            ),
          ],
        ),
      ),
    );

Stream<Student> retrieveStudent({required String studentrecordid}) =>
    FirebaseFirestore.instance
        .collection('Students')
        .doc(studentrecordid)
        .snapshots()
        .map((doc) => Student.fromJson(doc.data()!));

Widget buildUpdateStudentRecordFormAdmin(
  BuildContext context,
  String studentRecordID,
  GlobalKey<FormState> formkey,
  TextEditingController studentCourseFormController,
  String updateStudentCourse,
  TextEditingController studentYearFormController,
  int updateStudentYear,
  TextEditingController studentEmailFormController,
  String updateStudentEmail,
  TextEditingController studentNameFormController,
  String oldStudentName,
  String updateStudentName,
  TextEditingController studentPreviousViolationFormController,
  String updateStudentPreviousViolations,
  TextEditingController studentIDFormController,
  String oldStudentID,
  String updateStudentID,
) =>
    ListView(
      children: [
        Center(
          child: SizedBox(
            width: 600,
            child: Form(
              key: formkey,
              child: Column(
                children: [
                  const SizedBox(
                    height: 48,
                  ),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text("ID Number"),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  TextFormField(
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: const InputDecoration(
                        isDense: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        )),
                    autofocus: true,
                    controller: studentIDFormController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Required";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 48,
                  ),
                  const Align(
                      alignment: Alignment.centerLeft, child: Text("Name")),
                  const SizedBox(
                    height: 12,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                        isDense: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        )),
                    controller: studentNameFormController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Required";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 48,
                  ),
                  const Align(
                      alignment: Alignment.centerLeft, child: Text("Course")),
                  const SizedBox(
                    height: 12,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                        isDense: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        )),
                    controller: studentCourseFormController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Required";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 48,
                  ),
                  const Align(
                      alignment: Alignment.centerLeft, child: Text("Year")),
                  const SizedBox(
                    height: 12,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                        isDense: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        )),
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    controller: studentYearFormController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Required";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 48,
                  ),
                  const Align(
                      alignment: Alignment.centerLeft, child: Text("Email")),
                  const SizedBox(
                    height: 12,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                        isDense: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        )),
                    controller: studentEmailFormController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Required";
                      } else if (!value.contains("@")) {
                        return "Please enter a valid email.";
                      } else if (!value.contains(".")) {
                        return "Please enter a valid email.";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 48,
                  ),
                  const Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Number of Previous Violations")),
                  const SizedBox(
                    height: 12,
                  ),
                  TextFormField(
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: const InputDecoration(
                        isDense: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        )),
                    controller: studentPreviousViolationFormController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Required";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 69,
                  ),
                ],
              ),
            ),
          ),
        ),
        Center(
          child: SizedBox(
            width: 600,
            child: Row(children: [
              const SizedBox(
                width: 200,
              ),
              ElevatedButton(
                onPressed: () {
                  if (formkey.currentState!.validate()) {
                    updateStudentID = studentIDFormController.text;
                    updateStudentName = studentNameFormController.text;
                    updateStudentCourse = studentCourseFormController.text;
                    updateStudentEmail = studentEmailFormController.text;
                    updateStudentPreviousViolations =
                        studentPreviousViolationFormController.text;

                    int passableupdatePreviousViolations =
                        int.parse(updateStudentPreviousViolations);

                    updateStudentRecord(
                        context: context,
                        studentrecordid: studentRecordID,
                        updateCourse: updateStudentCourse,
                        updateEmail: updateStudentEmail,
                        updateName: updateStudentName,
                        updatePreviousViolations:
                            passableupdatePreviousViolations,
                        updateStudentID: updateStudentID);

                    if (!identical(oldStudentName, updateStudentName)) {
                      print("They are not identical");
                      updatestudentsviolationsNames(
                          oldstudentName: oldStudentName,
                          newstudentName: updateStudentName);
                    }

                    if (!identical(oldStudentID, updateStudentID)) {
                      print("They are not identical");
                      updatestudentsviolationsIDs(
                          oldstudentId: oldStudentID,
                          newstudentid: updateStudentID);
                    }
                  }
                },
                child: const Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 12.0, horizontal: 48.0),
                  child: Text("Update"),
                ),
              ),
              const SizedBox(
                width: 14,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 12.0, horizontal: 48.0),
                  child: Text("Cancel"),
                ),
              ),
            ]),
          ),
        ),
        const Center(
          child: SizedBox(
            height: 50,
          ),
        ),
      ],
    );

Future resetStudentViolationCount({ 
  required String studentrecordid,  
}) async {
  final studentRef =
      FirebaseFirestore.instance.collection("Students").doc(studentrecordid);
  studentRef.update({ 
    "previousViolation": 0, 
  }); 
}

Future updateStudentRecord({
  required BuildContext context,
  required String studentrecordid,
  required String updateCourse,
  required String updateEmail,
  required String updateName,
  required int updatePreviousViolations,
  required String updateStudentID,
}) async {
  final studentRef =
      FirebaseFirestore.instance.collection("Students").doc(studentrecordid);
  studentRef.update({
    "course": updateCourse,
    "email": updateEmail,
    "name": updateName,
    "previousViolation": updatePreviousViolations,
    "studentID": updateStudentID,
  });
  Navigator.pop(context);
}

Widget buildCreateStudentRecordForm(
  BuildContext context,
  GlobalKey<FormState> formkey,
  TextEditingController studentCourseFormController,
  String createStudentCourse,
  TextEditingController studentYearFormController,
  int createStudentYear,
  TextEditingController studentEmailFormController,
  String createStudentEmail,
  TextEditingController studentNameFormController,
  String createStudentName,
  TextEditingController studentPreviousViolationFormController,
  String createStudentPreviousViolations,
  TextEditingController studentIDFormController,
  String createStudentID,
) =>
    ListView(
      children: [
        Center(
          child: SizedBox(
            width: 600,
            child: Form(
              key: formkey,
              child: Column(
                children: [
                  const SizedBox(
                    height: 48,
                  ),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text("ID Number"),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  TextFormField(
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: const InputDecoration(
                        isDense: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        )),
                    autofocus: true,
                    controller: studentIDFormController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Required";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 48,
                  ),
                  const Align(
                      alignment: Alignment.centerLeft, child: Text("Name")),
                  const SizedBox(
                    height: 12,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                        isDense: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        )),
                    controller: studentNameFormController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Required";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 48,
                  ),
                  const Align(
                      alignment: Alignment.centerLeft, child: Text("Course")),
                  const SizedBox(
                    height: 12,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                        isDense: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        )),
                    controller: studentCourseFormController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Required";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 48,
                  ),
                  const Align(
                      alignment: Alignment.centerLeft, child: Text("Year")),
                  const SizedBox(
                    height: 12,
                  ),
                  TextFormField(
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: const InputDecoration(
                        isDense: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        )),
                    controller: studentYearFormController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Required";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 48,
                  ),
                  const Align(
                      alignment: Alignment.centerLeft, child: Text("Email")),
                  const SizedBox(
                    height: 12,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                        isDense: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        )),
                    controller: studentEmailFormController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Required";
                      } else if (!value.contains("@")) {
                        return "Please enter a valid email.";
                      } else if (!value.contains(".")) {
                        return "Please enter a valid email.";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 48,
                  ),
                  const Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Number of Previous Violations")),
                  const SizedBox(
                    height: 12,
                  ),
                  TextFormField(
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: const InputDecoration(
                        isDense: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        )),
                    controller: studentPreviousViolationFormController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Required";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 69,
                  ),
                ],
              ),
            ),
          ),
        ),
        Center(
          child: SizedBox(
            width: 600,
            child: Row(children: [
              const SizedBox(
                width: 200,
              ),
              ElevatedButton(
                onPressed: () {
                  if (formkey.currentState!.validate()) {
                    createStudentID = studentIDFormController.text;
                    createStudentName = studentNameFormController.text;
                    createStudentCourse = studentCourseFormController.text;
                    createStudentYear =
                        int.parse(studentYearFormController.text);
                    createStudentEmail = studentEmailFormController.text;
                    createStudentPreviousViolations =
                        studentPreviousViolationFormController.text;

                    int passablecreatePreviousViolations =
                        int.parse(createStudentPreviousViolations);

                    createStudentRecord(
                        createstudentid: createStudentID,
                        createstudentname: createStudentName,
                        createstudentcourse: createStudentCourse,
                        createstudentyear: createStudentYear,
                        createstudentpassword: "defaultstudentpassword",
                        createstudentemail: createStudentEmail,
                        createstudentpreviousviolations:
                            passablecreatePreviousViolations);

                    Navigator.pop(context);
                  }
                },
                child: const Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 12.0, horizontal: 48.0),
                  child: Text("Create"),
                ),
              ),
              const SizedBox(
                width: 14,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 12.0, horizontal: 48.0),
                  child: Text("Cancel"),
                ),
              ),
            ]),
          ),
        ),
        const Center(
          child: SizedBox(
            height: 50,
          ),
        ),
      ],
    );

Future createStudentRecord(
    {required String createstudentid,
    required String createstudentname,
    required String createstudentcourse,
    required int createstudentyear,
    required String createstudentpassword,
    required String createstudentemail,
    required int createstudentpreviousviolations}) async {
  final docStudent = FirebaseFirestore.instance.collection('Students').doc();

  final student = StudentUser(
    id: docStudent.id,
    studentid: createstudentid,
    name: createstudentname,
    course: createstudentcourse,
    year: createstudentyear,
    studentpassword: createstudentpassword,
    studentemail: createstudentemail,
    previousViolations: createstudentpreviousviolations,
  );

  final json = student.toJson();

  await docStudent.set(json);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////Violation Records  Code///////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                    //
//                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////

class StudentViolation {
  String id;
  final String violationrecordid;
  final String violationtype;
  final String violationdate;
  final String violationstatus;
  final String violationstudentid;
  final String violationstudentname;
  final int violationguardid;

  StudentViolation({
    this.id = "",
    required this.violationrecordid,
    required this.violationtype,
    required this.violationdate,
    required this.violationstatus,
    required this.violationstudentid,
    required this.violationstudentname,
    required this.violationguardid,
  });

  Map<String, dynamic> toJson() => {
        'violationId': id,
        'violationType': violationtype,
        'date': violationdate,
        'status': violationstatus,
        'studentId': violationstudentid,
        'studentName': violationstudentname,
        'guardIdNumber': violationguardid,
      };

  static StudentViolation fromJson(Map<String, dynamic> json) =>
      StudentViolation(
        violationrecordid: json['id'],
        violationtype: json['violationType'],
        violationdate: json['date'],
        violationstatus: json['status'],
        violationstudentid: json['studentId'],
        violationstudentname: json['studentName'],
        violationguardid: json['guardIdNumber'],
      );

  static StudentViolation mapDocSnapshot(querySnapshot) => StudentViolation(
        violationrecordid: querySnapshot.value['violationId'],
        violationtype: querySnapshot.value['violationType'],
        violationdate: querySnapshot.value['date'],
        violationstatus: querySnapshot.value['status'],
        violationstudentid: querySnapshot.value['studentId'],
        violationstudentname: querySnapshot.value['studentName'],
        violationguardid: querySnapshot.value['guardIdNumber'],
      );
}

Future updateViolationRecord(
    {required BuildContext context,
    required String violationid,
    required String updateViolationType,
    required String updateViolationStudentName,
    required String updateViolationStudentID,
    required String updateViolationDate,
    required String updateViolationStatus,
    required int updateViolationGuardID}) async {
  final violationRef = FirebaseFirestore.instance
      .collection("Violation Record")
      .doc(violationid);
  violationRef.update({
    "violationType": updateViolationType,
    "date": updateViolationDate,
    "status": updateViolationStatus,
    "studentId": updateViolationStudentID,
    "studentName": updateViolationStudentName,
    "guardIdNumber": updateViolationGuardID
  });
  Navigator.pop(context);
}

Stream<List<StudentViolation>> readViolations() => FirebaseFirestore.instance
    .collection('Violation Record')
    .snapshots()
    .map((snapshot) => snapshot.docs
        .map((doc) => StudentViolation.fromJson(doc.data()))
        .toList());

Stream<List<StudentViolation>> searchViolations(
        {required String searchcategory, required String adminsearchkey}) =>
    FirebaseFirestore.instance
        .collection('Violation Record')
        .where(searchcategory, isEqualTo: adminsearchkey)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => StudentViolation.fromJson(doc.data()))
            .toList());

Stream<List<StudentViolation>> readWarningViolations() => FirebaseFirestore
    .instance
    .collection('Violation Record')
    .where("status", isEqualTo: "Warning")
    .snapshots()
    .map((snapshot) => snapshot.docs
        .map((doc) => StudentViolation.fromJson(doc.data()))
        .toList());

Stream<List<StudentViolation>> searchWarningViolations(
        {required String searchcategory, required String adminsearchkey}) =>
    FirebaseFirestore.instance
        .collection('Violation Record')
        .where(searchcategory, isEqualTo: adminsearchkey)
        .where("status", isEqualTo: "Warning")
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => StudentViolation.fromJson(doc.data()))
            .toList());

Stream<List<StudentViolation>> readPendingViolations() => FirebaseFirestore
    .instance
    .collection('Violation Record')
    .where("status", isEqualTo: "Pending")
    .snapshots()
    .map((snapshot) => snapshot.docs
        .map((doc) => StudentViolation.fromJson(doc.data()))
        .toList());

Stream<List<StudentViolation>> searchPendingViolations(
        {required String searchcategory, required String adminsearchkey}) =>
    FirebaseFirestore.instance
        .collection('Violation Record')
        .where(searchcategory, isEqualTo: adminsearchkey)
        .where("status", isEqualTo: "Pending")
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => StudentViolation.fromJson(doc.data()))
            .toList());

Stream<List<StudentViolation>> readResolvedViolations() =>
    FirebaseFirestore.instance
        .collection('Violation Record')
        .where("status", isEqualTo: "Resolved")
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => StudentViolation.fromJson(doc.data()))
            .toList());

Stream<List<StudentViolation>> searchResolvedViolations(
        {required String searchcategory, required String adminsearchkey}) =>
    FirebaseFirestore.instance
        .collection('Violation Record')
        .where(searchcategory, isEqualTo: adminsearchkey)
        .where("status", isEqualTo: "Resolved")
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => StudentViolation.fromJson(doc.data()))
            .toList());

Widget buildViolationTile(StudentViolation violation) => ListTile(
      //Method for generating list tiles
      //key: ValueKey(violation.id),
      title: Align(
        alignment: Alignment.centerLeft,
        child: Column(
          children: [
            const Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                "Violation Type :",
                style: TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                violation.violationtype,
                style: const TextStyle(
                  fontSize: 32.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
      subtitle: Align(
        alignment: Alignment.centerLeft,
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Column(children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Date : ${violation.violationdate}"),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Guard ID : ${violation.violationguardid}"),
                    ),
                  ]),
                ),
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                            "Student Name : ${violation.violationstudentname}"),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                            "Student ID : ${violation.violationstudentid}"),
                      ),
                    ],
                  ),
                ),
                Expanded(
                    child: ElevatedButton(
                        onPressed: () {
                          gotoadminupdateviolationrecordpage(
                              NavigationService.navigatorKey.currentContext!,
                              violation.violationrecordid);
                        },
                        child: const Text("Update"))),
              ],
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text("Status : ${violation.violationstatus}"),
            ),
            const Divider(
              thickness: 2,
            ),
          ],
        ),
      ),
    );

Widget buildPendingViolationTile(StudentViolation violation) => ListTile(
      //Method for generating list tiles
      //key: ValueKey(violation.id),
      title: Align(
        alignment: Alignment.centerLeft,
        child: Column(
          children: [
            const Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                "Violation Type :",
                style: TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                violation.violationtype,
                style: const TextStyle(
                  fontSize: 32.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
      subtitle: Align(
        alignment: Alignment.centerLeft,
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Column(children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Date : ${violation.violationdate}"),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Guard ID : ${violation.violationguardid}"),
                    ),
                  ]),
                ),
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                            "Student Name : ${violation.violationstudentname}"),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                            "Student ID : ${violation.violationstudentid}"),
                      ),
                    ],
                  ),
                ),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.fromLTRB(2, 0, 2, 0),
                  child: ElevatedButton(
                      onPressed: () {
                        resolvePendingStudentViolations(
                            studentId: violation.violationstudentid,
                            violationType: violation.violationtype);
                        resolveWarningStudentViolations(
                            studentId: violation.violationstudentid,
                            violationType: violation.violationtype);
                        resetStudentViolationCount(studentrecordid: violation.violationstudentid);
                      },
                      child: const Text("Resolve")),
                )),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.fromLTRB(2, 0, 2, 0),
                  child: ElevatedButton(
                      onPressed: () {
                        gotoadminupdateviolationrecordpage(
                            NavigationService.navigatorKey.currentContext!,
                            violation.violationrecordid);
                      },
                      child: const Text("Update")),
                )),
              ],
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text("Status : ${violation.violationstatus}"),
            ),
            const Divider(
              thickness: 2,
            ),
          ],
        ),
      ),
    );

//Add Violation to Violation Record collection
Future createViolation(
    {required String violationtype,
    required String violationdate,
    required String violationstatus,
    required String violationstudentid,
    required String violationstudentname,
    required int violationguardid}) async {
  final docUser =
      FirebaseFirestore.instance.collection('Violation Record').doc();

  final violation = StudentViolation(
      id: docUser.id,
      violationrecordid: docUser.id,
      violationtype: violationtype,
      violationdate: violationdate,
      violationstatus: violationstatus,
      violationstudentid: violationstudentid,
      violationstudentname: violationstudentname,
      violationguardid: violationguardid);

  final json = violation.toJson();

  await docUser.set(json);
}

Stream<StudentViolation> retrieveviolation(
        {required String violationrecordid}) =>
    FirebaseFirestore.instance
        .collection('Violation Record')
        .doc(violationrecordid)
        .snapshots()
        .map((doc) => StudentViolation.fromJson(doc.data()!));

void _showdatepicker(BuildContext buildcontext, String date) {
  showDatePicker(
          context: buildcontext,
          initialDate: DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2024))
      .then((value) {
    date = value.toString();
    print(date);
  });
}

//Roberto my groupmate is nearly unworkable with, all that I'm asking him is to change the Firebase fields he
//uses in his create violation function to match up with the fields in the firebase collection so my webapp can read it,
//he himself asked me to change the fields earlier in the project which has caused this discrepancy
//he has delayed the project for 3 days before I stepped in and changed
//everything back so that he doesn't have to do anything
//the code below is part of my efforts to do this since he's unwilling to add these 2 fields
//to his violation creation code
//this is totally going to slow down opening the violations window everytime somebody adds a violation
//from the Robertos phone app
//I'm just glad I don't have to work with him anymore after this
//no one's actually gonna read the code so I'm venting here

Future getlistofviolationtype() async {
  violationtypes.clear();
  var collection = FirebaseFirestore.instance.collection('Violation Type');
  var querySnapshots = await collection.get();
  for (var doc in querySnapshots.docs) {
    String violationtypename = "";
    addViolationName(violationTypeID: doc.id);
  }
  return violationtypes;
}

Future addViolationName({required String violationTypeID}) async {
  String violationTypeName = "";

  final dbRef = FirebaseFirestore.instance
      .collection('Violation Type')
      .where("id", isEqualTo: violationTypeID)
      .get()
      .then(
    (querySnapshot) {
      violationTypeName = querySnapshot.docs[0]["name"];
      violationtypes.add(violationTypeName);
    },
    onError: (e) => print("Error completing: $e"),
  );
  return;
}
 
 

Future updatestudentsviolationsNames(
    {required String oldstudentName, required String newstudentName}) async {
  final dbRef = FirebaseFirestore.instance
      .collection('Violation Record')
      .where("studentName", isEqualTo: oldstudentName)
      .get()
      .then(
    (querySnapshot) {
      for (var doc in querySnapshot.docs) {
        final adminRef = FirebaseFirestore.instance
            .collection("Violation Record")
            .doc(doc.id);
        adminRef.update({
          "studentName": newstudentName,
        });
      }
    },
    onError: (e) => print("Error completing: $e"),
  );

  return;
}

Future updatestudentsviolationsIDs(
    {required String oldstudentId, required String newstudentid}) async {
  final dbRef = FirebaseFirestore.instance
      .collection('Violation Record')
      .where("studentId", isEqualTo: oldstudentId)
      .get()
      .then(
    (querySnapshot) {
      for (var doc in querySnapshot.docs) {
        final adminRef = FirebaseFirestore.instance
            .collection("Violation Record")
            .doc(doc.id);
        adminRef.update({
          "studentId": newstudentid,
        });
      }
    },
    onError: (e) => print("Error completing: $e"),
  );

  return;
}

Future resolveWarningStudentViolations(
    {required String studentId, required String violationType}) async {
  final dbRef = FirebaseFirestore.instance
      .collection('Violation Record')
      .where("status", isEqualTo: "Warning")
      .where("studentId", isEqualTo: studentId)
      .where("violationType", isEqualTo: violationType)
      .get()
      .then(
    (querySnapshot) {
      for (var doc in querySnapshot.docs) {
        final adminRef = FirebaseFirestore.instance
            .collection("Violation Record")
            .doc(doc.id);
        adminRef.update({
          "status": "Resolved",
        });
      }
    },
    onError: (e) => print("Error completing: $e"),
  );

  return;
}

Future resolvePendingStudentViolations(
    {required String studentId, required String violationType}) async {
  final dbRef = FirebaseFirestore.instance
      .collection('Violation Record')
      .where("status", isEqualTo: "Pending")
      .where("studentId", isEqualTo: studentId)
      .where("violationType", isEqualTo: violationType)
      .get()
      .then(
    (querySnapshot) {
      for (var doc in querySnapshot.docs) {
        final adminRef = FirebaseFirestore.instance
            .collection("Violation Record")
            .doc(doc.id);
        adminRef.update({
          "status": "Resolved",
        });
      }
    },
    onError: (e) => print("Error completing: $e"),
  );

  return;
}



















Future fixRobertosMistakes() async {
  int timesfixRobertosMistakecalled = 0;
  var collection = FirebaseFirestore.instance.collection('Violation Record');
  var querySnapshots = await collection.get();
  for (var doc in querySnapshots.docs) {
    timesfixRobertosMistakecalled = timesfixRobertosMistakecalled + 1;
    print("Times fixRobertosMistake is called: $timesfixRobertosMistakecalled");
    await fixRobertosMistake(violationid: doc.id);
  }
  return;
}

Future fixRobertosMistake({required String violationid}) async {
  final violationDocRef = FirebaseFirestore.instance
      .collection("Violation Record")
      .doc(violationid);
  String studentid = "null";
  int previousViolation = 0;
  String studentdocid = "null";

  await violationDocRef.get().then((DocumentSnapshot doc) {
    final dataMap = doc.data() as Map<String, dynamic>;
    studentid = dataMap['studentId'].toString();
    print("This is student id inside get");
    print(studentid);
  });

  final studentQueryRef = FirebaseFirestore.instance
      .collection('Students')
      .where("studentID", isEqualTo: studentid);
 
  print("Calling StudentQueryRef.get()");
  timesstudentquerycalled = timesstudentquerycalled + 1;
  print("Times Student Query Called: $timesstudentquerycalled");

  await studentQueryRef.get().then(
    (querySnapshot) {
      print("Done calling StudentQueryRef.get()");
      previousViolation = querySnapshot.docs[0]["previousViolation"];
      studentdocid = querySnapshot.docs[0]["id"].toString();
      print("Previous Violation inside");
      print(previousViolation);
    },
    onError: (e) {
      print("There's no previous violations dumbass");
      print("Error completing: $e");
    },
  );

  print("Previous Violation");
  print(previousViolation);
  print("[]");

   await violationDocRef.get().then(
    (DocumentSnapshot doc) {
      final dataMap = doc.data() as Map<String, dynamic>;
      if (dataMap.containsKey('id')) {
        return;
      } else {
        previousViolation = previousViolation + 1;

        FirebaseFirestore.instance
            .collection("Students")
            .doc(studentdocid)
            .update({
          "previousViolation": previousViolation,
        });

        final data = {"id": violationid};

        FirebaseFirestore.instance
            .collection("Violation Record")
            .doc(violationid)
            .set(data, SetOptions(merge: true));
        print("id added to violation record");
        return;
      }
    },
    onError: (e) => print("Error getting document: $e"),
  );

  // await violationDocRef.get().then(
  //   (DocumentSnapshot doc) {
  //     final dataMap = doc.data() as Map<String, dynamic>;
  //     if (dataMap.containsKey('status')) {
  //       return;
  //     } else if (previousViolation < 3) {
  //       previousViolation = previousViolation + 1;

  //       FirebaseFirestore.instance
  //           .collection("Students")
  //           .doc(studentdocid)
  //           .update({
  //         "previousViolation": previousViolation,
  //       });

  //       final data = {"id": violationid, "status": "Warning"};

  //       FirebaseFirestore.instance
  //           .collection("Violation Record")
  //           .doc(violationid)
  //           .set(data, SetOptions(merge: true));
  //       print("Status is Warning");
  //       return;
  //     } else {
  //       previousViolation = previousViolation + 1;

  //       FirebaseFirestore.instance
  //           .collection("Students")
  //           .doc(studentdocid)
  //           .update({
  //         "previousViolation": previousViolation,
  //       });

  //       final data = {"id": violationid, "status": "Pending"};

  //       FirebaseFirestore.instance
  //           .collection("Violation Record")
  //           .doc(violationid)
  //           .set(data, SetOptions(merge: true));
  //       print("Status is Pending");
  //       return;
  //     }
  //   },
  //   onError: (e) => print("Error getting document: $e"),
  // );
}
















////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////Violation Type  Code////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                    //
//                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////

class ViolationType {
  String id;
  final String name;
  final String description;

  ViolationType({
    this.id = "",
    required this.name,
    required this.description,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
      };

  static ViolationType fromJson(Map<String, dynamic> json) => ViolationType(
        id: json['id'],
        name: json['name'],
        description: json['description'],
      );

  static ViolationType mapDocSnapshot(querySnapshot) => ViolationType(
        id: querySnapshot.value['id'],
        name: querySnapshot.value['name'],
        description: querySnapshot.value['description'],
      );
}

Stream<List<ViolationType>> readViolationTypes() => FirebaseFirestore.instance
    .collection('Violation Type')
    .snapshots()
    .map((snapshot) => snapshot.docs
        .map((doc) => ViolationType.fromJson(doc.data()))
        .toList());

Stream<List<ViolationType>> searchViolationTypes(
        {required String searchcategory, required String adminsearchkey}) =>
    FirebaseFirestore.instance
        .collection('Violation Type')
        .where(searchcategory, isEqualTo: adminsearchkey)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ViolationType.fromJson(doc.data()))
            .toList());

//Add User to Student collection
Future createViolationType(
    {required String name, required String description}) async {
  final docViolationType =
      FirebaseFirestore.instance.collection('Violation Type').doc();

  final violationtype = ViolationType(
    id: docViolationType.id,
    name: name,
    description: description,
  );

  final json = violationtype.toJson();

  await docViolationType.set(json);
}

Widget buildViolationTypeTile(ViolationType violationtype) => ListTile(
      //Method for generating list tiles
      //key: ValueKey(violation.id),
      title: Align(
        alignment: Alignment.centerLeft,
        child: Column(
          children: [
            const Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                "Type :",
                style: TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                violationtype.name,
                style: const TextStyle(
                  fontSize: 32.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
      subtitle: Align(
        alignment: Alignment.centerLeft,
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 4,
                  child: Column(children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 12, 0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child:
                            Text("Description : ${violationtype.description}"),
                      ),
                    ),
                  ]),
                ),
                Expanded(
                    flex: 1,
                    child: ElevatedButton(
                        onPressed: () {
                          gotoadminupdateviolationtypepage(
                              NavigationService.navigatorKey.currentContext!,
                              violationtype.id);
                          print(violationtype.id);
                        },
                        child: const Text("Update"))),
                Expanded(
                    flex: 1,
                    child: ElevatedButton(
                        onPressed: () {
                          deleteViolationType(violationtype.id);
                          print(violationtype.id);
                        },
                        child: const Text("Delete"))),
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            const Divider(
              thickness: 2,
            ),
          ],
        ),
      ),
    );

Stream<ViolationType> retrieveViolationType(
        {required String violationtypeid}) =>
    FirebaseFirestore.instance
        .collection('Violation Type')
        .doc(violationtypeid)
        .snapshots()
        .map((doc) => ViolationType.fromJson(doc.data()!));

Widget buildUpdateViolationTypeFormAdmin(
  BuildContext context,
  String violationtypeid,
  GlobalKey<FormState> formkey,
  TextEditingController violationTypeNameFormController,
  String updateViolationTypeName,
  TextEditingController violationTypeDescriptionFormController,
  String updateViolationTypeDescription,
) =>
    ListView(
      children: [
        Center(
          child: SizedBox(
            width: 600,
            child: Form(
              key: formkey,
              child: Column(
                children: [
                  const SizedBox(
                    height: 48,
                  ),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Name"),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                        isDense: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        )),
                    autofocus: true,
                    controller: violationTypeNameFormController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Required";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 48,
                  ),
                  const Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Description")),
                  const SizedBox(
                    height: 12,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                        isDense: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        )),
                    controller: violationTypeDescriptionFormController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Required";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 69,
                  ),
                ],
              ),
            ),
          ),
        ),
        Center(
          child: SizedBox(
            width: 600,
            child: Row(children: [
              const SizedBox(
                width: 200,
              ),
              ElevatedButton(
                onPressed: () {
                  if (formkey.currentState!.validate()) {
                    updateViolationTypeName =
                        violationTypeNameFormController.text;
                    updateViolationTypeDescription =
                        violationTypeDescriptionFormController.text;

                    updateViolationTypeRecord(
                        context: context,
                        violationtypeid: violationtypeid,
                        updateName: updateViolationTypeName,
                        updateDescription: updateViolationTypeDescription);
                  }
                },
                child: const Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 12.0, horizontal: 48.0),
                  child: Text("Update"),
                ),
              ),
              const SizedBox(
                width: 14,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 12.0, horizontal: 48.0),
                  child: Text("Cancel"),
                ),
              ),
            ]),
          ),
        ),
        const Center(
          child: SizedBox(
            height: 50,
          ),
        ),
      ],
    );

Future updateViolationTypeRecord({
  required BuildContext context,
  required String violationtypeid,
  required String updateName,
  required String updateDescription,
}) async {
  final violationTypeRef = FirebaseFirestore.instance
      .collection("Violation Type")
      .doc(violationtypeid);
  violationTypeRef.update({
    "name": updateName,
    "description": updateDescription,
  });
  Navigator.pop(context);
}

Future deleteViolationType(violationtypeid) async {
  final violationTypeRef = FirebaseFirestore.instance
      .collection("Violation Type")
      .doc(violationtypeid);
  violationTypeRef.delete().then(
        (doc) => print("Violation Type deleted"),
        onError: (e) => print("Error updating Violation Type $e"),
      );
}

Widget buildCreateViolationTypeForm(
  BuildContext context,
  GlobalKey<FormState> formkey,
  TextEditingController violationTypeNameFormController,
  String createViolationTypeName,
  TextEditingController violationTypeDescriptionFormController,
  String createViolationTypeDescription,
) =>
    ListView(
      children: [
        Center(
          child: SizedBox(
            width: 600,
            child: Form(
              key: formkey,
              child: Column(
                children: [
                  const SizedBox(
                    height: 48,
                  ),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Name"),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                        isDense: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        )),
                    autofocus: true,
                    controller: violationTypeNameFormController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Required";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 48,
                  ),
                  const Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Description")),
                  const SizedBox(
                    height: 12,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                        isDense: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        )),
                    controller: violationTypeDescriptionFormController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Required";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 48,
                  ),
                ],
              ),
            ),
          ),
        ),
        Center(
          child: SizedBox(
            width: 600,
            child: Row(children: [
              const SizedBox(
                width: 200,
              ),
              ElevatedButton(
                onPressed: () {
                  if (formkey.currentState!.validate()) {
                    createViolationTypeName =
                        violationTypeNameFormController.text;
                    createViolationTypeDescription =
                        violationTypeDescriptionFormController.text;

                    createViolationType(
                        name: createViolationTypeName,
                        description: createViolationTypeDescription);

                    Navigator.pop(context);
                  }
                },
                child: const Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 12.0, horizontal: 48.0),
                  child: Text("Create"),
                ),
              ),
              const SizedBox(
                width: 14,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 12.0, horizontal: 48.0),
                  child: Text("Cancel"),
                ),
              ),
            ]),
          ),
        ),
        const Center(
          child: SizedBox(
            height: 50,
          ),
        ),
      ],
    );

////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////    Admin  Code     ////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                    //
//                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////

class Admin {
  String id;
  final String name;
  final String adminID;
  final String email;
  final String password;

  Admin({
    this.id = "",
    required this.name,
    required this.adminID,
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'adminID': adminID,
        'email': email,
        'password': password,
      };

  static Admin fromJson(Map<String, dynamic> json) => Admin(
        id: json['id'],
        name: json['name'],
        adminID: json['adminID'],
        email: json['email'],
        password: json['password'],
      );

  static Admin mapDocSnapshot(querySnapshot) => Admin(
        id: querySnapshot.value['id'],
        name: querySnapshot.value['name'],
        adminID: querySnapshot.value['adminID'],
        email: querySnapshot.value['email'],
        password: querySnapshot.value['password'],
      );
}

Future<bool> checkIfAdminIDIsUsed({required String adminID}) async {
  bool _adminFound = false;

  final QuerySnapshot result = await FirebaseFirestore.instance
      .collection('Admins')
      .where("adminID", isEqualTo: adminID)
      .get();

  final List<DocumentSnapshot> documents = result.docs;

  if (result.size > 0) {
    _adminFound = true;
    //exists
  } else {
    _adminFound = false;
    //not exists
  }

  return _adminFound;
}

Future<bool> checkIfAdminNameIsUsed({required String adminName}) async {
  bool _adminFound = false;

  final QuerySnapshot result = await FirebaseFirestore.instance
      .collection('Admins')
      .where("name", isEqualTo: adminName)
      .get();

  final List<DocumentSnapshot> documents = result.docs;

  if (result.size > 0) {
    _adminFound = true;
    //exists
  } else {
    _adminFound = false;
    //not exists
  }

  return _adminFound;
}

Future<bool> checkIfAdminEmailIsUsed({required String adminEmail}) async {
  bool _adminFound = false;

  final QuerySnapshot result = await FirebaseFirestore.instance
      .collection('Admins')
      .where("email", isEqualTo: adminEmail)
      .get();

  final List<DocumentSnapshot> documents = result.docs;

  if (result.size > 0) {
    _adminFound = true;
    //exists
  } else {
    _adminFound = false;
    //not exists
  }

  return _adminFound;
}

//This is part of a workaround, very unsafe - will be replaced by a Firebase Admin Auth API solution if time allows
Future<String> getAdminPassword({required String adminEmail}) async {
  bool _adminFound = false;
  String adminPassword =
      ""; //I am cringing at how unsafe this is. God help me if I have to do this again

  final dbRef = FirebaseFirestore.instance
      .collection('Admins')
      .where("adminEmail", isEqualTo: adminEmail)
      .get()
      .then(
    (querySnapshot) {
      adminPassword =
          querySnapshot.docs[0]["password"]; //Lord help me with this one.
      print("Retrieved password: $adminPassword");
    },
    onError: (e) => print("Error completing: $e"),
  );

  return adminPassword;
}

Future checkIfAdminExists(
    {required String adminID,
    required String adminName,
    required BuildContext buildcontext}) async {
  bool _adminFound = false;

  final dbRef = FirebaseFirestore.instance
      .collection('Admins')
      .where("adminID", isEqualTo: adminID)
      .get()
      .then(
    (querySnapshot) {
      if (identical(querySnapshot.docs[0]["name"], adminName)) {
        _adminFound = true;
      }
    },
    onError: (e) => print("Error completing: $e"),
  );

  return _adminFound;
}

Stream<List<Admin>> readAdmins() => FirebaseFirestore.instance
    .collection('Admins')
    .snapshots()
    .map((snapshot) =>
        snapshot.docs.map((doc) => Admin.fromJson(doc.data())).toList());

Stream<List<Admin>> searchAdmins(
        {required String searchcategory, required String adminsearchkey}) =>
    FirebaseFirestore.instance
        .collection('Admins')
        .where(searchcategory, isEqualTo: adminsearchkey)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Admin.fromJson(doc.data())).toList());

// Future<UserCredential> registerAdmin(String email, String password) async {
//   FirebaseApp app = await Firebase.initializeApp(
//       name: 'Secondary', options: Firebase.app().options);

//   UserCredential userCredential = await FirebaseAuth.instanceFor(app: app)
//       .createUserWithEmailAndPassword(email: email, password: password);

//   app.delete();
//   return Future.sync(() => userCredential);
// }

updateAdmin(String password, String email, String updateemail,
    String updatepassword) async {
  //This workaround is very unsafe, will be replaced with an Admin Auth API if there is time

  String editingAdminEmail = "";
  String editingAdminPassword = "";

  final User? editinguser = FirebaseAuth.instance.currentUser;
  if (editinguser == null) {
    print("There is no one logged in");
  } else {
    editingAdminEmail = editinguser.email!;
  }
  try {
    getAdminPassword(adminEmail: editingAdminEmail).then((password) {
      editingAdminPassword = password;
    });
    print("getAdminPassword succeeded");
  } catch (e) {
    print("getAdminPassword failed");
  }

  // FirebaseAuth.instance.signOut();

  // FirebaseAuth.instance
  //     .signInWithEmailAndPassword(email: email, password: password);

  final User? user = FirebaseAuth.instance.currentUser;
  if (user == null) {
  } else {
    user.updateEmail(updateemail);
    user.updatePassword(updatepassword);
  }

  FirebaseAuth.instance.signOut();

  FirebaseAuth.instance.signInWithEmailAndPassword(
      email: editingAdminEmail, password: editingAdminPassword);

  final User? editingusercheck = FirebaseAuth.instance.currentUser;
  if (editingusercheck == null) {
    print("There is no one logged in");
  } else {
    print("Currently logged in user after update:");
    print(editingusercheck.email);
  }

  //login with ediiting admin credentials here and return
}

Future createAdmin(
    {required BuildContext context,
    required String name,
    required String adminID,
    required String email,
    required String password}) async {
  // registerAdmin(email, password);

  final docAdmin = FirebaseFirestore.instance.collection('Admins').doc();

  final admin = Admin(
    id: docAdmin.id,
    name: name,
    adminID: adminID,
    email: email,
    password: password,
  );

  final json = admin.toJson();

  await docAdmin.set(json);
  return "Admin account successfully made";
}

Future deleteAdmin(adminid) async {
  final adminRef = FirebaseFirestore.instance.collection("Admins").doc(adminid);
  adminRef.delete().then(
        (doc) => print("Admin deleted"),
        onError: (e) => print("Error updating Admin $e"),
      );
}

Widget buildAdminTile(Admin admin) => ListTile(
      //Method for generating list tiles
      //key: ValueKey(violation.id),
      title: Align(
        alignment: Alignment.centerLeft,
        child: Column(
          children: [
            const Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                "Name :",
                style: TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                admin.name,
                style: const TextStyle(
                  fontSize: 32.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
      subtitle: Align(
        alignment: Alignment.centerLeft,
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 4,
                  child: Column(children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 12, 0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text("Email : ${admin.email}"),
                      ),
                    ),
                  ]),
                ),
                Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(2, 0, 2, 0),
                      child: ElevatedButton(
                          onPressed: () {
                            gotoadminupdateadminpage(
                                NavigationService.navigatorKey.currentContext!,
                                admin.id);
                            print(admin.id);
                          },
                          child: const Text("Update")),
                    )),
                Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(2, 0, 2, 0),
                      child: ElevatedButton(
                          onPressed: () {
                            print("Delete Button Pressed");
                            deleteAdmin(admin.id);
                            // gotoadminupdateadminpage(
                            //     NavigationService.navigatorKey.currentContext!,
                            //     admin.id);
                            print(admin.id);
                          },
                          child: const Text("Delete")),
                    )),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 12, 0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text("ID : ${admin.adminID}"),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            const Divider(
              thickness: 2,
            ),
          ],
        ),
      ),
    );

Stream<Admin> retrieveAdmin({required String adminid}) =>
    FirebaseFirestore.instance
        .collection('Admins')
        .doc(adminid)
        .snapshots()
        .map((doc) => Admin.fromJson(doc.data()!));

Widget buildUpdateAdminFormAdmin(
  BuildContext context,
  String adminid,
  String adminpassword,
  String adminemail,
  GlobalKey<FormState> formkey,
  TextEditingController adminEmailFormController,
  String updateAdminEmail,
  TextEditingController adminIDFormController,
  String updateAdminID,
  TextEditingController adminPasswordFormController,
  String updateAdminPassword,
) =>
    ListView(
      children: [
        Center(
          child: SizedBox(
            width: 600,
            child: Form(
              key: formkey,
              child: Column(
                children: [
                  const SizedBox(
                    height: 48,
                  ),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text("ID"),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  TextFormField(
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: const InputDecoration(
                        isDense: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        )),
                    autofocus: true,
                    controller: adminIDFormController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Required";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 48,
                  ),
                  const Align(
                      alignment: Alignment.centerLeft, child: Text("Email")),
                  const SizedBox(
                    height: 12,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                        isDense: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        )),
                    controller: adminEmailFormController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Required";
                      } else if (!value.contains("@")) {
                        return "Please enter a valid email.";
                      } else if (!value.contains(".")) {
                        return "Please enter a valid email.";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 48,
                  ),
                  const Align(
                      alignment: Alignment.centerLeft, child: Text("Password")),
                  const SizedBox(
                    height: 12,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                        isDense: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        )),
                    controller: adminPasswordFormController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Required";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 69,
                  ),
                ],
              ),
            ),
          ),
        ),
        Center(
          child: SizedBox(
            width: 600,
            child: Row(children: [
              const SizedBox(
                width: 200,
              ),
              ElevatedButton(
                onPressed: () {
                  if (formkey.currentState!.validate()) {
                    updateAdminID = adminIDFormController.text;
                    updateAdminEmail = adminEmailFormController.text;
                    updateAdminPassword = adminPasswordFormController.text;

                    updateAdminRecord(
                      email: adminemail,
                      password: adminpassword,
                      context: context,
                      adminid: adminid,
                      updateID: updateAdminID,
                      updateEmail: updateAdminEmail,
                      updatePassword: updateAdminPassword,
                    );
                    Navigator.pop(context);
                    // print("Email:|$adminemail|");
                    // print("Password:|$adminpassword|");
                    // updateAdmin(adminpassword, adminemail, updateAdminEmail,
                    //     updateAdminPassword);
                  }
                },
                child: const Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 12.0, horizontal: 48.0),
                  child: Text("Update"),
                ),
              ),
              const SizedBox(
                width: 14,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 12.0, horizontal: 48.0),
                  child: Text("Cancel"),
                ),
              ),
            ]),
          ),
        ),
        const Center(
          child: SizedBox(
            height: 50,
          ),
        ),
      ],
    );

Future updateAdminRecord({
  required String email,
  required String password,
  required BuildContext context,
  required String adminid,
  required String updateID,
  required String updateEmail,
  required String updatePassword,
}) async {
  final adminRef = FirebaseFirestore.instance.collection("Admins").doc(adminid);
  adminRef.update({
    "email": updateEmail,
    "password": updatePassword,
    "adminID": updateID,
  });
}

Widget buildCreateAdminForm(
  BuildContext context,
  GlobalKey<FormState> formkey,
  TextEditingController adminIDFormController,
  String createAdminID,
  TextEditingController adminNameFormController,
  String createAdminName,
  TextEditingController adminEmailFormController,
  String createAdminEmail,
) =>
    ListView(
      children: [
        Center(
          child: SizedBox(
            width: 600,
            child: Form(
              key: formkey,
              child: Column(
                children: [
                  const SizedBox(
                    height: 48,
                  ),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text("ID"),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  TextFormField(
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: const InputDecoration(
                        isDense: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        )),
                    autofocus: true,
                    controller: adminIDFormController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Required";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 48,
                  ),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Name"),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                        isDense: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        )),
                    autofocus: true,
                    controller: adminNameFormController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Required";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 48,
                  ),
                  const Align(
                      alignment: Alignment.centerLeft, child: Text("Email")),
                  const SizedBox(
                    height: 12,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                        isDense: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        )),
                    controller: adminEmailFormController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Required";
                      } else if (!value.contains("@")) {
                        return "Please enter a valid email.";
                      } else if (!value.contains(".")) {
                        return "Please enter a valid email.";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 48,
                  ),
                ],
              ),
            ),
          ),
        ),
        Center(
          child: SizedBox(
            width: 600,
            child: Row(children: [
              const SizedBox(
                width: 200,
              ),
              ElevatedButton(
                onPressed: () {
                  if (formkey.currentState!.validate()) {
                    createAdminID = adminIDFormController.text;
                    createAdminName = adminNameFormController.text;
                    createAdminEmail = adminEmailFormController.text;

                    checkIfAdminIDIsUsed(adminID: createAdminID).then((truth) {
                      if (truth == true) {
                        print("Admin ID is used");
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('ID number is in use'),
                          ),
                        );
                      } else {
                        checkIfAdminNameIsUsed(adminName: createAdminName)
                            .then((truth) {
                          if (truth == true) {
                            print("Admin Name is already used");
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Admin Name is already used'),
                              ),
                            );
                          } else {
                            checkIfAdminEmailIsUsed(
                                    adminEmail: createAdminEmail)
                                .then((truth) {
                              if (truth == true) {
                                print("Admin Email is already used");
                                ScaffoldMessenger.of(context)
                                    .hideCurrentSnackBar();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content:
                                        Text('Admin Email is already used'),
                                  ),
                                );
                              } else {
                                createAdmin(
                                    context: context,
                                    name: createAdminName,
                                    adminID: createAdminID,
                                    email: createAdminEmail,
                                    password: "defaultadminpassword");

                                Navigator.pop(context);
                              }
                            });
                          }
                        });
                      }
                    });
                  }
                },
                child: const Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 12.0, horizontal: 48.0),
                  child: Text("Create"),
                ),
              ),
              const SizedBox(
                width: 14,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 12.0, horizontal: 48.0),
                  child: Text("Cancel"),
                ),
              ),
            ]),
          ),
        ),
        const Center(
          child: SizedBox(
            height: 50,
          ),
        ),
      ],
    );

////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////    Guard  Code     ////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                    //
//                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////

class Guard {
  String id;
  final String name;
  final String guardID;
  final String email;
  final String password;

  Guard({
    this.id = "",
    required this.name,
    required this.guardID,
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'guardID': guardID,
        'email': email,
        'password': password,
      };

  static Guard fromJson(Map<String, dynamic> json) => Guard(
        id: json['id'],
        name: json['name'],
        guardID: json['guardID'],
        email: json['email'],
        password: json['password'],
      );

  static Guard mapDocSnapshot(querySnapshot) => Guard(
        id: querySnapshot.value['id'],
        name: querySnapshot.value['name'],
        guardID: querySnapshot.value['guardID'],
        email: querySnapshot.value['email'],
        password: querySnapshot.value['password'],
      );
}

Future<bool> checkIfGuardIDIsUsed({required String guardID}) async {
  bool _guardFound = false;

  final QuerySnapshot result = await FirebaseFirestore.instance
      .collection('Guards')
      .where("guardID", isEqualTo: guardID)
      .get();

  final List<DocumentSnapshot> documents = result.docs;

  if (result.size > 0) {
    _guardFound = true;
    //exists
  } else {
    _guardFound = false;
    //not exists
  }

  return _guardFound;
}

Future<bool> checkIfGuardNameIsUsed({required String guardName}) async {
  bool _guardFound = false;

  final QuerySnapshot result = await FirebaseFirestore.instance
      .collection('Guards')
      .where("name", isEqualTo: guardName)
      .get();

  final List<DocumentSnapshot> documents = result.docs;

  if (result.size > 0) {
    _guardFound = true;
    //exists
  } else {
    _guardFound = false;
    //not exists
  }

  return _guardFound;
}

Future<bool> checkIfGuardEmailIsUsed({required String guardEmail}) async {
  bool _guardFound = false;

  final QuerySnapshot result = await FirebaseFirestore.instance
      .collection('Guards')
      .where("email", isEqualTo: guardEmail)
      .get();

  final List<DocumentSnapshot> documents = result.docs;

  if (result.size > 0) {
    _guardFound = true;
    //exists
  } else {
    _guardFound = false;
    //not exists
  }

  return _guardFound;
}

//This is part of a workaround, very unsafe - will be replaced by a Firebase Guard Auth API solution if time allows
Future<String> getGuardPassword({required String guardEmail}) async {
  bool _guardFound = false;
  String guardPassword =
      ""; //I am cringing at how unsafe this is. God help me if I have to do this again

  final dbRef = FirebaseFirestore.instance
      .collection('Guards')
      .where("guardEmail", isEqualTo: guardEmail)
      .get()
      .then(
    (querySnapshot) {
      guardPassword =
          querySnapshot.docs[0]["password"]; //Lord help me with this one.
      print("Retrieved password: $guardPassword");
    },
    onError: (e) => print("Error completing: $e"),
  );

  return guardPassword;
}

Future checkIfGuardExists(
    {required String guardID,
    required String guardName,
    required BuildContext buildcontext}) async {
  bool _guardFound = false;

  final dbRef = FirebaseFirestore.instance
      .collection('Guards')
      .where("guardID", isEqualTo: guardID)
      .get()
      .then(
    (querySnapshot) {
      if (identical(querySnapshot.docs[0]["name"], guardName)) {
        _guardFound = true;
      }
    },
    onError: (e) => print("Error completing: $e"),
  );

  return _guardFound;
}

Stream<List<Guard>> readGuards() => FirebaseFirestore.instance
    .collection('Guards')
    .snapshots()
    .map((snapshot) =>
        snapshot.docs.map((doc) => Guard.fromJson(doc.data())).toList());

Stream<List<Guard>> searchGuards(
        {required String searchcategory, required String guardsearchkey}) =>
    FirebaseFirestore.instance
        .collection('Guards')
        .where(searchcategory, isEqualTo: guardsearchkey)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Guard.fromJson(doc.data())).toList());

// Future<UserCredential> registerGuard(String email, String password) async {
//   FirebaseApp app = await Firebase.initializeApp(
//       name: 'Secondary', options: Firebase.app().options);

//   UserCredential userCredential = await FirebaseAuth.instanceFor(app: app)
//       .createUserWithEmailAndPassword(email: email, password: password);

//   app.delete();
//   return Future.sync(() => userCredential);
// }

updateGuard(String password, String email, String updateemail,
    String updatepassword) async {
  //This workaround is very unsafe, will be replaced with an Guard Auth API if there is time

  String editingGuardEmail = "";
  String editingGuardPassword = "";

  final User? editinguser = FirebaseAuth.instance.currentUser;
  if (editinguser == null) {
    print("There is no one logged in");
  } else {
    editingGuardEmail = editinguser.email!;
  }
  try {
    getGuardPassword(guardEmail: editingGuardEmail).then((password) {
      editingGuardPassword = password;
    });
    print("getGuardPassword succeeded");
  } catch (e) {
    print("getGuardPassword failed");
  }

  // FirebaseAuth.instance.signOut();

  // FirebaseAuth.instance
  //     .signInWithEmailAndPassword(email: email, password: password);

  final User? user = FirebaseAuth.instance.currentUser;
  if (user == null) {
  } else {
    user.updateEmail(updateemail);
    user.updatePassword(updatepassword);
  }

  FirebaseAuth.instance.signOut();

  FirebaseAuth.instance.signInWithEmailAndPassword(
      email: editingGuardEmail, password: editingGuardPassword);

  final User? editingusercheck = FirebaseAuth.instance.currentUser;
  if (editingusercheck == null) {
    print("There is no one logged in");
  } else {
    print("Currently logged in user after update:");
    print(editingusercheck.email);
  }

  //login with ediiting guard credentials here and return
}

Future createGuard(
    {required BuildContext context,
    required String name,
    required String guardID,
    required String email,
    required String password}) async {
  // registerGuard(email, password);

  final docGuard = FirebaseFirestore.instance.collection('Guards').doc();

  final guard = Guard(
    id: docGuard.id,
    name: name,
    guardID: guardID,
    email: email,
    password: password,
  );

  final json = guard.toJson();

  await docGuard.set(json);
  return "Guard account successfully made";
}

Future deleteGuard(guardid) async {
  final guardRef = FirebaseFirestore.instance.collection("Guards").doc(guardid);
  guardRef.delete().then(
        (doc) => print("Guard deleted"),
        onError: (e) => print("Error updating Guard $e"),
      );
}

Widget buildGuardTile(Guard guard) => ListTile(
      //Method for generating list tiles
      //key: ValueKey(violation.id),
      title: Align(
        alignment: Alignment.centerLeft,
        child: Column(
          children: [
            const Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                "Name :",
                style: TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                guard.name,
                style: const TextStyle(
                  fontSize: 32.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
      subtitle: Align(
        alignment: Alignment.centerLeft,
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 4,
                  child: Column(children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 12, 0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text("Email : ${guard.email}"),
                      ),
                    ),
                  ]),
                ),
                Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(2, 0, 2, 0),
                      child: ElevatedButton(
                          onPressed: () {
                            gotoadminupdateguardpage(
                                NavigationService.navigatorKey.currentContext!,
                                guard.id);
                            print(guard.id);
                          },
                          child: const Text("Update")),
                    )),
                Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(2, 0, 2, 0),
                      child: ElevatedButton(
                          onPressed: () {
                            print("Delete Button Pressed");
                            deleteGuard(guard.id);
                            // gotoadminupdateguardpage(
                            //     NavigationService.navigatorKey.currentContext!,
                            //     guard.id);
                            print(guard.id);
                          },
                          child: const Text("Delete")),
                    )),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 12, 0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text("ID : ${guard.guardID}"),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            const Divider(
              thickness: 2,
            ),
          ],
        ),
      ),
    );

Stream<Guard> retrieveGuard({required String guardid}) =>
    FirebaseFirestore.instance
        .collection('Guards')
        .doc(guardid)
        .snapshots()
        .map((doc) => Guard.fromJson(doc.data()!));

Widget buildUpdateAdminFormGuard(
  BuildContext context,
  String guardid,
  String guardpassword,
  String guardemail,
  GlobalKey<FormState> formkey,
  TextEditingController guardEmailFormController,
  String updateGuardEmail,
  TextEditingController guardIDFormController,
  String updateGuardID,
) =>
    ListView(
      children: [
        Center(
          child: SizedBox(
            width: 600,
            child: Form(
              key: formkey,
              child: Column(
                children: [
                  const SizedBox(
                    height: 48,
                  ),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text("ID"),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  TextFormField(
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: const InputDecoration(
                        isDense: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        )),
                    autofocus: true,
                    controller: guardIDFormController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Required";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 48,
                  ),
                  const Align(
                      alignment: Alignment.centerLeft, child: Text("Email")),
                  const SizedBox(
                    height: 12,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                        isDense: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        )),
                    controller: guardEmailFormController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Required";
                      } else if (!value.contains("@")) {
                        return "Please enter a valid email.";
                      } else if (!value.contains(".")) {
                        return "Please enter a valid email.";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 48,
                  ),
                  ElevatedButton(
                    child: Text("Reset Password"),
                    onPressed: () {
                      guardpassword = "defaultguardpassword";
                    },
                  ),
                  const SizedBox(
                    height: 69,
                  ),
                ],
              ),
            ),
          ),
        ),
        Center(
          child: SizedBox(
            width: 600,
            child: Row(children: [
              const SizedBox(
                width: 200,
              ),
              ElevatedButton(
                onPressed: () {
                  if (formkey.currentState!.validate()) {
                    updateGuardID = guardIDFormController.text;
                    updateGuardEmail = guardEmailFormController.text;

                    updateGuardRecord(
                      context: context,
                      guardOldId: guardid,
                      updateID: updateGuardID,
                      updateEmail: updateGuardEmail,
                      updatePassword: guardpassword,
                    );
                    // print("Email:|$guardemail|");
                    // print("Password:|$guardpassword|");
                    // updateGuard(guardpassword, guardemail, updateGuardEmail,
                    //     updateGuardPassword);

                    Navigator.pop(context);
                  }
                },
                child: const Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 12.0, horizontal: 48.0),
                  child: Text("Update"),
                ),
              ),
              const SizedBox(
                width: 14,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 12.0, horizontal: 48.0),
                  child: Text("Cancel"),
                ),
              ),
            ]),
          ),
        ),
        const Center(
          child: SizedBox(
            height: 50,
          ),
        ),
      ],
    );

Future updateGuardRecord({
  required BuildContext context,
  required String guardOldId,
  required String updateID,
  required String updateEmail,
  required String updatePassword,
}) async {
  final guardRef =
      FirebaseFirestore.instance.collection("Guards").doc(guardOldId);
  guardRef.update({
    "email": updateEmail,
    "password": updatePassword,
    "guardID": updateID,
  });
}

Widget buildCreateGuardForm(
  BuildContext context,
  GlobalKey<FormState> formkey,
  TextEditingController guardIDFormController,
  String createGuardID,
  TextEditingController guardNameFormController,
  String createGuardName,
  TextEditingController guardEmailFormController,
  String createGuardEmail,
) =>
    ListView(
      children: [
        Center(
          child: SizedBox(
            width: 600,
            child: Form(
              key: formkey,
              child: Column(
                children: [
                  const SizedBox(
                    height: 48,
                  ),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text("ID"),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  TextFormField(
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: const InputDecoration(
                        isDense: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        )),
                    autofocus: true,
                    controller: guardIDFormController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Required";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 48,
                  ),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Name"),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                        isDense: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        )),
                    autofocus: true,
                    controller: guardNameFormController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Required";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 48,
                  ),
                  const Align(
                      alignment: Alignment.centerLeft, child: Text("Email")),
                  const SizedBox(
                    height: 12,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                        isDense: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        )),
                    controller: guardEmailFormController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Required";
                      } else if (!value.contains("@")) {
                        return "Please enter a valid email.";
                      } else if (!value.contains(".")) {
                        return "Please enter a valid email.";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 48,
                  ),
                ],
              ),
            ),
          ),
        ),
        Center(
          child: SizedBox(
            width: 600,
            child: Row(children: [
              const SizedBox(
                width: 200,
              ),
              ElevatedButton(
                onPressed: () {
                  if (formkey.currentState!.validate()) {
                    createGuardID = guardIDFormController.text;
                    createGuardName = guardNameFormController.text;
                    createGuardEmail = guardEmailFormController.text;

                    checkIfGuardIDIsUsed(guardID: createGuardID).then((truth) {
                      if (truth == true) {
                        print("Guard ID is used");
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('ID number is in use'),
                          ),
                        );
                      } else {
                        checkIfGuardNameIsUsed(guardName: createGuardName)
                            .then((truth) {
                          if (truth == true) {
                            print("Guard Name is already used");
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Guard Name is already used'),
                              ),
                            );
                          } else {
                            checkIfGuardEmailIsUsed(
                                    guardEmail: createGuardEmail)
                                .then((truth) {
                              if (truth == true) {
                                print("Guard Email is already used");
                                ScaffoldMessenger.of(context)
                                    .hideCurrentSnackBar();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content:
                                        Text('Guard Email is already used'),
                                  ),
                                );
                              } else {
                                createGuard(
                                    context: context,
                                    name: createGuardName,
                                    guardID: createGuardID,
                                    email: createGuardEmail,
                                    password: "defaultguardpassword");

                                Navigator.pop(context);
                              }
                            });
                          }
                        });
                      }
                    });
                  }
                },
                child: const Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 12.0, horizontal: 48.0),
                  child: Text("Create"),
                ),
              ),
              const SizedBox(
                width: 14,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 12.0, horizontal: 48.0),
                  child: Text("Cancel"),
                ),
              ),
            ]),
          ),
        ),
        const Center(
          child: SizedBox(
            height: 50,
          ),
        ),
      ],
    );
