import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _dbtestpageformkey = GlobalKey<FormState>();

Stream<List<User>> readUsers() => FirebaseFirestore.instance
    .collection('TestCollection') //Stream reads from db
    .snapshots()
    .map((snapshot) =>
        snapshot.docs.map((doc) => User.fromJson(doc.data())).toList());

Future createUser(
    {required String username, required String userpassword}) async {
  final docUser = FirebaseFirestore.instance.collection('TestCollection').doc();

  final user = User(id: docUser.id, name: username, password: userpassword);

  final json = user.toJson();

  await docUser.set(json);
}

class User {
  String id;
  final String name;
  final String password;

  User({
    this.id = "",
    required this.name,
    required this.password,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'password': password,
      };

  static User fromJson(Map<String, dynamic> json) => User(
        id: json['id'],
        name: json['name'],
        password: json['password'],
      );
}

Widget buildUser(User user) => ListTile(
      title: Text(user.name),
      subtitle: Text(user.password),
    );

class Dbtestpage extends StatefulWidget {
  const Dbtestpage({Key? key}) : super(key: key);
  final String title = "OSAViCi Database Test Page";

  @override
  State<Dbtestpage> createState() => _Dbtestpage();
}

class _Dbtestpage extends State<Dbtestpage> {
  _Dbtestpage();

  final nameFormController = TextEditingController();
  final ageFormController = TextEditingController();

  String username = "";
  String userpassword = "";

  String agetxt = "password: ";

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
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                width: 300,
                child: Form(
                  key: _dbtestpageformkey,
                  child: Column(
                    children: [
                      const Text("Create User"),
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
                      const Text("Enter Age"),
                      TextFormField(
                        controller: ageFormController,
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
                            if (_dbtestpageformkey.currentState!.validate()) {
                              setState(() {
                                username = nameFormController.text;
                                nameFormController.text = "";

                                userpassword = ageFormController.text;
                                ageFormController.text = "";

                                agetxt = "password:";
                              });

                              createUser(
                                  username: username,
                                  userpassword: userpassword);

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
                  child: StreamBuilder<List<User>>(
                      stream: readUsers(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
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
            ],
          ),
        ),
      ),
    );
  }
}
