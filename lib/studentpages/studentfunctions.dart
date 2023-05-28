import 'dart:convert';
import 'dart:js';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:osavici/studentpages/studentchangepassword.dart';
import 'package:osavici/studentpages/studentdashboard.dart';

import 'package:osavici/studentpages/studentlogin.dart';
import 'package:osavici/studentpages/studenttest.dart';

////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////Routes//////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////
gotostudentdashboardpage(BuildContext context, String userstudentid) {
  Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              StudentDashboardPage(userstudentid: userstudentid)));
}

gotostudentchangepasswordpage(BuildContext context, String userstudentid) {
  Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              StudentChangePasswordPage(userstudentid: userstudentid)));
}

gotostudentloginpage(BuildContext context) {
  Navigator.push(context,
      MaterialPageRoute(builder: (context) => const StudentLoginPage()));
}

////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////Student Users Code//////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////

class StudentUser {
  String id;
  final String studentid;
  final String name;
  final String course;
  final int year;
  final String studentpassword;
  final String studentemail;
  final int previousViolations;

  StudentUser({
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

  static StudentUser fromJson(Map<String, dynamic> json) => StudentUser(
      id: json['id'],
      studentid: json['studentID'],
      name: json['name'],
      course: json['course'],
      year: json['year'],
      studentpassword: json['password'],
      studentemail: json['email'],
      previousViolations: json['previousViolation']);

  static StudentUser mapDocSnapshot(querySnapshot) => StudentUser(
        studentid: querySnapshot.value['studentID'],
        name: querySnapshot.value['name'],
        course: querySnapshot.value['course'],
        year: querySnapshot.value['year'],
        studentpassword: querySnapshot.value['password'],
        studentemail: querySnapshot.value['email'],
        previousViolations: querySnapshot.value['previousViolation'],
      );
}

//Read list of Users in Student collection
Stream<List<StudentUser>> readUsers() => FirebaseFirestore.instance
    .collection('Students')
    .snapshots()
    .map((snapshot) =>
        snapshot.docs.map((doc) => StudentUser.fromJson(doc.data())).toList());

//Add User to Student collection
Future createUser(
    {required String userstudentid,
    required String username,
    required String usercourse,
    required int useryear,
    required String userstudentpassword,
    required String userstudentemail,
    required int userpreviousViolations}) async {
  final docUser = FirebaseFirestore.instance.collection('Students').doc();

  final user = StudentUser(
    id: docUser.id,
    studentid: userstudentid,
    name: username,
    course: usercourse,
    year: useryear,
    studentpassword: userstudentpassword,
    studentemail: userstudentemail,
    previousViolations: userpreviousViolations,
  );

  final json = user.toJson();

  await docUser.set(json);
}

Widget buildUser(StudentUser user) => ListTile(
      //Method for generating list tiles

      title: Text(user.name),
      subtitle: Align(
          alignment: Alignment.centerLeft,
          child: Column(children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(user.course),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(user.year.toString()),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(user.studentid),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(user.studentemail),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(user.previousViolations.toString()),
            ),
            const Divider(
              thickness: 2,
            ),
          ])),
    );

Future<bool> checkifidexists({required String userstudentid}) async {
  bool _isIDFound = false;

  final QuerySnapshot result = await FirebaseFirestore.instance
      .collection('Students')
      .where("studentID", isEqualTo: userstudentid)
      .get();

  final List<DocumentSnapshot> documents = result.docs;

  if (result.size > 0) {
    _isIDFound = true;
    //exists
  } else {
    _isIDFound = false;
    //not exists
  }
  return _isIDFound;
}

Future loginStudent(
    {required String userstudentid,
    required String userpassword,
    required BuildContext buildcontext}) async {
  final dbRef = FirebaseFirestore.instance
      .collection('Students')
      .where("studentID", isEqualTo: userstudentid)
      .get()
      .then(
    (querySnapshot) {
      if (identical(querySnapshot.docs[0]["password"], userpassword)) {
        ScaffoldMessenger.of(buildcontext).hideCurrentSnackBar();
        gotostudentdashboardpage(buildcontext, userstudentid);
      }
      if (!identical(querySnapshot.docs[0]["password"], userpassword)) {
        ScaffoldMessenger.of(buildcontext).hideCurrentSnackBar();
        ScaffoldMessenger.of(buildcontext).showSnackBar(
          const SnackBar(
            content: Text('Incorrect Password'),
          ),
        );
      }
    },
    onError: (e) => print("Error completing: $e"),
  );
}

Future updatePassword(
    {required String userstudentid,
    required String oldPassword,
    required String newPassword,
    required BuildContext buildcontext}) async {
  String docID = "";

  final QuerySnapshot result = await FirebaseFirestore.instance
      .collection('Students')
      .where("studentID", isEqualTo: userstudentid)
      .get();

  final dbRef = FirebaseFirestore.instance
      .collection('Students')
      .where("studentID", isEqualTo: userstudentid)
      .get()
      .then(
    (querySnapshot) {
      if (identical(querySnapshot.docs[0]["password"], oldPassword)) {
        ScaffoldMessenger.of(buildcontext).hideCurrentSnackBar();

        final List<DocumentSnapshot> documents = result.docs;
        for (var docSnapshot in documents) {
          print("ID Number found");
          print('${docSnapshot.id} => ${docSnapshot.data()}');
          docID = docSnapshot.id;
        }

        final studentRef =
            FirebaseFirestore.instance.collection("Students").doc(docID);
        studentRef.update({"password": newPassword});
        Navigator.pop(buildcontext);
      }
      if (!identical(querySnapshot.docs[0]["password"], oldPassword)) {
        ScaffoldMessenger.of(buildcontext).hideCurrentSnackBar();
        ScaffoldMessenger.of(buildcontext).showSnackBar(
          const SnackBar(
            content: Text('Incorrect Password'),
          ),
        );
      }
    },
    onError: (e) => print("Error completing: $e"),
  );
}

