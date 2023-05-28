import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'studentfunctions.dart';

final _testpageformkey = GlobalKey<FormState>();
final studentIDFormController = TextEditingController();
final nameFormController = TextEditingController();
final courseyearFormController = TextEditingController();
final passwordFormController = TextEditingController();
final emailFormController = TextEditingController();
final previousViolationFormController = TextEditingController();

String username = "";
String usercourseyear = "";

@override
void dispose() {
  studentIDFormController.dispose();
  nameFormController.dispose();
  courseyearFormController.dispose();
  passwordFormController.dispose();
  emailFormController.dispose();
  previousViolationFormController.dispose();
}

class StudentTestPage extends StatefulWidget {
  const StudentTestPage({Key? key}) : super(key: key);
  final String title = "Student Testing Page";

  @override
  State<StudentTestPage> createState() => _StudentTestPage();
}

class _StudentTestPage extends State<StudentTestPage> {
  _StudentTestPage();

  final studentIDFormController = TextEditingController();
  final nameFormController = TextEditingController();
  final courseFormController = TextEditingController();
  final yearFormController = TextEditingController();
  final passwordFormController = TextEditingController();

  String userstudentid = "";
  String username = "";
  String usercourse = "";
  int useryear = 0;
  String userpassword = "";
  String useremail = "";
  String userpreviousViolations = "";

  @override
  void dispose() {
    studentIDFormController.dispose();
    nameFormController.dispose();
    courseFormController.dispose();
    yearFormController.dispose();
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
                        const Text("Create Student User"),
                        const SizedBox(
                          height: 12,
                        ),
                        const Text("Enter Student ID"),
                        const SizedBox(
                          height: 12,
                        ),
                        TextFormField(
                          decoration: const InputDecoration(
                              border: OutlineInputBorder()),
                          controller: studentIDFormController,
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
                        const Text("Enter Name"),
                        TextFormField(
                          autofocus: true,
                          controller: nameFormController,
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
                        const Text("Enter Course and Year"),
                        TextFormField(
                          controller: courseyearFormController,
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
                        const Text("Enter Password"),
                        TextFormField(
                          controller: passwordFormController,
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
                        const Text("Enter Email"),
                        TextFormField(
                          controller: emailFormController,
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
                        const Text("Enter Number of Previous Violations"),
                        TextFormField(
                          controller: previousViolationFormController,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly
                          ],
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
                                  userstudentid = studentIDFormController.text;
                                  studentIDFormController.text = " ";

                                  username = nameFormController.text;
                                  nameFormController.text = "";

                                  usercourse =
                                      courseyearFormController.text;
                                  courseFormController.text = "";

                                  useryear = 
                                      int.parse(yearFormController.text);
                                  yearFormController.text = "";

                                  userpassword = passwordFormController.text;
                                  passwordFormController.text = "";

                                  useremail = emailFormController.text;
                                  emailFormController.text = "";

                                  userpreviousViolations =
                                      previousViolationFormController.text;
                                  previousViolationFormController.text = "";
                                });

                                createUser(
                                    userstudentid: userstudentid,
                                    username: username,
                                    usercourse: usercourse,
                                    useryear: useryear,
                                    userstudentpassword: userpassword,
                                    userstudentemail: useremail,
                                    userpreviousViolations:
                                        int.parse(userpreviousViolations));

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
                    height: 600,
                    width: 300,
                    child: StreamBuilder<List<StudentUser>>(
                        stream: readUsers(),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            print("snapshot.error");
                            print(snapshot.error);
                            return const Text('Something went wrong');
                          }
                          if (snapshot.hasData) {
                            final users = snapshot.data!;

                            return ListView(
                              scrollDirection: Axis.vertical,
                              children: users.map(buildUser).toList(),
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
