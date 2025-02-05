// ignore: file_names
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hire4consult/HelperWidgets/CustomElevatedButton.dart';
import 'package:hire4consult/HelperWidgets/CustomTextField.dart';
import 'package:hire4consult/HelperWidgets/customText.dart';
import 'package:hire4consult/HelperWidgets/customTextFieldLikeButton.dart';
import 'package:hire4consult/HelperWidgets/datePicker.dart';
import 'package:hire4consult/HelperWidgets/loadingIndicator.dart';
import 'package:hire4consult/HelperWidgets/toastBar.dart';
import 'package:hire4consult/Screens/Consultant/ConsultantIntro/controllers/consult_intro_controller.dart';
import 'package:universal_html/html.dart' as html;

final controller = Get.put(ConsultIntroController());

Widget buildPage2(dynamic pageController, BuildContext context) {
  return _buildContainer(
    context: context,
    step: "Step 2/5",
    title: "Add your education and certifications",
    content: Column(
      spacing: 8,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
            padding: EdgeInsets.only(left: 16),
            child: Row(
              children: [
                Text('Add Education'),
                Text(
                  '*',
                  style: TextStyle(color: Colors.red),
                ),
              ],
            )),
        customTextFieldLikeButton(
          label: 'Add Education',
          onPressed: () async {
            await _addEducationDialog(context);
          },
        ),
        Padding(
            padding: EdgeInsets.only(left: 16),
            child: Row(
              children: [
                Text('Certifications'),
              ],
            )),
        customTextFieldLikeButton(
          label: 'Certifications',
          onPressed: () async {
            await _addCertificationDialog(context);
          },
        ),
        SizedBox(height: 25),
        Center(
            child: customElevatedButton(
                onPress: () {
                  if (controller.addEducationController.text.isEmpty) {
                    customToastBar(
                        title: "Error",
                        description: "Please fill all the required fields.",
                        icon: Icon(Icons.error, color: Colors.yellow));
                    return;
                  }
                  pageController.nextPage(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
                buttonText: 'Next',
                backgroundColor: Color(0xff212E50))),
        SizedBox(height: 10),
      ],
    ),
  );
}

