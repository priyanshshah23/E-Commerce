import 'package:flutter/material.dart';
import 'package:diamnow/app/app.export.dart';

/// Builds a background with a gradient from top to bottom.
///
/// The [colors] default to the [AppTheme.backgroundColors] if omitted.
class AppBackground extends StatelessWidget {
  const AppBackground({
    this.child,
    this.colors,
    this.borderRadius,
  });

  final Widget child;
  final List<Color> colors;
  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);

    final backgroundColors = colors ?? appTheme.backgroundColors;

    if (backgroundColors.length == 1) {
      backgroundColors.add(backgroundColors.first);
    }

    return AnimatedContainer(
      duration: kThemeAnimationDuration,
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: colors ?? appTheme.backgroundColors,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: Directionality(
            textDirection: deviceTextDirection, child: child ?? Container()),
      ),
    );
  }
}
