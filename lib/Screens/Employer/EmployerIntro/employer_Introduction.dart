import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hire4consult/HelperWidgets/CustomElevatedButton.dart';
import 'package:hire4consult/HelperWidgets/CustomTextField.dart';
import 'package:hire4consult/HelperWidgets/customText.dart';
import 'package:hire4consult/HelperWidgets/loadingIndicator.dart';
import 'package:hire4consult/HelperWidgets/toastBar.dart';
import 'package:universal_html/html.dart' as html;

import 'controllers/employer_intro_controller.dart';

class EmployerIntroduction extends StatefulWidget {
  const EmployerIntroduction({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _EmployerIntroductionState createState() => _EmployerIntroductionState();
}

class _EmployerIntroductionState extends State<EmployerIntroduction> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;
  List<String> imageArray = [
    "assets/images/consultIntro/IntroConsult1.jpg",
    "assets/images/consultIntro/IntroConsult2.jpg",
    "assets/images/consultIntro/IntroConsult3.jpg",
  ];

  final controller = Get.put(EmployerIntroController());
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
                  image: AssetImage(imageArray[controller.imageIndex.value]),
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
                              _pageController.previousPage(
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
                          controller: _pageController,
                          onPageChanged: (index) {
                            setState(() {
                              _currentPage = index;
                              controller.imageIndex.value = index;
                            });
                          },
                          children: [
                            _buildPage1(),
                            _buildPage2(),
                            _buildPage3(),
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

  bool validateGst(String gst) {
    final gstRegex = RegExp(
        r'^[0-9]{2}[A-Z]{5}[0-9]{4}[A-Z]{1}[A-Z0-9]{1}[Z]{1}[0-9A-Z]{1}$');
    return gstRegex.hasMatch(gst);
  }

  bool validateEmail(String email) {
    final emailRegex =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return emailRegex.hasMatch(email);
  }
// Future<bool> companyValidateEmail(String email, String companyName) async {
//   // Validate email format
//   final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@([a-zA-Z0-9-]+\.[a-zA-Z]{2,})$');
//   if (!emailRegex.hasMatch(email)) return false;

//   try {
//     // Get company domains from Firestore
//     final doc = await FirebaseFirestore.instance
//         .collection('companies')
//         .doc(companyName)
//         .get();

//     if (!doc.exists) return false;

//     final domains = List<String>.from(doc['domains'] ?? [])
//         .map((d) => d.toLowerCase())
//         .toList();

//     // Extract domain from email
//     final emailDomain = email.split('@').last.toLowerCase();

//     return domains.contains(emailDomain);
//   } catch (e) {
//     print('Error validating email: $e');
//     return false;
//   }
// }

  bool validatePanCard(String panCard) {
    final panCardRegex = RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]$');
    return panCardRegex.hasMatch(panCard);
  }

  Widget _buildPage1() {
    return _buildContainer(
      step: "Step 1/3",
      title: "Tell us about yourself",
      content: Column(
        spacing: 8,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
              padding: EdgeInsets.only(left: 16),
              child: Row(
                children: [
                  Text('Full Name'),
                  Text(
                    '*',
                    style: TextStyle(color: Colors.red),
                  ),
                ],
              )),
          customTextField(
              hintText: "Full Name", controller: controller.nameController),
          Padding(
              padding: EdgeInsets.only(left: 16),
              child: Row(
                children: [
                  Text('Phone Number'),
                  Text(
                    '*',
                    style: TextStyle(color: Colors.red),
                  ),
                ],
              )),
          customTextField(
            hintText: "Phone Number",
            controller: controller.phoneController,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
          ),
          Padding(
              padding: EdgeInsets.only(left: 16),
              child: Row(
                children: [
                  Text('Desingnation'),
                  Text(
                    '*',
                    style: TextStyle(color: Colors.red),
                  ),
                ],
              )),
          customTextField(
              hintText: "Desingnation",
              controller: controller.designationController),
          SizedBox(height: 25),
          Center(
              child: customElevatedButton(
                  onPress: () {
                    if (controller.nameController.text.isEmpty ||
                        controller.phoneController.text.isEmpty ||
                        controller.designationController.text.isEmpty) {
                      customToastBar(
                          title: "Error",
                          description: "Please fill all the required fields.",
                          icon: Icon(Icons.error, color: Colors.yellow));
                      return;
                    }

                    final phoneValidationError =
                        validatePhoneNumber(controller.phoneController.text);
                    if (phoneValidationError != null) {
                      customToastBar(
                          title: "Error",
                          description: phoneValidationError,
                          icon: Icon(Icons.error, color: Colors.redAccent));
                      return;
                    }

                    _pageController.nextPage(
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

  Widget _buildPage2() {
    return _buildContainer(
      step: "Step 2/3",
      title: "Add your company details",
      content: Column(
        spacing: 8,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
              padding: EdgeInsets.only(left: 16),
              child: Row(
                children: [
                  Text('Company Name'),
                  Text(
                    '*',
                    style: TextStyle(color: Colors.red),
                  ),
                ],
              )),
          customTextField(
              hintText: "Company Name",
              controller: controller.companyNameController),
          Padding(
              padding: EdgeInsets.only(left: 16),
              child: Row(
                children: [
                  Text('Company Email'),
                  Text(
                    '*',
                    style: TextStyle(color: Colors.red),
                  ),
                ],
              )),
          customTextField(
              hintText: "Company Email",
              controller: controller.companyEmailController),
          Padding(
              padding: EdgeInsets.only(left: 16),
              child: Row(
                children: [
                  Text('Company Phone Number'),
                  Text(
                    '*',
                    style: TextStyle(color: Colors.red),
                  ),
                ],
              )),
          customTextField(
            hintText: "Company Phone Number",
            controller: controller.companyPhoneController,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
          ),
          SizedBox(height: 25),
          Center(
              child: customElevatedButton(
                  onPress: () {
                    if (controller.companyNameController.text.trim().isEmpty ||
                        controller.companyEmailController.text.trim().isEmpty ||
                        controller.companyPhoneController.text.trim().isEmpty) {
                      customToastBar(
                          title: "Error",
                          description: "Please fill all the required fields.",
                          icon: Icon(Icons.error, color: Colors.yellow));
                      return;
                    }

                    final emailValidationError =
                        validateEmail(controller.companyEmailController.text);
                    if (emailValidationError == false) {
                      customToastBar(
                          title: "Error",
                          description: "Please enter a valid email",
                          icon: Icon(Icons.error, color: Colors.redAccent));
                      return;
                    }

                    final phoneValidationError = validatePhoneNumber(
                        controller.companyPhoneController.text);
                    if (phoneValidationError != null) {
                      customToastBar(
                          title: "Error",
                          description: phoneValidationError,
                          icon: Icon(Icons.error, color: Colors.redAccent));
                      return;
                    }
                    _pageController.nextPage(
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

  Widget _buildPage3() {
    return _buildContainer(
      step: "Step 3/3",
      title: "We’re almost done!",
      content: Column(
        spacing: 8,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
              padding: EdgeInsets.only(left: 16),
              child: Row(
                children: [
                  Text('Company Website Link'),
                  Text(
                    '*',
                    style: TextStyle(color: Colors.red),
                  ),
                ],
              )),
          customTextField(
              hintText: "Company Website Link",
              controller: controller.companyWebsiteController),
          Padding(
              padding: EdgeInsets.only(left: 16),
              child: Row(
                children: [
                  Text('Company PAN'),
                  // Text(
                  //   '*',
                  //   style: TextStyle(color: Colors.red),
                  // ),
                ],
              )),
          _buildUploadButton(),
          Padding(
              padding: EdgeInsets.only(left: 16),
              child: Row(
                children: [
                  Text('Company GST Number'),
                  // Text(
                  //   '*',
                  //   style: TextStyle(color: Colors.red),
                  // ),
                ],
              )),
          customTextField(
              hintText: "Company GST Number",
              controller: controller.companyGstController),
          SizedBox(height: 25),
          Center(
            child: Obx(
              () => controller.isLoadingSubmitButton.value
                  ? loading(100)
                  : customElevatedButton(
                      onPress: () async {
                        controller.isLoadingSubmitButton.value = true;
                        final companyWebsite =
                            controller.companyWebsiteController.text;

                        final companyPan = controller.companyPanController.text;

                        final companyGst = controller.companyGstController.text;

                        if (companyWebsite.isEmpty ) {
                          customToastBar(
                              title: "Error",
                              description:
                                  "Please fill all the required fields.",
                              icon: Icon(Icons.error, color: Colors.yellow));
                          controller.isLoadingSubmitButton.value = false;

                          return;
                        }

                        if (companyWebsite.isNotEmpty && validateUrl(companyWebsite) != null) {
                          customToastBar(
                              title: "Error",
                              description:
                                  "Please enter a valid company website URL.",
                              icon: Icon(Icons.error, color: Colors.yellow));
                          controller.isLoadingSubmitButton.value = false;
                          return;
                        }

                        if (companyGst.isNotEmpty && !validateGst(companyGst)) {
                          customToastBar(
                              title: "Error",
                              description: "Please enter a valid GST number.",
                              icon: Icon(Icons.error, color: Colors.yellow));
                          controller.isLoadingSubmitButton.value = false;

                          return;
                        }
                        await controller.saveEmployerUserProfile();
                      },
                      buttonText: 'Submit',
                      backgroundColor: Color(0xff212E50)),
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

  Widget _buildUploadButton() {
    return GestureDetector(
      onTap: () async {
        await _uploadPanCardDialog();
      },
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
              "Upload PAN (max 2 MB)",
              style: TextStyle(color: Colors.black),
            ),
            Icon(Icons.upload_file, color: Colors.black),
          ],
        ),
      ),
    );
  }

  Future<String?> pickAndUploadPanCard({
    required TextEditingController pdfFileNameController,
    required void Function(void Function()) setState,
  }) async {
    final html.FileUploadInputElement uploadInput =
        html.FileUploadInputElement()..accept = 'application/pdf';

    uploadInput.click();
    return await uploadInput.onChange.first.then((event) async {
      final files = uploadInput.files;
      if (files != null && files.isNotEmpty) {
        controller.isPanUploaded.value = true;
        pdfFileNameController.text = files[0].name;

        final reader = html.FileReader();
        reader.readAsArrayBuffer(files[0]);
        String fileName = files[0].name;

        return reader.onLoadEnd.first.then((_) async {
          final Uint8List fileBytes = reader.result as Uint8List;

          try {
            final storageRef =
                FirebaseStorage.instance.ref().child('pan_cards/$fileName');
            final uploadTask = storageRef.putData(
              fileBytes,
              SettableMetadata(contentType: 'application/pdf'),
            );

            await uploadTask.whenComplete(() {});
            final downloadUrl = await storageRef.getDownloadURL();
            customToastBar(
                title: "Success!",
                description: "PAN Card added successfully!",
                icon: Icon(Icons.check_circle, color: Colors.green));

            return downloadUrl;
          } catch (e) {
            customToastBar(
                title: "Error",
                description: "Failed to upload PAN Card: $e",
                icon: Icon(Icons.error, color: Colors.red));
            return null;
          } finally {
            controller.isPanUploaded.value = false;
          }
        });
      }
      return null;
    });
  }

  Future<dynamic> _uploadPanCardDialog() {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController panNumberController = TextEditingController();
        TextEditingController panFileNameController = TextEditingController();
        String? panDownloadUrl;

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Color(0xfff1f1f1),
              title: Center(
                child: customText(
                    text: 'Add Pan Card',
                    context: context,
                    size: 35,
                    color: Color(0xff212E50),
                    fontWeight: FontWeight.w800),
              ),
              content: SizedBox(
                width: 400,
                child: Column(
                  spacing: 8,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                        padding: EdgeInsets.only(left: 16),
                        child: Row(
                          children: [
                            Text('Company PAN Number'),
                            Text(
                              '*',
                              style: TextStyle(color: Colors.red),
                            ),
                          ],
                        )),
                    customTextField(
                        hintText: "e.g. ABCDE1234F",
                        controller: panNumberController),
                    SizedBox(height: 16),
                    InkWell(
                      onTap: () async {
                        panDownloadUrl = await pickAndUploadPanCard(
                          pdfFileNameController: panFileNameController,
                          setState: setState,
                        );
                      },
                      child: Obx(
                        () => controller.isPanUploaded.value
                            ? loading(100)
                            : Container(
                                width: 250,
                                height: 100,
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: Color(0xFF212E50),
                                    width: 1,
                                  ),
                                ),
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.upload_file,
                                          color: Colors.red),
                                      SizedBox(width: 10),
                                      Text(
                                        'Upload PAN Card',
                                        style: TextStyle(
                                          color: Color(0xFF212E50),
                                          fontWeight: FontWeight.w600,
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
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    "Cancel",
                    style: TextStyle(color: Color(0xFF212E50)),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    if (panNumberController.text.isEmpty ||
                        panDownloadUrl == null) {
                      customToastBar(
                          title: 'Note:',
                          description: 'Please fill all the required fields.',
                          icon: Icon(Icons.error, color: Colors.yellow));
                      return;
                    }

                    if (validatePanCard(panNumberController.text) == false) {
                      customToastBar(
                          title: "Error",
                          description: "Please enter a valid PAN number",
                          icon: Icon(Icons.error, color: Colors.red));
                      return;
                    }

                    controller.companyPanController.text =
                        '${panNumberController.text}^$panDownloadUrl';


                    Navigator.pop(context);
                  },
                  child: Text(
                    "Save",
                    style: TextStyle(color: Color(0xFF212E50)),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
