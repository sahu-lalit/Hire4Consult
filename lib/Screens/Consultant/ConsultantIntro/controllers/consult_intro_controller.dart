import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hire4consult/HelperWidgets/toastBar.dart';
import 'package:hire4consult/Screens/Consultant/ConsultHome/consult_home.dart';

class ConsultIntroController extends GetxController{
  RxInt imageIndex = 0.obs;
  RxBool isSupportingDocumentUploaded = false.obs;
  RxBool isCertificateUploaded = false.obs;
  RxBool isResumeUploaded = false.obs;
  RxString resumeLink = "".obs;
  RxBool submitButtonLoading = false.obs;
  RxList<Map<String, String>> educationList = <Map<String, String>>[].obs;
  RxList<Map<String, String>> experienceList = <Map<String, String>>[].obs;

  TextEditingController fullNameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController addEducationController = TextEditingController();
  TextEditingController departmentController = TextEditingController();
  TextEditingController skillsController = TextEditingController();
  TextEditingController timeSlotAvailabilityController = TextEditingController();
  TextEditingController regionsInterestedController = TextEditingController();
  TextEditingController experienceController = TextEditingController();
  TextEditingController addCertificationController = TextEditingController();
  TextEditingController jobTitleLookingForController = TextEditingController();
  TextEditingController addPayRolePerMonthController = TextEditingController();
  TextEditingController addSocialMediaLinkController = TextEditingController();
  TextEditingController resumeLinkController = TextEditingController();
  TextEditingController addSocialMediaPlatformController = TextEditingController();


  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveUserProfile() async {
    try {
      // Create a map of the key-value pairs to store in Firestore
      Map<String, dynamic> userData = {
        "fullName": fullNameController.text.trim(),
        "phoneNumber": phoneNumberController.text.trim(),
        "userName": userNameController.text.trim(),
        "addEducation": addEducationController.text.trim(),
        "department": departmentController.text.trim(),
        "skills": skillsController.text.trim(),
        "timeSlotAvailability": timeSlotAvailabilityController.text.trim(),
        "regionsInterested": regionsInterestedController.text.trim(),
        "experience": experienceController.text.trim(),
        "addCertification": addCertificationController.text.trim(),
        "jobTitleLookingFor": jobTitleLookingForController.text.trim(),
        "addPayRolePerMonth": addPayRolePerMonthController.text.trim(),
        "addSocialMedia": addSocialMediaLinkController.text.trim(),
        "addResume": resumeLink.value ?? "",
        "selectedSocialMediaPlatform": addSocialMediaPlatformController.text.trim(),
        "profileVerify": "Verify",
        "userProfileLink": "",
      };
      final FirebaseAuth auth = FirebaseAuth.instance;
      final String uid = auth.currentUser?.uid ?? "";
      // Store the user data in the 'consult_user' collection
      await _firestore.collection('consult_user').doc(uid).set(userData);
      customToastBar(
          title: 'Success!',
          description: 'User profile saved successfully!',
          icon: Icon(Icons.check_circle, color: Colors.green),
          );

      Get.offAll(ConsultHome(),
          transition: Transition.native,
          duration: Duration(milliseconds: 1300));
    } catch (e) {
      customToastBar(
          title: 'Error',
          description: 'Error saving user profile: $e',
          primaryColor: Colors.red,
          icon: Icon(Icons.error));
    } finally {
      // isLoading.value = false;
      submitButtonLoading.value = false;
    }
  }
}