Future<dynamic> _addEducationDialog(BuildContext context) async {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            backgroundColor: Color(0xfff1f1f1),
            title: Center(
              child: customText(
                  text: 'Add Education',
                  context: context,
                  size: 35,
                  color: Color(0xff212E50),
                  fontWeight: FontWeight.w800),
            ),
            content: SizedBox(
              width: MediaQuery.of(context).size.width / 2,
              height: MediaQuery.of(context).size.height / 1.5,
              child: SingleChildScrollView(
                child: Obx(
                  () => Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ...controller.educationList.asMap().entries.map((entry) {
                        int index = entry.key;
                        Map<String, String> education = entry.value;

                        return Card(
                          color: Color(0xfff8f8f8),
                          margin: EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 16.0),
                          elevation: 4.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.school,
                                        color: Color(0xFF212E50), size: 24.0),
                                    SizedBox(width: 8.0),
                                    Expanded(
                                      child: Text(
                                        education['school'] ?? "School Name",
                                        style: TextStyle(
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    IconButton(
                                      icon:
                                          Icon(Icons.delete, color: Colors.red),
                                      onPressed: () {
                                        setState(() {
                                          controller.educationList
                                              .removeAt(index);
                                        });
                                      },
                                    ),
                                  ],
                                ),
                                SizedBox(height: 12.0),
                                Text(
                                  "Degree: ${education['degree'] ?? 'N/A'}",
                                  style: TextStyle(
                                      fontSize: 16.0, color: Colors.black87),
                                ),
                                SizedBox(height: 4.0),
                                Text(
                                  "Field of Study: ${education['fieldOfStudy'] ?? 'N/A'}",
                                  style: TextStyle(
                                      fontSize: 16.0, color: Colors.black54),
                                ),
                                SizedBox(height: 4.0),
                                Row(
                                  children: [
                                    Icon(Icons.date_range,
                                        color: Color(0xffCE2029), size: 20.0),
                                    SizedBox(width: 8.0),
                                    Text(
                                      "Start: ${education['startDate'] ?? 'N/A'}",
                                      style: TextStyle(
                                          fontSize: 14.0,
                                          color: Colors.black54),
                                    ),
                                    SizedBox(width: 16.0),
                                    Icon(Icons.date_range,
                                        color: Color(0xffCE2029), size: 20.0),
                                    SizedBox(width: 8.0),
                                    Text(
                                      "End: ${education['endDate'] ?? 'N/A'}",
                                      style: TextStyle(
                                          fontSize: 14.0,
                                          color: Colors.black54),
                                    ),
                                    SizedBox(width: 8.0),
                                    Icon(
                                      Icons.check,
                                      color: Color(0xffCE2029),
                                    ),
                                    SizedBox(width: 8.0),
                                    Text(
                                      "Supporting Documents: Uploaded",
                                      style: TextStyle(
                                          fontSize: 14.0,
                                          color: Colors.black54),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                      SizedBox(height: 10.0),
                      customElevatedButton(
                          onPress: () async {
                            await addEducationOnPressButton(context);
                          },
                          buttonText: 'Add More',
                          backgroundColor: Color(0xffCE2029)),
                    ],
                  ),
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  controller.educationList.clear();
                },
                child: Text("Cancel"),
              ),
              TextButton(
                onPressed: () {
                  String combinedEducationDetails =
                      controller.educationList.map((education) {
                    return '${education['school'] ?? ''}|${education['degree'] ?? ''}|${education['fieldOfStudy'] ?? ''}|${education['startDate'] ?? ''}|${education['endDate'] ?? ''}|${education['supportingDocumentLink'] ?? ''}';
                  }).join('^');
                  controller.addEducationController.text =
                      combinedEducationDetails;

                  Navigator.pop(context);
                },
                child: Text("Save All"),
              ),
            ],
          );
        },
      );
    },
  );
}

List<Map<String, String>> certificationList = [];
Future<dynamic> _addCertificationDialog(BuildContext context) async {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      TextEditingController certificateNameController = TextEditingController();
      TextEditingController pdfFileNameController = TextEditingController();
      String? downloadUrl;

      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            backgroundColor: Color(0xfff1f1f1),
            title: Center(
              child: customText(
                  text: 'Add Certification',
                  context: context,
                  size: 35,
                  color: Color(0xff212E50),
                  fontWeight: FontWeight.w800),
            ),
            content: SizedBox(
              width: MediaQuery.of(context).size.width / 2,
              height: MediaQuery.of(context).size.height / 1.5,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: certificationList.length,
                      itemBuilder: (context, index) {
                        final certification = certificationList[index];
                        return Card(
                          color: Color(0xfff8f8f8),
                          margin: EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 16.0),
                          elevation: 4.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          child: ListTile(
                            title: Text(certification['name'] ?? ''),
                            subtitle: Text("Certificate Uploaded"),
                            trailing: IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                setState(() {
                                  certificationList.removeAt(index);
                                });
                              },
                            ),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 10),
                    Padding(
                        padding: EdgeInsets.only(left: 16),
                        child: Row(
                          children: [
                            Text('Certificate Name'),
                            Text(
                              '*',
                              style: TextStyle(color: Colors.red),
                            ),
                          ],
                        )),
                    SizedBox(height: 10),
                    customTextField(
                        hintText: "e.g. AWS Certified Solutions Architect",
                        controller: certificateNameController),
                    SizedBox(height: 15),
                    InkWell(
                      overlayColor: WidgetStateProperty.all(Colors.transparent),
                      hoverColor: Colors.transparent,
                      onTap: () async {
                        downloadUrl = await pickAndUploadCertificate(
                          pdfFileNameController: pdfFileNameController,
                          setState: setState,
                        );
                      },
                      child: Obx(
                        () => controller.isCertificateUploaded.value
                            ? loading(100)
                            : Container(
                                width: 200,
                                height: 100,
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: Color(0xFF212E50),
                                    width: 1,
                                  ),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.upload_file,
                                        color: Colors.red, size: 30),
                                    SizedBox(height: 10),
                                    Text(
                                      'Upload Certificate',
                                      style: TextStyle(
                                        color: Color(0xFF212E50),
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Text("Note:",
                          style: TextStyle(
                              color: Colors.grey, fontWeight: FontWeight.bold)),
                      Text(" Make sure to press on add button before Save All.",
                          style: TextStyle(color: Colors.grey))
                    ])
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  "Cancel",
                  style: TextStyle(color: Color(0xFF212E50)),
                ),
              ),
              TextButton(
                onPressed: () {
                  // Add the certification to the list
                  addCertification(
                      certificateNameController: certificateNameController,
                      pdfFileNameController: pdfFileNameController,
                      certificationList: certificationList,
                      setState: setState,
                      downloadUrl: downloadUrl);
                },
                child: Text("Add", style: TextStyle(color: Color(0xFF212E50))),
              ),
              TextButton(
                onPressed: () {
                  // Combine certifications as `certificationName|downloadUrl`
                  String combinedCertificationDetails = certificationList
                      .map((cert) =>
                          '${cert['name'] ?? ''}|${cert['file'] ?? ''}')
                      .join('^');

                  controller.addCertificationController.text =
                      combinedCertificationDetails;

                  Navigator.pop(context);
                },
                child: Text("Save All",
                    style: TextStyle(color: Color(0xFF212E50))),
              ),
            ],
          );
        },
      );
    },
  );
}

