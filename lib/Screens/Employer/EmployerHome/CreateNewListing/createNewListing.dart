import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hire4consult/HelperWidgets/CustomElevatedButton.dart';
import 'package:hire4consult/HelperWidgets/CustomTextField.dart';
import 'package:hire4consult/HelperWidgets/customText.dart';

import '../employer_home.dart';
import 'create_new_listing_controller/create_new_listing_controller.dart';
import 'widgets/buildPage1.dart';
import 'widgets/buildPage2.dart';
import 'widgets/buildPage3.dart';

class Createnewlisting extends StatefulWidget {
  const Createnewlisting({super.key});

  @override
  State<Createnewlisting> createState() => _CreatenewlistingState();
}

class _CreatenewlistingState extends State<Createnewlisting> {
  final PageController pageController = PageController(initialPage: 0);
  int _currentPage = 0;
  List<String> imageArray = [
    "assets/images/consultIntro/IntroConsult1.jpg",
    "assets/images/consultIntro/IntroConsult2.jpg",
    "assets/images/consultIntro/IntroConsult3.jpg",
    "assets/images/consultIntro/IntroConsult4.jpg",
  ];



  final controller = Get.put(CreateNewListingController());
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
                            _buildPage4(),
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

  Widget _buildPage4() {
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
              Icon(Icons.verified, size: 100, color: Colors.green),
              SizedBox(height: 30),
              customText(
                  text: "Job Listed \nsuccessfully!",
                  context: context,
                  size: 40,
                  color: Color(0xff212E50),
                  fontWeight: FontWeight.w800),
            ],
          ),
        ),
      ),
    );
  }

}
