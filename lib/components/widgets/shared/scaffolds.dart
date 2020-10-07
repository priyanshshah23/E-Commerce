import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../../../app/app.export.dart';

/// A convenience Widget that wraps a [Scaffold].
///
/// If [showIcon] is `true`, the [FlareIcon..appLogo] is built next to the
/// [title] in the [AppBar].
///
/// The [AppBackground] is used with the [backgroundColors] to build the
/// background of the [Scaffold.body]. By default the [AppTheme] is used to
/// determine the [backgroundColors].
class AppScaffold extends StatelessWidget {
  AppScaffold({
    this.title,
    this.showIcon = false,
    this.actions,
    this.drawer,
    this.body,
    this.backgroundColors,
    this.appBarBottom,
  });

  final String title;
  final bool showIcon;
  final List<Widget> actions;
  final Widget drawer;
  final Widget body;
  final PreferredSizeWidget appBarBottom;

  /// When set the [AppBackground] will override the active theme background
  /// colors.
  final List<Color> backgroundColors;

  @override
  Widget build(BuildContext context) {
    final titleWidget = FittedBox(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (title != null)
            Text(
              title,
              style: Theme.of(context).textTheme.title,
            ),
          if (showIcon) ...[
            const SizedBox(width: 4),
//            const FlareIcon.appLogo(size: 24),
          ],
        ],
      ),
    );

    final AppBar appBar = AppBar(
      centerTitle: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      actions: actions,
      title: titleWidget,
      bottom: appBarBottom,
    );

    final double topPadding = MediaQuery.of(context).padding.top;
    final double extent = appBar.preferredSize.height + topPadding;

    return Scaffold(
      drawer: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Colors.transparent,
        ),
        child: drawer,
      ),
      body: AppBackground(
        colors: backgroundColors,
        child: Column(
          children: <Widget>[
            ConstrainedBox(
              constraints: BoxConstraints(maxHeight: extent),
              child: appBar,
            ),
            Expanded(child: body),
          ],
        ),
      ),
    );
  }
}

/// A [NestedScrollView] within a [Scaffold] where the [title] fades in when the
/// [FlexibleSpaceBar] in the [SliverAppBar] starts showing.
///
/// If [alwaysShowTitle] is `true` the title will show even when the
/// [SliverAppBar] is expanded.
class FadingNestedScaffold extends StatefulWidget {
  const FadingNestedScaffold({
    @required this.body,
    this.title,
    this.background,
    this.expandedAppBarSpace = 200.0,
    this.alwaysShowTitle = false,
  });

  final Widget body;
  final String title;
  final Widget background;
  final double expandedAppBarSpace;
  final bool alwaysShowTitle;

  @override
  _FadingNestedScaffoldState createState() => _FadingNestedScaffoldState();
}

class _FadingNestedScaffoldState extends State<FadingNestedScaffold> {
  ScrollController _controller;
  double _opacity = 0;

  double get opacity => widget.alwaysShowTitle ? 1.0 : _opacity;

  @override
  void initState() {
    super.initState();

    final double fadeStart = widget.expandedAppBarSpace - 125;
    final double fadeEnd = widget.expandedAppBarSpace - 40;
    final double difference = fadeEnd - fadeStart;

    _controller = ScrollController()
      ..addListener(() {
        if (_controller.offset >= fadeStart && _controller.offset <= fadeEnd) {
          final double val = _controller.offset - fadeStart;
          setState(() {
            _opacity = val / difference;
          });
        } else if (_controller.offset < fadeStart && _opacity != 0) {
          setState(() {
            _opacity = 0;
          });
        } else if (_controller.offset > fadeEnd && _opacity != 1.0) {
          setState(() {
            _opacity = 1.0;
          });
        }
      });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appTheme = Theme.of(context);

    final SliverAppBar sliverAppBar = SliverAppBar(
      expandedHeight: widget.expandedAppBarSpace,
      elevation: 0,
      backgroundColor: Colors.transparent,
      pinned: true,
      flexibleSpace: Container(
        color: appTheme.backgroundColor,
        child: FlexibleSpaceBar(
          centerTitle: true,
          // padding to prevent the text to get below the back arrow
          title: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 52),
            child: Opacity(
              opacity: opacity,
              child: Text(
                widget.title ?? "",
                style: Theme.of(context).textTheme.title,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          background: widget.background,
        ),
      ),
    );

    return AppBackground(
      child: NestedScrollView(
        controller: _controller,
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return <Widget>[
            sliverAppBar,
          ];
        },
        body: widget.body,
      ),
    );
  }
}