void addCertification({
  required TextEditingController certificateNameController,
  required TextEditingController pdfFileNameController,
  required List<Map<String, String>> certificationList,
  required void Function(void Function()) setState,
  required String? downloadUrl,
}) async {
  if (certificateNameController.text.isEmpty ||
      pdfFileNameController.text.isEmpty) {
    customToastBar(
        title: "Error",
        description: 'Please fill all the required fields.',
        icon: Icon(Icons.error, color: Colors.yellow));
    return;
  }
  if (downloadUrl != null) {
    setState(() {
      certificationList.add({
        'name': certificateNameController.text,
        'file': downloadUrl,
      });
      certificateNameController.clear();
      pdfFileNameController.clear();
    });
  } else {
    customToastBar(
        title: 'Error',
        description: 'Failed to upload certificate.',
        icon: Icon(Icons.error, color: Colors.red));
  }
}

Future<String?> pickAndUploadCertificate({
  required TextEditingController pdfFileNameController,
  required void Function(void Function()) setState,
}) async {
  final html.FileUploadInputElement uploadInput = html.FileUploadInputElement()
    ..accept = 'application/pdf';
  uploadInput.click();
  return await uploadInput.onChange.first.then((event) async {
    final files = uploadInput.files;
    if (files != null && files.isNotEmpty) {
      controller.isCertificateUploaded.value = true;
      pdfFileNameController.text = files[0].name;
      final reader = html.FileReader();
      reader.readAsArrayBuffer(files[0]);
      String fileName = files[0].name;

      return reader.onLoadEnd.first.then((_) async {
        final Uint8List fileBytes = reader.result as Uint8List;

        try {
          final storageRef =
              FirebaseStorage.instance.ref().child('certifications/$fileName');
          final uploadTask = storageRef.putData(
            fileBytes,
            SettableMetadata(contentType: 'application/pdf'),
          );

          await uploadTask.whenComplete(() {});
          final downloadUrl = await storageRef.getDownloadURL();
          customToastBar(
            title: 'Success!',
            description: 'Certificate added successfully!',
            icon: Icon(Icons.check_circle, color: Colors.green),
          );
          return downloadUrl;
        } catch (e) {
          customToastBar(
              title: 'Error',
              description: 'Failed to upload certificate: $e',
              icon: Icon(Icons.error, color: Colors.red),
              backgroundColor: Colors.red);
          return null;
        } finally {
          controller.isCertificateUploaded.value = false;
        }
      });
    }
    return null;
  });
}

