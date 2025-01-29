import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hire4consult/HelperWidgets/CustomElevatedButton.dart';
import 'package:hire4consult/HelperWidgets/customAppBar.dart';
import 'package:hire4consult/HelperWidgets/customText.dart';
import 'package:hire4consult/HelperWidgets/loadingIndicator.dart';
import 'package:hire4consult/HelperWidgets/toastBar.dart';
import 'package:hire4consult/Screens/AuthScreens/Login/login_screen.dart';
import 'package:hire4consult/Screens/Consultant/ConsultHome/JobDescription/controller/jobDescriptionController.dart';
import 'package:hire4consult/Screens/Consultant/ConsultHome/consult_home_controller/consult_home_controller.dart';

import '../MyProfile/consult_profile.dart';

class Jobdescription extends StatefulWidget {
  const Jobdescription({super.key, this.jobData});
  final dynamic jobData;

  @override
  State<Jobdescription> createState() => _JobdescriptionState();
}

class _JobdescriptionState extends State<Jobdescription> {
  final controller = Get.put(Jobdescriptioncontroller());
  final consultHomeController = Get.put(ConsultHomeController());

  @override
  void initState() {
    super.initState();
    controller.isAppliedForJob.value = widget.jobData['applicants']
        .contains(FirebaseAuth.instance.currentUser!.uid);
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
            Get.off(() => ConsultProfile(),
                transition: Transition.native,
                duration: Duration(milliseconds: 1300));
          },
          onPressForLogout: () async {
            await FirebaseAuth.instance.signOut();
            Get.offAll(() => LoginScreen(),
                transition: Transition.native,
                duration: Duration(milliseconds: 1300));
          }),
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              customText(
                                  text: widget.jobData['position'] ?? '',
                                  context: context,
                                  size: 25,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                              // Row(children: [
                              //   Icon(Icons.share, size: 22, color: Colors.black),
                              //   const SizedBox(width: 12),
                              //   Icon(Icons.bookmark_border,
                              //       size: 22, color: Colors.black),
                              // ])
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(Icons.business,
                                  size: 18, color: Colors.black),
                              const SizedBox(width: 8),
                              Text(widget.jobData['company_name_alias'] ?? ''),
                              const SizedBox(width: 16),
                              Icon(Icons.location_on,
                                  size: 18, color: Colors.black),
                              const SizedBox(width: 8),
                              Text(widget.jobData['regions_interested']),
                            ],
                          ),
                          const SizedBox(height: 25),
                          Row(
                            children: [
                              Obx(
                                () => controller.isAppliedForJob.value
                                    ? customElevatedButton(
                                        onPress: () {
                                          customToastBar(
                                              title: 'Error',
                                              description: 'Already Applied',
                                              icon: Icon(Icons.error,
                                                  color: Colors.yellowAccent));
                                        },
                                        buttonText: 'Applied',
                                        backgroundColor: Color(0xFF212E50),
                                        height: 15)
                                    : controller.isLoadingApplyJob.value
                                        ? loading(80)
                                        : customElevatedButton(
                                            onPress: () async {
                                              if (consultHomeController
                                                      .verifyButtonText.value ==
                                                  "Verified") {
                                                controller.isLoadingApplyJob
                                                    .value = true;
                                                controller.applyForJob(
                                                    widget.jobData);
                                              } else {
                                                customToastBar(
                                                    title: 'Error',
                                                    description:
                                                        'Please verify your account first. If you apply for this, then wait...',
                                                    icon: Icon(Icons.error,
                                                        color: Colors
                                                            .yellowAccent));
                                              }
                                            },
                                            buttonText: 'Apply',
                                            backgroundColor: Color(0xFFCE2029),
                                            height: 15),
                              ),
                              const SizedBox(width: 10),
                              Obx(
                                () => controller.isAppliedForJob.value
                                    ? customElevatedButton(
                                        onPress: () {
                                          controller.withdrawApplication(
                                              widget.jobData);
                                          controller.isAppliedForJob.value =
                                              false;
                                        },
                                        buttonText: 'Withraw Application',
                                        backgroundColor: Color(0xFFce2029),
                                        height: 15)
                                    : Container(),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 13,
                          ),
                          const Divider(thickness: 1),
                          const SizedBox(height: 10),
                          _headingSection(text: 'Job description'),
                          SizedBox(height: 5),
                          Text(widget.jobData['job_description'] ?? ''),
                          const SizedBox(height: 10),
                          const Divider(thickness: 1),
                          const SizedBox(height: 10),
                          _headingSection(text: 'Key skills'),
                          SizedBox(height: 5),
                          Text(widget.jobData['key_skills'] ?? ''),
                          const SizedBox(height: 10),
                          const Divider(thickness: 1),
                          const SizedBox(height: 10),
                          _headingSection(text: 'Position'),
                          SizedBox(height: 5),
                          Text(widget.jobData['position'] ?? ''),
                          const SizedBox(height: 10),
                          const Divider(thickness: 1),
                          const SizedBox(height: 10),
                          _headingSection(text: 'Time zone'),
                          SizedBox(height: 5),
                          Text(widget.jobData['time_zone'] ?? ''),
                          const SizedBox(height: 10),
                          const Divider(thickness: 1),
                          const SizedBox(height: 10),
                          _headingSection(text: 'Department'),
                          SizedBox(height: 5),
                          Text(widget.jobData['department'] ?? ''),
                          const SizedBox(height: 10),
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

  Widget _headingSection({required String text}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          text,
          style: GoogleFonts.poppins(
            textStyle: Theme.of(context).textTheme.displayLarge,
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: Color(0xff212E50),
          ),
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

  Widget _builtTextLine({required String text}) {
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.circle, size: 5, color: Colors.black),
              const SizedBox(width: 8),
              Expanded(child: Text(text)),
            ],
          ),
        ],
      ),
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
