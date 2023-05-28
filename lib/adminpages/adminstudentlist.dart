import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:osavici/adminpages/adminfunctions.dart';
import 'package:osavici/adminpages/adminlogin.dart';
import 'package:flutter/gestures.dart';

class AdminStudentList extends StatefulWidget {
  String adminEmail = "";
  AdminStudentList({Key? key, required this.adminEmail}) : super(key: key);
  final String title = "Student List";

  // final authuser = FirebaseAuth.instance.currentUser!;

  @override
  State<AdminStudentList> createState() => _AdminStudentList();
}

class _AdminStudentList extends State<AdminStudentList> {
  _AdminStudentList();

  final _adminstudentlistpageformkey = GlobalKey<FormState>();
  final adminSearchFormController = TextEditingController();

  String searchcategory = "name";
  String adminsearchkey = "";

  bool searchon = false;

  @override
  void dispose() {
    adminSearchFormController.dispose();
    super.dispose();
  }

  void dropdownCallback(String selectedValue) {
    setState(() {
      searchcategory = selectedValue;
    });
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
          child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Container( 
                color: const Color.fromRGBO(217, 217, 217, 1),
                child: Column(children: [
                  Expanded(
                    flex: 1,
                    child: GestureDetector(
                      onTap: () { 
                        gotoadminviolationwarninglistpage(context, widget.adminEmail);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black,
                            width: 2,
                          ),
                        ),
                        child: const Center(
                          child: Text(
                            "Violations",
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: GestureDetector(
                      onTap: () {
                        // gotostudentchangepasswordpage(context, widget.userstudentid);
                      },
                      child: Container(
                        color: const Color.fromRGBO(120, 120, 120, 1),
                        
                        child: const Center(
                          child: Text(
                            "Students",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: GestureDetector(
                      onTap: () {
                        gotoadminguardlistpage(context, widget.adminEmail);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black,
                            width: 2,
                          ),
                        ),
                        child: const Center(
                          child: Text(
                            "Guards",
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: GestureDetector(
                      onTap: () {
                        gotoadminadminlistpage(context, widget.adminEmail);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black,
                            width: 2,
                          ),
                        ),
                        child: const Center(
                          child: Text(
                            "Admins",
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: GestureDetector(
                      onTap: () {
                        gotoadminviolationtypelistpage(context, widget.adminEmail);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black,
                            width: 2,
                          ),
                        ),
                        child: const Center(
                          child: Text(
                            "Violation Types",
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 6,
                    child: Container(),
                  ),
                  Expanded(
                    flex: 2,
                    child: Container(
                        color: const Color.fromARGB(255, 34, 48, 95),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                widget.adminEmail,
                                // widget.authuser.email!,
                                style: const TextStyle(
                                  color: Colors.white,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              RichText(
                                text: TextSpan(
                                  text: "Log-Out",
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () => signOutAdmin(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              )
                            ],
                          ),
                        )),
                  ),
                ]),
              ),
            ),
            Expanded(
              flex: 5,
              child: Center(
                  child: SizedBox.expand(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                    Flexible(
                      child: FractionallySizedBox(
                        heightFactor: 0.9,
                        widthFactor: 0.8,
                        child: Column(children: [
                          Expanded(
                            flex: 1,
                            child: Form(
                              key: _adminstudentlistpageformkey,
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: TextFormField(
                                        decoration: const InputDecoration(
                                            isDense: true,
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10)),
                                            )),
                                        controller: adminSearchFormController,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return "Required";
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Container(
                                      padding: const EdgeInsets.all(8.0),
                                      child: DropdownButton(
                                        value: searchcategory,
                                        items: const [
                                          DropdownMenuItem<String>(
                                            value: "name",
                                            child: Text("Student Name"),
                                          ),
                                          DropdownMenuItem<String>(
                                            value: "studentID",
                                            child: Text("Student ID number"),
                                          ),
                                          DropdownMenuItem<String>(
                                            value: "email",
                                            child: Text("Email"),
                                          ),
                                          DropdownMenuItem<String>(
                                            value: "course",
                                            child: Text("Course"),
                                          ),
                                        ],
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            searchcategory = newValue!;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                      flex: 1,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: ElevatedButton(
                                          onPressed: () {
                                            if (_adminstudentlistpageformkey
                                                .currentState!
                                                .validate()) {
                                              setState(() {
                                                searchon = true;
                                                adminsearchkey =
                                                    adminSearchFormController
                                                        .text;
                                                adminSearchFormController.text =
                                                    "";
                                              });
                                              print(
                                                  "This is the search button. Bazinga!");
                                              print(adminsearchkey);
                                              print(searchcategory);
                                            } else {
                                              ScaffoldMessenger.of(context)
                                                  .hideCurrentSnackBar();
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                      'Please enter Searchkey'),
                                                ),
                                              );
                                            }
                                          },
                                          child: const Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 12.0,
                                                horizontal: 4.0),
                                            child: Text("Search"),
                                          ),
                                        ),
                                      )),
                                  Expanded(
                                      flex: 1,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: ElevatedButton(
                                          onPressed: () {
                                            setState(() {
                                              searchon = false;
                                            });
                                            print(
                                                "This is the reset table button. Bazinga!");
                                          },
                                          child: const Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 12.0,
                                                horizontal: 4.0),
                                            child: Text("Reset"),
                                          ),
                                        ),
                                      )),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Column(
                              children: [
                                Expanded(
                                  flex: 4,
                                  child: Container(
                                    color:
                                        const Color.fromRGBO(235, 222, 155, 1),
                                    child: const Center(
                                      child: Text(
                                        "Students",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 24,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                      color: const Color.fromRGBO(
                                          255, 255, 255, 1)),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 5,
                            child: Container(
                              color: Colors.white,
                              child: Center(
                                child: searchon
                                    ? StreamBuilder<List<Student>>(
                                        stream: searchStudents(
                                            searchcategory: searchcategory,
                                            adminsearchkey: adminsearchkey),
                                        builder: (context, snapshot) {
                                          if (snapshot.hasError) {
                                            print(snapshot.error);
                                            return const Text(
                                                'Something went wrong');
                                          }
                                          if (snapshot.hasData) {
                                            final students = snapshot.data!;

                                            return ListView(
                                              scrollDirection: Axis.vertical,
                                              children: students
                                                  .map(buildStudentTile)
                                                  .toList(),
                                            );
                                          } else {
                                            return const Center(
                                                child:
                                                    CircularProgressIndicator());
                                          }
                                        })
                                    : StreamBuilder<List<Student>>(
                                        stream: readStudents(),
                                        builder: (context, snapshot) {
                                          if (snapshot.hasError) {
                                            print(snapshot.error);
                                            return const Text(
                                                'Something went wrong');
                                          }
                                          if (snapshot.hasData) {
                                            final students = snapshot.data!;

                                            return ListView(
                                              scrollDirection: Axis.vertical,
                                              children: students
                                                  .map(buildStudentTile)
                                                  .toList(),
                                            );
                                          } else {
                                            return const Center(
                                                child:
                                                    CircularProgressIndicator());
                                          }
                                        }),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Row(children: [
                              Expanded(flex: 5, child: Container()),
                              Expanded(
                                flex: 1,
                                child: ElevatedButton(
                                  onPressed: () {
                                    gotoadmincreatestudentrecordpage(context);
                                  },
                                  child: const Text("Create"),
                                ),
                              )
                            ]),
                          )
                        ]),
                      ),
                    ),
                  ]))),
            ),
          ],
        ),
      )),
    );
  }

  signOutAdmin() { 
    print(
        "There was an attempt to logout");  
    // FirebaseAuth.instance.signOut();
    if (!context.mounted) return;
    // Navigator.of(context).popUntil((route) => route.isFirst);
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => const AdminLoginPage()));
  }
}
