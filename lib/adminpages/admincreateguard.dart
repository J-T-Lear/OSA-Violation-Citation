import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:osavici/adminpages/adminfunctions.dart';
import 'package:osavici/adminpages/adminlogin.dart';
import 'package:flutter/gestures.dart';

class AdminCreateGuard extends StatefulWidget {
  AdminCreateGuard({Key? key}) : super(key: key);
  final String title = "Create Guard Account";

  // final authuser = FirebaseAuth.instance.currentUser!;

  @override
  State<AdminCreateGuard> createState() => _AdminCreateGuard();
}

class _AdminCreateGuard extends State<AdminCreateGuard> {
  _AdminCreateGuard();

  final _guardcreateguardformkey = GlobalKey<FormState>();

  final guardIDFormController = TextEditingController();
  final guardNameFormController = TextEditingController();
  final guardEmailFormController = TextEditingController();
  final guardPasswordFormController = TextEditingController();

  String createGuardID = "";
  String createGuardName = "";
  String createGuardEmail = ""; 

  @override
  void dispose() {
    guardIDFormController.dispose();
    guardNameFormController.dispose();
    guardEmailFormController.dispose(); 
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
          child: buildCreateGuardForm(
              context,
              _guardcreateguardformkey,
              guardIDFormController,
              createGuardID,
              guardNameFormController,
              createGuardName,
              guardEmailFormController,
              createGuardEmail)),
    );
  }
}
