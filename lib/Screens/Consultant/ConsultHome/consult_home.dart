import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hire4consult/HelperWidgets/constant.dart';
import 'package:hire4consult/HelperWidgets/customAppBar.dart';

import 'package:hire4consult/HelperWidgets/customOutlineButton.dart';
import 'package:hire4consult/HelperWidgets/customText.dart';
import 'package:hire4consult/HelperWidgets/loadingIndicator.dart';
import 'package:hire4consult/Screens/AuthScreens/Login/login_screen.dart';
import 'package:hire4consult/Screens/Consultant/ConsultHome/JobDescription/jobDescription.dart';

import 'MyProfile/consult_profile.dart';
import 'consult_home_controller/consult_home_controller.dart';

class ConsultHome extends StatefulWidget {
  const ConsultHome({super.key});

  @override
  State<ConsultHome> createState() => _ConsultHomeState();
}

class _ConsultHomeState extends State<ConsultHome> {
  final controller = Get.put(ConsultHomeController());
  @override
  void dispose() {
    super.dispose();
    Get.find<ConsultHomeController>()
      ..selectedSkills.clear()
      ..selectedDepartments.clear();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey[100],
      appBar: customAppBar(
          context: context,
          onPressForMyProfile: () {
            Get.to(() => ConsultProfile(),
                transition: Transition.native,
                duration: Duration(milliseconds: 1300));
          },
          onPressForLogout: () async {
            await FirebaseAuth.instance.signOut();
            Get.offAll(() => LoginScreen(),
                transition: Transition.native,
                duration: Duration(milliseconds: 1300));
          }),
      body: Stack(
        children: [
          Row(
            children: [
              // Sidebar
              Expanded(
                flex: 4,
                child: Container(
                  margin: const EdgeInsets.only(top: 20, left: 30, right: 20),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: ScrollbarTheme(
                          data: ScrollbarThemeData(
                            thumbColor: WidgetStateProperty.all(
                                Color(0xFFCE2029)), // Change scrollbar color
                            trackColor: WidgetStateProperty.all(
                                Color(0xff212E50)), // Track color
                            radius: Radius.circular(8),
                          ),
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Filter Jobs',
                                      style:
                                          TextStyle(color: Color(0xFF212E50)),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Get.find<ConsultHomeController>()
                                          ..selectedSkills.clear()
                                          ..selectedDepartments.clear()
                                          ..availableSkills.clear();
                                      },
                                      child: const Text(
                                        'Clear filters',
                                        style: TextStyle(
                                            color: Color(0xFF212E50),
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                                _buildFilterSection(
                                  'Departments',
                                  [
                                    SizedBox(
                                      height: height / 2,
                                      child: ListView.builder(
                                        itemCount: listDepartments.length,
                                        itemBuilder: (context, index) {
                                          return _buildCheckboxListTile(
                                              listDepartments[index],
                                              isDepartment: true);
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                const Divider(color: Color(0xff212E50)),
                                _buildFilterSection(
                                  'Skills',
                                  [
                                    Obx(() => controller
                                            .availableSkills.isNotEmpty
                                        ? SizedBox(
                                            height: height / 2,
                                            child: ListView.builder(
                                              itemCount: controller
                                                  .availableSkills.length,
                                              itemBuilder: (context, index) {
                                                return _buildCheckboxListTile(
                                                    controller.availableSkills[
                                                        index]);
                                              },
                                            ),
                                          )
                                        : const Center(
                                            child: Text(
                                                'First select any department'),
                                          )),
                                  ],
                                ),
                                const Divider(
                                  color: Color(0xff212E50),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Job Listings
              Expanded(
                flex: 12,
                child: Container(
                  margin: EdgeInsets.only(top: 5),
                  child: Obx(
                    () => ScrollbarTheme(
                      data: ScrollbarThemeData(
                        thumbColor: WidgetStateProperty.all(
                            Color(0xFFCE2029)), // Change scrollbar color
                        trackColor: WidgetStateProperty.all(
                            Color(0xff212E50)), // Track color
                        radius: Radius.circular(8),
                      ),
                      child: StreamBuilder<QuerySnapshot>(
                        stream: controller.jobsStream,
                        builder: (context, snapshot) {
                          // Add error handling
                          if (snapshot.hasError) {
                            return Center(
                                child: Text('Error: ${snapshot.error}'));
                          }
                          if (!snapshot.hasData ||
                              snapshot.data!.docs.isEmpty) {
                            return Center(
                              child: Text('No jobs found'),
                            );
                          }

                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: loading(100));
                          }

                          return ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              final jobData = snapshot.data!.docs[index].data()
                                  as Map<String, dynamic>;

                              return JobCard(
                                jobData: jobData,
                                title: jobData['position'] ?? '',
                                company: jobData['company_name_alias'] ?? '',
                                location: jobData['regions_interested'] ?? '',
                                qualifications:
                                    jobData['job_description'] ?? '',
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Obx(
            () => (controller.showPopup.value)
                ? Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        color: controller.verifyButtonText.value == "Verifying"
                            ? Color.fromARGB(255, 247, 249, 225)
                            : Color.fromARGB(255, 250, 222, 222),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(16),
                          bottomRight: Radius.circular(16),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha((0.1 * 255).toInt()),
                            offset: Offset(0, 2),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                      padding: EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 16.0),
                      child: Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          controller.verifyButtonText.value == "Verifying"
                              ? Icon(Icons.schedule, color: Colors.black87)
                              : Icon(
                                  Icons.cancel,
                                  color: Colors.redAccent,
                                ),
                          SizedBox(width: 10),
                          Text(
                            controller.verifyButtonText.value == "Verifying"
                                ? "Your profile is currently under verification. We will verify it shortly."
                                : "Your profile verification has failed. Please update your profile details.",
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          // ElevatedButton(
                          //   onPressed:
                          //       controller.verifyButtonText.value == "Verify"
                          //           ? controller.updateProfileVerification
                          //           : null, // Disable button while verifying
                          //   style: ElevatedButton.styleFrom(
                          //     backgroundColor: Colors.white,
                          //     foregroundColor: Colors.black,
                          //     shape: RoundedRectangleBorder(
                          //       borderRadius: BorderRadius.circular(8.0),
                          //     ),
                          //     padding: EdgeInsets.symmetric(
                          //         vertical: 8.0, horizontal: 16.0),
                          //   ),
                          //   child: Text(
                          //     controller.verifyButtonText.value,
                          //     style: TextStyle(
                          //       fontSize: 14,
                          //       fontWeight: FontWeight.bold,
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  )
                : Container(),
          )
        ],
      ),
    );
  }

  Widget _buildCheckboxListTile(String value, {bool isDepartment = false}) {
    final controller = Get.find<ConsultHomeController>();
    return Obx(() {
      final Set<String> selectedSet = isDepartment
          ? controller.selectedDepartments
          : controller.selectedSkills;

      return ListTile(
        leading: Checkbox(
          checkColor: const Color(0xFFCE2029),
          activeColor: Colors.transparent,
          value: selectedSet.contains(value),
          onChanged: (bool? checked) {
            if (checked == true) {
              selectedSet.add(value);
              if (isDepartment) controller.updateSkills();
            } else {
              selectedSet.remove(value);
              if (isDepartment) controller.updateSkills();
            }
          },
        ),
        title: Text(
          value,
          overflow: TextOverflow.ellipsis,
        ),
        onTap: () {
          final currentValue = selectedSet.contains(value);
          if (currentValue) {
            selectedSet.remove(value);
          } else {
            selectedSet.add(value);
          }
          if (isDepartment) controller.updateSkills();
        },
      );
    });
  }

  Widget _buildFilterSection(String title, List<Widget> children) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF212E50),
          ),
        ),
        children: children,
      ),
    );
  }
}

class JobCard extends StatelessWidget {
  final dynamic jobData;
  final String title;
  final String company;
  final String location;
  final String qualifications;

  const JobCard({
    Key? key,
    required this.title,
    required this.company,
    required this.location,
    required this.qualifications,
    this.jobData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 0,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 26),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                customText(
                    text: title,
                    context: context,
                    size: 25,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
                // Row(children: [
                //   Icon(Icons.share, size: 22, color: Colors.black),
                //   const SizedBox(width: 12),
                //   Icon(Icons.bookmark_border, size: 22, color: Colors.black),
                // ])
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.business, size: 18, color: Colors.black),
                const SizedBox(width: 8),
                Text(company),
                const SizedBox(width: 16),
                Icon(Icons.location_on, size: 18, color: Colors.black),
                const SizedBox(width: 8),
                Text(location),
              ],
            ),
            const SizedBox(height: 25),
            const Divider(),
            Text(
              'Job description',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            RichText(
              text: TextSpan(
                text: qualifications,
                style: TextStyle(fontSize: 14, color: Colors.black),
                children: [
                  TextSpan(
                    text: '...',
                    style: TextStyle(fontSize: 14, color: Colors.black),
                  ),
                ],
              ),
              // maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 25),
            customOutlineButton(
                onPress: () {
                  Get.to(() => Jobdescription(jobData: jobData),
                      transition: Transition.native,
                      duration: Duration(milliseconds: 1300));
                },
                buttonText: 'Learn More')
          ],
        ),
      ),
    );
  }
}
