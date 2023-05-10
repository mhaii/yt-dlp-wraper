import 'dart:async';

import 'package:flutter/material.dart';
import 'package:yt_dlp_wrapper/navigator.dart';

class LoadingDialog {
  LoadingDialog._();

  static int _counter = 0;
  static Completer? _completer;
  static Future<void>? _dialogFuture;

  static Future<void> show() {
    _counter++;
    if (_counter == 1) {
      final context = NavigationService.navigatorKey.currentContext!;
      _completer = Completer()..future.then((_) => Navigator.pop(context));
      _dialogFuture = showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Dialog(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                CircularProgressIndicator(),
                SizedBox(width: 20),
                Text('Loading'),
              ],
            ),
          ),
        ),
      );
    }
    return _dialogFuture!;
  }

  static void hide() {
    _counter--;
    if (_counter == 0) {
      _dialogFuture = null;
      _completer?.complete();
    }
  }

  static void forceHide() {
    _counter = 0;
    _completer?.complete();
  }
}
