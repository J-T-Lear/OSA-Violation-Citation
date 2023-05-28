import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'studentfunctions.dart';
import 'studentdashboard.dart';



class StudentChangePasswordPage extends StatefulWidget {
  const StudentChangePasswordPage({
    Key? key,
    required this.userstudentid,
  }) : super(key: key);
  final String title = "Password Change";
  final String userstudentid;

  @override
  State<StudentChangePasswordPage> createState() =>
      _StudentChangePasswordPage();
}

class _StudentChangePasswordPage extends State<StudentChangePasswordPage> {
  _StudentChangePasswordPage();

  final _studentupdatepasswordformkey = GlobalKey<FormState>(); 

  final oldPasswordFormController = TextEditingController();
  final newPasswordFormController = TextEditingController();
  final confirmPasswordFormController = TextEditingController();

  String oldPassword = "";
  String newPassword = "";
  String confirmPassword = "";

  @override
  void dispose() {
    oldPasswordFormController.dispose();
    newPasswordFormController.dispose();
    confirmPasswordFormController.dispose();
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
        leadingWidth: 1100,
        title: Text(widget.title),
        toolbarHeight: 70.0,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                width: 500,
                child: Form(
                  key: _studentupdatepasswordformkey,
                  child: Column(
                    children: [
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text("Old Password"),
                      ),
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
                        autofocus: true,
                        controller: oldPasswordFormController,
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
                          child: Text("New Password")),
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
                        controller: newPasswordFormController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Required";
                          }
                          if (value != confirmPasswordFormController.text) {
                            return "Passwords must match";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 48,
                      ),
                      const Align(
                          alignment: Alignment.centerLeft,
                          child: Text("Confirm Password")),
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
                        controller: confirmPasswordFormController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Required";
                          }
                          if (value != newPasswordFormController.text) {
                            return "Passwords must match";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 48,
                      ),
                      Center(
                        child: Row(
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                if (_studentupdatepasswordformkey.currentState!
                                    .validate()) {
                                  setState(() {
                                    oldPassword =
                                        oldPasswordFormController.text;
                                    oldPasswordFormController.text = "";

                                    newPassword =
                                        newPasswordFormController.text;
                                    newPasswordFormController.text = "";

                                    confirmPassword =
                                        confirmPasswordFormController.text;
                                    confirmPasswordFormController.text = "";
                                  });

                                  updatePassword(
                                      userstudentid: widget.userstudentid,
                                      oldPassword: oldPassword,
                                      newPassword: newPassword,
                                      buildcontext: context);
                                }
                              },
                              child: const Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 12.0, horizontal: 48.0),
                                child: Text("Change Password"),
                              ),
                            ),
                            const SizedBox(
                              width: 22,
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
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
