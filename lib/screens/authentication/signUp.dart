// ignore_for_file: file_names, use_build_context_synchronously, avoid_print, prefer_const_constructors

import 'package:bidhouse/constants.dart';
import 'package:bidhouse/models/authenticationModel.dart';
import 'package:bidhouse/screens/authentication/login.dart';
import 'package:bidhouse/screens/dashboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore db = FirebaseFirestore.instance;
  Color color = AppConstants.appColor;
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

  bool validateSignUpData(
      {required String userName,
      required String email,
      required String phoneNo,
      required String password}) {
    if (userName == "" && email == "" && phoneNo == "" && password == "") {
      AppConstants.showAlertDialog(
          context: context,
          title: "Error",
          content: "Please fill all the fields");
      return false;
    } else if (!RegExp(r"^[a-zA-Z]").hasMatch(userName) ||
        !RegExp(r"^[a-zA-z0-9]+@[a-z]+.[a-z]").hasMatch(email) ||
        !RegExp(r"^((\+92)|(0092))-{0,1}\d{3}-{0,1}\d{7}$|^\d{11}$|^\d{4}-\d{7}$")
            .hasMatch(phoneNo) ||
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

  Future<bool> checkUserExist(String email) async {
    final snapshot =
        await db.collection("Users").where("email", isEqualTo: email).get();
    if (snapshot.docs.isEmpty) {
      return true;
    }
    //final userData = AuthenticationModel.fromJson(snapshot.docs.first);
    //return userData;
    return false;
  }

  Future<void> createUser(
      {required AuthenticationModel authModel,
      required BuildContext context}) async {
    try {
      AppConstants.showLoadingDialog(
          context: context, title: "Creating Your Account");
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
          email: authModel.email, password: authModel.password);
      authModel.id = userCredential.user!.uid;
      await db.collection("Users").doc(authModel.id).set({
        'id': authModel.id,
        'name': authModel.name,
        'email': authModel.email,
        'phoneNo': authModel.phoneNo,
        'imageUrl': authModel.imageUrl,
        'password': authModel.password,
      }).whenComplete(() {
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
      print(e.toString());
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
                          password: passwordController.text.toString().trim());
                      //checking the inputs of the user
                      bool validate = validateSignUpData(
                        userName: nameController.text.trim(),
                        email: emailController.text.trim(),
                        phoneNo: phoneNoController.text.trim(),
                        password: passwordController.text.trim(),
                      );
                      if (validate) {
                        //checking whether user with this email exist or not
                        var validateUserEmail = checkUserExist(
                            emailController.text.toString().trim());
                        if (await validateUserEmail) {
                          //creating user
                          createUser(authModel: user, context: context)
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
