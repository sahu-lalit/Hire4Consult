import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hire4consult/HelperWidgets/CustomElevatedButton.dart';
import 'package:hire4consult/HelperWidgets/CustomTextField.dart';
import 'package:hire4consult/HelperWidgets/customMultiSelectDropdown.dart';
import 'package:hire4consult/HelperWidgets/customText.dart';
import 'package:hire4consult/HelperWidgets/toastBar.dart';
import 'package:hire4consult/Screens/Employer/EmployerHome/CreateNewListing/create_new_listing_controller/create_new_listing_controller.dart';

final controller = Get.put(CreateNewListingController());
Widget buildPage1(dynamic pageController, BuildContext context) {
  return _buildContainer(
    context: context,
    step: "Step 1/3",
    title: "Provide your company details",
    content: Column(
      spacing: 8,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
            padding: EdgeInsets.only(left: 16),
            child: Row(
              children: [
                Text('Company name alias'),
                Text(
                  '*',
                  style: TextStyle(color: Colors.red),
                ),
              ],
            )),
        customTextField(
            hintText: "Company name alias",
            controller: controller.companyNameAliasController),
        Padding(
            padding: EdgeInsets.only(left: 16),
            child: Row(
              children: [
                Text('Regions interested'),
                Text(
                  '*',
                  style: TextStyle(color: Colors.red),
                ),
              ],
            )),
        customMultiSelectDropdown(
            context: context,
            items: [
              'EMEA',
              'GULF'
                  'NA',
              'LATAM',
              'APAC',
            ],
            controller: controller.regionsInterestedController),
        SizedBox(height: 25),
        Center(
            child: customElevatedButton(
                onPress: () {
                  if (controller.companyNameAliasController.text
                          .trim()
                          .isEmpty ||
                      controller.regionsInterestedController.text
                          .trim()
                          .isEmpty) {
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
