import 'dart:math';

import 'package:flutter/material.dart';

import '../../../app/app.export.dart';

/// A simple circular button mainly used by the [MediaVideoPlayer].
class CircleButton extends StatelessWidget {
  const CircleButton({
    @required this.child,
    this.backgroundColor = Colors.black26,
    this.highlightColor = Colors.white10,
    this.splashColor = Colors.white24,
    this.padding = const EdgeInsets.all(8),
    this.onPressed,
  });

  final Widget child;
  final Color backgroundColor;
  final Color highlightColor;
  final Color splashColor;
  final EdgeInsets padding;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.circle,
      color: backgroundColor,
      child: InkWell(
        highlightColor: highlightColor,
        splashColor: splashColor,
        onTap: onPressed,
        customBorder: CircleBorder(),
        child: Padding(
          padding: padding,
          child: child,
        ),
      ),
    );
  }
}

/// The base for the [AppButton].
///
/// Uses [AnimatedScale] to have the button appear pressed down while it is
/// tapped.
class _AppButtonBase extends StatefulWidget {
  const _AppButtonBase({
    @required this.child,
    this.onTap,
  });

  final Widget child;
  final VoidCallback onTap;

  @override
  _AppButtonBaseState createState() => _AppButtonBaseState();
}

class _AppButtonBaseState extends State<_AppButtonBase> {
  bool _tapDown = false;

