import 'package:flutter/services.dart';

class ShowToast {
  static Future<void> show(String text) async {
    const platform = MethodChannel('devyuji.com/anima');

    await platform.invokeMethod('toastMessage', {"text": text});
  }
}
