import 'package:flutter/material.dart'; 
import 'studentfunctions.dart'; 
 
class StudentLoginPage extends StatefulWidget {
  const StudentLoginPage({Key? key}) : super(key: key);
  final String title = "Student Login";

  @override
  State<StudentLoginPage> createState() => _StudentLoginPage();
}

class _StudentLoginPage extends State<StudentLoginPage> {
  _StudentLoginPage();

  final _studentloginpageformkey = GlobalKey<FormState>();
  final studentIDFormController = TextEditingController();
  final passwordFormController = TextEditingController();

  String userstudentid = "";
  String userpassword = "";

  bool _obscureText = true;

  @override
  void dispose() {
    studentIDFormController.dispose();
    passwordFormController.dispose();
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
                  key: _studentloginpageformkey,
                  child: Column(
                    children: [
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text("Enter ID Number"),
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
                        controller: studentIDFormController,
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
                          child: Text("Enter Password")),
                      const SizedBox(
                        height: 12,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          isDense: true,
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          suffixIcon: InkWell(
                            onTap: toggle,
                            child: Icon(
                              _obscureText
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              size: 15.0,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        controller: passwordFormController,
                        obscureText: _obscureText,
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
                      ElevatedButton(
                        onPressed: () {
                          if (_studentloginpageformkey.currentState!
                              .validate()) {
                            setState(() {
                              userstudentid = studentIDFormController.text;
                              studentIDFormController.text = "";

                              userpassword = passwordFormController.text;
                              passwordFormController.text = "";
                            });

                            checkifidexists(userstudentid: userstudentid)
                                .then((truth) {
                              if (truth == true) { 
                                loginStudent(
                                    userstudentid: userstudentid,
                                    userpassword: userpassword,
                                    buildcontext: context);
                              } else {
                                print("It ain't true you fool");
                                ScaffoldMessenger.of(context)
                                    .hideCurrentSnackBar();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('ID number does not exist'),
                                  ),
                                );
                              }
                            });
                          }
                        },
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 12.0, horizontal: 48.0),
                          child: Text("Login"),
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
  void toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

}