  void _updateTapDown(bool value) {
    if (widget.onTap != null && _tapDown != value) {
      setState(() {
        _tapDown = value;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: _tapDown ? .9 : 1,
      child: GestureDetector(
        onTapDown: (_) => _updateTapDown(true),
        onTapUp: (_) => _updateTapDown(false),
        onTapCancel: () => _updateTapDown(false),
        onTap: widget.onTap,
        child: widget.child,
      ),
    );
  }
}

/// A custom button with a rounded border that uses an [AnimatedScale] to
/// appear pressed down on tap.
///
/// The [AppButton.raised] builds a button with elevation and a
/// [backgroundColor].
///
/// The [AppButton.flat] builds a flat button with a transparent background.
///
/// The button can have an [icon] and [text]. When both are not `null`, the
/// icon is built to the left of the text with a padding in between that is
/// half of its vertical padding.
///
/// Alternatively to [icon], an [iconBuilder] can be used to build the icon
/// widget with more control.
///
/// Either [icon], [iconBuilder] or [text] must not be `null`.
class AppButton extends StatelessWidget {
  /// A button that appears raised with a shadow.
  ///
  /// Uses the [ThemeData.buttonColor] as the [backgroundColor] by default.
  const AppButton.raised({
    @required this.onTap,
    this.text,
    this.textColor,
    this.icon,
    this.iconSize,
    this.iconBuilder,
    this.backgroundColor,
    this.isButtonEnabled = true,
    this.dense = false,
    this.fitWidth = false,
    this.padding,
    this.foregroundColor,
    this.borderRadius = 0,
  })  : materialType = MaterialType.canvas,
        elevation = 8,
        assert(text != null || icon != null || iconBuilder != null);

  /// A flat button that has a transparent background and no shadow.
  ///
  /// Should only be used when the context makes it clear it can be tapped.
  const AppButton.flat(
      {@required this.onTap,
      this.text,
      this.textColor,
      this.icon,
      this.iconSize,
      this.iconBuilder,
      this.backgroundColor,
      this.dense = false,
      this.fitWidth = false,
      this.padding,
      this.foregroundColor,
      this.isButtonEnabled = true,
      this.borderRadius = 0})
      : materialType = MaterialType.canvas,
        elevation = 0,
        assert(text != null || icon != null || iconBuilder != null);

  /// The [text] of the button.
  ///
  /// Can be `null` if the button has no text.
  final String text;

  /// The color of the Text.
  ///
  /// Uses the [ThemeData.textTheme.button.color] if `null`.
  final Color textColor;

  /// The [icon] of the button.
  ///
  /// Can be `null` if the button has no icon.
  final IconData icon;

  /// The size of the [icon];
  final double iconSize;

  /// Can be used in place of [icon] to build the icon widget.
  final WidgetBuilder iconBuilder;

  /// The callback when the button is tapped.
  ///
  /// If `null`, the button is slightly transparent to appear disabled.
  final VoidCallback onTap;

  /// The color of the button.
  ///
  /// Uses the [ThemeData.buttonColor] if `null`.
  final Color backgroundColor;

  final double borderRadius;

  /// The color of the [icon] and [text] of the button.
  ///
  /// Defaults to [TextTheme.button] if the [backgroundColor] is `null`,
  /// to the [TextTheme.body1] color if the [backgroundColor] is transparent
  /// or to a complimentary color when [backgroundColor] is set.
  final Color foregroundColor;

  /// Whether or not the button should have less padding.
  ///
  /// Has no effect if [padding] is not `null`.
  final bool dense;
  final bool isButtonEnabled;
  final bool fitWidth;

  /// The padding for the button.
  ///
  /// Should usually be `null` to use the default padding that is controlled
  /// with [dense] if a smaller padding is required.
  final EdgeInsets padding;

  /// The [elevation] that changes when using a [AppButton.flat] or
  /// [AppButton.raised].
  final double elevation;

  /// Determines the material type that the button uses as its background.
  ///
  /// Set to [MaterialType.transparency] for [AppButton.flat] and
  /// [MaterialType.canvas] for [AppButton.raised].
  final MaterialType materialType;

  EdgeInsets get _padding =>
      padding ??
      EdgeInsets.symmetric(
        vertical: dense ? 8 : 12,
        horizontal: dense ? 32 : 32,
      );

  /// Returns the color for the [icon] and [text].
  Color _getForegroundColor(ThemeData theme) {
    if (foregroundColor != null) {
      return foregroundColor;
    } else if (materialType == MaterialType.transparency) {
      // the text color since the button is transparent, therefore directly
      // on the background

      return theme.textTheme.body1.color;
    } else if (backgroundColor == null) {
      // dont override the button color
      return theme.textTheme.button.color;
    } else {
      // black or white depending on the background color
      final brightness = ThemeData.estimateBrightnessForColor(backgroundColor);

      return brightness == Brightness.light ? Colors.black : Colors.white;
    }
  }

  /// Builds the row with the [Icon] and [Text] widget.
  Widget _buildContent(BuildContext context) {
    final theme = AppTheme.of(context).theme;

    Widget iconWidget;
    Widget textWidget;

    if (text != null) {
      // need to make sure the text overflow is handled when the button size is
      // constrained, for example during an AnimatedCrossFade transition
      textWidget = Text(
        text,
        //textAlign: fitWidth ? TextAlign.center : TextAlign.start,
        textAlign: TextAlign.center,
        style: theme.textTheme.button.copyWith(
            fontWeight: FontWeight.normal,
            color: textColor == null ? Colors.white : textColor),
        overflow: TextOverflow.fade,
        softWrap: false,
      );
    }

    if (icon != null) {
      iconWidget = Icon(icon);
    } else if (iconBuilder != null) {
      iconWidget = iconBuilder(context);
    }

    return IntrinsicWidth(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (iconWidget != null) iconWidget,
          if (iconWidget != null && textWidget != null)
            SizedBox(width: _padding.vertical / 4),
          if (textWidget != null) Expanded(child: textWidget),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context).theme;
    final borderRadius = BorderRadius.circular(this.borderRadius);

    Color bgColor = isButtonEnabled
        ? (backgroundColor ?? theme.buttonColor)
        : theme.disabledColor;
    Color fgColor = _getForegroundColor(theme);

    if (onTap == null) {
      // reduce the opacity by 30% when disabled
      bgColor = bgColor.withOpacity(max(0, bgColor.opacity - 0.3));
      fgColor = fgColor.withOpacity(max(0, fgColor.opacity - 0.3));
    }

    return _AppButtonBase(
      onTap: isButtonEnabled ? onTap : null,
      child: AnimatedTheme(
        data: ThemeData(
          // material background color
          canvasColor: bgColor,
          // text color
          textTheme: TextTheme(
            button: theme.textTheme.button.copyWith(color: fgColor),
          ),

          // icon color
          iconTheme: IconThemeData(color: fgColor, size: iconSize),
        ),
        child: Material(
          elevation: elevation,
          type: materialType,
          borderRadius: borderRadius,
          child: Container(
            height: getSize(50),
            width: fitWidth ? MediaQuery.of(context).size.width : null,
            child: Center(
              child: Builder(builder: _buildContent),
            ),
          ),
        ),
      ),
    );
  }
}
