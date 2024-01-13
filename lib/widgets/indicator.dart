import "package:flutter/material.dart";

import "package:anima/constraint.dart";

class Indicator extends StatelessWidget {
  const Indicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10,
      height: 3,
      margin: const EdgeInsets.only(
        bottom: kDefaultPadding / 2,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: kActionColor,
      ),
    );
  }
}
