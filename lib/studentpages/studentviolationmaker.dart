import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'studentfunctions.dart';

final _testpageformkey = GlobalKey<FormState>();
final violationtypeController = TextEditingController();
final violationdateController = TextEditingController();
final violationstatusController = TextEditingController();
final violationstudentidController = TextEditingController();
final violationstudentnameController = TextEditingController();
final violationguardidController = TextEditingController();

String username = "";
String usercourseyear = "";

@override
void dispose() {
  violationtypeController.dispose();
  violationdateController.dispose();
  violationstatusController.dispose();
  violationstudentidController.dispose();
  violationstudentnameController.dispose();
  violationguardidController.dispose();
}

class StudentViolationMakerPage extends StatefulWidget {
  const StudentViolationMakerPage({Key? key}) : super(key: key);
  final String title = "Violation Maker Page";

  @override
  State<StudentViolationMakerPage> createState() =>
      _StudentViolationMakerPage();
}

class _StudentViolationMakerPage extends State<StudentViolationMakerPage> {
  _StudentViolationMakerPage();
  String violationtype = "";
  String violationdate = "";
  String violationstatus = "";
  String violationstudentid = "";
  String violationstudentname = "";
  String violationguardid = "";

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 100,
                ),

                SizedBox(
                  width: 300,
                  child: Form(
                    key: _testpageformkey,
                    child: Column(
                      //Form for making new students
                      children: [
                        const Text("Create Student Violation"),
                        const SizedBox(
                          height: 12,
                        ),
                        const Text("Enter Violation Type"),
                        const SizedBox(
                          height: 12,
                        ),
                        TextFormField(
                          decoration: const InputDecoration(
                              border: OutlineInputBorder()),
                          controller: violationtypeController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Required";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Text("Enter Date"),
                        TextFormField(
                          autofocus: true,
                          controller: violationdateController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Required";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        const Text("Enter Status"),
                        TextFormField(
                          controller: violationstatusController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Required";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        const Text("Enter Student ID"),
                        TextFormField(
                          controller: violationstudentidController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Required";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        const Text("Enter Student Name"),
                        TextFormField(
                          controller: violationstudentnameController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Required";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        const Text("Enter Guard ID"),
                        TextFormField(
                          controller: violationguardidController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Required";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        ElevatedButton(
                            onPressed: () {
                              if (_testpageformkey.currentState!.validate()) {
                                setState(() {
                                  violationtype = violationtypeController.text;
                                  violationtypeController.text = "";

                                  violationdate = violationdateController.text;
                                  violationdateController.text = "";

                                  violationstatus =
                                      violationstatusController.text;
                                  violationstatusController.text = "";

                                  violationstudentid =
                                      violationstudentidController.text;
                                  violationstudentidController.text = "";

                                  violationstudentname =
                                      violationstudentnameController.text;
                                  violationstudentnameController.text = "";

                                  violationguardid =
                                      violationguardidController.text;
                                  violationguardidController.text = "";
                                });

                                createViolation(
                                    violationtype: violationtype,
                                    violationdate: violationdate,
                                    violationstatus: violationstatus,
                                    violationstudentid: violationstudentid,
                                    violationstudentname: violationstudentname,
                                    violationguardid: violationguardid);

                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Submitted'),
                                  ),
                                );
                              }
                            },
                            child: const Text("Submit"))
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),

                //Displays list of Students
                Container(
                  padding: const EdgeInsets.all(2.0),
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: .5,
                      color: Colors.black,
                    ),
                  ),
                  child: SizedBox(
                    height: 200,
                    width: 300,
                    child: StreamBuilder<List<StudentViolation>>(
                        stream: readViolationsAdmin(),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            print(snapshot.error);
                            return const Text('Something went wrong');
                          }
                          if (snapshot.hasData) {
                            final users = snapshot.data!;

                            return ListView(
                              scrollDirection: Axis.vertical,
                              children: users.map(buildViolationAdmin).toList(),
                            );
                          } else {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                        }),
                  ),
                ),

                //////

                //////
              ],
            ),
            const SizedBox(
              height: 100,
            ),
          ]),
        ),
      ),
    );
  }
}
