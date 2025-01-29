// ignore: file_names
import 'package:flutter/material.dart';
import 'package:hire4consult/HelperWidgets/toastBar.dart';
import 'package:universal_html/html.dart' as html;

Widget userEducationDetails(dynamic educationString) {
  if (educationString == null || educationString!.isEmpty) {
    return Text('Not Provided');
  }
  final educationList = educationString!.split('^');
  return ListView.separated(
    physics: NeverScrollableScrollPhysics(),
    shrinkWrap: true,
    itemCount: educationList.length,
    separatorBuilder: (context, index) => Divider(thickness: 1),
    itemBuilder: (context, index) {
      final parts = educationList[index].split('|');
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDetailsSection('Institution', parts.length > 0 ? parts[0] : ''),
          _buildDetailsSection('Degree', parts.length > 1 ? parts[1] : ''),
          _buildDetailsSection(
              'Field of Study', parts.length > 2 ? parts[2] : ''),
          _buildDetailsSection(
              'Start Date', parts.length > 3 ? parts[3] : 'Not Provided'),
          _buildDetailsSection(
              'End Date', parts.length > 4 ? parts[4] : 'Not Provided'),
          if (parts.length > 5)
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 1,
                    child: Text(
                      'Supporting Document',
                     
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            final docLink = parts[5];
                            if (docLink.isNotEmpty) {
                              html.window.open(docLink, '_blank');
                            } else {
                              customToastBar(
                                  title: "Error",
                                  description: "No Document Link Found");
                            }
                          },
                          child: Icon(
                            Icons.open_in_new,
                            color: Color(0xFFCE2029),
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

        ],
      );
    },
  );
}

Widget _buildDetailsSection(String title, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 5),
    child: Row(
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
          child: Text(value),
        ),
      ],
    ),
  );
}
