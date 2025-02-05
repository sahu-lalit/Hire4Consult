import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hire4consult/HelperWidgets/customAppBar.dart';
import 'package:hire4consult/HelperWidgets/customText.dart';
import 'package:hire4consult/HelperWidgets/loadingIndicator.dart';
import 'package:hire4consult/HelperWidgets/toastBar.dart';
import 'package:hire4consult/Screens/AuthScreens/Login/login_screen.dart';
import 'package:hire4consult/Screens/Employer/EmployerHome/EmployerProfile/employer_profile.dart';

import 'view_applicants_details_controller/view_applicants_details_controller.dart';
import 'employer_widgets/certificationDetails.dart';
import 'employer_widgets/educationDetail.dart';
import 'employer_widgets/experienceDetail.dart';
import 'package:universal_html/html.dart' as html;

class ViewApplicantsDetail extends StatefulWidget {
  final dynamic applicantData;
  const ViewApplicantsDetail({super.key, this.applicantData});

  @override
  State<ViewApplicantsDetail> createState() => _ViewApplicantsDetailState();
}

class _ViewApplicantsDetailState extends State<ViewApplicantsDetail> {
  final controller = Get.put(ViewApplicantsDetailsController());
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
          Get.off(() => EmployerProfile(), transition: Transition.native,  duration: Duration(milliseconds: 1300));
        },
        onPressForLogout: () async{
          await FirebaseAuth.instance.signOut();
          Get.offAll(() => LoginScreen(), transition: Transition.native, duration: Duration(milliseconds: 1300));
        },
      ),
      body: Row(
        children: [
          Expanded(
              flex: 1,
              child: Obx(
                () => _goBackButton(),
              )),
          Expanded(
            flex: 5,
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Container(
                      margin:
                          const EdgeInsets.only(top: 20, left: 30, right: 20),
                      padding: const EdgeInsets.all(25),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 70,
                                  backgroundImage: widget.applicantData?['userProfileLink'] != null
                                      ? NetworkImage(widget.applicantData?['userProfileLink'])
                                      : AssetImage(
                                          'assets/images/default_user.png'),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 13,
                          ),
                          const Divider(thickness: 1),
                          const SizedBox(height: 10),

                          _headingSection(text: 'User details'),
                          SizedBox(height: 10),
                          _buildDetailsSection(
                              'Name', widget.applicantData?['fullName']),
                          _buildDetailsSection(
                              'Username', widget.applicantData?['userName']),
                          _buildDetailsSection('Phone number',
                              widget.applicantData?['phoneNumber']),

                          // _buildDetailsSection('Department', widget.applicantData?['department']),

                          // _buildDetailsSection('Pay role per month',
                          //     '₹${widget.applicantData?['addPayRolePerMonth'] ?? 'Not Provided'}'),

                          // const Divider(thickness: 1),
                          divider(),
                          const SizedBox(height: 10),
                          _headingSection(text: 'Education details'),
                          SizedBox(height: 10),

                          userEducationDetails(
                              widget.applicantData?['addEducation']),

                          divider(),
                          const SizedBox(height: 10),
                          _headingSection(text: 'Certifications'),
                          SizedBox(height: 10),
                          certificationDetails(
                              widget.applicantData?['addCertification']),

                          divider(),
                          const SizedBox(height: 10),
                          _headingSection(text: 'Experience'),
                          const SizedBox(height: 10),
                          experienceDetail(widget.applicantData?['experience']),

                          divider(),
                          const SizedBox(height: 10),
                          _headingSection(text: 'Job preferences'),
                          const SizedBox(height: 10),
                          _buildDetailsSection('Department',
                              widget.applicantData?['department']),
                          _buildDetailsSection('Job title looking for',
                              widget.applicantData?['jobTitleLookingFor']),
                          // _buildDetailsSection('Pay role per month',
                          //     '₹${widget.applicantData?['addPayRolePerMonth'] ?? 'Not Provided'}'),

                          divider(),
                          const SizedBox(height: 10),
                          _headingSection(text: 'Skills'),
                          const SizedBox(height: 10),
                          _buildDetailsSection(
                              'Skills', widget.applicantData?['skills']),

                          divider(),
                          const SizedBox(height: 10),
                          _headingSection(text: 'Availability'),
                          const SizedBox(height: 10),
                          _buildDetailsSection(
                              'Time slot availability',
                              widget.applicantData?['timeSlotAvailability'] +
                                  " hours"),
                          _buildDetailsSection('Regions interested',
                              widget.applicantData?['regionsInterested']),

                          divider(),
                          const SizedBox(height: 10),
                          _headingSection(text: 'Tools'),
                          const SizedBox(height: 10),
                          _buildDetailsSection(
                              'Platform name',
                              widget.applicantData?[
                                  'selectedSocialMediaPlatform']),
                          _buildDetailsSection('Platform link',
                              widget.applicantData?['addSocialMedia']),

                          SizedBox(height: 10),
                          divider(),
                          const SizedBox(height: 10),
                          _headingSection(text: 'Resume/CV'),
                          const SizedBox(height: 5),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    'Open Resume',
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Row(
                                    children: [
                                      TextButton.icon(
                                        onPressed: () {
                                          final resumeLink = widget
                                              .applicantData?['addResume'];
                                          if (resumeLink != null &&
                                              resumeLink.isNotEmpty) {
                                            html.window
                                                .open(resumeLink, '_blank');
                                          } else {
                                            customToastBar(
                                                title: "Error",
                                                description:
                                                    "No Resume Link Found");
                                          }
                                        },
                                        icon: const Icon(Icons.visibility,
                                            size: 16),
                                        label: const Text('View'),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget divider() {
    return Divider(
      // color: Colors.grey,
      thickness: 1,
    );
  }

  Widget _headingSection({required String text}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          text,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _goBackButton() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(left: 40, top: 40),
          child: MaterialButton(
            onPressed: () {
              Navigator.pop(context);
            },
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
            hoverElevation: 0,
            color: controller.isHovered.value
                ? Color(0xff212E50)
                : Colors.white, // Hover background color
            textColor: controller.isHovered.value
                ? Colors.white
                : Color(0xff212E50), // Hover text color
            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 40),
            child: MouseRegion(
              onEnter: (_) {
                controller.isHovered.value = true;
              },
              onExit: (_) {
                controller.isHovered.value = false;
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 7.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.arrow_back_ios,
                      weight: 50,
                      size: 18,
                      color: controller.isHovered.value
                          ? Colors.white
                          : Color(0xff212E50), // Change arrow color on hover
                    ),
                    SizedBox(
                        width: 8), // Add some spacing between the icon and text
                    Text(
                      "Go Back",
                      style: GoogleFonts.quicksand(
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1,
                        color: controller.isHovered.value
                            ? Colors.white
                            : Color(0xff212E50), // Change text color on hover
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailsSection(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: Text(
              title,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(value),
          ),
        ],
      ),
    );
  }
}
