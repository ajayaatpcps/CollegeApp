import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

import '../resource/colors.dart';


class Utils {
  // static toastMessage(String message) {
  //   Fluttertoast.showToast(
  //       msg: message, backgroundColor: Colors.green, textColor: Colors.white);
  // }
  static noInternet(String message) {
    Flushbar(
      message: message,
      backgroundColor: Colors.red,
      title: 'Error',
      messageColor: Colors.black,
      duration: const Duration(seconds: 3),
      icon: const Icon(
        Icons.error,
        size: 28.0,
        color: Colors.white,
      ),
      leftBarIndicatorColor: Colors.redAccent,
      animationDuration: const Duration(milliseconds: 2000),
      isDismissible: true,
      flushbarPosition: FlushbarPosition.BOTTOM,
      flushbarStyle: FlushbarStyle.FLOATING,
      forwardAnimationCurve: Curves.easeInOut,
    );
  }
  static flushBarErrorMessage(String message, BuildContext context) {
    Flushbar(
      message: message,
      backgroundColor: Colors.red,
      title: 'Error',
      messageColor: Colors.black,
      duration: const Duration(seconds: 4),
      icon: const Icon(
        Icons.error,
        size: 28.0,
        color: Colors.white,
      ),
      leftBarIndicatorColor: Colors.redAccent,
      animationDuration: const Duration(milliseconds: 2000),
      isDismissible: true,
      flushbarPosition: FlushbarPosition.BOTTOM,
      flushbarStyle: FlushbarStyle.FLOATING,
      forwardAnimationCurve: Curves.easeInOut,
    ).show(context);
  }
  static flushBarSuccessMessage(String message, BuildContext context) {
    Flushbar(
      message: message,
      backgroundColor: AppColors.primary,
      title: 'Success',
      messageColor: Colors.white,
      duration: const Duration(seconds: 2),
      icon: const Icon(
        Icons.check,
        size: 28.0,
        color: Colors.white,
      ),
      leftBarIndicatorColor:AppColors.primary,
      animationDuration: const Duration(milliseconds: 500),
      isDismissible: true,
      flushbarPosition: FlushbarPosition.TOP,
      flushbarStyle: FlushbarStyle.FLOATING,
      forwardAnimationCurve: Curves.easeInOut,
    ).show(context);
  }
  static flushBarNOdata(String message, BuildContext context) {
    Flushbar(
      message: message,
      backgroundColor: Colors.black,
      title: 'No Data',
      messageColor: Colors.white,
      duration: const Duration(seconds: 2),
      icon: const Icon(
        Icons.check,
        size: 28.0,
        color: Colors.white,
      ),
      leftBarIndicatorColor:AppColors.primary,
      animationDuration: const Duration(milliseconds: 500),
      isDismissible: true,
      flushbarPosition: FlushbarPosition.BOTTOM,
      flushbarStyle: FlushbarStyle.FLOATING,
      forwardAnimationCurve: Curves.easeInOut,
    ).show(context);
  }

  static void fieldFocusChange(String message, BuildContext context, FocusNode current, FocusNode nextFocus){
    current.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

}
