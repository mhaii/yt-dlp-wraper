import 'package:flutter/material.dart';
import 'package:yt_dlp_wrapper/navigator.dart';

class OkDialog {
  OkDialog._();

  static Future<void> show(String msg) {
    return showDialog(
      context: NavigationService.navigatorKey.currentContext!,
      builder: (context) => AlertDialog(
        title: const Text('Something went wrong'),
        content: Text(msg),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
