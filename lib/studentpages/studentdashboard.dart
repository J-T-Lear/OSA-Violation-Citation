import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:osavici/studentpages/studentlogin.dart';
import 'studentfunctions.dart';
import 'package:flutter/gestures.dart';

class StudentDashboardPage extends StatefulWidget {
  const StudentDashboardPage({
    Key? key,
    required this.userstudentid,
  }) : super(key: key);
  final String title = "Student Dashboard";
  final String userstudentid;

  @override
  State<StudentDashboardPage> createState() => _StudentDashboardPage();
}

class _StudentDashboardPage extends State<StudentDashboardPage> {
  _StudentDashboardPage();

  bool warning = true;

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
                    child: Container(
                      color: const Color.fromRGBO(120, 120, 120, 1),
                      child: const Center(
                        child: Text(
                          "Violations",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: GestureDetector(
                      onTap: () {
                        gotostudentchangepasswordpage(
                            context, widget.userstudentid);
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
                            "Change Password",
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 9,
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
                                widget.userstudentid,
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
                                    ..onTap = () => logout(context),
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
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.blue,
                          ),
                          child: Column(children: [
                            Expanded(
                              flex: 1,
                              child: Column(
                                children: [
                                  Expanded(
                                    flex: 4,
                                    child: Container(
                                      color: const Color.fromRGBO(
                                          235, 222, 155, 1),
                                      child: warning
                                          ? Row(
                                              children: [
                                                const Expanded(
                                                  flex: 8,
                                                  child: Center(
                                                    child: Text(
                                                      "Pending Violations",
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 24,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                    flex: 2,
                                                    child: Padding(
                                                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                                      child: ElevatedButton(
                                                        onPressed: () {
                                                          setState(() {
                                                            warning = false;
                                                          });
                                                        },
                                                        child: const Padding(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  vertical:
                                                                      12.0,
                                                                  horizontal:
                                                                      4.0),
                                                          child:  Text(
                                                            "Resolved", 
                                                          ),
                                                        ),
                                                      ),
                                                    ))
                                              ],
                                            )
                                          : Row(
                                              children: [
                                                const Expanded(
                                                  flex: 8,
                                                  child: Center(
                                                    child: Text(
                                                      "Resolved Violations",
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 24,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                    flex: 2,
                                                    child: Padding(
                                                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                                      child: ElevatedButton(
                                                        onPressed: () {
                                                          setState(() {
                                                            warning = true;
                                                          });
                                                        },
                                                        child: const Padding(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  vertical:
                                                                      12.0,
                                                                  horizontal:
                                                                      4.0),
                                                          child:  Text(
                                                            "Pending", 
                                                          ),
                                                        ),
                                                      ),
                                                    ))
                                              ],
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
                              flex: 6,
                              child: Container(
                                color: Colors.white,
                                child: Center(
                                  child: warning
                                      ? StreamBuilder<List<StudentViolation>>(
                                          stream: readwarningViolations(
                                              userstudentid:
                                                  widget.userstudentid),
                                          builder: (context, snapshot) {
                                            if (snapshot.hasError) {
                                              print(snapshot.error);
                                              return const Text(
                                                  'Something went wrong');
                                            }
                                            if (snapshot.hasData) {
                                              final users = snapshot.data!;
                                              print("Data is correct");
                                              return ListView(
                                                scrollDirection: Axis.vertical,
                                                children: users
                                                    .map(buildViolation)
                                                    .toList(),
                                              );
                                            } else {
                                              return const Center(
                                                  child:
                                                      CircularProgressIndicator());
                                            }
                                          })
                                      : StreamBuilder<List<StudentViolation>>(
                                          stream: readresolvedViolations(
                                              userstudentid:
                                                  widget.userstudentid),
                                          builder: (context, snapshot) {
                                            if (snapshot.hasError) {
                                              print(snapshot.error);
                                              return const Text(
                                                  'Something went wrong');
                                            }
                                            if (snapshot.hasData) {
                                              final users = snapshot.data!;
                                              print("Data is correct");
                                              return ListView(
                                                scrollDirection: Axis.vertical,
                                                children: users
                                                    .map(buildViolation)
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
                              child: Container(
                                color: const Color.fromARGB(255, 205, 209, 248),
                                child: const Center(
                                  child: Text(
                                    "In order to resolve your pending violations, visit the Office of Student Affairs at the 2nd floor Magis building",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ]),
                        ),
                      ),
                    ),
                  ]))),
            ),
          ],
        ),
      )),
    );
  }
}
