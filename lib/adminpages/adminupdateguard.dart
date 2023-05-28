import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:osavici/adminpages/adminfunctions.dart';
import 'package:osavici/adminpages/adminlogin.dart';
import 'package:flutter/gestures.dart';

class AdminUpdateGuardRecord extends StatefulWidget {
  final String guardid;
  AdminUpdateGuardRecord({Key? key, required this.guardid}) : super(key: key);
  final String title = "Update Guard Account";

  // final authuser = FirebaseAuth.instance.currentUser!;

  @override
  State<AdminUpdateGuardRecord> createState() => _AdminUpdateGuardRecord();
}

class _AdminUpdateGuardRecord extends State<AdminUpdateGuardRecord> {
  _AdminUpdateGuardRecord();

  final _adminupdateguardformkey = GlobalKey<FormState>();

  final guardIDFormController = TextEditingController();
  final guardNameFormController = TextEditingController();
  final guardEmailFormController = TextEditingController();
 

  String guardPassword = "";
  String guardEmail = "";
  String updateGuardID = "";
  String updateGuardName = "";
  String updateGuardEmail = "";
  String updateGuardPassword = "";

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
        child: StreamBuilder<Guard>(
            stream: retrieveGuard(guardid: widget.guardid),
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
                final guard = snapshot.data!;
                String guardID = guard.id;
                guardEmail = guard.email;
                guardPassword = guard.password;
                guardIDFormController.text = guard.guardID;
                guardNameFormController.text = guard.name;
                guardEmailFormController.text = guard.email;

                return buildUpdateAdminFormGuard(
                    context,
                    guardID,
                    guardPassword,
                    guardEmail, 
                    _adminupdateguardformkey, 
                    guardEmailFormController,
                    updateGuardEmail,
                    guardIDFormController,
                    updateGuardID,);
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            }),
      ),
    );
  }
}
