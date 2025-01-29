import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hire4consult/HelperWidgets/toastBar.dart';

class Jobdescriptioncontroller extends GetxController {
  RxBool isHovered = false.obs;
  RxBool isLoadingApplyJob = false.obs;
  RxBool isAppliedForJob = false.obs;

  final user = FirebaseAuth.instance.currentUser;
  late final String? userId;

  @override
  void onInit() {
    super.onInit();
    userId = user?.uid;
  }

  Future<void> applyForJob(dynamic jobData) async {
    try {
      await FirebaseFirestore.instance.collection('jobs_information').doc(jobData['document_id']).update({
        'applicants': FieldValue.arrayUnion([userId])
      });
      customToastBar(title: 'Success', description: 'Applied for job', icon: Icon(Icons.check_circle, color: Colors.green,));
      isAppliedForJob.value = true;
    } catch (e) {
      customToastBar(
          title: 'Error!', description: 'Failed to apply for job: $e', icon: Icon(Icons.error, color: Colors.redAccent));
    } finally {
      isLoadingApplyJob.value = false;
    }
  }

  Future<void> withdrawApplication(dynamic jobData) async {
  try {
    await FirebaseFirestore.instance.collection('jobs_information').doc(jobData['document_id']).update({
      'applicants': FieldValue.arrayRemove([userId])
    });
    customToastBar(title: 'Success', description: 'Application withdrawn', icon: Icon(Icons.check_circle, color: Colors.green,));
    isAppliedForJob.value = false;
  } catch (e) {
    customToastBar(
        title: 'Error!', description: 'Failed to withdraw application: $e', icon: Icon(Icons.error, color: Colors.redAccent));
  } finally {
    isLoadingApplyJob.value = false;
  }
}
}
