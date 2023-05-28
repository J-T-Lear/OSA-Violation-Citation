import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:osavici/adminpages/adminviolationlist.dart';
import 'firebase_options.dart';


import 'package:osavici/adminpages/adminlogin.dart'; 
import 'package:osavici/studentpages/studentlogin.dart';
import 'testpage.dart';
import 'package:osavici/apptheme.dart'
; 

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

class NavigationService { 
  static GlobalKey<NavigatorState> navigatorKey = 
  GlobalKey<NavigatorState>();
}
Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OSAViCi',
      theme: SystemTheme().themedata,
      home: const MyHomePage(title: 'OSAVICI Testing Main Page'),
      navigatorKey: NavigationService.navigatorKey,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void gototestpage() {
    //Delete when finalizing
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const TestPage()),
    );
  }
 

  void gotostudentloginpage() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const StudentLoginPage()));
  } 

  void gotoadminloginpage() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const AdminLoginPage()));
  } 


  // void checkIfLoggedIn() { 

  //   final User? user = FirebaseAuth.instance.currentUser;
  //   if (user == null) {
  //         print('User is currently signed out!');  
  //         Navigator.push(context,
  //         MaterialPageRoute(builder: (context) => const AdminLoginPage()));
  //   } else { 
  //         print('User is signed in!'); 
  //         Navigator.push(context,
  //         MaterialPageRoute(builder: (context) =>  AdminViolationList()));
  //   } 
 
  // }
 

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
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Column(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   crossAxisAlignment: CrossAxisAlignment.center,
              //   children: [
              //     const Text("Go to Test Page "), //Delete when finalizing

              //     const SizedBox(
              //       height: 30,
              //     ),

              //     ElevatedButton(
              //         onPressed: gototestpage, child: const Text("Test Page")),
              //   ],
              // ),
              // const SizedBox(
              //   width: 40,
              // ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text("Go to Student Portal"),
                  const SizedBox(
                    height: 30,
                  ),
                  ElevatedButton(
                      onPressed: gotostudentloginpage,
                      child: const Text("Login")),
                  const SizedBox(
                    height: 30,
                  ),
                  const Text("Go to Admin Portal"),
                  const SizedBox(
                    height: 30,
                  ), 
                   ElevatedButton(
                      onPressed: gotoadminloginpage,
                      child: const Text("Login")),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  
}
