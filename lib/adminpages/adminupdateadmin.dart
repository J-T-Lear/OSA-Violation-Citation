import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:osavici/adminpages/adminfunctions.dart';
import 'package:osavici/adminpages/adminlogin.dart';
import 'package:flutter/gestures.dart';

class AdminUpdateAdminRecord extends StatefulWidget {
  final String adminid;
  AdminUpdateAdminRecord({Key? key, required this.adminid}) : super(key: key);
  final String title = "Update Admin Account";

  // final authuser = FirebaseAuth.instance.currentUser!;

  @override
  State<AdminUpdateAdminRecord> createState() => _AdminUpdateAdminRecord();
}

class _AdminUpdateAdminRecord extends State<AdminUpdateAdminRecord> {
  _AdminUpdateAdminRecord();

  final _adminupdatestudentrecordformkey = GlobalKey<FormState>();

  final adminIDFormController = TextEditingController();
  final adminNameFormController = TextEditingController();
  final adminEmailFormController = TextEditingController();
  final adminPasswordFormController = TextEditingController();

  String adminPassword = "";
  String adminEmail = "";
  String updateAdminID = "";
  String updateAdminName = "";
  String updateAdminEmail = "";
  String updateAdminPassword = "";

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
        child: StreamBuilder<Admin>(
            stream: retrieveAdmin(adminid: widget.adminid),
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
                final admin = snapshot.data!;
                String adminID = admin.id;
                adminEmail = admin.email;
                adminPassword = admin.password;
                adminIDFormController.text = admin.adminID;
                adminNameFormController.text = admin.name;
                adminEmailFormController.text = admin.email;

                return buildUpdateAdminFormAdmin(
                  context,
                  adminID,
                  adminPassword,
                  adminEmail,
                  _adminupdatestudentrecordformkey,
                  adminEmailFormController,
                  updateAdminEmail,
                  adminIDFormController,
                  updateAdminID,
                  adminPasswordFormController,
                  updateAdminPassword,
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            }),
      ),
    );
  }
}
