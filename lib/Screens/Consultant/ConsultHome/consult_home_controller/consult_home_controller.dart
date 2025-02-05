import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hire4consult/HelperWidgets/toastBar.dart';
import 'package:hire4consult/HelperWidgets/constant.dart';

class ConsultHomeController extends GetxController {
  RxBool showPopup = true.obs;
  RxString verifyButtonText = "Verify".obs;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> updateProfileVerification() async {
    final user = _auth.currentUser;
    if (user != null) {
      try {
        final docRef = _firestore.collection('consult_user').doc(user.uid);
        // Update Firestore, button state will change via Firestore listener
        await docRef.update({'profileVerify': 'Verifying'});
      } catch (e) {
        customToastBar(
            title: "Error",
            description: e.toString(),
            icon: Icon(Icons.error, color: Colors.red));
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
      final docRef = _firestore.collection('consult_user').doc(user.uid);

      docRef.snapshots().listen((snapshot) {
        if (snapshot.exists) {
          final data = snapshot.data();
          final profileVerify = data?['profileVerify'];
          if (profileVerify == 'Verified') {
            verifyButtonText.value = 'Verified';
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

  final selectedSkills = <String>{}.obs;
  final selectedDepartments = <String>{}.obs;

   final availableSkills = <String>[].obs;

  void updateSkills() {
    final selectedDeptSkills = selectedDepartments
        .expand((dept) => mapSkillsSelection[dept] ?? [])
        .toSet()
        .toList();
    availableSkills.assignAll(selectedDeptSkills.cast<String>());
  }

  Stream<QuerySnapshot> get jobsStream {
    Query query = FirebaseFirestore.instance.collection('jobs_information');
    
    if (selectedDepartments.isNotEmpty) {
      query = query.where('department', whereIn: selectedDepartments.toList());
    }
    if (selectedSkills.isNotEmpty) {
      query = query.where('key_skills', whereIn: selectedSkills.toList());
    }
    return query.snapshots();
  }
}
