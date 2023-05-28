import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:osavici/adminpages/adminfunctions.dart';
import 'package:osavici/adminpages/adminlogin.dart';
import 'package:flutter/gestures.dart';
// import 'package:path_provider/path_provider.dart';

import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';

// Directory tempDir = await getTemporaryDirectory();
// String tempPath = tempDir.path;
// final ts = DateTime.now().millisecondsSinceEpoch.toString();
// String path = '$tempPath/$ts.png';

class AdminGenerateQRCode extends StatefulWidget {
  final String studentrecordid;
  AdminGenerateQRCode({Key? key, required this.studentrecordid})
      : super(key: key);
  final String title = "Update Violation Type";
  // final authuser = FirebaseAuth.instance.currentUser!;

  ScreenshotController qrScreenshotController = ScreenshotController();

  @override
  State<AdminGenerateQRCode> createState() => _AdminGenerateQRCode();
}

class _AdminGenerateQRCode extends State<AdminGenerateQRCode> {
  _AdminGenerateQRCode();
  late Uint8List _imageFile;

  String qrData = "Placeholder";
  final qrdataFeed = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //Appbar having title
      appBar: AppBar(
        title: Center(child: Text("Generate QR Code")),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          //Scroll view given to Column
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: FractionallySizedBox(
              heightFactor: 0.9,
              widthFactor: 0.8,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Screenshot(
                      controller: widget.qrScreenshotController,
                      child: QrImage(
                        data: widget.studentrecordid,
                        size: 300.0,
                      )),
                  // Container(height: 12),
                  // ElevatedButton(
                  //     onPressed: () {
                  //       print("You Pressed the Save Button, Congrats");
                  //       widget.qrScreenshotController
                  //           .capture()
                  //           .then((Uint8List image) {
                  //             //Capture Done
                  //             setState(() {
                  //               _imageFile = image;
                  //             });
                  //           } as FutureOr Function(Uint8List? value))
                  //           .catchError((onError) {
                  //         print(onError);
                  //       });
                  //     },
                  //     child: Text("Save")),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
