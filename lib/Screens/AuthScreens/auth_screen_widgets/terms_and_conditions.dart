import 'package:flutter/material.dart';

Future<void> showDialogForTermsAndConditions(BuildContext context) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        title: Center(
          child: Text(
            'Privacy Policy',
            style: TextStyle(
              fontSize: 32,
              color: const Color(0xff212E50),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        content: ScrollbarTheme(
          data: ScrollbarThemeData(
            thumbColor: WidgetStateProperty.all(
                Color(0xFFCE2029)), // Change scrollbar color
            trackColor:
                WidgetStateProperty.all(Color(0xff212E50)), // Track color
            radius: Radius.circular(8),
          ),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildLastUpdated(),
                _buildSection('Introduction', '''
            BralJobs PVT LTD. ("we," "our," or "us") values your privacy and is committed to protecting the personal data you share with us. This Privacy Policy explains how we collect, use, store, and protect your personal information when you visit our website www.hire4consult.com (the "Site").
            
            By using our Site, you agree to the collection and use of information in accordance with this Privacy Policy.
                  '''),
                _buildSection('1. Information We Collect', '''
            We may collect the following types of information when you use our Site:
                  '''),
                _buildBulletPoint(
                    'Personal Identifiable Information (PII): This includes, but is not limited to, your name, email address, phone number, and any other information you voluntarily provide when filling out forms, subscribing to newsletters, or interacting with our services.'),
                _buildBulletPoint(
                    'Non-Personal Identifiable Information: This includes data about your device, browser type, IP address, location data, browsing behavior, and any other usage data collected through cookies and similar technologies.'),
                _buildBulletPoint(
                    'Payment Information: If you make a purchase or transaction on our Site, we may collect billing information (such as credit card details) through secure payment processors.'),
                _buildSection('2. How We Use Your Information', '''
            We use your information for various purposes, including but not limited to:
                  '''),
                _buildBulletPoint(
                    'Providing, improving, and personalizing our services.'),
                _buildBulletPoint(
                    'Communicating with you, including responding to inquiries and sending marketing or promotional materials.'),
                _buildBulletPoint(
                    'Processing payments and fulfilling transactions.'),
                _buildBulletPoint(
                    'Analyzing usage trends to improve the functionality of the Site.'),
                _buildBulletPoint(
                    'Complying with legal obligations and protecting our rights.'),
                _buildSection('3. How We Share Your Information', '''
            We do not sell, trade, or otherwise transfer your personal information to outside parties, except in the following cases:
                  '''),
                _buildBulletPoint(
                    'Service Providers: We may share your information with third-party vendors and service providers who assist us in running our business (e.g., payment processors, hosting providers, email marketing platforms) and are required to maintain confidentiality.'),
                _buildBulletPoint(
                    'Legal Compliance: We may disclose your information when required to do so by law or in response to a subpoena, court order, or legal process.'),
                _buildBulletPoint(
                    'Business Transfers: In the event of a merger, acquisition, or sale of assets, your information may be transferred as part of that transaction.'),
                _buildSection('4. Cookies and Tracking Technologies', '''
            We use cookies and similar tracking technologies (e.g., web beacons, analytics tools) to enhance your experience on the Site. Cookies help us analyze Site usage, improve functionality, and customize content and advertisements.
            
            You can control cookie settings through your browser preferences or by using third-party tools. Please note that disabling cookies may affect your experience on the Site.
                  '''),
                _buildSection('5. Data Retention', '''
            We retain your personal information only as long as necessary for the purposes outlined in this Privacy Policy, or as required by law. Once your data is no longer needed, we will securely delete or anonymize it.
                  '''),
                _buildSection('6. Security of Your Information', '''
            We take reasonable steps to protect your personal data from unauthorized access, use, or disclosure. However, no method of data transmission over the internet or electronic storage is 100% secure. While we strive to use commercially acceptable means to protect your information, we cannot guarantee its absolute security.
                  '''),
                _buildSection('7. Your Data Protection Rights', '''
            Depending on your location, you may have certain rights regarding your personal data, including:
                  '''),
                _buildBulletPoint(
                    'Access: You may request access to the personal information we hold about you.'),
                _buildBulletPoint(
                    'Correction: You may request that we correct any inaccuracies in your personal data.'),
                _buildBulletPoint(
                    'Deletion: You may request that we delete your personal data, subject to certain legal exceptions.'),
                _buildBulletPoint(
                    'Opt-Out: You can opt out of receiving marketing communications from us at any time by following the unsubscribe instructions in our emails or contacting us directly.\n\nTo exercise these rights, please contact us at info@hire4consult.com'),
                _buildSection('8. Third-Party Links', '''
            Our Site may contain links to third-party websites that are not operated or controlled by us. This Privacy Policy does not apply to those sites, and we are not responsible for their privacy practices. We encourage you to review the privacy policies of any third-party websites you visit.
                  '''),
                _buildSection('9. Children’s Privacy', '''
            Our Site is not intended for children under the age of 13. We do not knowingly collect or solicit personal information from children. If we learn that we have collected personal information from a child under 13, we will take steps to delete that information as soon as possible.
                  '''),
                _buildSection('10. Changes to This Privacy Policy', '''
            We may update our Privacy Policy from time to time. When we do, we will post the updated policy on this page with a new "Last Updated" date. We encourage you to review this Privacy Policy periodically to stay informed about how we are protecting your information.
                  '''),
                _buildSection('11. Contact Us', '''
            If you have any questions or concerns about this Privacy Policy or our data practices, please contact us at:
            
            BralJobs PVT LTD.
            Email: info@hire4consult.com
                  '''),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close', style: TextStyle(fontSize: 18)),
          ),
        ],
      );
    },
  );
}

Widget _buildSection(String title, String content) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const SizedBox(height: 16),
      Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Color(0xff212E50),
        ),
      ),
      const SizedBox(height: 8),
      Text(
        content,
        textAlign: TextAlign.justify,
      ),
    ],
  );
}

Widget _buildBulletPoint(String text) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('• '),
        Expanded(child: Text(text)),
      ],
    ),
  );
}

Widget _buildLastUpdated() {
  return const Padding(
    padding: EdgeInsets.only(bottom: 16.0),
    child: Text(
      'Last updated: 29-01-2025',
      style: TextStyle(
        fontStyle: FontStyle.italic,
        color: Colors.grey,
      ),
    ),
  );
}