Future<void> addEducationOnPressButton(BuildContext context) async {
  TextEditingController schoolController = TextEditingController();
  TextEditingController degreeController = TextEditingController();
  TextEditingController fieldOfStudyController = TextEditingController();
  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();

  String supportingDocumentLink = "";

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Color(0xfff8f8f8),
        title: Center(
          child: customText(
              text: 'Add New Education',
              context: context,
              size: 32,
              color: Color(0xff212E50),
              fontWeight: FontWeight.w800),
        ),
        content: SingleChildScrollView(
          child: SizedBox(
            width: 500,
            child: Column(
              spacing: 8,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                    padding: EdgeInsets.only(left: 16),
                    child: Row(
                      children: [
                        Text('School'),
                        Text(
                          '*',
                          style: TextStyle(color: Colors.red),
                        ),
                      ],
                    )),
                customTextField(
                    hintText: 'School', controller: schoolController),
                Padding(
                    padding: EdgeInsets.only(left: 16),
                    child: Row(
                      children: [
                        Text('Degree'),
                        Text(
                          '*',
                          style: TextStyle(color: Colors.red),
                        ),
                      ],
                    )),
                customTextField(
                    hintText: 'Degree', controller: degreeController),
                Padding(
                    padding: EdgeInsets.only(left: 16),
                    child: Row(
                      children: [
                        Text('Field of Study'),
                        Text(
                          '*',
                          style: TextStyle(color: Colors.red),
                        ),
                      ],
                    )),
                customTextField(
                    hintText: 'Field of Study',
                    controller: fieldOfStudyController),
                Padding(
                    padding: EdgeInsets.only(left: 16),
                    child: Row(
                      children: [
                        Text('Start Date'),
                        Text(
                          '*',
                          style: TextStyle(color: Colors.red),
                        ),
                      ],
                    )),
                datePicker(
                    labelText: "Start Date",
                    hintText: 'e.g. 2020-01-01',
                    controller: startDateController,
                    context: context,
                    isDatePicker: true),
                Padding(
                    padding: EdgeInsets.only(left: 16),
                    child: Row(
                      children: [
                        Text('End Date'),
                        Text(
                          '*',
                          style: TextStyle(color: Colors.red),
                        ),
                      ],
                    )),
                datePicker(
                    labelText: "End Date",
                    hintText: "e.g. 2022-12-31",
                    controller: endDateController,
                    context: context,
                    isDatePicker: true),
                Row(
                  children: [
                    SizedBox(width: 15),
                    Icon(Icons.error_outline, color: Colors.grey),
                    SizedBox(width: 10),
                    Text(
                      'If the end date is the present, select the current date.',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                      child: InkWell(
                        overlayColor:
                            WidgetStateProperty.all(Colors.transparent),
                        hoverColor: Colors.transparent,
                        onTap: () {
                          pickSupportingDocumentWeb((link) {
                            supportingDocumentLink = link;
                            print(
                                'Updated supportingDocumentLink: $supportingDocumentLink');
                          });
                        },
                        child: Obx(
                          () => controller.isSupportingDocumentUploaded.value
                              ? loading(100)
                              : Container(
                                  width: 200,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: Color(0xFF212E50),
                                      width: 1,
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.upload_file,
                                          color: Colors.red, size: 30),
                                      SizedBox(height: 10),
                                      Text(
                                        'Upload Supporting Document*',
                                        style: TextStyle(
                                          color: Color(0xFF212E50),
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12,
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
                Obx(
                  () => Text(
                    controller.isSupportingDocumentUploaded.value
                        ? 'Uploading...'
                        : 'Uploaded File: ${fileNameForSupportingDocument ?? 'No file selected'}',
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              "Cancel",
              style: TextStyle(color: Color(0xff212E50)),
            ),
          ),
          TextButton(
            onPressed: () {
              if (schoolController.text.isEmpty ||
                  degreeController.text.isEmpty ||
                  fieldOfStudyController.text.isEmpty ||
                  startDateController.text.isEmpty ||
                  endDateController.text.isEmpty ||
                  supportingDocumentLink.isEmpty) {
                customToastBar(
                    title: 'Error',
                    description: 'Please fill all the required fields.',
                    icon: Icon(Icons.error, color: Colors.yellow));

                return;
              } else {
                controller.educationList.add({
                  'school': schoolController.text,
                  'degree': degreeController.text,
                  'fieldOfStudy': fieldOfStudyController.text,
                  'startDate': startDateController.text,
                  'endDate': endDateController.text,
                  'supportingDocumentLink': supportingDocumentLink,
                });

                schoolController.clear();
                degreeController.clear();
                fieldOfStudyController.clear();
                startDateController.clear();
                endDateController.clear();
                supportingDocumentLink = '';
                fileNameForSupportingDocument = '';
                Navigator.pop(context);
              }
            },
            child: Text(
              "Save",
              style: TextStyle(color: Color(0xff212E50)),
            ),
          ),
        ],
      );
    },
  );
}

Uint8List? pdfBytesForSupportingDocument;
String? fileNameForSupportingDocument;

Future<void> uploadSupportingDocumentToFirebase(
    void Function(String) onDownloadUrlGenerated) async {
  if (pdfBytesForSupportingDocument == null ||
      fileNameForSupportingDocument == null) {
    customToastBar(
        title: 'Note',
        description: 'Please select a file first',
        icon: Icon(Icons.error, color: Colors.yellow));

    controller.isSupportingDocumentUploaded.value = false;
    return;
  }

  try {
    final storageRef = FirebaseStorage.instance
        .ref()
        .child('supporting_documents/$fileNameForSupportingDocument');
    final uploadTask = storageRef.putData(
      pdfBytesForSupportingDocument!,
      SettableMetadata(contentType: 'application/pdf'),
    );

    await uploadTask.whenComplete(() {});

    final downloadUrl = await storageRef.getDownloadURL();
    onDownloadUrlGenerated(
        downloadUrl); // Call the callback with the download URL
    customToastBar(
        title: 'Success!',
        description: "Document uploaded successfully!",
        icon: Icon(Icons.check_circle, color: Colors.green));
  } catch (e) {
    customToastBar(
        title: 'Failed!',
        description: "Failed to upload document",
        icon: Icon(Icons.cancel, color: Colors.red, size: 20.0));
  } finally {
    controller.isSupportingDocumentUploaded.value = false;
  }
}

Future<void> pickSupportingDocumentWeb(
    void Function(String) onLinkUpdated) async {
  final html.FileUploadInputElement uploadInput = html.FileUploadInputElement()
    ..accept = 'application/pdf'; // Only allow PDFs
  uploadInput.click(); // Trigger the file selection dialog

  uploadInput.onChange.listen((event) {
    final files = uploadInput.files;
    if (files != null && files.isNotEmpty) {
      final reader = html.FileReader();
      reader.readAsArrayBuffer(files[0]);
      fileNameForSupportingDocument = files[0].name; // Store the file name

      reader.onLoadEnd.listen((_) {
        pdfBytesForSupportingDocument =
            reader.result as Uint8List; // Store the file bytes
        controller.isSupportingDocumentUploaded.value = true;
        uploadSupportingDocumentToFirebase((downloadUrl) {
          onLinkUpdated(downloadUrl); // Pass the URL to the callback
        });
      });
    }
  });
}

Widget _buildContainer(
    {required String step,
    required String title,
    required Widget content,
    required BuildContext context}) {
  return Center(
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
      decoration: BoxDecoration(
        color: Color(0xffFFFFFF),
        borderRadius: BorderRadius.circular(50),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((0.1 * 255).toInt()),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              step,
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
            SizedBox(height: 20),
            customText(
                text: title,
                context: context,
                size: 35,
                color: Color(0xff212E50),
                fontWeight: FontWeight.w800),
            SizedBox(height: 40),
            content,
          ],
        ),
      ),
    ),
  );
}
