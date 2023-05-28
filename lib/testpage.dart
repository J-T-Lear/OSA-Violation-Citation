import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:osavici/studentpages/studenttest.dart';
import 'package:osavici/studentpages/studentviolationmaker.dart';
import 'dbtestpage.dart';

final _testpageformkey = GlobalKey<FormState>();

class TestPage extends StatefulWidget {
  const TestPage({Key? key}) : super(key: key);
  final String title = "OSAViCi Test Page";

  @override
  State<TestPage> createState() => _TestPage();
}

class _TestPage extends State<TestPage> {
  _TestPage();

  final nameFormController = TextEditingController();
  final ageFormController = TextEditingController();

  String username = "";
  String userpassword = "";

  String agetxt = "password: ";

  void gotodbtestpage() {
    //Delete when finalizing
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Dbtestpage()),
    );
  }

  void gotoviolationmakerpage() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => const StudentViolationMakerPage()),
    );
  }

  void gotostudenttestpage() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const StudentTestPage()));
  }

  @override
  void dispose() {
    nameFormController.dispose();
    ageFormController.dispose();
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
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: //////////insert widget to check here
          Center(
            child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
            const Text("Go to Database Test Page "), //Delete when finalizing
          
            const SizedBox(
              height: 30,
            ),
          
            ElevatedButton(
                onPressed: gotodbtestpage, child: const Text("Test Page")),
          
            const SizedBox(
              height: 30,
            ),
          
            const Text("Go to Student Testing Page"), //Delete when finalizing
          
            const SizedBox(
              height: 30,
            ),
          
            ElevatedButton(
                onPressed: gotostudenttestpage,
                child: const Text("Student Test Page")),
          
            const SizedBox(
              height: 30,
            ),
          
            const Text("Go to Violation Maker Page"), //Delete when finalizing
          
            const SizedBox(
              height: 30,
            ),
          
            ElevatedButton(
                onPressed: gotoviolationmakerpage,
                child: const Text("Violation Maker Page")),
                  ],
                ),
          ),
    );
  }
}
