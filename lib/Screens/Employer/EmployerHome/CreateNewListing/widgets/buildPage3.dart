import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hire4consult/HelperWidgets/CustomDropdown.dart';
import 'package:hire4consult/HelperWidgets/CustomElevatedButton.dart';
import 'package:hire4consult/HelperWidgets/customMultiSelectDropdown.dart';
import 'package:hire4consult/HelperWidgets/customText.dart';
import 'package:hire4consult/HelperWidgets/loadingIndicator.dart';
import 'package:hire4consult/HelperWidgets/toastBar.dart';
import 'package:hire4consult/HelperWidgets/constant.dart';
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
        customMultiSelectDropdown(items: mapSkillsSelection[controller.departmentController.text] ?? [], controller: controller.keySkillsController, hintText: "Key skills", context: context),
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
            items: timeZones,
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
