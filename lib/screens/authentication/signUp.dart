// ignore_for_file: file_names, use_build_context_synchronously, avoid_print, prefer_const_constructors

import 'package:bidhouse/constants.dart';
import 'package:bidhouse/dataValidatingHelper.dart';
import 'package:bidhouse/firebasehelper.dart';
import 'package:bidhouse/models/authenticationModel.dart';
import 'package:bidhouse/screens/authentication/login.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  Color color = AppConstants.appColor;
  String userType = "User Type";
  TextEditingController nameController = TextEditingController(),
      emailController = TextEditingController(),
      phoneNoController = TextEditingController(),
      passwordController = TextEditingController();
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
                    "Sign Up To Get Started With Your Account",
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
                    label: "Name",
                    hintText: "Enter Your Name",
                    controller: nameController,
                    icon: Icons.person,
                    obsecureText: false,
                    keyboardType: TextInputType.text,
                  ),
                  SizedBox(
                    height: 15,
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
                    label: "Phone No.",
                    hintText: "Enter Your Phone No.",
                    controller: phoneNoController,
                    icon: Icons.phone,
                    obsecureText: false,
                    keyboardType: TextInputType.phone,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    width: MediaQuery.sizeOf(context).width,
                    padding:
                        EdgeInsets.symmetric(horizontal: 8.0, vertical: 3.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(width: 0.5)),
                    child: Theme(
                      data: Theme.of(context).copyWith(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          menuWidth: MediaQuery.sizeOf(context).width * 0.8,
                          borderRadius: BorderRadius.circular(20),
                          value: userType,
                          icon: Icon(Icons.arrow_drop_down, color: color),
                          onChanged: (String? newValue) {
                            setState(() {
                              userType = newValue!;
                            });
                          },
                          items: <String>[
                            'User Type',
                            'User',
                            'Bidder',
                          ].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 8.0,
                                    bottom: 8.0,
                                    right: 8.0,
                                    left: 4.0),
                                child: Row(
                                  children: [
                                    Image.asset(
                                      'lib/assets/utype.png',
                                      width: 25,
                                      height: 25,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      value,
                                      style: TextStyle(
                                          color: color,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
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
                  SizedBox(
                    height: 25,
                  ),
                  AppConstants.button(
                    buttonWidth: 0.9,
                    buttonHeight: 0.07,
                    onTap: () async {
                      //saving user Data
                      final user = AuthenticationModel(
                          name: nameController.text.toString().trim(),
                          email: emailController.text.toString().trim(),
                          phoneNo: phoneNoController.text.toString().trim(),
                          imageUrl: '',
                          userType: userType,
                          password: passwordController.text.toString().trim());
                      //checking the inputs of the user
                      bool validate = Datavalidatinghelper.validateSignUpData(
                        userName: nameController.text.trim(),
                        email: emailController.text.trim(),
                        phoneNo: phoneNoController.text.trim(),
                        userType: userType,
                        password: passwordController.text.trim(),
                        context: context,
                      );
                      if (validate) {
                        //checking whether user with this email exist or not
                        var validateUserEmail = FireBaseHelper.checkUserExist(
                          emailController.text.toString().trim(),
                          context,
                        );
                        if (await validateUserEmail) {
                          //creating user
                          FireBaseHelper.createUser(
                                  authModel: user, context: context)
                              .whenComplete(() {
                            nameController.clear();
                            emailController.clear();
                            passwordController.clear();
                            phoneNoController.clear();
                          });
                        }
                      }
                    },
                    buttonText: "SignUp",
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
                            "Already have an Account ...?",
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
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LoginScreen(),
                              ),
                            );
                          },
                          style: ButtonStyle(
                            overlayColor:
                                WidgetStateProperty.all(Colors.transparent),
                          ),
                          child: Text(
                            "Login",
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
