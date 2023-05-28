import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:osavici/adminpages/adminviolationlist.dart';
import 'package:osavici/studentpages/studentfunctions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

import 'adminfunctions.dart';

class AdminLoginPage extends StatefulWidget {
  const AdminLoginPage({Key? key}) : super(key: key);
  final String title = "Admin Login";

  @override
  State<AdminLoginPage> createState() => _AdminLoginPage();
}

class _AdminLoginPage extends State<AdminLoginPage> {
  _AdminLoginPage();

  final _adminloginpageformkey = GlobalKey<FormState>();
  final adminEmailFormController = TextEditingController();
  final passwordFormController = TextEditingController();
  bool _obscureText = true;
  String errormessage = "";

  String email = "";
  String password = "";
  @override
  void dispose() {
    adminEmailFormController.dispose();
    passwordFormController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                  key: _adminloginpageformkey,
                  child: Column(
                    children: [
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text("Enter Email"),
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
                        controller: adminEmailFormController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Required";
                          } else if (!value.contains("@")) {
                            return "Please enter a valid email.";
                          } else if (!value.contains(".")) {
                            return "Please enter a valid email.";
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
                          if (_adminloginpageformkey.currentState!.validate()) {
                            email = adminEmailFormController.text;
                            password = passwordFormController.text;
                            checkifaccountexists(adminemail: email)
                                .then((truth) {
                              if (truth == true) { 
                                signInAdmin(
                                    adminemail: email,
                                    adminpassword: password,
                                    buildcontext: context);
                              } else {
                                print("It ain't true you fool");
                                ScaffoldMessenger.of(context)
                                    .hideCurrentSnackBar();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Account does not exist'),
                                  ),
                                );
                              }
                            });
                            ;

                            setState(() {
                              adminEmailFormController.text = "";
                              passwordFormController.text = "";
                            });
                          }
                        },
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 12.0, horizontal: 48.0),
                          child: Text("Login"),
                        ),
                      ),
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

//////////////////////////////////////////////////////////////////////
///////////////////////////////Functions//////////////////////////////
//////////////////////////////////////////////////////////////////////

  Future<bool> checkifaccountexists({required String adminemail}) async {
    bool _isIDFound = false;

    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('Admins')
        .where("email", isEqualTo: adminemail)
        .get();

    final List<DocumentSnapshot> documents = result.docs;

    if (result.size > 0) {
      _isIDFound = true;
      //exists
    } else {
      _isIDFound = false;
      //not exists
    }
    return _isIDFound;
  }

  Future signInAdmin(
      {required String adminemail,
      required String adminpassword,
      required BuildContext buildcontext}) async {
    final dbRef = FirebaseFirestore.instance
        .collection('Admins')
        .where("email", isEqualTo: adminemail)
        .get()
        .then(
      (querySnapshot) {
        if (identical(querySnapshot.docs[0]["password"], adminpassword)) {
          ScaffoldMessenger.of(buildcontext).hideCurrentSnackBar();
          gotoadminviolationwarninglistpage(buildcontext, adminemail);
        }
        if (!identical(querySnapshot.docs[0]["password"], adminpassword)) {
          ScaffoldMessenger.of(buildcontext).hideCurrentSnackBar();
          ScaffoldMessenger.of(buildcontext).showSnackBar(
            const SnackBar(
              content: Text('Incorrect Password'),
            ),
          );
        }
      },
      onError: (e) => print("Error completing: $e"),
    );
  }

  void toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

////////////////////////////
  ///Firebase auth function///
////////////////////////////

// Future signInAdmin() async {
//   print("signInAdmin starts:");

//   if (adminEmailFormController.text.isNotEmpty &&
//       passwordFormController.text.isNotEmpty) {
//     try {
//       await FirebaseAuth.instance.signInWithEmailAndPassword(
//           email: adminEmailFormController.text.trim(),
//           password: passwordFormController.text.trim());

//       final User? user = FirebaseAuth.instance.currentUser;
//       if (user == null) {
//         print('User is currently signed out!');
//         Navigator.push(context,
//             MaterialPageRoute(builder: (context) => const AdminLoginPage()));
//       } else {
//         print('User is signed in!');
//         Navigator.push(context,
//             MaterialPageRoute(builder: (context) => AdminViolationList()));
//       }
//     } on FirebaseAuthException catch (e) {
//       ScaffoldMessenger.of(context).hideCurrentSnackBar();
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Error: ${e.code}'),
//         ),
//       );
//       print('Failed with error code: ${e.code}');
//       print(e.message);
//       return e;
//     }
//   } else {
//     ScaffoldMessenger.of(context).hideCurrentSnackBar();
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(
//         content: Text('Please enter Email and Password'),
//       ),
//     );
//   }

//   gotoadminviolationlistpage(context);

//   print("signInAdmin ends:");
// }
}
