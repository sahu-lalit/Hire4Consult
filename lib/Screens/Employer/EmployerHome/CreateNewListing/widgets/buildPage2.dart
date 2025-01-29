import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hire4consult/HelperWidgets/CustomDropdown.dart';
import 'package:hire4consult/HelperWidgets/CustomElevatedButton.dart';
import 'package:hire4consult/HelperWidgets/CustomTextField.dart';
import 'package:hire4consult/HelperWidgets/customText.dart';
import 'package:hire4consult/HelperWidgets/toastBar.dart';

import '../create_new_listing_controller/create_new_listing_controller.dart';

final controller = Get.put(CreateNewListingController());
Widget buildPage2(dynamic pageController, BuildContext context) {
  return buildContainer(
    context: context,
    step: "Step 2/3",
    title: "Tell us about role details",
    content: Column(
      spacing: 8,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
            padding: EdgeInsets.only(left: 16),
            child: Row(
              children: [
                Text('Department'),
                Text(
                  '*',
                  style: TextStyle(color: Colors.red),
                ),
              ],
            )),
        customDropdown(items: [
          'Software Development',
          'HR',
          'Business Development',
          'Marketing',
          'Sales',
          'Customer Support',
          'Finance',
          'Product Management',
          'UI/UX Design',
          'Quality Assurance (QA) & Testing',
          'IT Support & Infrastructure',
          'Cybersecurity',
          'Data Science & Analytics',
          'Cloud Computing',
          'Operations & Administration',
          'Legal & Compliance',
          'Procurement & Supply Chain',
          'Research & Development (R&D)',
          'Production & Manufacturing',
          'Quality Control',
          'Maintenance & Engineering',
          'Logistics & Warehouse'
        ], hintText: "Department", controller: controller.departmentController),
        Padding(
            padding: EdgeInsets.only(left: 16),
            child: Row(
              children: [
                Text('Job description'),
                Text(
                  '*',
                  style: TextStyle(color: Colors.red),
                ),
              ],
            )),
        TextFormField(
          controller: controller.jobDescriptionController,
          keyboardType: TextInputType.multiline,
          maxLines: null,
          minLines: 5,
          decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xff212E50)),
              borderRadius: BorderRadius.circular(30),
            ),
            hintText: "Enter job description here...",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            contentPadding:
                EdgeInsets.only(left: 20.0, right: 20.0, top: 20, bottom: 20),
          ),
        ),
        Padding(
            padding: EdgeInsets.only(left: 16),
            child: Row(
              children: [
                Text('Position'),
                Text(
                  '*',
                  style: TextStyle(color: Colors.red),
                ),
              ],
            )),
        customTextField(
            hintText: "Position", controller: controller.positionController),
        SizedBox(height: 25),
        Center(
            child: customElevatedButton(
                onPress: () {
                  if (controller.departmentController.text.trim().isEmpty ||
                      controller.jobDescriptionController.text.trim().isEmpty ||
                      controller.positionController.text.trim().isEmpty) {
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

Widget buildContainer(
    {required String step,
    required String title,
    required Widget content,
    required BuildContext context}) {
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
