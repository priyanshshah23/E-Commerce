import 'package:flutter/material.dart';

import '../../../app/app.export.dart';

/// Builds a text that takes 2 seconds to slide into position.
///
/// An optional [delay] can be set to hide the widget for that amount.
/// Uses the [TextTheme.display4] text style by default if [style] is omitted.
class ImageAnimation extends StatelessWidget {
  const ImageAnimation({
    this.child,
    this.delay = Duration.zero,
  });

  final Widget child;
  final Duration delay;

  @override
  Widget build(BuildContext context) {
    return SlideFadeInAnimation(
      duration: const Duration(seconds: 2),
      delay: delay,
      offset: const Offset(0, 75),
      curve: Curves.easeOutCubic,
      child: child,
    );
  }
}
