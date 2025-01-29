import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hire4consult/HelperWidgets/toastBar.dart';

class EmployerHomeController extends GetxController {
  RxBool showPopup = true.obs;
  RxString verifyButtonText = "Verify".obs;

    final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    Future<void> updateProfileVerification() async {
    final user = _auth.currentUser;
    if (user != null) {
      try {
        final docRef = _firestore.collection('employer_user').doc(user.uid);
        // Update Firestore, button state will change via Firestore listener
        await docRef.update({'profileVerify': 'Verifying'});
      } catch (e) {
        customToastBar(title: "Error", description: e.toString(), icon: Icon(Icons.error, color: Colors.red));        
      }
    }
  }

  @override
  onInit() {
    super.onInit();
    listenForProfileVerification();
  }

  void listenForProfileVerification() {
    final user = _auth.currentUser;
    if (user != null) {
      final docRef = _firestore.collection('employer_user').doc(user.uid);

      docRef.snapshots().listen((snapshot) {
        if (snapshot.exists) {
          final data = snapshot.data();
          final profileVerify = data?['profileVerify'];
            if (profileVerify == 'Verified') {
              showPopup.value = false;
            } else if (profileVerify == 'Verifying') {
              verifyButtonText.value = 'Verifying';
            } else {
              verifyButtonText.value = 'Verify';
            }
        }
      });
    }
  }
}
