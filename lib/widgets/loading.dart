import 'package:anima/constraint.dart';
import 'package:flutter/material.dart';

import 'package:flutter_animate/flutter_animate.dart';

class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return Animate(
      onPlay: (controller) => controller.repeat(),
    )
        .custom(
          duration: 600.milliseconds,
          builder: (context, value, child) {
            return Transform.translate(
              offset: const Offset(0, 5),
              child: Padding(
                padding: const EdgeInsets.all(kDefaultPadding),
                child: Container(
                  width: 15,
                  height: 15,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: Colors.white.withOpacity(.8),
                  ),
                ),
              ),
            );
          },
        )
        .rotate();
  }
}
