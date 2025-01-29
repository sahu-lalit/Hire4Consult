import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hire4consult/HelperWidgets/toastBar.dart';

class CreateNewListingController extends GetxController {
  RxInt imageIndex = 0.obs;
  RxBool isLoadingForSubmitJob = false.obs;

  TextEditingController companyNameAliasController = TextEditingController();
  TextEditingController regionsInterestedController = TextEditingController();
  TextEditingController departmentController = TextEditingController();
  TextEditingController jobDescriptionController = TextEditingController();
  TextEditingController positionController = TextEditingController();
  TextEditingController hoursNeededController = TextEditingController();
  TextEditingController keySkillsController = TextEditingController();
  TextEditingController timeZoneController = TextEditingController();

  Future<void> submitJob() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        throw Exception('No user logged in');
      }

      CollectionReference jobs =
          FirebaseFirestore.instance.collection('jobs_information');

      DocumentReference docRef = await jobs.add({
        'company_name_alias': companyNameAliasController.text.trim(),
        'regions_interested': regionsInterestedController.text.trim(),
        'department': departmentController.text.trim(),
        'job_description': jobDescriptionController.text.trim(),
        'position': positionController.text.trim(),
        'key_skills': keySkillsController.text.trim(),
        'time_zone': timeZoneController.text.trim(),
        'jobCreatorID': user.uid,
        'applicants': [],
        'created_at': FieldValue.serverTimestamp(),
        'document_id': '',
      });

      await docRef.update({'document_id': docRef.id});

    } catch (e) {
      customToastBar(
          title: 'Error!',
          description: 'Failed to create job listing: ${e.toString()}',
          icon: Icon(Icons.error, color: Colors.red));
    } finally {
      isLoadingForSubmitJob.value = false;
      companyNameAliasController.clear();
      regionsInterestedController.clear();
      departmentController.clear();
      jobDescriptionController.clear();
      positionController.clear();
      keySkillsController.clear();
      timeZoneController.clear();
    }

  }
}
