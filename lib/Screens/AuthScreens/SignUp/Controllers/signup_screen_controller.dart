import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hire4consult/HelperWidgets/toastBar.dart';
import 'package:hire4consult/Screens/AuthScreens/Login/login_screen.dart';

class SignupScreenController extends GetxController {
  RxBool isSelected = false.obs;
  RxBool consultantLoading = false.obs;
  RxBool employerLoading = false.obs;

  TextEditingController emailConsultantController = TextEditingController();
  TextEditingController passwordConsultantController = TextEditingController();

  TextEditingController emailEmployerController = TextEditingController();
  TextEditingController passwordEmployerController = TextEditingController();

  Future<void> signUpConsultant() async {
    try {
      final FirebaseAuth auth = FirebaseAuth.instance;
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: emailConsultantController.text.trim(),
        password: passwordConsultantController.text.trim(),
      );

      User? user = userCredential.user;

      if (user != null) {
        await user.sendEmailVerification();
        await auth.signOut();

        Get.offAll(() => LoginScreen(),
            transition: Transition.native,
            duration: Duration(milliseconds: 1300));
        customToastBar(
            title: 'Signup successful',
            description:
                'Verification email sent to ${emailConsultantController.text}',
            icon: Icon(
              Icons.check_circle,
              color: Colors.green,
            ));
        customToastBar(
            title: 'Note: ',
            description: 'Please verify your email to activate your account.',
            icon: Icon(
              Icons.error,
              color: Colors.yellow,
            ));
      }
    } catch (e) {
      customToastBar(
          title: 'Failed',
          description: 'Error during signup: $e',
          icon: Icon(
            Icons.error,
            color: Colors.red,
          ));
    } finally {
      consultantLoading.value = false;
    }
  }

  Future<void> signUpEmployer() async {
    try {
      final FirebaseAuth auth = FirebaseAuth.instance;
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: emailEmployerController.text.trim(),
        password: passwordEmployerController.text.trim(),
      );

      User? user = userCredential.user;

      if (user != null) {
        await user.sendEmailVerification();
        await auth.signOut();
        Get.offAll(() => LoginScreen(),
            transition: Transition.native,
            duration: Duration(milliseconds: 1300));

        customToastBar(
            title: 'Signup successful',
            description:
                'Verification email sent to ${emailEmployerController.text}',
            icon: Icon(
              Icons.check_circle,
              color: Colors.green,
            ));
        customToastBar(
            title: 'Note: ',
            description: 'Please verify your email to activate your account.',
            icon: Icon(
              Icons.error,
              color: Colors.yellow,
            ));
      }
    } catch (e) {
      customToastBar(
          title: 'Failed',
          description: 'Error during signup: $e',
          icon: Icon(
            Icons.error,
            color: Colors.red,
          ));
    } finally {
      employerLoading.value = false;
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
