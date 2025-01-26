// ignore_for_file: use_build_context_synchronously, avoid_print, prefer_const_constructors

import 'package:bidhouse/constants.dart';
import 'package:bidhouse/dataValidatinHelper.dart';
import 'package:bidhouse/firebasehelper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  Color color = AppConstants.appColor;
  TextEditingController emailController = TextEditingController(),
      passwordController = TextEditingController(),
      forgotPasswordController = TextEditingController();
  bool show = false;

  passwordToggler() {
    setState(() {
      show = !show;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                children: [
                  SizedBox(
                    height: 40,
                  ),
                  Center(
                    child: CircleAvatar(
                      minRadius: 40.0,
                      maxRadius: 70.0,
                      backgroundImage: AssetImage('lib/assets/BidHouse.jpeg'),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Welcome".toUpperCase(),
                    style: TextStyle(
                      //fontFamily: "SingleDay",
                      fontSize: 25,
                      letterSpacing: 2,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                  Text(
                    "Please Enter Your Credentials To Continue",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  AppConstants.inputField(
                    label: "Email",
                    hintText: "Enter Your Email",
                    controller: emailController,
                    icon: Icons.email,
                    obsecureText: false,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  AppConstants.inputField(
                    label: "Password",
                    hintText: "Enter Your Password",
                    controller: passwordController,
                    icon: Icons.lock,
                    obsecureText: show ? false : true,
                    suffixIcon: GestureDetector(
                      onTap: () {
                        passwordToggler();
                      },
                      child: show
                          ? Icon(
                              Icons.visibility_off,
                              color: color,
                            )
                          : Icon(
                              Icons.visibility,
                              color: color,
                            ),
                    ),
                    keyboardType: TextInputType.visiblePassword,
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: TextButton(
                      onPressed: () {
                        forEmailConfirmation(context);
                      },
                      style: ButtonStyle(
                        overlayColor:
                            WidgetStateProperty.all(Colors.transparent),
                      ),
                      child: Text(
                        "forgot password...?",
                        style: TextStyle(
                          color: color,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  AppConstants.button(
                    buttonWidth: 0.9,
                    buttonHeight: 0.07,
                    onTap: () {
                      bool validate = Datavalidatinghelper.validateLoginData(
                        email: emailController.text.toString().trim(),
                        password: passwordController.text.toString().trim(),
                        context: context,
                      );
                      if (validate) {
                        FireBaseHelper.loginUser(
                                email: emailController.text.toString().trim(),
                                password:
                                    passwordController.text.toString().trim(),
                                context: context)
                            .whenComplete(() {
                          emailController.clear();
                          passwordController.clear();
                        });
                      }
                    },
                    buttonText: "Login",
                    textSize: 20,
                    context: context,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 3.0),
                          child: Text(
                            "Don't have an Account ...?",
                            style: const TextStyle(
                              color: Colors.black,
                              wordSpacing: 1,
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.popUntil(
                                context, (route) => route.isFirst);
                          },
                          style: ButtonStyle(
                            overlayColor:
                                WidgetStateProperty.all(Colors.transparent),
                          ),
                          child: Text(
                            "SignUp",
                            style: TextStyle(
                              color: color,
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  forEmailConfirmation(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Center(
            child: Text(
          "Confirm",
          style: TextStyle(
            color: AppConstants.appColor,
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        )),
        content: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
          child: SizedBox(
            width: MediaQuery.sizeOf(context).width * 0.7,
            child: AppConstants.inputField(
              label: "Email",
              hintText: "Enter Your Email",
              controller: forgotPasswordController,
              icon: Icons.email,
              obsecureText: false,
              keyboardType: TextInputType.emailAddress,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              String mail = forgotPasswordController.text.trim();
              print(mail);
              try {
                AppConstants.showLoadingDialog(
                    context: context, title: "Confirming...!");
                final user = await FirebaseFirestore.instance
                    .collection("Users")
                    .where("email", isEqualTo: mail)
                    .get();
                if (user.docs.isNotEmpty) {
                  FirebaseAuth.instance
                      .sendPasswordResetEmail(email: mail)
                      .then((value) {
                    Navigator.pop(context);
                    AppConstants.showAlertDialog(
                        context: context,
                        title: "Succcess",
                        content:
                            "We have sent you an email to recover your password. Please check your Email");
                    forgotPasswordController.clear();
                  });
                } else if (user.docs.isEmpty) {
                  Navigator.pop(context);
                  AppConstants.showAlertDialog(
                      context: context,
                      title: "Error",
                      content: "User Not Found");
                }
              } catch (e) {
                AppConstants.showAlertDialog(
                    context: context, title: "Error", content: e.toString());
              }
            },
            child: Text(
              "Continue",
              style: TextStyle(
                color: AppConstants.appColor,
                fontWeight: FontWeight.bold,
                fontSize: 17,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
