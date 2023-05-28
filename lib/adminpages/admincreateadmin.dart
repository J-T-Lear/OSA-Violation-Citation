import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:osavici/adminpages/adminfunctions.dart';
import 'package:osavici/adminpages/adminlogin.dart';
import 'package:flutter/gestures.dart';

class AdminCreateAdmin extends StatefulWidget {
  AdminCreateAdmin({Key? key}) : super(key: key);
  final String title = "Create Admin Account";

  // final authuser = FirebaseAuth.instance.currentUser!;

  @override
  State<AdminCreateAdmin> createState() => _AdminCreateAdmin();
}

class _AdminCreateAdmin extends State<AdminCreateAdmin> {
  _AdminCreateAdmin();

  final _admincreateadminformkey = GlobalKey<FormState>();

  final adminIDFormController = TextEditingController();
  final adminNameFormController = TextEditingController();
  final adminEmailFormController = TextEditingController(); 

  String createAdminID = "";
  String createAdminName = "";
  String createAdminEmail = ""; 

  @override
  void dispose() {
    adminIDFormController.dispose();
    adminNameFormController.dispose();
    adminEmailFormController.dispose(); 
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
          child: buildCreateAdminForm(
              context,
              _admincreateadminformkey,
              adminIDFormController,
              createAdminID,
              adminNameFormController,
              createAdminName,
              adminEmailFormController,
              createAdminEmail)),
    );
  }
}
