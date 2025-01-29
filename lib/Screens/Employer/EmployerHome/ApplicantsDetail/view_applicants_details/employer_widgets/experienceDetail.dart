import 'package:flutter/material.dart';

Widget experienceDetail(dynamic experienceString) {
  if (experienceString == null || experienceString!.isEmpty) {
    return Text('Not Provided');
  }

  final experienceList = experienceString!.split('#');

  return ListView.builder(
    physics: NeverScrollableScrollPhysics(),
    shrinkWrap: true,
    itemCount: experienceList.length,
    itemBuilder: (context, index) {
      final parts = experienceList[index].split('@');
      return Column(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailsSection('Role', parts.length > 0 ? parts[0] : ''),
              _buildDetailsSection('Employment Type', parts.length > 1 ? parts[1] : ''),
              _buildDetailsSection(
                  'Company Name', parts.length > 2 ? parts[2] : ''),
              _buildDetailsSection(
                  'Start Date', parts.length > 3 ? parts[3] : 'Not Provided'),
              _buildDetailsSection(
                  'End Date', parts.length > 4 ? parts[4] : 'Not Provided'),
            ],
          ),
          if (index < experienceList.length - 1 && experienceList.length > 1)
            Divider(thickness: 1),
         
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
