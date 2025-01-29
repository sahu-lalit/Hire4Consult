import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hire4consult/HelperWidgets/toastBar.dart';
import 'package:hire4consult/Screens/Employer/EmployerHome/employer_home.dart';

class EmployerIntroController extends GetxController{
  RxBool isPanUploaded = false.obs;
  RxBool isLoadingSubmitButton = false.obs;
  RxInt imageIndex = 0.obs;
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController companyEmailController = TextEditingController();
  TextEditingController designationController = TextEditingController();
  TextEditingController companyNameController = TextEditingController();
  TextEditingController companyPhoneController = TextEditingController();
  TextEditingController companyWebsiteController = TextEditingController();
  TextEditingController companyPanController = TextEditingController();
  TextEditingController companyGstController = TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveEmployerUserProfile() async {
    try {
      Map<String, dynamic> userData = {
        "name": nameController.text.trim(),
        "phoneNumber": phoneController.text.trim(),
        "companyEmail": companyEmailController.text.trim(),
        "designation": designationController.text.trim(),
        "companyName": companyNameController.text.trim(),
        "companyPhone": companyPhoneController.text.trim(),
        "companyWebsite": companyWebsiteController.text.trim(),
        "companyPan": companyPanController.text.trim(),
        "companyGst": companyGstController.text.trim(),
        "profileVerify": "Verify",
      };
      final FirebaseAuth auth = FirebaseAuth.instance;
      final String uid = auth.currentUser?.uid ?? "";
      await _firestore.collection('employer_user').doc(uid).set(userData);

      customToastBar(title: 'Success!', description: 'User profile saved successfully!', icon: Icon(Icons.check_circle, color: Colors.green,));
   
      Get.offAll(EmployerHome(),
          transition: Transition.native,
          duration: Duration(milliseconds: 1300));

    } catch (e) {
      customToastBar(title: 'Error!', description: 'Error saving user profile: $e');
    } finally {
    //   isLoading.value = false;
      isLoadingSubmitButton.value = false;
    }
  }
}