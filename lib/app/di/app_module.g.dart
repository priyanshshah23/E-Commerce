// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_module.dart';

// **************************************************************************
// KiwiInjectorGenerator
// **************************************************************************

class _$AppModule extends AppModule {
  void configure() {
    final KiwiContainer container = KiwiContainer();
    container.registerSingleton((c) => ConnectivityService());
    container.registerSingleton((c) => PrefUtils());
    container.registerSingleton((c) => FlushbarService());
    container.registerSingleton((c) => ThemeSettingsModel());
    container.registerSingleton((c) => ServiceModule());
    container.registerSingleton((c) => CustomDialogs());
  }
}
