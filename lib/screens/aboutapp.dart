import 'package:bidhouse/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AboutAppScreen extends StatefulWidget {
  const AboutAppScreen({super.key});

  @override
  State<AboutAppScreen> createState() => _AboutAppScreenState();
}

class _AboutAppScreenState extends State<AboutAppScreen> {
  @override
  Widget build(BuildContext context) {
    Color color = AppConstants.appColor;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 65,
        backgroundColor: color,
        centerTitle: false,
        title: const Text(
          "Information",
          style: TextStyle(
            overflow: TextOverflow.ellipsis,
            fontWeight: FontWeight.bold,
            fontSize: 27,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
            child: Column(
          children: [
            ExpansionTile(
              title: Text(
                "About Us",
                style: TextStyle(
                  color: color,
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                ),
              ),
              children: const [
                Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Text(
                    "Welcome to BidHouse, your one-stop solution for smarter and more efficient home building! BidHouse revolutionizes the construction industry by integrating cost estimation, communication management, and user-friendly design tools into a single platform. Our app bridges the gap between homeowners, architects, and constructors, fostering collaboration and simplifying the construction process. With cutting-edge technologies like Flutter and Firebase, we ensure seamless real-time data synchronization, intuitive navigation, and accurate cost predictions. At BidHouse, we aim to make home building accessible, efficient, and enjoyable for everyone.",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                )
              ],
            ),
            ExpansionTile(
              title: Text(
                "Contact Us",
                style: TextStyle(
                  color: color,
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                ),
              ),
              children: const [
                Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Text(
                    "We value your feedback and are here to assist with any queries or concerns. Reach out to us using the following details: \nEmail: support@bidhouseapp.com \nPhone: +92 312 5835138 \nAddress: H-9 street 4 office no 12",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                )
              ],
            ),
            ExpansionTile(
              title: Text(
                "Terms & Privacy Policy ",
                style: TextStyle(
                  color: color,
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                ),
              ),
              children: const [
                Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Text(
                    "Terms of Service \n1. Usage Agreement: By using BidHouse, you agree to comply with our terms and conditions. \n2. Account Responsibility: Users are responsible for safeguarding their login credentials. Unauthorized use of your account must be reported immediately. \n3. Service Limitations: BidHouse may experience periodic updates or outages; we are not liable for any disruptions caused by these events. \n4. Intellectual Property: All content on the BidHouse app is the property of its creators and protected under copyright laws. \nPrivacy Policy \n1. Data Collection: BidHouse collects user data, including account details, building dimensions, and communication logs, to enhance user experience and provide accurate cost estimations. \n2. Data Security: We prioritize your privacy by employing industry-standard encryption and access controls to safeguard your information. \n3. Third-party Sharing: We do not share your personal information with third parties without your explicit consent, except as required by law. \n4. Cookies: BidHouse may use cookies to improve app functionality and user experience. \n5. User Rights: You have the right to access, modify, or delete your personal data within the app.",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                )
              ],
            ),
          ],
        )),
      ),
    );
  }
}
