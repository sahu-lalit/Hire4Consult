import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hire4consult/HelperWidgets/CustomElevatedButton.dart';
import 'package:hire4consult/HelperWidgets/CustomTextField.dart';
import 'package:hire4consult/HelperWidgets/customText.dart';
import 'package:hire4consult/HelperWidgets/loadingIndicator.dart';
import 'package:hire4consult/HelperWidgets/toastBar.dart';
import 'package:hire4consult/Screens/Consultant/ConsultantIntro/consult_Introduction.dart';
import 'package:hire4consult/Screens/Employer/EmployerIntro/employer_Introduction.dart';

import '../Login/login_screen.dart';
import '../auth_screen_controller/auth_screen_controller.dart';
import '../auth_screen_widgets/terms_and_conditions.dart';
import 'Controllers/signup_screen_controller.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<SignupScreen>
    with SingleTickerProviderStateMixin {
  final signUpController = Get.put(SignupScreenController());
  final authScreenController = Get.put(AuthScreenController());
  TextEditingController confirmationPasswordConsultantController =
      TextEditingController();
  TextEditingController confirmationPasswordEmployerController =
      TextEditingController();

  @override
  void dispose() {
    super.dispose();
    confirmationPasswordConsultantController.dispose();
    confirmationPasswordEmployerController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color(0xffFFFFFF),
      body: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                // Left Side - Image
                Expanded(
                  flex: 1,
                  child: Stack(
                    children: [
                      Obx(
                        () => Image.asset(
                          height: height,
                          width: width / 2,
                          signUpController.isSelected.value
                              ? 'assets/images/ConsultSignUp.png'
                              : 'assets/images/EmployerSignUp.jpeg', // Replace with your image asset
                          fit: BoxFit.fill,
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.bottomLeft,
                                end: Alignment.topCenter,
                                colors: [
                              Colors.black.withAlpha((.9 * 255).toInt()),
                              Colors.black.withAlpha((.7 * 255).toInt()),
                              Colors.black.withAlpha((.0 * 255).toInt()),
                            ])),
                        child: Padding(
                          padding: EdgeInsets.only(right: 90.0, bottom: 90.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              customText(
                                  text:
                                      'Flexible Experts, \nZero Hiring Hassles.\nJoin Hire4Consult.',
                                  context: context,
                                  size: 48,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),

                // Right Side - Form
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: width / 11),
                    child: ScrollbarTheme(
                      data: ScrollbarThemeData(
                        thumbColor: WidgetStateProperty.all(
                            Colors.transparent), // Change scrollbar color
                        trackColor: WidgetStateProperty.all(
                            Colors.transparent), // Track color
                      ),
                      child: SingleChildScrollView(
                        physics: NeverScrollableScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: 35),

                            // Logo and Title
                            Image.asset(
                              'assets/images/homeLogo.png',
                              width: 250,
                            ),
                            const SizedBox(height: 25),
                            Text(
                              'Sign Up',
                              style: GoogleFonts.mulish(
                                textStyle:
                                    Theme.of(context).textTheme.displayLarge,
                                fontSize: 48,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            const SizedBox(height: 60),
                            DefaultTabController(
                              length: 2,
                              initialIndex:
                                  authScreenController.tabBarIndex.value,
                              child: StatefulBuilder(
                                builder: (BuildContext context,
                                    StateSetter setState) {
                                  final TabController controller =
                                      DefaultTabController.of(context);
                                  controller.addListener(() {
                                    setState(() {
                                      authScreenController.tabBarIndex.value =
                                          controller.index;
                                    });
                                  });
                                  return Column(
                                    children: [
                                      TabBar(
                                        overlayColor: WidgetStateProperty.all(
                                            Colors.transparent),
                                        dividerColor: Colors.transparent,
                                        indicatorColor: Colors
                                            .transparent, // Remove the default indicator
                                        labelPadding: EdgeInsets
                                            .zero, // Avoid extra padding
                                        tabs: [
                                          // Consultant Tab
                                          Tab(
                                            child: Builder(
                                              builder: (context) {
                                                final bool isSelected =
                                                    controller.index == 0;
                                                WidgetsBinding.instance
                                                    .addPostFrameCallback((_) {
                                                  if (isSelected) {
                                                    signUpController.isSelected
                                                        .value = true;
                                                  }
                                                });
                                                return isSelected
                                                    ? Container(
                                                        width: 250,
                                                        decoration:
                                                            BoxDecoration(
                                                          color:
                                                              Color(0xFFCE2029),

                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      30.0),
                                                          border: Border.all(
                                                              color: Colors
                                                                  .red), // Add border for unselected tab
                                                        ),
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal:
                                                                    20.0,
                                                                vertical: 10.0),
                                                        child: Center(
                                                          child: Text(
                                                              'Consultant',
                                                              style: googleFontStyle(
                                                                  FontWeight
                                                                      .w700,
                                                                  Colors
                                                                      .white)),
                                                        ),
                                                      )
                                                    : Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          SizedBox(
                                                            height: 5,
                                                          ),
                                                          Text(
                                                            'Consultant',
                                                            style:
                                                                googleFontStyle(
                                                                    FontWeight
                                                                        .w700,
                                                                    Colors
                                                                        .black),
                                                          ),
                                                          SizedBox(
                                                            height: 5,
                                                          ),
                                                          Divider(
                                                            color: Color(
                                                                0xff212E50),
                                                          )
                                                        ],
                                                      );
                                              },
                                            ),
                                          ),
                                          // Employer Tab
                                          Tab(
                                            child: Builder(
                                              builder: (context) {
                                                final bool isSelected =
                                                    controller.index == 1;
                                                WidgetsBinding.instance
                                                    .addPostFrameCallback((_) {
                                                  if (isSelected) {
                                                    signUpController.isSelected
                                                        .value = false;
                                                  }
                                                });
                                                return isSelected
                                                    ? Container(
                                                        width: 250,
                                                        decoration:
                                                            BoxDecoration(
                                                          color:
                                                              Color(0xff212E50),

                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      30.0),
                                                          border: Border.all(
                                                              color: Color(
                                                                  0xff212E50)), // Add border for unselected tab
                                                        ),
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal:
                                                                    20.0,
                                                                vertical: 10.0),
                                                        child: Center(
                                                          child: Text(
                                                              'Employer',
                                                              style: googleFontStyle(
                                                                  FontWeight
                                                                      .w700,
                                                                  Colors
                                                                      .white)),
                                                        ),
                                                      )
                                                    : Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          SizedBox(
                                                            height: 5,
                                                          ),
                                                          Text(
                                                            'Employer',
                                                            style:
                                                                googleFontStyle(
                                                                    FontWeight
                                                                        .w700,
                                                                    Colors
                                                                        .black),
                                                          ),
                                                          SizedBox(
                                                            height: 5,
                                                          ),
                                                          Divider(
                                                            color: Color(
                                                                0xff212E50),
                                                          )
                                                        ],
                                                      );
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: height / 1.8,
                                        child: TabBarView(
                                          children: [
                                            // Consultant Tab Content
                                            SingleChildScrollView(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  SizedBox(
                                                    height: 35,
                                                  ),
                                                  Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 12),
                                                      child: Text(
                                                          'Email Address')),
                                                  const SizedBox(height: 8),
                                                  customTextField(
                                                      hintText: 'Email address',
                                                      controller: signUpController
                                                          .emailConsultantController),
                                                  const SizedBox(height: 16),
                                                  Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 12),
                                                      child: Text('Password')),
                                                  const SizedBox(height: 8),
                                                  customTextField(
                                                      hintText: 'Password',
                                                      obscureText: true,
                                                      controller: signUpController
                                                          .passwordConsultantController),
                                                  const SizedBox(height: 16),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 12),
                                                    child: Text(
                                                        'Confirm Password'),
                                                  ),
                                                  const SizedBox(height: 8),
                                                  customTextField(
                                                      hintText:
                                                          'Confirm Password',
                                                      obscureText: true,
                                                      controller:
                                                          confirmationPasswordConsultantController),
                                                  Obx(
                                                    () => signUpController
                                                            .consultantLoading
                                                            .value
                                                        ? SizedBox()
                                                        : SizedBox(
                                                            height: 30,
                                                          ),
                                                  ),
                                                  Row(
                                                    children: [
                                                      Obx(
                                                        () => signUpController
                                                                .consultantLoading
                                                                .value
                                                            ? loading(100)
                                                            : customElevatedButton(
                                                                onPress:
                                                                    () async {
                                                                  signUpController
                                                                      .consultantLoading
                                                                      .value = true;

                                                                  if (signUpController
                                                                          .passwordConsultantController
                                                                          .text !=
                                                                      confirmationPasswordConsultantController
                                                                          .text) {
                                                                    customToastBar(
                                                                        title:
                                                                            'Error',
                                                                        description:
                                                                            'Password does not match',
                                                                        icon:
                                                                            Icon(
                                                                          Icons
                                                                              .error,
                                                                          color:
                                                                              Colors.red,
                                                                        ));
                                                                    signUpController
                                                                        .consultantLoading
                                                                        .value = false;
                                                                    return;
                                                                  }
                                                                  String email =
                                                                      signUpController
                                                                          .emailConsultantController
                                                                          .text
                                                                          .trim();
                                                                  String
                                                                      password =
                                                                      signUpController
                                                                          .passwordConsultantController
                                                                          .text
                                                                          .trim();

                                                                  if (email
                                                                          .isNotEmpty &&
                                                                      password
                                                                          .isNotEmpty) {
                                                                    signUpController
                                                                        .signUpConsultant();
                                                                  } else {
                                                                    customToastBar(
                                                                        title:
                                                                            'Error',
                                                                        description:
                                                                            'Please fill all the fields',
                                                                        icon:
                                                                            Icon(
                                                                          Icons
                                                                              .error,
                                                                          color:
                                                                              Colors.yellow,
                                                                        ));
                                                                    signUpController
                                                                        .consultantLoading
                                                                        .value = false;
                                                                  }
                                                                },
                                                                buttonText:
                                                                    'Sign Up',
                                                                backgroundColor:
                                                                    Color(
                                                                        0xff212E50)),
                                                      ),
                                                      SizedBox(
                                                        width: 20,
                                                      ),
                                                      Text(
                                                          "Already have an account? "),
                                                      TextButton(
                                                        onPressed: () {
                                                          Get.off(
                                                              () =>
                                                                  LoginScreen(),
                                                              transition:
                                                                  Transition
                                                                      .native,
                                                              duration: Duration(
                                                                  milliseconds:
                                                                      1300));
                                                        },
                                                        style: TextButton
                                                            .styleFrom(
                                                          padding:
                                                              EdgeInsets.zero,
                                                          minimumSize:
                                                              Size(0, 0),
                                                        ),
                                                        child: Text(
                                                          'Log In',
                                                          style: TextStyle(
                                                            decoration:
                                                                TextDecoration
                                                                    .underline,
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
                                            // Employer Tab Content
                                            SingleChildScrollView(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  SizedBox(
                                                    height: 35,
                                                  ),
                                                  Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 12),
                                                      child: Text(
                                                          'Email Address')),
                                                  const SizedBox(height: 8),
                                                  customTextField(
                                                      hintText: 'Email address',
                                                      controller: signUpController
                                                          .emailEmployerController),
                                                  const SizedBox(height: 16),
                                                  Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 12),
                                                      child: Text('Password')),
                                                  const SizedBox(height: 8),
                                                  customTextField(
                                                      hintText: 'Password',
                                                      obscureText: true,
                                                      controller: signUpController
                                                          .passwordEmployerController),
                                                  const SizedBox(height: 16),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 12),
                                                    child: Text(
                                                        'Confirm Password'),
                                                  ),
                                                  const SizedBox(height: 8),
                                                  customTextField(
                                                      hintText:
                                                          'Confirm Password',
                                                      obscureText: true,
                                                      controller:
                                                          confirmationPasswordEmployerController),
                                                  Obx(
                                                    () => signUpController
                                                            .employerLoading
                                                            .value
                                                        ? SizedBox()
                                                        : SizedBox(
                                                            height: 30,
                                                          ),
                                                  ),
                                                  Row(
                                                    children: [
                                                      Obx(
                                                        () => signUpController
                                                                .employerLoading
                                                                .value
                                                            ? loading(100)
                                                            : customElevatedButton(
                                                                onPress: () {
                                                                  signUpController
                                                                      .employerLoading
                                                                      .value = true;

                                                                  if (signUpController
                                                                          .passwordEmployerController
                                                                          .text !=
                                                                      confirmationPasswordEmployerController
                                                                          .text) {
                                                                    customToastBar(
                                                                        title:
                                                                            'Error',
                                                                        description:
                                                                            'Password does not match',
                                                                        icon:
                                                                            Icon(
                                                                          Icons
                                                                              .error,
                                                                          color:
                                                                              Colors.red,
                                                                        ));
                                                                    signUpController
                                                                        .employerLoading
                                                                        .value = false;
                                                                    return;
                                                                  }
                                                                  String email =
                                                                      signUpController
                                                                          .emailEmployerController
                                                                          .text
                                                                          .trim();
                                                                  String
                                                                      password =
                                                                      signUpController
                                                                          .passwordEmployerController
                                                                          .text
                                                                          .trim();

                                                                  if (email
                                                                          .isNotEmpty &&
                                                                      password
                                                                          .isNotEmpty) {
                                                                    signUpController
                                                                        .signUpEmployer();
                                                                  } else {
                                                                    customToastBar(
                                                                        title:
                                                                            'Error',
                                                                        description:
                                                                            'Please fill all the fields',
                                                                        icon:
                                                                            Icon(
                                                                          Icons
                                                                              .error,
                                                                          color:
                                                                              Colors.yellow,
                                                                        ));
                                                                    signUpController
                                                                        .employerLoading
                                                                        .value = false;
                                                                    return;
                                                                  }
                                                                },
                                                                buttonText:
                                                                    'Sign Up',
                                                                backgroundColor:
                                                                    Color(
                                                                        0xFFCE2029)),
                                                      ),
                                                      SizedBox(
                                                        width: 20,
                                                      ),
                                                      Text(
                                                          "Already have an account? "),
                                                      TextButton(
                                                        onPressed: () {
                                                          Get.off(
                                                              () =>
                                                                  LoginScreen(),
                                                              transition:
                                                                  Transition
                                                                      .native,
                                                              duration: Duration(
                                                                  milliseconds:
                                                                      1300));
                                                        },
                                                        style: TextButton
                                                            .styleFrom(
                                                          padding:
                                                              EdgeInsets.zero,
                                                          minimumSize:
                                                              Size(0, 0),
                                                        ),
                                                        child: Text(
                                                          'Log In',
                                                          style: TextStyle(
                                                            decoration:
                                                                TextDecoration
                                                                    .underline,
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
                                          ],
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 32),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Obx(
            () => Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                  color: signUpController.isSelected.value
                      ? Color(0xFFCE2029)
                      : Color(0xff212E50)),
              child: Row(
                children: [
                  textBox(
                      '© Hire4Consult 2024 . All Rights Reserved', 3, () {}),
                  textBox('Privacy policy', 2, () {
                    showDialogForTermsAndConditions(context);
                  }),
                  // textBox('Privacy Policy', 1, () {}),
                  // textBox('Compliance Policy', 1, () {}),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  TextStyle googleFontStyle(FontWeight fb, Color c) {
    return GoogleFonts.poppins(
        textStyle: Theme.of(context).textTheme.displayLarge,
        fontSize: 18,
        fontWeight: fb,
        color: c,
        letterSpacing: 1);
  }

  Widget textBox(String str, int f, onPress) {
    return Expanded(
        flex: f,
        child: Center(
            child: TextButton(
                onPressed: onPress,
                child: Text(
                  str,
                  style: TextStyle(color: Colors.white),
                ))));
  }
}
