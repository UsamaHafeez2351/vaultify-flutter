import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Helpers {
  // Show a simple snackbar
  static void showSnack(String title, String message, {bool isError = false}) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: isError ? Colors.redAccent : Colors.green,
      colorText: Colors.white,
      margin: const EdgeInsets.all(10),
      borderRadius: 10,
      duration: const Duration(seconds: 2),
    );
  }

  // Simple loader dialog
  static void showLoader([String message = 'Please wait...']) {
    Get.dialog(
      Center(child: CircularProgressIndicator(color: Colors.blueAccent)),
      barrierDismissible: false,
    );
  }

  // Close dialog if open
  static void hideLoader() {
    if (Get.isDialogOpen ?? false) Get.back();
  }
}
