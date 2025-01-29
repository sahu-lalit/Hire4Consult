import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget customText({required String text, required BuildContext context, required double size, required Color color, FontWeight? fontWeight, double? letterSpacing}) {
  return Text(
    text,
    style: GoogleFonts.poppins(
      textStyle: Theme.of(context).textTheme.displayLarge,
      fontSize: size,
      fontWeight: fontWeight,
      color: color,
      letterSpacing: letterSpacing,
    ),
  );
}
