// ignore_for_file: file_names

import 'package:bidhouse/constants.dart';
import 'package:flutter/material.dart';

class Datavalidatinghelper {
  //checking if the user entered the credentials correctly
  static bool validateLoginData({
    required String email,
    required String password,
    required BuildContext context,
  }) {
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

  //checking user data while creating new account
  static bool validateSignUpData({
    required String userName,
    required String email,
    required String phoneNo,
    required String userType,
    required String password,
    required BuildContext context,
  }) {
    if (userName == "" && email == "" && phoneNo == "" && password == "") {
      AppConstants.showAlertDialog(
          context: context,
          title: "Error",
          content: "Please fill all the fields");
      return false;
    } else if (userType == "User Type") {
      AppConstants.showAlertDialog(
          context: context, title: "Error", content: "Please Select User Type");
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
}
