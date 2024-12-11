// ignore_for_file: avoid_print, no_leading_underscores_for_local_identifiers, use_build_context_synchronously, must_be_immutable

import 'package:bidhouse/constants.dart';
import 'package:bidhouse/models/authenticationModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  AuthenticationModel? userData;
  ProfileScreen({super.key, required this.userData});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Color color = AppConstants.appColor;

  Future<void> logout() async {
    Navigator.pop(context);
    FirebaseAuth.instance.signOut();
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Clear all saved data
    Navigator.popUntil(context, (route) => route.isFirst);
    Navigator.pushNamedAndRemoveUntil(
        context, '/afterlogout', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 65,
        backgroundColor: color,
        title: const Text(
          "Profile",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
        leading: Container(),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(10),
            child: Column(children: [
              SizedBox(
                height: MediaQuery.sizeOf(context).height * 0.05,
              ),
              const CircleAvatar(
                minRadius: 40.0,
                maxRadius: 70.0,
                backgroundImage: AssetImage('lib/assets/BidHouse.jpeg'),
              ),
              SizedBox(
                height: MediaQuery.sizeOf(context).height * 0.01,
              ),
              Text(
                widget.userData!.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 26,
                ),
              ),
              Text(
                widget.userData!.email,
                style: const TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 20,
                ),
              ),
              SizedBox(
                height: MediaQuery.sizeOf(context).height * 0.03,
              ),
              AppConstants.button(
                buttonWidth: 0.5,
                buttonHeight: 0.06,
                onTap: () {},
                buttonText: "Delete Profile",
                textSize: 18,
                context: context,
              ),
              SizedBox(
                height: MediaQuery.sizeOf(context).height * 0.025,
              ),
              const Divider(),
              SizedBox(
                height: MediaQuery.sizeOf(context).height * 0.035,
              ),
              ProfileListTile(
                title: "Settings",
                icon: Icons.settings,
                onPress: () {},
                endIcon: true,
              ),
              SizedBox(
                height: MediaQuery.sizeOf(context).height * 0.025,
              ),
              ProfileListTile(
                title: "Information",
                icon: Icons.info,
                onPress: () {},
                endIcon: true,
              ),
              SizedBox(
                height: MediaQuery.sizeOf(context).height * 0.025,
              ),
              ProfileListTile(
                  title: "Logout",
                  icon: Icons.logout_outlined,
                  onPress: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        backgroundColor: Colors.white,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(20),
                          ),
                        ),
                        title: const Text(
                          "Confirm",
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        content: const Text(
                          "Are you sure you want to Logout",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              "No",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: color,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              logout();
                            },
                            child: Text(
                              "Yes",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: color,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  endIcon: false,
                  textColor: Colors.red),
            ]),
          ),
        ),
      ),
    );
  }
}

class ProfileListTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onPress;
  final bool endIcon;
  final Color? textColor;

  const ProfileListTile(
      {super.key,
      required this.title,
      required this.icon,
      required this.onPress,
      required this.endIcon,
      this.textColor});

  @override
  Widget build(BuildContext context) {
    Color color = AppConstants.appColor;
    return ListTile(
      onTap: onPress,
      leading: Container(
        height: 50,
        width: 50,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: color.withOpacity(0.1)),
        child: Icon(
          icon,
          color: color,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 18, color: textColor),
      ),
      trailing: Container(
        height: 30,
        width: 30,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: endIcon ? Colors.grey.withOpacity(0.2) : null),
        child: Icon(
          endIcon ? Icons.arrow_forward_ios : null,
          size: 15,
          color: Colors.grey,
        ),
      ),
    );
  }
}
