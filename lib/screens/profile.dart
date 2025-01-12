// ignore_for_file: avoid_print, no_leading_underscores_for_local_identifiers, use_build_context_synchronously, must_be_immutable, deprecated_member_use

import 'dart:io';

import 'package:bidhouse/constants.dart';
import 'package:bidhouse/firebasehelper.dart';
import 'package:bidhouse/models/authenticationModel.dart';
import 'package:bidhouse/screens/aboutapp.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  AuthenticationModel? userData;
  ProfileScreen({super.key, required this.userData});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Color color = AppConstants.appColor;

  bool showCameraButton = true;

  @override
  void initState() {
    super.initState();
    if (widget.userData!.imageUrl != "") {
      setState(() {
        showCameraButton = false;
      });
    }
  }

  void selectImage(ImageSource source, BuildContext context) async {
    XFile? pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      cropImage(pickedFile, context);
    }
  }

  void cropImage(XFile file, BuildContext context) async {
    try {
      CroppedFile? croppedImage = await ImageCropper().cropImage(
        sourcePath: file.path,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        compressQuality: 15,
      );
      if (croppedImage != null) {
        FireBaseHelper.imageFile = File(croppedImage.path);
        Navigator.pop(context);
        forConfirmation(context);
        print("Image saved");
      } else {
        print("Cropping cancelled");
      }
    } catch (e) {
      print("Error during cropping: $e");
    }
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
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  'lib/assets/bg4.png',
                ),
                fit: BoxFit.cover,
                opacity: 0.5,
              ),
            ),
            width: MediaQuery.sizeOf(context).width,
            height: MediaQuery.sizeOf(context).height,
            padding: const EdgeInsets.all(10),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              SizedBox(
                height: MediaQuery.sizeOf(context).height * 0.05,
              ),
              Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(
                        color: AppConstants.appColor,
                      ),
                    ),
                    child: ClipOval(
                      child: widget.userData!.imageUrl != ""
                          ? Image.network(
                              widget.userData!.imageUrl!,
                              fit: BoxFit.fill,
                              height: 120,
                              width: 120,
                            )
                          : FireBaseHelper.imageFile != null
                              ? Image.asset(
                                  FireBaseHelper.imageFile!.path,
                                  fit: BoxFit.fill,
                                  height: 120,
                                  width: 120,
                                )
                              : Image.asset(
                                  'lib/assets/BidHouse.jpeg',
                                  fit: BoxFit.fill,
                                  height: 120,
                                  width: 120,
                                ),
                    ),
                  ),
                  showCameraButton
                      ? Positioned(
                          bottom: -15,
                          right: -10,
                          child: IconButton(
                            onPressed: () {
                              forProfileImage(context);
                            },
                            icon: Icon(
                              Icons.camera_alt,
                              size: 35,
                              color: AppConstants.appColor,
                            ),
                          ),
                        )
                      : Positioned(
                          bottom: -15,
                          right: -10,
                          child: Container(),
                        ),
                ],
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
                onPress: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AboutAppScreen(),
                    ),
                  );
                },
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
                              FireBaseHelper.logout(context: context);
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

  forConfirmation(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          "Confirm",
          style: TextStyle(
            color: AppConstants.appColor,
            fontWeight: FontWeight.bold,
            fontSize: 23,
          ),
        ),
        content: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "Are You Sure You Want To Use This As Your Profile Photo..?",
              style: TextStyle(fontSize: 17),
            )),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              "No",
              style: TextStyle(fontSize: 18, color: AppConstants.appColor),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              FireBaseHelper.uploadData(widget.userData!, context);
              setState(() {
                showCameraButton = false;
              });
            },
            child: Text(
              "Yes",
              style: TextStyle(fontSize: 18, color: AppConstants.appColor),
            ),
          ),
        ],
      ),
    );
  }

  forProfileImage(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          "Upload From...",
          style: TextStyle(
            color: AppConstants.appColor,
            fontWeight: FontWeight.bold,
            fontSize: 23,
          ),
        ),
        content: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppConstants.button(
                buttonWidth: 0.6,
                buttonHeight: 0.06,
                onTap: () {
                  selectImage(ImageSource.camera, context);
                },
                buttonText: "Camera",
                textSize: 20,
                context: context,
              ),
              const SizedBox(
                height: 10,
              ),
              AppConstants.button(
                buttonWidth: 0.6,
                buttonHeight: 0.06,
                onTap: () {
                  selectImage(ImageSource.gallery, context);
                },
                buttonText: "Gallery",
                textSize: 20,
                context: context,
              ),
            ],
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
