import 'package:anima/constraint.dart';
import 'package:flutter/material.dart';

void customModalBottomSheet(
    BuildContext context, Widget Function(BuildContext) builder) {
  showModalBottomSheet(
    isScrollControlled: true,
    backgroundColor: kPrimaryColor,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(kBorderRadius),
        topRight: Radius.circular(kBorderRadius),
      ),
    ),
    context: context,
    builder: builder,
  );
}
