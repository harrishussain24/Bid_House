// ignore_for_file: use_build_context_synchronously, avoid_print, prefer_const_constructors

import 'package:bidhouse/constants.dart';
import 'package:bidhouse/screens/dashboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore db = FirebaseFirestore.instance;
  Color color = AppConstants.appColor;
  TextEditingController emailController = TextEditingController(),
      passwordController = TextEditingController();
  bool show = false;

  passwordToggler() {
    setState(() {
      show = !show;
    });
  }

  bool validateLoginData({required String email, required String password}) {
    if (email == "" && password == "") {
      AppConstants.showAlertDialog(
          context: context,
          title: "Error",
          content: "Please fill all the fields");
      return false;
    } else if (!RegExp(r"^[a-zA-z0-9]+@[a-z]+.[a-z]").hasMatch(email) ||
        !RegExp(r"^.{6,}$").hasMatch(password)) {
      AppConstants.showAlertDialog(
          context: context,
          title: "Error",
          content: "Entered data badly formatted");
      return false;
    } else {
      return true;
    }
  }

  Future<void> loginUser(
      {required String email,
      required String password,
      required BuildContext context}) async {
    try {
      AppConstants.showLoadingDialog(context: context, title: "Logging In...!");
      await auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) async => {
                await db
                    .collection("Users")
                    .where('email', isEqualTo: email)
                    .get()
                    .then((value) => {})
              })
          .whenComplete(() {
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const Dashboard(),
          ),
        );
      });
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      AppConstants.showAlertDialog(
          context: context, title: "Error", content: e.toString());
    } catch (e) {
      print(e);
    }
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
                      onPressed: () {},
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
                      bool validate = validateLoginData(
                          email: emailController.text.toString().trim(),
                          password: passwordController.text.toString().trim());
                      if (validate) {
                        loginUser(
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
}
