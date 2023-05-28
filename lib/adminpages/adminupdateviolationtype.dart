import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:osavici/adminpages/adminfunctions.dart';
import 'package:osavici/adminpages/adminlogin.dart';
import 'package:flutter/gestures.dart';

class AdminUpdateViolationTypeRecord extends StatefulWidget {
  final String violationtypeid;
  AdminUpdateViolationTypeRecord({Key? key, required this.violationtypeid})
      : super(key: key);
  final String title = "Update Violation Type";

  // final authuser = FirebaseAuth.instance.currentUser!;

  @override
  State<AdminUpdateViolationTypeRecord> createState() =>
      _AdminUpdateViolationTypeRecord();
}

class _AdminUpdateViolationTypeRecord extends State<AdminUpdateViolationTypeRecord> {
  _AdminUpdateViolationTypeRecord();

  final _adminupdatestudentrecordformkey = GlobalKey<FormState>();

  final violationTypeNameFormController = TextEditingController();
  final violationTypeDescriptionFormController = TextEditingController(); 

  String updateViolationTypeName = "";
  String updateViolationTypeDescription = ""; 

  @override
  void dispose() {
    violationTypeNameFormController.dispose();
    violationTypeDescriptionFormController.dispose(); 
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
        child: StreamBuilder<ViolationType>(
            stream: retrieveViolationType(violationtypeid: widget.violationtypeid),
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
                final violationtype = snapshot.data!;
                String studentrecordID = violationtype.id;
                violationTypeNameFormController.text = 
                    violationtype.name;
                violationTypeDescriptionFormController.text =
                    violationtype.description; 

                return buildUpdateViolationTypeFormAdmin( context,
                    studentrecordID,
                    _adminupdatestudentrecordformkey,
                    violationTypeNameFormController,
                    updateViolationTypeName,
                    violationTypeDescriptionFormController,
                    updateViolationTypeDescription);
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            }),
      ),
    );
  }
 
}
