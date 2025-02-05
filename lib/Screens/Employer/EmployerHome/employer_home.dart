import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hire4consult/HelperWidgets/CustomElevatedButton.dart';
import 'package:hire4consult/HelperWidgets/customAppBar.dart';
import 'package:hire4consult/HelperWidgets/customOutlineButton.dart';
import 'package:hire4consult/HelperWidgets/loadingIndicator.dart';
import 'package:hire4consult/HelperWidgets/toastBar.dart';
import 'package:hire4consult/Screens/AuthScreens/Login/login_screen.dart';

import '../../../HelperWidgets/customText.dart';
import 'ApplicantsDetail/applicants_detail.dart';
import 'CreateNewListing/createNewListing.dart';
import 'EmployerProfile/employer_profile.dart';
import 'employerHomeController/employer_home_controller.dart';

class EmployerHome extends StatefulWidget {
  const EmployerHome({super.key});

  @override
  State<EmployerHome> createState() => _EmployerHomeState();
}

class _EmployerHomeState extends State<EmployerHome> {
  final controller = Get.put(EmployerHomeController());
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
          Get.to(() => EmployerProfile(),
              transition: Transition.native,
              duration: Duration(milliseconds: 1300));
        },
        onPressForLogout: () async {
          await FirebaseAuth.instance.signOut();
          Get.offAll(() => LoginScreen(),
              transition: Transition.native,
              duration: Duration(milliseconds: 1300));
        },
      ),
      body: Stack(
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: width / 6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 15),
                Expanded(
                  child: ScrollbarTheme(
                    data: ScrollbarThemeData(
                      thumbColor: WidgetStateProperty.all(
                          Color(0xFFCE2029)), // Change scrollbar color
                      trackColor: WidgetStateProperty.all(
                          Color(0xff212E50)), // Track color
                      radius: Radius.circular(8),
                    ),
                    child: ListView(
                      children: [
                        // My Listings header and button
                        Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'My Listings',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Color(0xFF212E50),
                                ),
                              ),
                              customElevatedButton(
                                onPress: () {
                                  Get.to(() => Createnewlisting(),
                                      transition: Transition.native,
                                      duration: Duration(milliseconds: 1300));
                                },
                                buttonText: '+ Create new listing',
                                backgroundColor: const Color(0xFFCE2029),
                                height: 15,
                              ),
                            ],
                          ),
                        ),
                        // Job Listings
                        Container(
                          margin: EdgeInsets.only(top: 2),
                          child: StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('jobs_information')
                                .where('jobCreatorID',
                                    isEqualTo:
                                        FirebaseAuth.instance.currentUser!.uid)
                                .snapshots(),
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
                                  child: Text(
                                      'You have not created any jobs yet!'),
                                );
                              }

                              return ListView.builder(
                                shrinkWrap: true,
                                padding: const EdgeInsets.all(16),
                                itemCount: snapshot.data!.docs.length,
                                itemBuilder: (context, index) {
                                  final jobData = snapshot.data!.docs[index]
                                      .data() as Map<String, dynamic>;
                                  final docRef =
                                      snapshot.data!.docs[index].reference;

                                  return JobCard(
                                    docReference: docRef,
                                    jobData: jobData,
                                    title: jobData['position'] ?? '',
                                    company:
                                        jobData['company_name_alias'] ?? '',
                                    location:
                                        jobData['regions_interested'] ?? '',
                                    qualifications:
                                        jobData['job_description'] ?? '',
                                  );
                                },
                              );
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
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
                          vertical: 18.0, horizontal: 16.0),
                      child: Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          controller.verifyButtonText.value == "Verifying"
                              ? Icon(Icons.schedule, color: Colors.black87)
                              : Icon(Icons.cancel, color: Colors.redAccent,),
                          SizedBox(
                            width: 10,
                          ),
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
}

class JobCard extends StatelessWidget {
  final dynamic docReference;
  final dynamic jobData;
  final String title;
  final String company;
  final String location;
  final String qualifications;

  const JobCard({
    super.key,
    required this.title,
    required this.company,
    required this.location,
    required this.qualifications,
    this.jobData,
    this.docReference,
  });

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
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total applicants',
                      style: TextStyle(fontSize: 14, color: Colors.black),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      jobData['applicants'].length.toString(),
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                Text(
                  jobData['created_at'] != null
                      ? 'Created on ${(jobData['created_at'] as Timestamp).toDate().toString().split(' ')[0]}'
                      : 'No date',
                  style: TextStyle(fontSize: 14, color: Colors.black),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              'Job description',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                customOutlineButton(
                    onPress: () {
                      Get.to(() => ApplicantsDetail(jobData),
                          transition: Transition.native,
                          duration: Duration(milliseconds: 1300));
                    },
                    buttonText: 'Check applications'),
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () async {
                      await docReference.delete();
                      customToastBar(
                          title: "Success!",
                          description: "Job listing removed successfully!",
                          icon: Icon(Icons.check_circle, color: Colors.green));
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.delete,
                          color: Color(0xff212E50),
                        ),
                        SizedBox(width: 8),
                        customText(
                          text: 'Remove',
                          context: context,
                          size: 16,
                          color: Color(0xff212E50),
                          fontWeight: FontWeight.w800,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
