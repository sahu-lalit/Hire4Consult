import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hire4consult/HelperWidgets/toastBar.dart';
import 'package:hire4consult/Screens/Consultant/ConsultHome/consult_home.dart';
import 'package:hire4consult/Screens/Consultant/ConsultantIntro/consult_Introduction.dart';
import 'package:hire4consult/Screens/Employer/EmployerHome/employer_home.dart';
import 'package:hire4consult/Screens/Employer/EmployerIntro/employer_Introduction.dart';

class LoginScreenController extends GetxController {
  RxBool isSelected = true.obs;
  RxBool consultantLoading = false.obs;
  RxBool employerLoading = false.obs;
  RxBool resetPasswordLoading = false.obs;

  TextEditingController emailConsultantController = TextEditingController();
  TextEditingController passwordConsultantController = TextEditingController();
  TextEditingController emailEmployerController = TextEditingController();
  TextEditingController passwordEmployerController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<bool> fetchConsultantData() async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser != null) {
        final doc = await _firestore
            .collection('consult_user')
            .doc(currentUser.uid)
            .get();
        if (doc.exists) {
          return true;
        } else {
          return false;
        }
      }
      return false;
    } catch (e) {
      print('Error fetching employer data: $e');
      return false;
    }
  }

  Future<bool> fetchEmployerData() async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser != null) {
        final doc = await _firestore
            .collection('employer_user')
            .doc(currentUser.uid)
            .get();
        if (doc.exists) {
          return true;
        } else {
          return false;
        }
      }
      return false;
    } catch (e) {
      print('Error fetching employer data: $e');
      return false;
    }
  }

  Future<void> loginConsultant() async {
    try {
      final FirebaseAuth auth = FirebaseAuth.instance;
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: emailConsultantController.text.trim(),
        password: passwordConsultantController.text.trim(),
      );

      User? user = userCredential.user;

      if (user != null && user.emailVerified) {
        customToastBar(
          title: 'Success!',
          description: 'Login successful! Your email has been verified.',
          icon: Icon(
            Icons.check_circle,
            color: Colors.green,
          ),
        );
        
        if (await fetchConsultantData()) {
          Get.off(ConsultHome(),
              transition: Transition.native,
              duration: Duration(milliseconds: 1300));
        } else {
          Get.off(ConsultIntroduction(),
              transition: Transition.native,
              duration: Duration(milliseconds: 1300));
        }
        emailConsultantController.clear();
        passwordConsultantController.clear();

      } else {
        await auth.signOut();
        customToastBar(
            title: 'Error',
            description: 'Please verify your email before logging in.',
            icon: Icon(
              Icons.error,
              color: Colors.yellow,
            ));
      }
    } catch (e) {
      customToastBar(
          title: 'Error',
          description: 'Error during login: $e',
          icon: Icon(
            Icons.error,
            color: Colors.red,
          ));
    } finally {
      consultantLoading.value = false;
    }
  }

  Future<void> loginEmployer() async {
    try {
      final FirebaseAuth auth = FirebaseAuth.instance;
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: emailEmployerController.text.trim(),
        password: passwordEmployerController.text.trim(),
      );

      User? user = userCredential.user;

      if (user != null && user.emailVerified) {
        customToastBar(
          title: 'Success!',
          description: 'Login successful! Your email has been verified.',
          icon: Icon(
            Icons.check_circle,
            color: Colors.green,
          ),
        );
        
        if (await fetchEmployerData()) {
          Get.off(EmployerHome(),
              transition: Transition.native,
              duration: Duration(milliseconds: 1300));
        } else {
          Get.off(EmployerIntroduction(),
              transition: Transition.native,
              duration: Duration(milliseconds: 1300));
        }
        emailEmployerController.clear();
        passwordEmployerController.clear();
      } else {
        await auth.signOut();
        customToastBar(
            title: 'Error',
            description: 'Please verify your email before logging in.',
            icon: Icon(
              Icons.error,
              color: Colors.yellow,
            ));
      }
    } catch (e) {
      customToastBar(
          title: 'Error',
          description: 'Error during login: $e',
          icon: Icon(
            Icons.error,
            color: Colors.red,
          ));
    } finally {
      employerLoading.value = false;
    }
  }

  Future<void> resetPassword({required String emailId}) async {
    String email = emailId.trim();

    if (email.isNotEmpty) {
      try {
        await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
        customToastBar(
            title: 'Success!',
            description:
                'Password reset email sent to $email. Check your inbox.',
            icon: Icon(
              Icons.check_circle,
              color: Colors.green,
            ));
      } catch (e) {
        customToastBar(
            title: 'Error',
            description: 'Error sending password reset email: ${e.toString()}',
            icon: Icon(
              Icons.error,
              color: Colors.red,
            ));
      } finally {
        resetPasswordLoading.value = false;
      }
    } else {
      customToastBar(
          title: 'Error',
          description: 'Please enter a valid email address.',
          icon: Icon(
            Icons.error,
            color: Colors.yellow,
          ));
    }
  }

  @override
  void onClose() {
    super.onClose();
    emailConsultantController.dispose();
    passwordConsultantController.dispose();
    emailEmployerController.dispose();
    passwordEmployerController.dispose();
  }
}
