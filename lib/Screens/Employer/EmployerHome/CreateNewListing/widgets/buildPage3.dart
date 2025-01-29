import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hire4consult/HelperWidgets/CustomDropdown.dart';
import 'package:hire4consult/HelperWidgets/CustomElevatedButton.dart';
import 'package:hire4consult/HelperWidgets/customMultiSelectDropdown.dart';
import 'package:hire4consult/HelperWidgets/customText.dart';
import 'package:hire4consult/HelperWidgets/loadingIndicator.dart';
import 'package:hire4consult/HelperWidgets/toastBar.dart';

import '../../employer_home.dart';
import '../create_new_listing_controller/create_new_listing_controller.dart';

void triggerNavigationAfterDelay() {
  Future.delayed(Duration(seconds: 2), () {
    Get.to(() => EmployerHome(),
        transition: Transition.native, duration: Duration(milliseconds: 1300));
  });
}

final controller = Get.put(CreateNewListingController());
Widget buildPage3(dynamic pageController, BuildContext context) {
  return _buildContainer(
    context: context,
    step: "Step 3/3",
    title: "Work requirements",
    content: Column(
      spacing: 8,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
            padding: EdgeInsets.only(left: 16),
            child: Row(
              children: [
                Text('Hours needed'),
                Text(
                  '*',
                  style: TextStyle(color: Colors.red),
                ),
              ],
            )),
        customMultiSelectDropdown(
            context: context,
            items: ["3", "4", "5", "6", "7", "8", "9"],
            controller: controller.hoursNeededController,
            hintText: "Hours needed"),
        Padding(
            padding: EdgeInsets.only(left: 16),
            child: Row(
              children: [
                Text('Key skills'),
                Text(
                  '*',
                  style: TextStyle(color: Colors.red),
                ),
              ],
            )),
        customDropdown(items: [
          "React.js",
          "React Native",
          "Flutter",
          "Excel",
          "UI/UX",
          "JavaScript",
          "TypeScript",
          "Redux",
          "Context API",
          "Hooks",
          "RESTful APIs",
          "GraphQL",
          "Firebase",
          "Supabase",
          "CI/CD",
          "Jest",
          "Mocha",
          "Flutter Test",
          "Figma",
          "Adobe XD",
          "Sketch",
          "Wireframing",
          "Prototyping",
          "Material Design",
          "Cupertino Guidelines",
          "Accessibility",
          "Usability Testing",
          "Design Thinking",
          "Pivot Tables",
          "VBA",
          "CRM Tools",
          "Salesforce",
          "HubSpot",
          "Data Visualization",
          "Power BI",
          "Tableau",
          "Lead Generation",
          "Market Research",
          "SEO",
          "SEM",
          "Google Analytics",
          "Social Media Marketing",
          "Email Marketing",
          "Content Strategy",
          "Copywriting",
          "Customer Data Management",
          "CRM & Ticketing Systems",
          "Zendesk",
          "Freshdesk",
          "Troubleshooting",
          "Financial Modeling",
          "Budgeting",
          "Accounting Software",
          "QuickBooks",
          "SAP",
          "Data Analysis",
          "Forecasting",
          "Agile",
          "Scrum",
          "A/B Testing",
          "Jira",
          "Trello"
        ], controller: controller.keySkillsController, hintText: "Key skills"),
        Padding(
            padding: EdgeInsets.only(left: 16),
            child: Row(
              children: [
                Text('Time zone company works in'),
                Text(
                  '*',
                  style: TextStyle(color: Colors.red),
                ),
              ],
            )),
        customMultiSelectDropdown(
            context: context,
            items: [
              "Pacific Time (PT) UTC -8 / UTC -7",
              "Mountain Time (MT) UTC -7 / UTC -6",
              "Central Time (CT) UTC -6 / UTC -5",
              "Eastern Time (ET) UTC -5 / UTC -4",
              "Brasilia Time (BRT) UTC -3",
              "Argentina Time (ART) UTC -3",
              "Colombia Time (COT) UTC -5",
              "Greenwich Mean Time (GMT) UTC 0",
              "Central European Time (CET) UTC +1 / UTC +2",
              "Eastern European Time (EET) UTC +2 / UTC +3",
              "West Africa Time (WAT) UTC +1",
              "Central Africa Time (CAT) UTC +2",
              "East Africa Time (EAT) UTC +3",
              "India Standard Time (IST) UTC +5:30",
              "China Standard Time (CST) UTC +8",
              "Japan Standard Time (JST) UTC +9",
              "Singapore Time (SGT) UTC +8",
              "Gulf Standard Time (GST) UTC +4",
              "Arabian Standard Time (AST) UTC +3",
              "Australian Western Standard Time (AWST) UTC +8",
              "Australian Eastern Standard Time (AEST) UTC +10 / UTC +11",
              "New Zealand Standard Time (NZST) UTC +12 / UTC +13"
            ],
            controller: controller.timeZoneController),
        SizedBox(height: 25),
        Center(
            child: Obx(
          () => controller.isLoadingForSubmitJob.value
              ? loading(100)
              : customElevatedButton(
                  onPress: () async {
                    controller.isLoadingForSubmitJob.value = true;
                    if (controller.hoursNeededController.text.trim().isEmpty ||
                        controller.timeZoneController.text.trim().isEmpty ||
                        controller.keySkillsController.text.trim().isEmpty) {
                      customToastBar(
                          title: "Error",
                          description: "Please fill all the required fields.",
                          icon: Icon(Icons.error, color: Colors.yellow));
                      controller.isLoadingForSubmitJob.value = false;
                      return;
                    }
                    await controller.submitJob();
                    pageController.nextPage(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                    triggerNavigationAfterDelay();
                  },
                  buttonText: 'Submit',
                  backgroundColor: Color(0xff212E50)),
        )),
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
