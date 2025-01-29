import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

ToastificationItem customToastBar({required String title, required String description, Icon ? icon, Color ? primaryColor, Color ? backgroundColor, Color ? foregroundColor}) {
  return toastification.show(
    style: ToastificationStyle.flatColored,
    title: Text(
      title,
      style: TextStyle(color: Color(0xff212E50), fontWeight: FontWeight.bold),
    ),
    description: Text(
      description,
      style: TextStyle(color: Color(0xff212E50)),
    ),
    autoCloseDuration: const Duration(seconds: 3),
    alignment: Alignment.topRight,
    dragToClose: true,
    icon: icon,
    showIcon: true, // show or hide the icon
    primaryColor:Colors.white,
    backgroundColor:backgroundColor?? Colors.grey[200],
    foregroundColor: foregroundColor ?? Colors.black,
    progressBarTheme: ProgressIndicatorThemeData(
      color: Color(0xffCE2029),
      linearTrackColor: Colors.white,
    )
  );
}