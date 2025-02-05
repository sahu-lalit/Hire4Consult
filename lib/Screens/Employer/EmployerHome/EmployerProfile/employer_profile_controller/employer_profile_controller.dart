import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hire4consult/HelperWidgets/toastBar.dart';
import 'package:hire4consult/Screens/Employer/EmployerHome/employer_home.dart';

import '../employer_profile.dart';

class EmployerProfileController extends GetxController {
  RxBool isHovered = false.obs;
  RxBool userDataLoading = false.obs;
  RxBool isEditing = false.obs;
  RxBool isPanUploaded = false.obs;
  RxBool isLoadingSave = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchEmployerData();
  }

  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController designationController = TextEditingController();
  TextEditingController companyNameController = TextEditingController();
  TextEditingController companyEmailController = TextEditingController();
  TextEditingController companyPhoneController = TextEditingController();
  TextEditingController companyWebsiteController = TextEditingController();
  TextEditingController companyGstController = TextEditingController();
  TextEditingController companyPanController = TextEditingController();
  String userProfileVerified = '';

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Map<String, dynamic>? employerData;

  Future<void> fetchEmployerData() async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser != null) {
        final doc = await _firestore
            .collection('employer_user')
            .doc(currentUser.uid)
            .get();
        if (doc.exists) {
          employerData = doc.data();
          userDataLoading.value = true;
        }
        nameController.text = employerData?['name'] ?? '';
        phoneController.text = employerData?['phoneNumber'] ?? '';
        designationController.text = employerData?['designation'] ?? '';
        companyNameController.text = employerData?['companyName'] ?? '';
        companyEmailController.text = employerData?['companyEmail'] ?? '';
        companyPhoneController.text = employerData?['companyPhone'] ?? '';
        companyWebsiteController.text = employerData?['companyWebsite'] ?? '';
        companyGstController.text = employerData?['companyGst'] ?? '';
        companyPanController.text = employerData?['companyPan'] ?? '';
        userProfileVerified = employerData?['profileVerify'] ?? '';
      }
    } catch (e) {
      print('Error fetching employer data: $e');
    }
  }

  Future<void> saveProfile() async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser != null) {
        await _firestore.collection('employer_user').doc(currentUser.uid).set({
          'name': nameController.text,
          'phoneNumber': phoneController.text,
          'designation': designationController.text,
          'companyName': companyNameController.text,
          'companyEmail': companyEmailController.text,
          'companyPhone': companyPhoneController.text,
          'companyWebsite': companyWebsiteController.text,
          'companyGst': companyGstController.text,
          'companyPan': companyPanController.text,
          "profileVerify": "Verify",
        });
        customToastBar(
            title: 'Success!',
            description: 'Profile updated successfully',
            icon: Icon(Icons.check_circle, color: Colors.green));
      }
    } catch (e) {
      print('Error saving profile: $e');
      customToastBar(
          title: 'Error!',
          description: 'Failed to update profile',
          icon: Icon(Icons.error, color: Colors.red));
    } finally {
      isLoadingSave.value = false;
      isEditing.value = false;
      Get.off(() => EmployerHome(), transition: Transition.native, duration: Duration(milliseconds: 1300));
    }
  }
}
