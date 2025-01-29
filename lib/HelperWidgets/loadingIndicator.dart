import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

Widget loading(double width) {
  return SizedBox(
    width: width,
    child: LoadingIndicator(
      indicatorType: Indicator.ballClipRotatePulse,
      colors: const [Color(0xff212E50), Color(0xFFCE2029)],
      strokeWidth: 2,
    ),
  );
}
