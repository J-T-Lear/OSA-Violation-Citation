import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:jiffy/jiffy.dart';
import 'package:osavici/adminpages/adminfunctions.dart';
import 'package:osavici/adminpages/adminlogin.dart';
import 'package:flutter/gestures.dart';

class AdminUpdateViolationRecord extends StatefulWidget {
  final String violationid;
  AdminUpdateViolationRecord({Key? key, required this.violationid})
      : super(key: key);
  final String title = "Update Violation Record";

  // final authuser = FirebaseAuth.instance.currentUser!;

  @override
  State<AdminUpdateViolationRecord> createState() =>
      _AdminUpdateViolationRecord();
}

class _AdminUpdateViolationRecord extends State<AdminUpdateViolationRecord> {
  _AdminUpdateViolationRecord();

  final _adminupdateviolationrecordformkey = GlobalKey<FormState>();

  final violationStudentNameFormController = TextEditingController();
  final violationStudentIDFormController = TextEditingController();
  final violationDateFormController = TextEditingController();
  final violationGuardIDFormController = TextEditingController();

  List<String> statuslist = <String>['Warning', 'Resolved'];

  String updateViolationType = violationtypes.first;

  String updateStudentName = "";
  String updateStudentID = "";
  String updateDate = "";
  String updateStatus = "Resolved";
  String updateGuardID = "";

  @override
  void dispose() {
    violationStudentNameFormController.dispose();
    violationStudentIDFormController.dispose();
    violationDateFormController.dispose();
    violationGuardIDFormController.dispose();
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
        child: StreamBuilder<StudentViolation>(
            stream: retrieveviolation(violationrecordid: widget.violationid),
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
                final violation = snapshot.data!;
                String violationID = violation.violationrecordid;
                violationStudentNameFormController.text =
                    violation.violationstudentname;
                violationStudentIDFormController.text =
                    violation.violationstudentid;
                violationDateFormController.text = violation.violationdate;
                violationGuardIDFormController.text =
                    violation.violationguardid.toString();

                return ListView(
                  children: [
                    Center(
                      child: SizedBox(
                        width: 600,
                        child: Form(
                          key: _adminupdateviolationrecordformkey,
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 48,
                              ),
                              const Align(
                                alignment: Alignment.centerLeft,
                                child: Text("Violation"),
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: DropdownButton(
                                      value: updateViolationType,
                                      items: violationtypes
                                          .map<DropdownMenuItem<String>>(
                                              (String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                      onChanged: (String? value) {
                                        // This is called when the user selects an item.
                                        setState(() {
                                          updateViolationType = value!;
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 48,
                              ),
                              const Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text("Student Name")),
                              const SizedBox(
                                height: 12,
                              ),
                              TextFormField(
                                decoration: const InputDecoration(
                                    isDense: true,
                                    border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                    )),
                                controller: violationStudentNameFormController,
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
                                  child: Text("Student ID")),
                              const SizedBox(
                                height: 12,
                              ),
                              TextFormField(
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                decoration: const InputDecoration(
                                    isDense: true,
                                    border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                    )),
                                controller: violationStudentIDFormController,
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
                                  child: Text("Date")),
                              const SizedBox(
                                height: 12,
                              ),
                              TextFormField(
                                onTap: () {
                                  // Below line stops keyboard from appearing

                                  showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime(2000),
                                          lastDate: DateTime(2024))
                                      .then((value) {
                                    violationDateFormController.text =
                                        Jiffy(value).format('MMM do yyyy');
                                    print(violationDateFormController.text);
                                  });
                                  // Show Date Picker Here
                                },
                                decoration: const InputDecoration(
                                    isDense: true,
                                    border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                    )),
                                controller: violationDateFormController,
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
                                  child: Text("Status")),
                              const SizedBox(
                                height: 12,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: DropdownButton(
                                      value: updateStatus,
                                      items: statuslist
                                          .map<DropdownMenuItem<String>>(
                                              (String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                      onChanged: (String? value) {
                                        // This is called when the user selects an item.
                                        setState(() {
                                          updateStatus = value!;
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 48,
                              ),
                              const Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text("Guard ID")),
                              const SizedBox(
                                height: 12,
                              ),
                              TextFormField(
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                decoration: const InputDecoration(
                                    isDense: true,
                                    border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                    )),
                                controller: violationGuardIDFormController,
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
                              if (_adminupdateviolationrecordformkey
                                  .currentState!
                                  .validate()) {
                                updateStudentName =
                                    violationStudentNameFormController.text;
                                updateStudentID =
                                    violationStudentIDFormController.text;
                                updateDate = violationDateFormController.text;
                                updateGuardID =
                                    violationGuardIDFormController.text;

                                updateViolationRecord(
                                    context: context,
                                    violationid: violationID,
                                    updateViolationType: updateViolationType,
                                    updateViolationStudentName:
                                        updateStudentName,
                                    updateViolationStudentID: updateStudentID,
                                    updateViolationDate: updateDate,
                                    updateViolationStatus: updateStatus,
                                    updateViolationGuardID:
                                        int.parse(updateGuardID));
                              }
                            },
                            child: const Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 12.0, horizontal: 48.0),
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
                              padding: EdgeInsets.symmetric(
                                  vertical: 12.0, horizontal: 48.0),
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
