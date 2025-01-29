import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
                                      'jobs matched',
                                      style:
                                          TextStyle(color: Color(0xFF212E50)),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Get.find<ConsultHomeController>()
                                          ..selectedSkills.clear()
                                          ..selectedDepartments.clear();
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
                                    _buildCheckboxListTile(
                                        'Software Development'),
                                    _buildCheckboxListTile('HR'),
                                    _buildCheckboxListTile(
                                        'Business Development'),
                                    _buildCheckboxListTile('Marketing'),
                                    _buildCheckboxListTile('Sales'),
                                    _buildCheckboxListTile('Customer Support'),
                                    _buildCheckboxListTile('Finance'),
                                    _buildCheckboxListTile(
                                        'Product Management'),
                                    _buildCheckboxListTile('UI/UX Design'),
                                    _buildCheckboxListTile(
                                        'Quality Assurance (QA) & Testing'),
                                    _buildCheckboxListTile(
                                        'IT Support & Infrastructure'),
                                    _buildCheckboxListTile('Cybersecurity'),
                                    _buildCheckboxListTile(
                                        'Data Science & Analytics'),
                                    _buildCheckboxListTile('Cloud Computing'),
                                    _buildCheckboxListTile(
                                        'Operations & Administration'),
                                    _buildCheckboxListTile(
                                        'Legal & Compliance'),
                                    _buildCheckboxListTile(
                                        'Procurement & Supply Chain'),
                                    _buildCheckboxListTile(
                                        'Research & Development (R&D)'),
                                    _buildCheckboxListTile(
                                        'Production & Manufacturing'),
                                    _buildCheckboxListTile('Quality Control'),
                                    _buildCheckboxListTile(
                                        'Maintenance & Engineering'),
                                    _buildCheckboxListTile(
                                        'Logistics & Warehouse'),
                                  ],
                                ),
                                const Divider(
                                  color: Color(0xff212E50),
                                ),
                                _buildFilterSection(
                                  'Skills',
                                  [
                                    _buildCheckboxListTile('React.js'),
                                    _buildCheckboxListTile('React Native'),
                                    _buildCheckboxListTile('Flutter'),
                                    _buildCheckboxListTile('Excel'),
                                    _buildCheckboxListTile('UI/UX'),
                                    _buildCheckboxListTile('JavaScript'),
                                    _buildCheckboxListTile('TypeScript'),
                                    _buildCheckboxListTile('Redux'),
                                    _buildCheckboxListTile('Context API'),
                                    _buildCheckboxListTile('Hooks'),
                                    _buildCheckboxListTile('RESTful APIs'),
                                    _buildCheckboxListTile('GraphQL'),
                                    _buildCheckboxListTile('Firebase'),
                                    _buildCheckboxListTile('Supabase'),
                                    _buildCheckboxListTile('CI/CD'),
                                    _buildCheckboxListTile('Jest'),
                                    _buildCheckboxListTile('Mocha'),
                                    _buildCheckboxListTile('Flutter Test'),
                                    _buildCheckboxListTile('Figma'),
                                    _buildCheckboxListTile('Adobe XD'),
                                    _buildCheckboxListTile('Sketch'),
                                    _buildCheckboxListTile('Wireframing'),
                                    _buildCheckboxListTile('Prototyping'),
                                    _buildCheckboxListTile('Material Design'),
                                    _buildCheckboxListTile(
                                        'Cupertino Guidelines'),
                                    _buildCheckboxListTile('Accessibility'),
                                    _buildCheckboxListTile('Usability Testing'),
                                    _buildCheckboxListTile('Design Thinking'),
                                    _buildCheckboxListTile('Pivot Tables'),
                                    _buildCheckboxListTile('VBA'),
                                    _buildCheckboxListTile('CRM Tools'),
                                    _buildCheckboxListTile('Salesforce'),
                                    _buildCheckboxListTile('HubSpot'),
                                    _buildCheckboxListTile(
                                        'Data Visualization'),
                                    _buildCheckboxListTile('Power BI'),
                                    _buildCheckboxListTile('Tableau'),
                                    _buildCheckboxListTile('Lead Generation'),
                                    _buildCheckboxListTile('Market Research'),
                                    _buildCheckboxListTile('SEO'),
                                    _buildCheckboxListTile('SEM'),
                                    _buildCheckboxListTile('Google Analytics'),
                                    _buildCheckboxListTile(
                                        'Social Media Marketing'),
                                    _buildCheckboxListTile('Email Marketing'),
                                    _buildCheckboxListTile('Content Strategy'),
                                    _buildCheckboxListTile('Copywriting'),
                                    _buildCheckboxListTile(
                                        'Customer Data Management'),
                                    _buildCheckboxListTile(
                                        'CRM & Ticketing Systems'),
                                    _buildCheckboxListTile('Zendesk'),
                                    _buildCheckboxListTile('Freshdesk'),
                                    _buildCheckboxListTile('Troubleshooting'),
                                    _buildCheckboxListTile(
                                        'Financial Modeling'),
                                    _buildCheckboxListTile('Budgeting'),
                                    _buildCheckboxListTile(
                                        'Accounting Software'),
                                    _buildCheckboxListTile('QuickBooks'),
                                    _buildCheckboxListTile('SAP'),
                                    _buildCheckboxListTile('Data Analysis'),
                                    _buildCheckboxListTile('Forecasting'),
                                    _buildCheckboxListTile('Agile'),
                                    _buildCheckboxListTile('Scrum'),
                                    _buildCheckboxListTile('A/B Testing'),
                                    _buildCheckboxListTile('Jira'),
                                    _buildCheckboxListTile('Trello'),
                                  ],
                                ),
                                const Divider(
                                  color: Color(0xff212E50),
                                ),
                                // _buildFilterSection(
                                //   'Time Zones',
                                //   [
                                //     _buildCheckboxListTile(
                                //         'Pacific Time (PT) UTC -8 / UTC -7'),
                                //     _buildCheckboxListTile(
                                //         'Mountain Time (MT) UTC -7 / UTC -6'),
                                //     _buildCheckboxListTile(
                                //         'Central Time (CT) UTC -6 / UTC -5'),
                                //     _buildCheckboxListTile(
                                //         'Eastern Time (ET) UTC -5 / UTC -4'),
                                //     _buildCheckboxListTile(
                                //         'Brasilia Time (BRT) UTC -3'),
                                //     _buildCheckboxListTile(
                                //         'Argentina Time (ART) UTC -3'),
                                //     _buildCheckboxListTile(
                                //         'Colombia Time (COT) UTC -5'),
                                //     _buildCheckboxListTile(
                                //         'Greenwich Mean Time (GMT) UTC 0'),
                                //     _buildCheckboxListTile(
                                //         'Central European Time (CET) UTC +1 / UTC +2'),
                                //     _buildCheckboxListTile(
                                //         'Eastern European Time (EET) UTC +2 / UTC +3'),
                                //     _buildCheckboxListTile(
                                //         'West Africa Time (WAT) UTC +1'),
                                //     _buildCheckboxListTile(
                                //         'Central Africa Time (CAT) UTC +2'),
                                //     _buildCheckboxListTile(
                                //         'East Africa Time (EAT) UTC +3'),
                                //     _buildCheckboxListTile(
                                //         'India Standard Time (IST) UTC +5:30'),
                                //     _buildCheckboxListTile(
                                //         'China Standard Time (CST) UTC +8'),
                                //     _buildCheckboxListTile(
                                //         'Japan Standard Time (JST) UTC +9'),
                                //     _buildCheckboxListTile(
                                //         'Singapore Time (SGT) UTC +8'),
                                //     _buildCheckboxListTile(
                                //         'Gulf Standard Time (GST) UTC +4'),
                                //     _buildCheckboxListTile(
                                //         'Arabian Standard Time (AST) UTC +3'),
                                //     _buildCheckboxListTile(
                                //         'Australian Western Standard Time (AWST) UTC +8'),
                                //     _buildCheckboxListTile(
                                //         'Australian Eastern Standard Time (AEST) UTC +10 / UTC +11'),
                                //     _buildCheckboxListTile(
                                //         'New Zealand Standard Time (NZST) UTC +12 / UTC +13'),
                                //   ],
                                // ),
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

                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: loading(100));
                          }

                          if (!snapshot.hasData ||
                              snapshot.data!.docs.isEmpty) {
                            return Center(
                              child: Text('No jobs found'),
                            );
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
                            ? Color(0xfff8f8f8)
                            : Color(0xffe1e1e1),
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            controller.verifyButtonText.value == "Verifying"
                                ? "We'll shortly verify your profile."
                                : "Please verify your profile.",
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          ElevatedButton(
                            onPressed:
                                controller.verifyButtonText.value == "Verify"
                                    ? controller.updateProfileVerification
                                    : null, // Disable button while verifying
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              padding: EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 16.0),
                            ),
                            child: Text(
                              controller.verifyButtonText.value,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
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

  Widget _buildCheckboxListTile(String value, {bool isCompany = false}) {
    return Obx(() {
      final controller = Get.find<ConsultHomeController>();
      final Set<String> selectedSet = isCompany
          ? controller.selectedDepartments
          : controller.selectedSkills;

      return ListTile(
        leading: Checkbox(
          checkColor: Color(0xFFCE2029),
          activeColor: Colors.transparent,
          value: selectedSet.contains(value),
          onChanged: (bool? checked) {
            if (checked == true) {
              selectedSet.add(value);
            } else {
              selectedSet.remove(value);
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
        },
      );
    });
  }

  Widget _buildFilterSection(String title, children) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        title: Text(
          title,
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF212E50)),
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
