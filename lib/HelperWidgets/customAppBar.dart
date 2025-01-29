import 'package:flutter/material.dart';
import 'package:hire4consult/HelperWidgets/customText.dart';

PreferredSizeWidget customAppBar({required BuildContext context, required VoidCallback? onPressForMyProfile, required VoidCallback? onPressForLogout}) {
  final double screenWidth = MediaQuery.of(context).size.width;
  
  return PreferredSize(
    preferredSize: const Size.fromHeight(70.0),
    child: AppBar(
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          Container(
            margin: const EdgeInsets.only(left: 20, top: 17),
            child: Image.asset(
              'assets/images/homeLogo.png',
              width: screenWidth * 0.15,
            ),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      elevation: 0,
      actions: [
        TextButton(
          onPressed: onPressForMyProfile,
          child: customText(
            text: 'My Profile',
            context: context,
            size: 18,
            color: const Color(0xFF212E50),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 12),
        TextButton(
          onPressed: onPressForLogout,
          child: customText(
            text: 'Log out',
            context: context,
            size: 18,
            color: const Color(0xFF212E50),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 25),
      ],
    ),
  );
}
