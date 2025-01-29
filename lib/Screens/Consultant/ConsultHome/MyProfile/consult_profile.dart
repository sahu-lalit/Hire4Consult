import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hire4consult/HelperWidgets/customAppBar.dart';
import 'package:hire4consult/HelperWidgets/customText.dart';
import 'package:hire4consult/HelperWidgets/editProfileTextField.dart';
import 'package:hire4consult/HelperWidgets/loadingIndicator.dart';
import 'package:hire4consult/HelperWidgets/toastBar.dart';
import 'package:hire4consult/Screens/AuthScreens/Login/login_screen.dart';
import 'package:hire4consult/Screens/Consultant/ConsultHome/MyProfile/controller/my_profile_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hire4consult/Screens/Consultant/ConsultHome/consult_home.dart';
import 'widgets/educationDetail.dart';
import 'widgets/certificationDetails.dart';
import 'widgets/experienceDetail.dart';
import 'package:universal_html/html.dart' as html;

class ConsultProfile extends StatefulWidget {
  const ConsultProfile({super.key});

  @override
  State<ConsultProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<ConsultProfile> {
  final controller = Get.put(MyProfileController());

  @override
  void initState() {
    super.initState();
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
            Get.offAll(() => ConsultProfile(),
                transition: Transition.native,
                duration: Duration(milliseconds: 1300));
          },
          onPressForLogout: () async {
            await FirebaseAuth.instance.signOut();
            Get.offAll(() => LoginScreen(),
                transition: Transition.native,
                duration: Duration(milliseconds: 1300));
          }),
      body: Obx(
        () => controller.userDataLoading.value == false
            ? Center(
                child: loading(200),
              )
            : Row(
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
                          child: ScrollbarTheme(
                            data: ScrollbarThemeData(
                              thumbColor: WidgetStateProperty.all(
                                  Color(0xFFCE2029)), // Change scrollbar color
                              trackColor: WidgetStateProperty.all(
                                  Color(0xff212E50)), // Track color
                              radius: Radius.circular(8),
                            ),
                            child: SingleChildScrollView(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              child: Container(
                                margin: const EdgeInsets.only(
                                    top: 20, left: 30, right: 20),
                                padding: const EdgeInsets.all(25),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Center(
                                      child: Obx(
                                        () => Row(
                                          children: [
                                            CircleAvatar(
                                              radius: 70,
                                              backgroundImage: controller
                                                          .imageUrl.value !=
                                                      ''
                                                  ? NetworkImage(
                                                      controller.imageUrl.value)
                                                  : AssetImage(
                                                      'assets/images/default_user.png'),
                                            ),
                                            const SizedBox(width: 30),
                                            Column(
                                              spacing: 5,
                                              children: [
                                                controller.isImagUploading.value
                                                    ? loading(70)
                                                    : ElevatedButton(
                                                        onPressed: () {
                                                          controller
                                                              .pickAndUploadProfilePicture();
                                                        },
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                                backgroundColor:
                                                                    Color(
                                                                        0xff212E50),
                                                                shape:
                                                                    RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              20),
                                                                ),
                                                                padding:
                                                                    const EdgeInsets
                                                                        .symmetric(
                                                                  horizontal:
                                                                      35,
                                                                  vertical: 15,
                                                                )),
                                                        child: Text(
                                                            'Update Profile Picture',
                                                            style: GoogleFonts
                                                                .poppins(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color:
                                                                  Colors.white,
                                                            )),
                                                      ),
                                                controller.isImageRemoving.value
                                                    ? loading(70)
                                                    : TextButton(
                                                        onPressed: () {
                                                          controller
                                                              .isImageRemoving
                                                              .value = true;
                                                          controller
                                                              .removeProfilePicture();
                                                        },
                                                        child: Text(
                                                          'Remove',
                                                          style: GoogleFonts
                                                              .poppins(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: Color(
                                                                0xff212E50),
                                                          ),
                                                        ),
                                                      ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 13,
                                    ),
                                    const Divider(thickness: 1),
                                    const SizedBox(height: 10),
                                    Obx(
                                      () => controller.isEditing.value
                                          ? Row(
                                              children: [
                                                Spacer(),
                                                controller.isLoadingSave.value
                                                    ? loading(70)
                                                    : MouseRegion(
                                                        cursor:
                                                            SystemMouseCursors
                                                                .click,
                                                        child: GestureDetector(
                                                          onTap: () async {
                                                            await onTapButtonForUpdateDetail();
                                                            controller.isEditing
                                                                .value = false;
                                                          },
                                                          child: Row(
                                                            children: [
                                                              Icon(Icons.save,
                                                                  color: Colors
                                                                      .black),
                                                              SizedBox(
                                                                  width: 8),
                                                              customText(
                                                                text: 'Save',
                                                                context:
                                                                    context,
                                                                size: 16,
                                                                color: Color(
                                                                    0xff212E50),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w800,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                SizedBox(
                                                  width: 25,
                                                )
                                              ],
                                            )
                                          : Row(
                                              children: [
                                                Spacer(),
                                                MouseRegion(
                                                  cursor:
                                                      SystemMouseCursors.click,
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      controller.isEditing
                                                          .value = true;
                                                    },
                                                    child: Row(
                                                      children: [
                                                        Icon(Icons.edit,
                                                            color:
                                                                Colors.black),
                                                        SizedBox(width: 8),
                                                        customText(
                                                          text: 'Edit profile',
                                                          context: context,
                                                          size: 16,
                                                          color:
                                                              Color(0xff212E50),
                                                          fontWeight:
                                                              FontWeight.w800,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 25,
                                                )
                                              ],
                                            ),
                                    ),
                                    _headingSection(text: 'User details'),
                                    SizedBox(height: 10),
                                    _buildDetailsSection(
                                        'Name',
                                        controller.userData?['fullName'],
                                        controller.fullNameController),
                                    _buildDetailsSection(
                                        'Username',
                                        controller.userData?['userName'],
                                        controller.userNameController),
                                    _buildDetailsSection(
                                        'Phone number',
                                        controller.userData?['phoneNumber'],
                                        controller.phoneNumberController),

                                    // const Divider(thickness: 1),
                                    divider(),
                                    const SizedBox(height: 10),
                                    _headingSection(text: 'Education details'),
                                    SizedBox(height: 10),

                                    userEducationDetails(
                                        controller.userData?['addEducation']),

                                    divider(),
                                    const SizedBox(height: 10),
                                    _headingSection(text: 'Certifications'),
                                    SizedBox(height: 10),
                                    certificationDetails(controller
                                        .userData?['addCertification']),

                                    divider(),
                                    const SizedBox(height: 10),
                                    _headingSection(text: 'Experience'),
                                    const SizedBox(height: 10),
                                    experienceDetail(
                                        controller.userData?['experience']),

                                    divider(),
                                    const SizedBox(height: 10),
                                    _headingSection(text: 'Job preferences'),
                                    const SizedBox(height: 10),
                                    _buildDetailsSection(
                                        'Department',
                                        controller.userData?['department'],
                                        controller.departmentController),
                                    _buildDetailsSection(
                                        'Job title looking for',
                                        controller
                                            .userData?['jobTitleLookingFor'],
                                        controller
                                            .jobTitleLookingForController),
                                    _buildDetailsSection(
                                        'Pay role per month',
                                        '₹${controller.userData?['addPayRolePerMonth'] ?? 'Not Provided'}',
                                        controller
                                            .addPayRolePerMonthController),

                                    divider(),
                                    const SizedBox(height: 10),
                                    _headingSection(text: 'Skills'),
                                    const SizedBox(height: 10),
                                    _buildDetailsSection(
                                        'Skills',
                                        controller.userData?['skills'],
                                        controller.skillsController),

                                    divider(),
                                    const SizedBox(height: 10),
                                    _headingSection(text: 'Availability'),
                                    const SizedBox(height: 10),
                                    _buildDetailsSection(
                                        'Time slot availability',
                                        controller.userData?[
                                                'timeSlotAvailability'] +
                                            " hours",
                                        controller
                                            .timeSlotAvailabilityController),
                                    _buildDetailsSection(
                                        'Regions interested',
                                        controller
                                            .userData?['regionsInterested'],
                                        controller.regionsInterestedController),

                                    divider(),
                                    const SizedBox(height: 10),
                                    _headingSection(text: 'Tools'),
                                    const SizedBox(height: 10),
                                    _buildDetailsSection(
                                        'Platform name',
                                        controller.userData?[
                                            'selectedSocialMediaPlatform'],
                                        controller
                                            .addSocialMediaPlatformController),
                                    _buildDetailsSection(
                                        'Platform link',
                                        controller.userData?['addSocialMedia'],
                                        controller
                                            .addSocialMediaLinkController),

                                    SizedBox(height: 10),
                                    divider(),
                                    const SizedBox(height: 10),
                                    _headingSection(text: 'Resume/CV'),
                                    const SizedBox(height: 5),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                                                    final resumeLink =
                                                        controller.userData?[
                                                            'addResume'];
                                                    if (resumeLink != null &&
                                                        resumeLink.isNotEmpty) {
                                                      html.window.open(
                                                          resumeLink, '_blank');
                                                    } else {
                                                      customToastBar(
                                                          title: "Error",
                                                          description:
                                                              "No Resume Link Found");
                                                    }
                                                  },
                                                  icon: const Icon(
                                                      Icons.visibility,
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
                        ),
                      ],
                    ),
                  ),
                ],
              ),
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

  Widget _buildDetailsSection(
      String title, String value, TextEditingController? editingController) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Obx(
        () => Row(
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
              child: controller.isEditing.value
                  ? Row(
                      children: [
                        SizedBox(
                            width: 300,
                            height: 40,
                            child: editProfileTextField(
                                hintText: title,
                                controller: editingController)),
                      ],
                    )
                  : Text(value),
            ),
          ],
        ),
      ),
    );
  }

  String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }
    if (value.length != 10) {
      return 'Phone number must be exactly 10 digits';
    }
    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return 'Phone number must contain only digits';
    }
    return null;
  }

  String? validateUrl(String? value) {
    if (value == null || value.isEmpty) {
      return 'URL is required';
    }

    final urlPattern =
        r'^(https?:\/\/)?([a-zA-Z0-9]+[.])+[a-zA-Z]{2,}(:[0-9]{1,5})?(\/.*)?$';
    final regex = RegExp(urlPattern);

    if (!regex.hasMatch(value)) {
      return 'Please enter a valid URL';
    }

    return null;
  }

  Future<void> onTapButtonForUpdateDetail() async {
    controller.isLoadingSave.value = true;
    if (controller.fullNameController.text.isEmpty ||
        controller.phoneNumberController.text.isEmpty ||
        controller.userNameController.text.isEmpty) {
      customToastBar(
          title: "Error",
          description: "Please fill all the required fields.",
          icon: Icon(Icons.error, color: Colors.yellow));
      controller.isLoadingSave.value = false;
      return;
    }
    final phoneValidationError =
        validatePhoneNumber(controller.phoneNumberController.text);
    if (phoneValidationError != null) {
      customToastBar(
          title: "Error",
          description: phoneValidationError,
          icon: Icon(Icons.error, color: Colors.redAccent));
      controller.isLoadingSave.value = false;
      return;
    }
    if (controller.addCertificationController.text.isEmpty ||
        controller.addEducationController.text.isEmpty) {
      customToastBar(
          title: "Error",
          description: "Please fill all the required fields.",
          icon: Icon(Icons.error, color: Colors.yellow));
      controller.isLoadingSave.value = false;
      return;
    }
    if (controller.addPayRolePerMonthController.text.isEmpty ||
        controller.departmentController.text.isEmpty ||
        controller.jobTitleLookingForController.text.isEmpty) {
      customToastBar(
          title: "Error",
          description: "Please fill all the required fields.",
          icon: Icon(Icons.error, color: Colors.yellow));
      controller.isLoadingSave.value = false;
      return;
    }
    if (controller.skillsController.text.isEmpty ||
        controller.timeSlotAvailabilityController.text.isEmpty ||
        controller.regionsInterestedController.text.isEmpty) {
      customToastBar(
          title: "Error",
          description: "Please fill all the required fields.",
          icon: Icon(Icons.error, color: Colors.yellow));
      controller.isLoadingSave.value = false;
      return;
    }
    if (controller.addSocialMediaPlatformController.text.isEmpty ||
        controller.addSocialMediaLinkController.text.isEmpty) {
      customToastBar(
          title: "Error",
          description: "Please fill all the required fields.",
          icon: Icon(Icons.error, color: Colors.yellow));

      controller.isLoadingSave.value = false;
    }
    // else if (controller.resumeLink.isEmpty) {
    //   customToastBar(
    //       title: "Error",
    //       description: "Please upload your resume.",
    //       icon: Icon(Icons.error, color: Colors.yellow));
    //   controller.submitButtonLoading.value = false;
    // }
    final phoneLinkError =
        validateUrl(controller.addSocialMediaLinkController.text);
    if (phoneLinkError != null) {
      customToastBar(
          title: "Error",
          description: phoneLinkError,
          icon: Icon(Icons.error, color: Colors.redAccent));
      controller.isLoadingSave.value = false;
      return;
    }

    await controller.saveProfile();
  }
}
