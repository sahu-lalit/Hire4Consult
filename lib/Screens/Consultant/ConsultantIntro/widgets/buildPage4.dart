

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hire4consult/HelperWidgets/CustomDropdown.dart';
import 'package:hire4consult/HelperWidgets/CustomElevatedButton.dart';
import 'package:hire4consult/HelperWidgets/constant.dart';
import 'package:hire4consult/HelperWidgets/customMultiSelectDropdown.dart';
import 'package:hire4consult/HelperWidgets/customText.dart';
import 'package:hire4consult/HelperWidgets/toastBar.dart';
import 'package:hire4consult/Screens/Consultant/ConsultantIntro/controllers/consult_intro_controller.dart';


final controller = Get.put(ConsultIntroController());
Widget buildPage4(dynamic  pageController, BuildContext context) {
    return _buildContainer(
      context: context,
      step: "Step 4/5",
      title: "Provide details about your skills and availability",
      content: Column(
        spacing: 8,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
              padding: EdgeInsets.only(left: 16),
              child: Row(
                children: [
                  Text('Skills'),
                  Text(
                    '*',
                    style: TextStyle(color: Colors.red),
                  ),
                ],
              )),
          customMultiSelectDropdown(
              items: mapSkillsSelection[controller.departmentController.text] ?? [],
              hintText: "Job Title Looking For",
              controller: controller.skillsController, context: context),
          Padding(
              padding: EdgeInsets.only(left: 16),
              child: Row(
                children: [
                  Text('Time Slot Availability'),
                  Text(
                    '*',
                    style: TextStyle(color: Colors.red),
                  ),
                ],
              )),
          customMultiSelectDropdown(
              context: context,
              items: ["3", "4", "5", "6", "7", "8"],
              controller: controller.timeSlotAvailabilityController,
              hintText: 'Time Slot Availability for'),
          Padding(
              padding: EdgeInsets.only(left: 16),
              child: Row(
                children: [
                  Text('Regions Interested'),
                  Text(
                    '*',
                    style: TextStyle(color: Colors.red),
                  ),
                ],
              )),
          customMultiSelectDropdown(
              context: context,
              items: listRegions,
              controller: controller.regionsInterestedController,
              hintText: 'e.g. APAC'),
          SizedBox(height: 25),
          Center(
              child: customElevatedButton(
                  onPress: () {
                    if (controller.skillsController.text.isEmpty ||
                        controller
                            .timeSlotAvailabilityController.text.isEmpty ||
                        controller.regionsInterestedController.text.isEmpty) {
                      customToastBar(
                          title: "Error",
                          description: "Please fill all the required fields.",
                          icon: Icon(Icons.error, color: Colors.yellow));
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