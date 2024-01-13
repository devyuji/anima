import 'package:flutter/widgets.dart';

import 'package:anima/constraint.dart';

class Gap extends StatelessWidget {
  const Gap(
      {super.key, this.size = kDefaultPadding, this.axis = Axis.vertical});

  final double size;
  final Axis axis;

  @override
  Widget build(BuildContext context) {
    if (axis == Axis.vertical) {
      return SizedBox(
        height: size,
      );
    }

    return SizedBox(
      width: size,
    );
  }
}
