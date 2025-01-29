import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hire4consult/HelperWidgets/toastBar.dart';

import 'package:universal_html/html.dart' as html;

import '../../consult_home.dart';

class MyProfileController extends GetxController {
  RxBool isHovered = false.obs;
  RxBool userDataLoading = false.obs;
  RxBool isImagUploading = false.obs;
  RxBool isImageRemoving = false.obs;
  RxBool isEditing = false.obs;
  RxBool isLoadingSave = false.obs;
  // RxBool submitButtonLoading = false.obs;

  Map<String, dynamic>? userData;

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
  String? userProfileLink = '';
  String? userProfileVerified = '';


  RxString imageUrl = ''.obs;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  onInit() {
    super.onInit();
    loadProfilePicture();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser != null) {
        final doc = await _firestore
            .collection('consult_user')
            .doc(currentUser.uid)
            .get();
        if (doc.exists) {
          userData = doc.data();
          userDataLoading.value = true;
        }
        fullNameController.text = userData?['fullName'] ?? '';
        userNameController.text = userData?['userName'] ?? '';
        phoneNumberController.text = userData?['phoneNumber'] ?? '';
        addEducationController.text = userData?['addEducation'] ?? '';
        addCertificationController.text = userData?['addCertification'] ?? '';
        experienceController.text = userData?['experience'] ?? '';
        departmentController.text = userData?['department'] ?? '';
        jobTitleLookingForController.text = userData?['jobTitleLookingFor'] ?? '';
        addPayRolePerMonthController.text = userData?['addPayRolePerMonth'] ?? '';
        skillsController.text = userData?['skills'] ?? '';
        timeSlotAvailabilityController.text = userData?['timeSlotAvailability'] ?? '';
        regionsInterestedController.text = userData?['regionsInterested'] ?? '';
        addSocialMediaPlatformController.text = userData?['selectedSocialMediaPlatform'] ?? '';
        addSocialMediaLinkController.text = userData?['addSocialMedia'] ?? '';
        userProfileLink = userData?['userProfileLink'] ?? '';
        userProfileVerified = userData?['profileVerify'] ?? '';
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  Future<void> loadProfilePicture() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        final docSnapshot =
            await _firestore.collection('consult_user').doc(user.uid).get();
        if (docSnapshot.exists) {
          final data = docSnapshot.data();
          if (data != null && data.containsKey('userProfileLink')) {
            imageUrl.value = data['userProfileLink'];
            print('Profile picture loaded: ${imageUrl.value}');
            update();
          }
        }
      }
    } catch (e) {
      print("Error loading profile picture: $e");
    }
  }

  Future<void> pickAndUploadProfilePicture() async {
    final html.FileUploadInputElement uploadInput =
        html.FileUploadInputElement()..accept = 'image/*';
    uploadInput.click();

    await uploadInput.onChange.first.then((event) async {
      isImagUploading.value = true;
      final files = uploadInput.files;
      if (files != null && files.isNotEmpty) {
        final file = files[0];
        final reader = html.FileReader();

        reader.readAsArrayBuffer(file);
        await reader.onLoadEnd.first;

        final Uint8List fileBytes = reader.result as Uint8List;
        final fileName = file.name;
        final fileType = file.type;

        try {
          final storageRef = FirebaseStorage.instance
              .ref()
              .child('user_profiles/${_auth.currentUser!.uid}/$fileName');
          final uploadTask = storageRef.putData(
            fileBytes,
            SettableMetadata(contentType: fileType),
          );

          await uploadTask.whenComplete(() {});
          final downloadUrl = await storageRef.getDownloadURL();

          await _firestore
              .collection('consult_user')
              .doc(_auth.currentUser!.uid)
              .set(
            {'userProfileLink': downloadUrl},
            SetOptions(merge: true),
          );

          imageUrl.value = downloadUrl;
          customToastBar(
              title: 'Success!',
              description: 'Profile picture uploaded successfully!',
              icon: Icon(Icons.check_circle, color: Colors.green));
        } catch (e) {
          customToastBar(
              title: 'Error!',
              description: 'Error uploading profile picture: $e',
              icon: Icon(Icons.error, color: Colors.red));
        } finally {
          isImagUploading.value = false;
        }
      }
    });
  }

  Future<void> removeProfilePicture() async {
    final user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('consult_user').doc(user.uid).update({
        'userProfileLink': FieldValue.delete(),
      });

      imageUrl.value = '';
      customToastBar(
          title: "Success!",
          description: "Profile picture removed successfully!",
          icon: Icon(
            Icons.check_circle,
            color: Colors.green,
          ));
    }
    isImageRemoving.value = false;
  }


  Future<void> saveProfile() async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser != null) {
        await _firestore.collection('consult_user').doc(currentUser.uid).set({
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
        "selectedSocialMediaPlatform": addSocialMediaPlatformController.text.trim(),
        "profileVerify": userProfileVerified,
        "userProfileLink": userProfileLink,
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
      Get.off(() => ConsultHome(), transition: Transition.native, duration: Duration(milliseconds: 1300));
    }
  }
}
