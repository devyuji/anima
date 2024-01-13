import 'package:flutter/material.dart';

Widget backButton(BuildContext context) {
  return IconButton(
    onPressed: () => Navigator.pop(context),
    icon: const Icon(Icons.arrow_back_ios_new),
    tooltip: "Navigate Back",
  );
}