exitwithmessage({required BuildContext buildcontext, required String message}) {
  ScaffoldMessenger.of(buildcontext).showSnackBar(
    SnackBar(
      content: Text(message),
    ),
  );

  Navigator.pop(buildcontext);
}

fuckYOUFlutter() {
  print("Fuck YOU Flutter");
}

logout(BuildContext context) {
  Navigator.pop(context);
}

Widget studentsidebar() {
  return FractionallySizedBox(
    widthFactor: 0.3,
    heightFactor: 1,
    child: Container(
      color: Colors.grey,
    ),
  );
}

Future fixRobertosMistakes(String studentid) async {
  int timesfixRobertosMistakecalled = 0;
  var collection = FirebaseFirestore.instance
      .collection('Violation Record')
      .where("studentId", isEqualTo: studentid);
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

  final studentDocRef =
      FirebaseFirestore.instance.collection("Students").doc(studentid);
  await studentQueryRef.get().then(
    (querySnapshot) {
      print("Done calling StudentQueryRef.get()");
      previousViolation = querySnapshot.docs[0]["previousViolation"];
      studentdocid = querySnapshot.docs[0]["id"].toString();
      print("Previous Violation inside");
      print(previousViolation);
    },
    onError: (e) => print("Error completing: $e"),
  );

  print("Previous Violation");
  print(previousViolation);

  await violationDocRef.get().then(
    (DocumentSnapshot doc) {
      final dataMap = doc.data() as Map<String, dynamic>;
      if (dataMap.containsKey('status')) {
        return;
      } else if (previousViolation < 3) {
        previousViolation = previousViolation + 1;

        FirebaseFirestore.instance
            .collection("Students")
            .doc(studentdocid)
            .update({
          "previousViolation": previousViolation,
        });

        final data = {"id": violationid, "status": "Warning"};

        FirebaseFirestore.instance
            .collection("Violation Record")
            .doc(violationid)
            .set(data, SetOptions(merge: true));
        print("Status is Warning");
        return;
      } else {
        previousViolation = previousViolation + 1;

        FirebaseFirestore.instance
            .collection("Students")
            .doc(studentdocid)
            .update({
          "previousViolation": previousViolation,
        });

        final data = {"id": violationid, "status": "Pending"};

        FirebaseFirestore.instance
            .collection("Violation Record")
            .doc(violationid)
            .set(data, SetOptions(merge: true));
        print("Status is Pending");
        return;
      }
    },
    onError: (e) => print("Error getting document: $e"),
  );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////Student Violations Code///////////////////////////////////////
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

Stream<List<StudentViolation>> readViolationsAdmin() =>
    FirebaseFirestore.instance.collection('Violation Record').snapshots().map(
        (snapshot) => snapshot.docs
            .map((doc) => StudentViolation.fromJson(doc.data()))
            .toList());

Widget buildViolationAdmin(StudentViolation violation) => ListTile(
      //Method for generating list tiles
      title: Text(violation.violationtype),
      subtitle: Align(
          alignment: Alignment.centerLeft,
          child: Column(children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(violation.violationdate),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(violation.violationstatus),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(violation.violationstudentid),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(violation.violationstudentname),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(violation.violationguardid.toString()),
            ),
          ])),
    );

//Read list of specific student's violations in Violation Records collection
Stream<List<StudentViolation>> readwarningViolations(
        {required String userstudentid}) =>
    FirebaseFirestore.instance
        .collection('Violation Record')
        .where("studentId", isEqualTo: userstudentid)
        .where("status", isEqualTo: "Warning")
        .orderBy("violationType")
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => StudentViolation.fromJson(doc.data()))
            .toList());

Stream<List<StudentViolation>> readresolvedViolations(
        {required String userstudentid}) =>
    FirebaseFirestore.instance
        .collection('Violation Record')
        .where("studentId", isEqualTo: userstudentid)
        .where("status", isEqualTo: "Resolved")
        .orderBy("violationType")
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => StudentViolation.fromJson(doc.data()))
            .toList());

//Add Violation to Violation Record collection
Future createViolation(
    {required String violationtype,
    required String violationdate,
    required String violationstatus,
    required String violationstudentid,
    required String violationstudentname,
    required String violationguardid}) async {
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
      violationguardid: int.parse(violationguardid));

  final json = violation.toJson();

  await docUser.set(json);
}

Widget buildViolation(StudentViolation violation) => ListTile(
      //Method for generating list tiles
      title: Text(
        violation.violationtype,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),

      subtitle: Align(
          alignment: Alignment.centerLeft,
          child: Column(children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 2.0),
                child: Text(violation.violationstudentname),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 2.0),
                child: Text(violation.violationdate),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(violation.violationstatus),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 4),
              child: Divider(
                height: 6,
                thickness: .5,
                color: Colors.black,
              ),
            ),
          ])),
    );


////Write and test code here before adding it to the rest