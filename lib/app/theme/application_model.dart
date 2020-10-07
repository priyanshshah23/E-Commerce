import 'package:flutter/widgets.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';

import '../app.export.dart';

/// The [ApplicationModel] handles initialization when starting the app.
///
/// During initialization, the [EntryScreen] is showing.
///
/// If a user was previously logged in, the app will automatically navigate
/// to the [HomeScreen], otherwise it will navigate to the [LoginScreen].
class ApplicationModel {
  ApplicationModel({@required this.themeSettingsModel}) {
    _initialize();
  }

  final PrefUtils harpyPrefs = app.resolve<PrefUtils>();
  final ConnectivityService connectivityService =
      app.resolve<ConnectivityService>();

  final ThemeSettingsModel themeSettingsModel;

  static ApplicationModel of(BuildContext context) {
    return Provider.of<ApplicationModel>(context);
  }

  static final Logger _log = Logger("ApplicationModel");

  /// Whether or not the [ApplicationModel] has been initialized.
  bool initialized = false;

  Future<void> _initialize() async {
    await Future.wait([
      harpyPrefs.init(),
      connectivityService.init(),
    ]);
    initialized = true;
    _onInitialized();
  }

  /// Called when the [ApplicationModel] finished initializing and navigates
  /// to the next screen.
  Future<void> _onInitialized() async {
    themeSettingsModel.updateSystemUi();
    themeSettingsModel.initTheme();
  }
}
