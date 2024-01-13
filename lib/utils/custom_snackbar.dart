import 'package:anima/constraint.dart';
import 'package:flutter/material.dart';

SnackBar customSnackBar(BuildContext context, String text,
    [bool danger = false]) {
  ScaffoldMessenger.of(context).clearSnackBars();

  return SnackBar(
    content: Text(
      text,
      style: const TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.w700,
        fontSize: 18,
      ),
    ),
    backgroundColor: danger ? Colors.red : kActionColor,
  );
}
