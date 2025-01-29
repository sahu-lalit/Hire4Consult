import 'package:flutter/material.dart';
import 'package:universal_html/html.dart' as html;

Widget certificationDetails(dynamic certificationString) {
  if (certificationString == null || certificationString!.isEmpty) {
    return Text('Not Provided');
  }
  
  final certificationList = certificationString!.split('^');
  
  return ListView.separated(
    physics: NeverScrollableScrollPhysics(),
    shrinkWrap: true,
    itemCount: certificationList.length,
    separatorBuilder: (context, index) => Divider(thickness: 1),
    itemBuilder: (context, index) {
      final parts = certificationList[index].split('|');
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 1,
              child: Text(
                parts.isNotEmpty ? parts[0] : '',
                
              ),
            ),
            if (parts.length > 1 && parts[1].isNotEmpty)
              Expanded(
                flex: 2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        html.window.open(parts[1], '_blank');
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
      );
    },
  );
}