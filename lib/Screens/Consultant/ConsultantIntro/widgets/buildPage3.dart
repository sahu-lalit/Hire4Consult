


import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hire4consult/HelperWidgets/CustomDropdown.dart';
import 'package:hire4consult/HelperWidgets/CustomElevatedButton.dart';
import 'package:hire4consult/HelperWidgets/CustomTextField.dart';
import 'package:hire4consult/HelperWidgets/customText.dart';
import 'package:hire4consult/HelperWidgets/customTextFieldLikeButton.dart';
import 'package:hire4consult/HelperWidgets/datePicker.dart';
import 'package:hire4consult/HelperWidgets/toastBar.dart';
import 'package:hire4consult/Screens/Consultant/ConsultantIntro/controllers/consult_intro_controller.dart';

final controller = Get.put(ConsultIntroController());

Widget buildPage3(dynamic pageController, BuildContext context) {
    return _buildContainer(
      context: context,
      step: "Step 3/5",
      title: "Share information about your experience and job preferences",
      content: Column(
        spacing: 8,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
              padding: EdgeInsets.only(left: 16),
              child: Row(
                children: [
                  Text('Add Experience'),
                ],
              )),
          customTextFieldLikeButton(
            label: 'Add Experience',
            onPressed: () async {
              await _addExperienceDialog(context);
            },
          ),
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
          customDropdown(
              items: [
                "Software Development",
                "Finance",
                "Human Resources",
                "Marketing",
                "Sales"
              ],
              hintText: "Select Department",
              controller: controller.departmentController),
          Padding(
              padding: EdgeInsets.only(left: 16),
              child: Row(
                children: [
                  Text('Job Title Looking For'),
                  Text(
                    '*',
                    style: TextStyle(color: Colors.red),
                  ),
                ],
              )),
          customTextField(
              hintText: "Job Title Looking For",
              controller: controller.jobTitleLookingForController),
          Padding(
              padding: EdgeInsets.only(left: 16),
              child: Row(
                children: [
                  Text('Pay Scale Per Month'),
                  Text(
                    '*',
                    style: TextStyle(color: Colors.red),
                  ),
                ],
              )),
          customTextField(
            hintText: "Pay Scale Per Month",
            controller: controller.addPayRolePerMonthController,
            keyboardType: TextInputType.phone,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
          ),
          SizedBox(height: 25),
          Center(
              child: customElevatedButton(
                  onPress: () {
                    if (controller.addPayRolePerMonthController.text.isEmpty ||
                        controller.departmentController.text.isEmpty ||
                        controller.jobTitleLookingForController.text.isEmpty) {
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

  Future<dynamic> _addExperienceDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Color(0xfff1f1f1),
              title: Center(
                child: customText(
                    text: 'Add Experience',
                    context: context,
                    size: 35,
                    color: Color(0xff212E50),
                    fontWeight: FontWeight.w800),
              ),
              content: SizedBox(
                width: MediaQuery.of(context).size.width / 2,
                height: MediaQuery.of(context).size.height / 1.5,
                child: SingleChildScrollView(
                  child: Obx(
                    () => Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ...controller.experienceList
                            .asMap()
                            .entries
                            .map((entry) {
                          int index = entry.key;
                          Map<String, String> experince = entry.value;

                          return Card(
                            color: Color(0xfff8f8f8),
                            margin: EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 16.0),
                            elevation: 4.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.work_outlined,
                                          color: Color(0xFF212E50), size: 24.0),
                                      SizedBox(width: 8.0),
                                      Expanded(
                                        child: Text(
                                          experince['jobTitle'] ?? "Job Title",
                                          style: TextStyle(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black87,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.delete,
                                            color: Colors.red),
                                        onPressed: () {
                                          setState(() {
                                            controller.experienceList
                                                .removeAt(index);
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 12.0),
                                  Text(
                                    "Company or Organization: ${experince['companyName'] ?? 'N/A'}",
                                    style: TextStyle(
                                        fontSize: 16.0, color: Colors.black87),
                                  ),
                                  SizedBox(height: 4.0),
                                  Text(
                                    "Employment Type: ${experince['employmentType'] ?? 'N/A'}",
                                    style: TextStyle(
                                        fontSize: 16.0, color: Colors.black54),
                                  ),
                                  SizedBox(height: 4.0),
                                  Row(
                                    children: [
                                      Icon(Icons.date_range,
                                          color: Color(0xffCE2029), size: 20.0),
                                      SizedBox(width: 8.0),
                                      Text(
                                        "Start: ${experince['startDate'] ?? 'N/A'}",
                                        style: TextStyle(
                                            fontSize: 14.0,
                                            color: Colors.black54),
                                      ),
                                      SizedBox(width: 16.0),
                                      Icon(Icons.date_range,
                                          color: Color(0xffCE2029), size: 20.0),
                                      SizedBox(width: 8.0),
                                      Text(
                                        "End: ${experince['endDate'] ?? 'N/A'}",
                                        style: TextStyle(
                                            fontSize: 14.0,
                                            color: Colors.black54),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                        SizedBox(height: 10.0),
                        customElevatedButton(
                            onPress: () async {
                              await addExperienceOnPressButton(context);
                            },
                            buttonText: 'Add More',
                            backgroundColor: Color(0xffCE2029)),
                      ],
                    ),
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    controller.experienceList.clear();
                  },
                  child: Text("Cancel"),
                ),
                TextButton(
                  onPressed: () {
                    String combinedExperienceDetails =
                        controller.experienceList.map((experience) {
                      return '${experience['jobTitle'] ?? ''}@${experience['employmentType'] ?? ''}@${experience['companyName'] ?? ''}@${experience['startDate'] ?? ''}@${experience['endDate'] ?? ''}';
                    }).join('#');
                    controller.experienceController.text =
                        combinedExperienceDetails;
                    Navigator.pop(context);
                  },
                  child: Text("Save All"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> addExperienceOnPressButton(context) async {
    TextEditingController jobTitleController = TextEditingController();
    TextEditingController employmentTypeController = TextEditingController();
    TextEditingController companyNameController = TextEditingController();
    TextEditingController startDateController = TextEditingController();
    TextEditingController endDateController = TextEditingController();

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xfff8f8f8),
          title: Center(
            child: customText(
                text: 'Add New Experience',
                context: context,
                size: 32,
                color: Color(0xff212E50),
                fontWeight: FontWeight.w800),
          ),
          content: SingleChildScrollView(
            child: SizedBox(
              width: 500,
              child: Column(
                spacing: 8,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                      padding: EdgeInsets.only(left: 16),
                      child: Row(
                        children: [
                          Text('Job Title'),
                          Text(
                            '*',
                            style: TextStyle(color: Colors.red),
                          ),
                        ],
                      )),
                  customTextField(
                      hintText: "e.g. Software Engineer",
                      controller: jobTitleController),
                  Padding(
                      padding: EdgeInsets.only(left: 16),
                      child: Row(
                        children: [
                          Text('Employment Type'),
                          Text(
                            '*',
                            style: TextStyle(color: Colors.red),
                          ),
                        ],
                      )),
                  customDropdown(
                      items: [
                        'Full-Time',
                        'Part-Time',
                        'Self-Employed',
                        'Freelance',
                        'Internship',
                        'Trainee',
                      ],
                      hintText: 'e.g. Full-Time',
                      controller: employmentTypeController),
                  Padding(
                      padding: EdgeInsets.only(left: 16),
                      child: Row(
                        children: [
                          Text('Company Name'),
                          Text(
                            '*',
                            style: TextStyle(color: Colors.red),
                          ),
                        ],
                      )),
                  customTextField(
                      hintText: "e.g. Hire4Consult",
                      controller: companyNameController),
                  Padding(
                      padding: EdgeInsets.only(left: 16),
                      child: Row(
                        children: [
                          Text('Start Date'),
                          Text(
                            '*',
                            style: TextStyle(color: Colors.red),
                          ),
                        ],
                      )),
                  datePicker(
                      labelText: "Start Date",
                      hintText: 'e.g. 2020-01-01',
                      controller: startDateController,
                      context: context,
                      isDatePicker: true),
                  Padding(
                      padding: EdgeInsets.only(left: 16),
                      child: Row(
                        children: [
                          Text('End Date'),
                          Text(
                            '*',
                            style: TextStyle(color: Colors.red),
                          ),
                        ],
                      )),
                  datePicker(
                      labelText: "End Date",
                      hintText: 'e.g. 2022-05-25',
                      controller: endDateController,
                      context: context,
                      isDatePicker: true),
                  Row(
                    children: [
                      SizedBox(width: 15),
                      Icon(Icons.error_outline, color: Colors.grey),
                      SizedBox(width: 10),
                      Text(
                        'If the end date is the present, select the current date.',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                "Cancel",
                style: TextStyle(color: Color(0xff212E50)),
              ),
            ),
            TextButton(
              onPressed: () {
                if (jobTitleController.text.isEmpty ||
                      employmentTypeController.text.isEmpty ||
                      companyNameController.text.isEmpty ||
                      startDateController.text.isEmpty ||
                      endDateController.text.isEmpty) {
                    customToastBar(
                        title: "Error",
                        description: "Please fill all the required fields.",
                        icon: Icon(Icons.error, color: Colors.yellow));
                    return;
                  } else {
                    controller.experienceList.add({
                      'jobTitle': jobTitleController.text,
                      'employmentType': employmentTypeController.text,
                      'companyName': companyNameController.text,
                      'startDate': startDateController.text,
                      'endDate': endDateController.text,
                    });
                    Navigator.pop(context);
                    jobTitleController.clear();
                    employmentTypeController.clear();
                    companyNameController.clear();
                    startDateController.clear();
                    endDateController.clear();
                  }
                
              },
              child: Text(
                "Save",
                style: TextStyle(color: Color(0xff212E50)),
              ),
            ),
          ],
        );
      },
    );
  }