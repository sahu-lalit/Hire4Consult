import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hire4consult/HelperWidgets/CustomDropdown.dart';
import 'package:hire4consult/HelperWidgets/CustomElevatedButton.dart';
import 'package:hire4consult/HelperWidgets/CustomTextField.dart';
import 'package:hire4consult/HelperWidgets/constant.dart';
import 'package:hire4consult/HelperWidgets/customText.dart';
import 'package:hire4consult/HelperWidgets/loadingIndicator.dart';
import 'package:hire4consult/HelperWidgets/toastBar.dart';
import 'package:universal_html/html.dart' as html;
import 'controllers/consult_intro_controller.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'widgets/buildPage1.dart';
import 'widgets/buildPage2.dart';
import 'widgets/buildPage3.dart';
import 'widgets/buildPage4.dart';

class ConsultIntroduction extends StatefulWidget {
  const ConsultIntroduction({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ConsultIntroductionState createState() => _ConsultIntroductionState();
}

class _ConsultIntroductionState extends State<ConsultIntroduction> {
  final PageController pageController = PageController(initialPage: 0);
  int _currentPage = 0;
  List<String> imageArray = [
    "assets/images/consultIntro/IntroConsult1.jpg",
    "assets/images/consultIntro/IntroConsult2.jpg",
    "assets/images/consultIntro/IntroConsult3.jpg",
    "assets/images/consultIntro/IntroConsult4.jpg",
    "assets/images/consultIntro/IntroConsult5.jpg"
  ];

  final controller = Get.put(ConsultIntroController());
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
          child: Stack(
        children: [
          Obx(
            () => Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(imageArray[controller
                      .imageIndex.value]), // Replace with your background image
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.black.withAlpha((.5 * 255).toInt()),
                      Colors.black.withAlpha((.3 * 255).toInt()),
                      Colors.black.withAlpha((.0 * 255).toInt()),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 50, top: 50),
            child: Align(
              alignment: Alignment.topLeft,
              child: _currentPage > 0
                  ? IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: Color(0xffFFFFFF),
                        size: 30,
                      ),
                      onPressed: _currentPage > 0
                          ? () {
                              pageController.previousPage(
                                duration: Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            }
                          : null,
                    )
                  : Container(),
            ),
          ),
          Center(
            child: SizedBox(
              width: width / 3,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20),
                      Expanded(
                        child: PageView(
                          controller: pageController,
                          onPageChanged: (index) {
                            setState(() {
                              _currentPage = index;
                              controller.imageIndex.value = index;
                            });
                          },
                          children: [
                            buildPage1(pageController, context),
                            buildPage2(pageController, context),
                            buildPage3(pageController, context),
                            buildPage4(pageController, context),
                            _buildPage5()
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
      )),
    );
  }

  

  Widget _buildPage5() {
    return _buildContainer(
      step: "Step 5/5",
      title: "Upload your docs and provide profile link",
      content: Column(
        spacing: 8,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
              padding: EdgeInsets.only(left: 16),
              child: Row(
                children: [
                  Text('Select Platform'),
                  Text(
                    '*',
                    style: TextStyle(color: Colors.red),
                  ),
                ],
              )),
          customDropdown(
              items: listPlatforms,
              hintText: "Select Platform",
              controller: controller.addSocialMediaPlatformController),
          Padding(
              padding: EdgeInsets.only(left: 16),
              child: Row(
                children: [
                  Text('Enter Platform Profile Link'),
                  Text(
                    '*',
                    style: TextStyle(color: Colors.red),
                  ),
                ],
              )),
          customTextField(
              hintText: "Enter Platform Profile Link",
              controller: controller.addSocialMediaLinkController),
          Padding(
              padding: EdgeInsets.only(left: 16),
              child: Row(
                children: [
                  Text('Upload your CV/Resume'),
                  Text(
                    '*',
                    style: TextStyle(color: Colors.red),
                  ),
                ],
              )),
          _buildUploadButton(),
          if (pdfBytes != null) ...[
            SizedBox(height: 10),
            Text(controller.isResumeUploaded.value
                ? 'Uploading...'
                : 'Uploaded File: $fileName'),
            SizedBox(height: 20),
            TextButton.icon(
              onPressed: () {
                final blob = html.Blob([pdfBytes!], 'application/pdf');
                final url = html.Url.createObjectUrlFromBlob(blob);
                html.window.open(url, '_blank');
                html.Url.revokeObjectUrl(url);
              },
              icon: const Icon(Icons.visibility, size: 16),
              label: const Text('View'),
            ),
          ],
          SizedBox(height: 25),
          Center(
            child: Obx(
              () => controller.submitButtonLoading.value
                  ? loading(100)
                  : customElevatedButton(
                      onPress: () async {
                        controller.submitButtonLoading.value = true;
                        if (controller.addSocialMediaPlatformController.text
                                .isEmpty ||
                            controller
                                .addSocialMediaLinkController.text.isEmpty) {
                          customToastBar(
                              title: "Error",
                              description:
                                  "Please fill all the required fields.",
                              icon: Icon(Icons.error, color: Colors.yellow));

                          controller.submitButtonLoading.value = false;
                        } else if (controller.resumeLink.isEmpty) {
                          customToastBar(
                              title: "Error",
                              description: "Please upload your resume.",
                              icon: Icon(Icons.error, color: Colors.yellow));
                          controller.submitButtonLoading.value = false;
                        } else {
                          final phoneLinkError = validateUrl(
                              controller.addSocialMediaLinkController.text);
                          if (phoneLinkError != null) {
                            customToastBar(
                                title: "Error",
                                description: phoneLinkError,
                                icon:
                                    Icon(Icons.error, color: Colors.redAccent));
                            controller.submitButtonLoading.value = false;
                            return;
                          }

                          await controller.saveUserProfile();
                        }
                      },
                      buttonText: 'Submit',
                      backgroundColor: Color(0xff212E50),
                    ),
            ),
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildContainer(
      {required String step, required String title, required Widget content}) {
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

  Uint8List? pdfBytes;
  String? fileName;

  Future<void> pickResumeWeb() async {
    final html.FileUploadInputElement uploadInput =
        html.FileUploadInputElement()
          ..accept = 'application/pdf'; // Only allow PDFs
    uploadInput.click(); // Trigger the file selection dialog

    uploadInput.onChange.listen((event) {
      final files = uploadInput.files;
      if (files != null && files.isNotEmpty) {
        final reader = html.FileReader();
        reader.readAsArrayBuffer(files[0]);
        fileName = files[0].name; // Store the file name

        reader.onLoadEnd.listen((_) {
          setState(() {
            pdfBytes = reader.result as Uint8List; // Store the file bytes
            controller.isResumeUploaded.value = true;
            uploadResumeToFirebase();
          });
        });
      }
    });
  }

  // Method to upload the file to Firebase Storage
  Future<void> uploadResumeToFirebase() async {
    if (pdfBytes == null || fileName == null) {
      customToastBar(
          title: 'Note: ',
          description: 'Please select a file first',
          icon: Icon(Icons.error, color: Colors.yellow));
      controller.isResumeUploaded.value = false;
      return;
    }

    try {
      final storageRef =
          FirebaseStorage.instance.ref().child('resumes/$fileName');
      final uploadTask = storageRef.putData(
          pdfBytes!, SettableMetadata(contentType: 'application/pdf'));

      await uploadTask.whenComplete(() {});

      final downloadUrl = await storageRef.getDownloadURL();

      setState(() {
        controller.resumeLinkController.text = downloadUrl;
      });
      controller.resumeLink.value = downloadUrl;
      customToastBar(
          title: 'Success!',
          description: 'Resume uploaded successfully!',
          icon: Icon(Icons.check_circle, color: Colors.green));
    } catch (e) {
      customToastBar(
          title: 'Error',
          description: 'Failed to upload resume',
          icon: Icon(Icons.error, color: Colors.red));
    } finally {
      controller.isResumeUploaded.value = false;
    }
  }

  Widget _buildUploadButton() {
    return GestureDetector(
      onTap: pickResumeWeb,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 30),
        height: 60,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(50),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Upload document (max 2 MB)",
              style: TextStyle(color: Colors.black),
            ),
            Icon(Icons.upload_file, color: Colors.black),
          ],
        ),
      ),
    );
  }
}
