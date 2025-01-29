

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hire4consult/HelperWidgets/CustomElevatedButton.dart';
import 'package:hire4consult/HelperWidgets/CustomTextField.dart';
import 'package:hire4consult/HelperWidgets/customText.dart';
import 'package:hire4consult/HelperWidgets/toastBar.dart';
import 'package:hire4consult/Screens/Consultant/ConsultantIntro/controllers/consult_intro_controller.dart';

final controller = Get.put(ConsultIntroController());

String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }
    if (value.length != 10) {
      return 'Phone number must be exactly 10 digits';
    }
    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return 'Phone number must contain only digits';
    }
    return null;
  }

  String? validateUrl(String? value) {
    if (value == null || value.isEmpty) {
      return 'URL is required';
    }

    final urlPattern =
        r'^(https?:\/\/)?([a-zA-Z0-9]+[.])+[a-zA-Z]{2,}(:[0-9]{1,5})?(\/.*)?$';
    final regex = RegExp(urlPattern);

    if (!regex.hasMatch(value)) {
      return 'Please enter a valid URL';
    }

    return null;
  }

  Widget buildPage1(dynamic pageController, BuildContext context) {
    return _buildContainer(
      context: context,
      step: "Step 1/5",
      title: "Tell us about yourself",
      content: Column(
        spacing: 8,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
              padding: EdgeInsets.only(left: 16),
              child: Row(
                children: [
                  Text('Full Name'),
                  Text(
                    '*',
                    style: TextStyle(color: Colors.red),
                  ),
                ],
              )),
          customTextField(
              hintText: "Full Name",
              controller: controller.fullNameController,
              keyboardType: TextInputType.name),
          Padding(
              padding: EdgeInsets.only(left: 16),
              child: Row(
                children: [
                  Text('Phone Number'),
                  Text(
                    '*',
                    style: TextStyle(color: Colors.red),
                  ),
                ],
              )),
          customTextField(
            hintText: "Phone Number",
            controller: controller.phoneNumberController,
            keyboardType: TextInputType.phone,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
          ),
          Padding(
              padding: EdgeInsets.only(left: 16),
              child: Row(
                children: [
                  Text('User Name'),
                  Text(
                    '*',
                    style: TextStyle(color: Colors.red),
                  ),
                ],
              )),
          customTextField(
              hintText: "User Name",
              controller: controller.userNameController,
              keyboardType: TextInputType.text),
          SizedBox(height: 25),
          Center(
              child: customElevatedButton(
                  onPress: () {
                    if (controller.fullNameController.text.isEmpty ||
                        controller.phoneNumberController.text.isEmpty ||
                        controller.userNameController.text.isEmpty) {
                      customToastBar(
                          title: "Error",
                          description: "Please fill all the required fields.",
                          icon: Icon(Icons.error, color: Colors.yellow));
                      return;
                    }
                    final phoneValidationError = validatePhoneNumber(
                        controller.phoneNumberController.text);
                    if (phoneValidationError != null) {
                      customToastBar(
                          title: "Error",
                          description: phoneValidationError,
                          icon: Icon(Icons.error, color: Colors.redAccent));
                      return;
                    }

                    pageController.nextPage(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                  buttonText: 'Next',
                  backgroundColor: Color(0xff212E50))),
          SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildContainer(
      {required String step, required String title, required Widget content, required BuildContext context}) {
    return Center(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
        decoration: BoxDecoration(
          color: Color(0xffFFFFFF),
          borderRadius: BorderRadius.circular(50),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha((0.1 * 255).toInt()),
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                step,
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
              SizedBox(height: 20),
              customText(
                  text: title,
                  context: context,
                  size: 35,
                  color: Color(0xff212E50),
                  fontWeight: FontWeight.w800),
              SizedBox(height: 40),
              content,
            ],
          ),
        ),
      ),
    );
  }