import 'package:flutter/material.dart';

/// An [IconRow] to display an [Icon] next to some text.
class IconRow extends StatelessWidget {
  const IconRow({
    @required this.icon,
    @required this.child,
    this.iconPadding,
  });

  /// The [IconData] of the icon.
  final IconData icon;

  /// The [child] an either be a Widget or a String that will turn into a text
  /// widget and is displayed to the right of the [icon].
  final dynamic child;

  /// If [iconPadding] is not null the [icon] will be in the center of a
  /// [SizedBox] with a width of [iconPadding].
  final double iconPadding;

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.body1;

    return Row(
      children: <Widget>[
        SizedBox(
          width: iconPadding,
          child: Icon(icon, size: 18),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: child is Widget
              ? child
              : Text(
                  child,
                  style: textStyle.copyWith(
                    color: textStyle.color.withOpacity(0.8),
                  ),
                ),
        ),
      ],
    );
  }
}

class TweetDivider extends StatelessWidget {
  const TweetDivider();

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;

    return Divider(
      height: 0,
      color: brightness == Brightness.dark
          ? const Color(0x55FFFFFF)
          : const Color(0x35000000),
    );
  }
}
