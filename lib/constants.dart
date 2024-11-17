// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class AppConstants {
  //App main color
  static Color appColor = Color(0xFF607d8b);
  static Color bgColor = const Color(0xFFEFEFEF);
  //TextField
  static Widget inputField(
      {required String label,
      required String hintText,
      required TextEditingController controller,
      required IconData icon,
      required bool obsecureText,
      Widget? suffixIcon,
      required TextInputType keyboardType}) {
    return TextFormField(
      keyboardType: keyboardType,
      obscureText: obsecureText,
      cursorColor: appColor,
      controller: controller,
      decoration: InputDecoration(
        suffixIcon: suffixIcon,
        prefixIconColor: appColor,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: appColor,
          ),
        ),
        labelText: label,
        labelStyle: TextStyle(color: appColor, fontWeight: FontWeight.bold),
        hintText: hintText,
      ),
    );
  }

//ElevatedButton
  static Widget button(
      {required double buttonWidth,
      required double buttonHeight,
      required GestureTapCallback onTap,
      required String buttonText,
      required double textSize,
      required BuildContext context}) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width * buttonWidth,
      height: MediaQuery.sizeOf(context).height * buttonHeight,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: appColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: onTap,
        child: Text(
          buttonText,
          style: TextStyle(
              color: Colors.black,
              fontSize: textSize,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  //Loading Dialog
  static void showLoadingDialog(
      {required BuildContext context, required String title}) {
    AlertDialog loadingDialog = AlertDialog(
      content: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(
              color: appColor,
            ),
            const SizedBox(
              height: 30,
            ),
            Text(title),
          ],
        ),
      ),
    );

    showDialog(
      context: context,
      builder: (context) {
        return loadingDialog;
      },
    );
  }

  //Alert Dialog
  static void showAlertDialog({
    required BuildContext context,
    required String title,
    required String content,
  }) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("OK"),
        ),
      ],
    );

    showDialog(
      context: context,
      builder: (context) {
        return alertDialog;
      },
    );
  }
}
