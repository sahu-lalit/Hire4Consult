import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hire4consult/Screens/AuthScreens/Login/login_screen.dart';
import 'package:hire4consult/Screens/Consultant/ConsultHome/consult_home.dart';
import 'package:hire4consult/Screens/Employer/EmployerHome/employer_home.dart';
import 'package:hire4consult/firebase_options.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:toastification/toastification.dart';
import 'package:universal_html/html.dart' as html;
// Replace with your actual home screen


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  if (kIsWeb) {
    await FirebaseAuth.instance.setPersistence(Persistence.LOCAL);
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ToastificationWrapper(
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Hire4Consult',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: AuthWrapper(),
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  AuthWrapper({super.key});

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: _auth.authStateChanges(),
      builder: (context, authSnapshot) {
        if (authSnapshot.connectionState == ConnectionState.active) {
          final user = authSnapshot.data;

          if (user != null) {
            return FutureBuilder<bool>(
              future: _isConsultant(user.uid),
              builder: (context, consultantSnapshot) {
                if (consultantSnapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Scaffold(
                    body: Center(
                      child: SizedBox(
                        width: 200,
                        child: LoadingIndicator(
                          indicatorType: Indicator.ballClipRotatePulse,
                          colors: [Color(0xff212E50), Color(0xFFCE2029)],
                          strokeWidth: 2,
                        ),
                      ),
                    ),
                  );
                }

                if (consultantSnapshot.hasError) {
                  return const Scaffold(
                    body: Center(
                      child: Text('Error checking user type'),
                    ),
                  );
                }

                final isConsultant = consultantSnapshot.data ?? false;
                return isConsultant
                    ? ConsultHome()
                    : FutureBuilder<bool>(
                        future: _isEmployer(user.uid),
                        builder: (context, employerSnapshot) {
                          if (employerSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Scaffold(
                              body: Center(
                                child: SizedBox(
                                  width: 200,
                                  child: LoadingIndicator(
                                    indicatorType:
                                        Indicator.ballClipRotatePulse,
                                    colors: [
                                      Color(0xff212E50),
                                      Color(0xFFCE2029)
                                    ],
                                    strokeWidth: 2,
                                  ),
                                ),
                              ),
                            );
                          }

                          if (consultantSnapshot.hasError) {
                            return const Scaffold(
                              body: Center(
                                child: Text('Error checking user type'),
                              ),
                            );
                          }

                          final isEmployer = employerSnapshot.data ?? false;
                          return isEmployer ? EmployerHome() : LoginScreen();
                        },
                      );
              },
            );
          }
          return LoginScreen();
        }

        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }

  Future<bool> _isConsultant(String uid) async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('consult_user')
          .doc(uid)
          .get();
      return doc.exists;
    } catch (e) {
      return false;
    }
  }

  Future<bool> _isEmployer(String uid) async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('employer_user')
          .doc(uid)
          .get();
      return doc.exists;
    } catch (e) {
      return false;
    }
  }
}
