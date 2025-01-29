import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hire4consult/HelperWidgets/customAppBar.dart';
import 'package:hire4consult/HelperWidgets/customText.dart';
import 'package:hire4consult/HelperWidgets/editProfileTextField.dart';
import 'package:hire4consult/HelperWidgets/loadingIndicator.dart';
import 'package:hire4consult/HelperWidgets/toastBar.dart';
import 'package:hire4consult/Screens/AuthScreens/Login/login_screen.dart';
import 'package:universal_html/html.dart' as html;
import 'employer_profile_controller/employer_profile_controller.dart';

class EmployerProfile extends StatefulWidget {
  const EmployerProfile({super.key});

  @override
  State<EmployerProfile> createState() => _EmployerProfileState();
}

class _EmployerProfileState extends State<EmployerProfile> {
  @override
  void initState() {
    super.initState();
  }

  final controller = Get.put(EmployerProfileController());

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
      body: Obx(
        () => controller.userDataLoading.value == false
            ? Center(
                child: loading(200),
              )
            : Row(
                children: [
                  Expanded(
                      flex: 1,
                      child: Obx(
                        () => _goBackButton(),
                      )),
                  Expanded(
                    flex: 5,
                    child: Column(
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            child: Container(
                              margin: const EdgeInsets.only(
                                  top: 20, left: 30, right: 20),
                              padding: const EdgeInsets.all(25),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Obx(
                                    () => controller.isEditing.value
                                        ?  Row(
                                            children: [
                                              Spacer(),
                                              controller.isLoadingSave.value ? loading(70) : MouseRegion(
                                                cursor:
                                                    SystemMouseCursors.click,
                                                child: GestureDetector(
                                                  onTap: () async {
                                                    onTapButtonForUpdateDetail();
                                                  },
                                                  child: Row(
                                                    children: [
                                                      Icon(Icons.save,
                                                          color: Colors.black),
                                                      SizedBox(width: 8),
                                                      customText(
                                                        text: 'Save',
                                                        context: context,
                                                        size: 16,
                                                        color:
                                                            Color(0xff212E50),
                                                        fontWeight:
                                                            FontWeight.w800,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 25,
                                              )
                                            ],
                                          )
                                        : Row(
                                            children: [
                                              Spacer(),
                                              MouseRegion(
                                                cursor:
                                                    SystemMouseCursors.click,
                                                child: GestureDetector(
                                                  onTap: () {
                                                   
                                                    controller.isEditing.value =
                                                        true;
                                                  },
                                                  child: Row(
                                                    children: [
                                                      Icon(Icons.edit,
                                                          color: Colors.black),
                                                      SizedBox(width: 8),
                                                      customText(
                                                        text: 'Edit profile',
                                                        context: context,
                                                        size: 16,
                                                        color:
                                                            Color(0xff212E50),
                                                        fontWeight:
                                                            FontWeight.w800,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 25,
                                              )
                                            ],
                                          ),
                                  ),
                                  _headingSection(text: 'User details'),
                                  SizedBox(height: 10),
                                  _buildDetailsSection(
                                      'Name',
                                      controller.employerData?['name'],
                                      controller.nameController),
                                  _buildDetailsSection(
                                      'Phone number',
                                      controller.employerData?['phoneNumber'],
                                      controller.phoneController),
                                  _buildDetailsSection(
                                      'Designation',
                                      controller.employerData?['designation'],
                                      controller.designationController),
                                  const Divider(thickness: 1),
                                  const SizedBox(height: 10),
                                  _headingSection(text: 'Company details'),
                                  SizedBox(height: 10),
                                  _buildDetailsSection(
                                      'Company name',
                                      controller.employerData?['companyName'],
                                      controller.companyNameController),
                                  _buildDetailsSection(
                                      'Company email',
                                      controller.employerData?['companyEmail'],
                                      controller.companyEmailController),
                                  _buildDetailsSection(
                                      'Company phone number',
                                      controller.employerData?['companyPhone'],
                                      controller.companyPhoneController),
                                  _buildDetailsSection(
                                      'Company website',
                                      controller
                                          .employerData?['companyWebsite'],
                                      controller.companyWebsiteController),
                                  _buildDetailsSection(
                                      'Company GST number',
                                      controller.employerData?['companyGst'],
                                      controller.companyGstController),
                                  const Divider(thickness: 1),
                                  const SizedBox(height: 10),
                                  _headingSection(text: 'Pan card detail'),
                                  const SizedBox(height: 5),
                                  _panCardDetail(
                                      controller.employerData?['companyPan'] ??
                                          'Not Provided'),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
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

  bool validatePanCard(String panCard) {
    final panCardRegex = RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]$');
    return panCardRegex.hasMatch(panCard);
  }

  Widget _panCardDetail(dynamic panDetail) {
    List<String> panParts = panDetail.toString().split('^');
    String panNumber = panParts.isNotEmpty ? panParts[0] : 'Not Provided';
    String panCardLink = panParts.length > 1 ? panParts[1] : '';

    TextEditingController panFileNameController = TextEditingController();
    TextEditingController panNumberController =
        TextEditingController(text: panNumber);
    String? panDownloadUrl = panCardLink;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Text('Pan number'),
          ),
          Expanded(
            flex: 2,
            child: Obx(
              () => Row(
                children: [
                  controller.isEditing.value
                      ? Row(
                          children: [
                            SizedBox(
                                width: 300,
                                height: 40,
                                child: editProfileTextField(
                                    hintText: 'Pan number',
                                    controller: panNumberController)),
                          ],
                        )
                      : Text(panNumber),
                  const SizedBox(width: 16),
                  controller.isEditing.value
                      ? controller.isPanUploaded.value
                          ? loading(50)
                          : OutlinedButton(
                              style: ButtonStyle(
                                backgroundColor: WidgetStateProperty.all<Color>(
                                    Colors.white),
                                foregroundColor:
                                    WidgetStateProperty.all(Color(0xff212E50)),
                              ),
                              onPressed: () async {
                                panDownloadUrl = await pickAndUploadPanCard(
                                  pdfFileNameController: panFileNameController,
                                  setState: setState,
                                );
                                controller.companyPanController.text =
                                    '${panNumberController.text}^$panDownloadUrl';
                              },
                              child: Text('Upload PAN Card',
                                  style: GoogleFonts.quicksand(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: 1)),
                            )
                      : TextButton.icon(
                          onPressed: () =>
                              html.window.open(panCardLink, '_blank'),
                          icon: const Icon(Icons.visibility, size: 16),
                          label: const Text('View PAN Card'),
                        ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _headingSection({required String text}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          text,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
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

  Widget _buildDetailsSection(
      String title, String value, TextEditingController? editingController) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Obx(
        () => Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: Text(
                title,
              ),
            ),
            Expanded(
              flex: 2,
              child: controller.isEditing.value
                  ? Row(
                      children: [
                        SizedBox(
                            width: 300,
                            height: 40,
                            child: editProfileTextField(
                                hintText: title,
                                controller: editingController)),
                      ],
                    )
                  : Text(value),
            ),
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

  Future<void> onTapButtonForUpdateDetail() async {
    controller.isLoadingSave.value = true;
    if (controller.nameController.text.isEmpty ||
        controller.phoneController.text.isEmpty ||
        controller.designationController.text.isEmpty) {
      customToastBar(
          title: "Error",
          description: "Please fill all the required fields.",
          icon: Icon(Icons.error, color: Colors.yellow));
      controller.isLoadingSave.value = false;
      return;
    }

    final phoneValidationError =
        validatePhoneNumber(controller.phoneController.text);
    if (phoneValidationError != null) {
      customToastBar(
          title: "Error",
          description: phoneValidationError,
          icon: Icon(Icons.error, color: Colors.redAccent));
      controller.isLoadingSave.value = false;
      return;
    }

    if (controller.companyNameController.text.trim().isEmpty ||
        controller.companyEmailController.text.trim().isEmpty ||
        controller.companyPhoneController.text.trim().isEmpty) {
      customToastBar(
          title: "Error",
          description: "Please fill all the required fields.",
          icon: Icon(Icons.error, color: Colors.yellow));
      controller.isLoadingSave.value = false;
      return;
    }

    final emailValidationError =
        validateEmail(controller.companyEmailController.text);
    if (emailValidationError == false) {
      customToastBar(
          title: "Error",
          description: "Please enter a valid email",
          icon: Icon(Icons.error, color: Colors.redAccent));
      controller.isLoadingSave.value = false;
      return;
    }

    final phoneValidationErrorCompany =
        validatePhoneNumber(controller.companyPhoneController.text);
    if (phoneValidationErrorCompany != null) {
      customToastBar(
          title: "Error",
          description: phoneValidationErrorCompany,
          icon: Icon(Icons.error, color: Colors.redAccent));
      controller.isLoadingSave.value = false;
      return;
    }
    final companyWebsite = controller.companyWebsiteController.text;

    final companyPan = controller.companyPanController.text;

    final companyGst = controller.companyGstController.text;

    if (companyWebsite.isEmpty || companyPan.isEmpty || companyGst.isEmpty) {
      customToastBar(
          title: "Error",
          description: "Please fill all the required fields.",
          icon: Icon(Icons.error, color: Colors.yellow));
      controller.isLoadingSave.value = false;
      return;
    }

    if (validateUrl(companyWebsite) != null) {
      customToastBar(
          title: "Error",
          description: "Please enter a valid company website URL.",
          icon: Icon(Icons.error, color: Colors.yellow));
      controller.isLoadingSave.value = false;
      return;
    }

    if (!validateGst(companyGst)) {
      customToastBar(
          title: "Error",
          description: "Please enter a valid GST number.",
          icon: Icon(Icons.error, color: Colors.yellow));
      controller.isLoadingSave.value = false;
      return;
    }
    await controller.saveProfile();
  }
}
