import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hire4consult/HelperWidgets/customAppBar.dart';
import 'package:hire4consult/HelperWidgets/customOutlineButton.dart';
import 'package:hire4consult/HelperWidgets/customText.dart';
import 'package:hire4consult/Screens/AuthScreens/Login/login_screen.dart';
import 'package:hire4consult/Screens/Employer/EmployerHome/ApplicantsDetail/view_applicants_details/view_applicants_detail.dart';
import 'package:hire4consult/Screens/Employer/EmployerHome/EmployerProfile/employer_profile.dart';

import 'applicants_detail_controller/applicants_detail_controller.dart';

class ApplicantsDetail extends StatefulWidget {
  final dynamic jobData;
  const ApplicantsDetail(this.jobData, {super.key});

  @override
  State<ApplicantsDetail> createState() => _ApplicantsDetailState();
}

class _ApplicantsDetailState extends State<ApplicantsDetail> {
  final controller = Get.put(ApplicantsDetailController());

  List<String> applicantsId = [];

  Future<void> getApplicantsId() async {
    await FirebaseFirestore.instance
        .collection('jobs_information')
        .doc(widget.jobData['document_id'])
        .collection('applicants')
        .get()
        .then((value) {
      for (var doc in value.docs) {
        applicantsId.add(doc.id);
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getApplicantsId();
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
            child: Container(
              margin: EdgeInsets.only(top: 20),
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: Card(
                        margin: const EdgeInsets.only(bottom: 16),
                        elevation: 0,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 18, horizontal: 26),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Job Title and Icons
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    widget.jobData['position'] ?? '',
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  // Row(
                                  //   children: [
                                  //     Icon(Icons.share,
                                  //         size: 22, color: Colors.black),
                                  //     const SizedBox(width: 12),
                                  //     Icon(Icons.bookmark_border,
                                  //         size: 22, color: Colors.black),
                                  //   ],
                                  // ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              // Company and Location
                              Row(
                                children: [
                                  Icon(Icons.business,
                                      size: 18, color: Colors.black),
                                  const SizedBox(width: 8),
                                  Text(
                                    widget.jobData['company_name_alias'] ?? '',
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.black),
                                  ),
                                  const SizedBox(width: 16),
                                  Icon(Icons.location_on,
                                      size: 18, color: Colors.black),
                                  const SizedBox(width: 8),
                                  Text(
                                    widget.jobData['regions_interested'] ?? '',
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.black),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              // Total Applicants and Posting Date
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Total applicants',
                                        style: TextStyle(
                                            fontSize: 14, color: Colors.black),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        widget.jobData['applicants'].length
                                            .toString(),
                                        style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    widget.jobData['created_at'] != null
                                        ? 'Created on ${(widget.jobData['created_at'] as Timestamp).toDate().toString().split(' ')[0]}'
                                        : 'No date',
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.black),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Job description',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                              Text(widget.jobData['job_description'] ?? ''),

                              const SizedBox(height: 16),
                              // Divider
                              const Divider(),
                              const SizedBox(height: 8),
                              // Search Bar
                              SizedBox(
                                width: 200,
                                height: 31,
                                child: TextField(
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.search,
                                        color: Colors.black, size: 20),
                                    hintText: "Search",
                                    hintStyle: TextStyle(
                                        fontSize: 13, color: Colors.grey),
                                    filled: false, // No background fill
                                    contentPadding: EdgeInsets
                                        .zero, // Remove vertical padding
                                    border: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.grey),
                                    ),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.grey),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.black),
                                    ),
                                  ),
                                  style: TextStyle(
                                      fontSize: 13, color: Colors.black),
                                ),
                              ),

                              const SizedBox(height: 16),
                              // List of Applicants
                              Column(
                                children: [
                                  ListView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount:
                                          widget.jobData['applicants'].length,
                                      itemBuilder: (context, index) {
                                        final applicantId =
                                            widget.jobData['applicants'][index];
                                        return FutureBuilder<DocumentSnapshot>(
                                          future: FirebaseFirestore.instance
                                              .collection('consult_user')
                                              .doc(applicantId)
                                              .get(),
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return Center(
                                                  child:
                                                      CircularProgressIndicator());
                                            }
                                            if (snapshot.hasError) {
                                              return Center(
                                                  child: Text(
                                                      'Error: ${snapshot.error}'));
                                            }
                                            if (!snapshot.hasData ||
                                                !snapshot.data!.exists) {
                                              return Center(
                                                  child: Text('No data found'));
                                            }
                                            final applicantData = snapshot.data!
                                                .data() as Map<String, dynamic>;
                                            return _viewApplicants(
                                                applicantData);
                                          },
                                        );
                                      }),
                                ],
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
          ),
        ],
      ),
    );
  }

  Widget _viewApplicants(dynamic applicantData) {
    return Column(
      children: [
        SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: applicantData?['userProfileLink'] != null
                      ? NetworkImage(applicantData?['userProfileLink'])
                      : AssetImage('assets/images/default_user.png'),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      applicantData['fullName'], // Replace with dynamic name
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      applicantData['skills'],
                      style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                    ),
                  ],
                ),
              ],
            ),
            // Column(
            //   crossAxisAlignment: CrossAxisAlignment.start,
            //   children: [
            //     Text(
            //       "Applied on",
            //       style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            //     ),
            //     const SizedBox(height: 4),
            //     Text(
            //       "Jan 4, 2024",
            //       style: TextStyle(fontSize: 14, color: Colors.black),
            //     ),
            //   ],
            // ),
            customOutlineButton(
                onPress: () {
                  Get.to(() => ViewApplicantsDetail(
                        applicantData: applicantData,
                      ), transition: Transition.native, duration: Duration(milliseconds: 1300));
                },
                buttonText: "View applicant details"),
          ],
        ),
        SizedBox(height: 8),
        Divider(
          color: Colors.grey[300],
          thickness: 1,
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
}
