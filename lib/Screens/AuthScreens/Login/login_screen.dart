import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hire4consult/HelperWidgets/CustomElevatedButton.dart';
import 'package:hire4consult/HelperWidgets/CustomTextField.dart';
import 'package:hire4consult/HelperWidgets/customText.dart';
import 'package:hire4consult/HelperWidgets/loadingIndicator.dart';
import 'package:hire4consult/HelperWidgets/toastBar.dart';
import 'package:hire4consult/Screens/AuthScreens/SignUp/signup_screen.dart';
import 'package:toastification/toastification.dart';

import '../auth_screen_controller/auth_screen_controller.dart';
import 'Controllers/login_screen_controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final loginController = Get.put(LoginScreenController());
  final authScreenController = Get.put(AuthScreenController());
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
                          loginController.isSelected.value
                              ? 'assets/images/ConsultLogin.jpg'
                              : 'assets/images/EmployerLogin.jpeg', // Replace with your image asset
                          fit: BoxFit.cover,
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
                    child: SingleChildScrollView(
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
                            'Log In',
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
                            initialIndex: authScreenController.tabBarIndex.value,
                            child: StatefulBuilder(
                              builder:
                                  (BuildContext context, StateSetter setState) {
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
                                                  loginController
                                                      .isSelected.value = true;
                                                }
                                              });
                                              return isSelected
                                                  ? Container(
                                                      width: 250,
                                                      decoration: BoxDecoration(
                                                        color:
                                                            Color(0xFFCE2029),

                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(30.0),
                                                        border: Border.all(
                                                            color: Colors
                                                                .red), // Add border for unselected tab
                                                      ),
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 20.0,
                                                          vertical: 10.0),
                                                      child: Center(
                                                        child: Text(
                                                            'Consultant',
                                                            style:
                                                                googleFontStyle(
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
                                                                  Colors.black),
                                                        ),
                                                        SizedBox(
                                                          height: 5,
                                                        ),
                                                        Divider(
                                                          color:
                                                              Color(0xff212E50),
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
                                                  loginController
                                                      .isSelected.value = false;
                                                }
                                              });
                                              return isSelected
                                                  ? Container(
                                                      width: 250,
                                                      decoration: BoxDecoration(
                                                        color:
                                                            Color(0xff212E50),

                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(30.0),
                                                        border: Border.all(
                                                            color: Color(
                                                                0xff212E50)), // Add border for unselected tab
                                                      ),
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 20.0,
                                                          vertical: 10.0),
                                                      child: Center(
                                                        child: Text('Employer',
                                                            style:
                                                                googleFontStyle(
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
                                                                  Colors.black),
                                                        ),
                                                        SizedBox(
                                                          height: 5,
                                                        ),
                                                        Divider(
                                                          color:
                                                              Color(0xff212E50),
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
                                                    child:
                                                        Text('Email address')),
                                                const SizedBox(height: 8),
                                                customTextField(
                                                    hintText: 'Email address',
                                                    controller: loginController
                                                        .emailConsultantController),
                                                const SizedBox(height: 16),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 12),
                                                  child: Text('Password'),
                                                ),
                                                const SizedBox(height: 8),
                                                customTextField(
                                                    hintText: 'Password',
                                                    obscureText: true,
                                                    controller: loginController
                                                        .passwordConsultantController),
                                                SizedBox(
                                                  height: 8,
                                                ),
                                                TextButton(
                                                    onPressed: () async {
                                                      await showResetPasswordDialog(
                                                          context);
                                                    },
                                                    child: Text(
                                                        'Forgot Password')),
                                                Obx(
                                                  () => loginController
                                                          .consultantLoading
                                                          .value
                                                      ? SizedBox(
                                                          height: 0,
                                                        )
                                                      : SizedBox(
                                                          height: 30,
                                                        ),
                                                ),
                                                Obx(
                                                  () => loginController
                                                          .consultantLoading
                                                          .value
                                                      ? loading(100)
                                                      : customElevatedButton(
                                                          onPress: () async {
                                                            loginController
                                                                .consultantLoading
                                                                .value = true;
                                                            String email =
                                                                loginController
                                                                    .emailConsultantController
                                                                    .text
                                                                    .trim();
                                                            String password =
                                                                loginController
                                                                    .passwordConsultantController
                                                                    .text
                                                                    .trim();
                                                            if (email
                                                                    .isNotEmpty &&
                                                                password
                                                                    .isNotEmpty) {
                                                              await loginController
                                                                  .loginConsultant();
                                                            } else {
                                                              loginController
                                                                  .consultantLoading
                                                                  .value = false;
                                                              customToastBar(
                                                                title: 'Error',
                                                                description:
                                                                    'Please fill all the fields',
                                                                icon: Icon(
                                                                  Icons.error,
                                                                  color: Colors
                                                                      .yellow,
                                                                ),
                                                              );
                                                            }
                                                          },
                                                          buttonText: 'Login',
                                                          backgroundColor:
                                                              Color(
                                                                  0xff212E50)),
                                                ),
                                                Obx(
                                                  () => loginController
                                                          .consultantLoading
                                                          .value
                                                      ? SizedBox(
                                                          height: 0,
                                                        )
                                                      : SizedBox(
                                                          height: 30,
                                                        ),
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                        "Don’t have an account? "),
                                                    TextButton(
                                                      onPressed: () {
                                                        Get.to(
                                                            () =>
                                                                SignupScreen(),
                                                            transition:
                                                                Transition
                                                                    .native,
                                                            duration: Duration(
                                                                milliseconds:
                                                                    1300));
                                                      },
                                                      style:
                                                          TextButton.styleFrom(
                                                        padding:
                                                            EdgeInsets.zero,
                                                        minimumSize: Size(0, 0),
                                                      ),
                                                      child: Text(
                                                        'Sign Up',
                                                        style: TextStyle(
                                                          decoration:
                                                              TextDecoration
                                                                  .underline,
                                                          color:
                                                              Color(0xff212E50),
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
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 12),
                                                  child: Text('Email address'),
                                                ),
                                                const SizedBox(height: 8),
                                                customTextField(
                                                    hintText: 'Email address',
                                                    controller: loginController
                                                        .emailEmployerController),
                                                const SizedBox(height: 16),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 12),
                                                  child: Text('Password'),
                                                ),
                                                const SizedBox(height: 8),
                                                customTextField(
                                                    hintText: 'Password',
                                                    obscureText: true,
                                                    controller: loginController
                                                        .passwordEmployerController),
                                                SizedBox(
                                                  height: 8,
                                                ),
                                                TextButton(
                                                    onPressed: () async {
                                                      await showResetPasswordDialog(
                                                          context);
                                                    },
                                                    child: Text(
                                                        'Forgot Password')),
                                                Obx(
                                                  () => loginController
                                                          .employerLoading.value
                                                      ? SizedBox(
                                                          height: 0,
                                                        )
                                                      : SizedBox(
                                                          height: 30,
                                                        ),
                                                ),
                                                Obx(
                                                  () => loginController
                                                          .employerLoading.value
                                                      ? loading(100)
                                                      : customElevatedButton(
                                                          onPress: () async {
                                                            loginController
                                                                .employerLoading
                                                                .value = true;
                                                            String email =
                                                                loginController
                                                                    .emailEmployerController
                                                                    .text
                                                                    .trim();
                                                            String password =
                                                                loginController
                                                                    .passwordEmployerController
                                                                    .text
                                                                    .trim();
                                                            if (email
                                                                    .isNotEmpty &&
                                                                password
                                                                    .isNotEmpty) {
                                                              await loginController
                                                                  .loginEmployer();
                                                            } else {
                                                              loginController
                                                                  .employerLoading
                                                                  .value = false;
                                                              customToastBar(
                                                                title: 'Error',
                                                                description:
                                                                    'Please fill all the fields',
                                                                icon: Icon(
                                                                  Icons.error,
                                                                  color: Colors
                                                                      .yellow,
                                                                ),
                                                              );
                                                            }
                                                          },
                                                          buttonText: 'Login',
                                                          backgroundColor:
                                                              Color(
                                                                  0xFFCE2029)),
                                                ),
                                                Obx(
                                                  () => loginController
                                                          .employerLoading.value
                                                      ? SizedBox(
                                                          height: 0,
                                                        )
                                                      : SizedBox(
                                                          height: 30,
                                                        ),
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                        "Don’t have an account? "),
                                                    TextButton(
                                                      onPressed: () {
                                                        Get.to(
                                                            () =>
                                                                SignupScreen(),
                                                            transition:
                                                                Transition
                                                                    .native,
                                                            duration: Duration(
                                                                milliseconds:
                                                                    1300));
                                                      },
                                                      style:
                                                          TextButton.styleFrom(
                                                        padding:
                                                            EdgeInsets.zero,
                                                        minimumSize: Size(0, 0),
                                                      ),
                                                      child: Text(
                                                        'Sign Up',
                                                        style: TextStyle(
                                                          decoration:
                                                              TextDecoration
                                                                  .underline,
                                                          color:
                                                              Color(0xff212E50),
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
              ],
            ),
          ),
          Obx(
            () => Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                  color: loginController.isSelected.value
                      ? Color(0xFFCE2029)
                      : Color(0xff212E50)),
              child: Row(
                children: [
                  textBox(
                      '© Hire4Consult 2024 . All Rights Reserved', 3, () {}),
                  textBox('Terms and Conditions', 1, () {
                    // showDialogForTermsAndConditions(context);
                  }),
                  textBox('Privacy Policy', 1, () {}),
                  textBox('Compliance Policy', 1, () {}),
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
                onPressed: onPress ?? () {},
                child: Text(
                  str,
                  style: TextStyle(color: Colors.white),
                ))));
  }

  Future<void> showDialogForTermsAndConditions(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.white,
          title: Center(
            child: customText(
                text: 'Terms and Conditions',
                context: context,
                size: 32,
                color: Color(0xff212E50),
                fontWeight: FontWeight.bold),
          ),
          );
        });
  }

  Future<dynamic> showResetPasswordDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController emailAddressTextController =
            TextEditingController();
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Center(
            child: customText(
                text: 'Reset Password',
                context: context,
                size: 32,
                color: Color(0xff212E50),
                fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              customText(
                  text:
                      'Please enter your email address to reset your password.',
                  context: context,
                  size: 16,
                  color: Colors.black),
              SizedBox(height: 30),
              customTextField(
                controller: emailAddressTextController,
                hintText: 'Email Address',
              ),
              SizedBox(
                height: 20,
              )
            ],
          ),
          actions: [
            customElevatedButton(
              onPress: () {
                Navigator.pop(context);
              },
              buttonText: 'Cancel',
              backgroundColor: Color(0xff212E50),
              height: 10,
            ),
            Obx(
              () => loginController.resetPasswordLoading.value
                  ? loading(50)
                  : customElevatedButton(
                      onPress: () async {
                        loginController.resetPasswordLoading.value = true;
                        await loginController.resetPassword(
                            emailId: emailAddressTextController.text);
                        emailAddressTextController.clear();
                      },
                      buttonText: 'Send',
                      backgroundColor: Color(0xff212E50),
                      height: 10,
                    ),
            ),
          ],
        );
      },
    );
  }
}
