import 'package:diamnow/components/Screens/Auth/ChangePassword.dart';
import 'package:diamnow/components/Screens/Auth/CompanyInformation.dart';
import 'package:diamnow/components/Screens/Auth/ForgetPassword.dart';
import 'package:diamnow/components/Screens/Auth/Login.dart';
import 'package:diamnow/components/Screens/Auth/PasswordResetSuccessfully.dart';
import 'package:diamnow/components/Screens/Auth/PersonalInformation.dart';
import 'package:diamnow/components/Screens/Auth/Profile.dart';
import 'package:diamnow/components/Screens/Auth/ProfileList.dart';
import 'package:diamnow/components/Screens/Auth/ResetPassword.dart';
import 'package:diamnow/components/Screens/Auth/SignInAsGuestScreen.dart';
import 'package:diamnow/components/Screens/Auth/Signup.dart';
import 'package:diamnow/components/Screens/Auth/TabBarDemo.dart';
import 'package:diamnow/components/Screens/Auth/Widget/MyAccountScreen.dart';
import 'package:diamnow/components/Screens/DiamondDetail/DiamondDetailScreen.dart';
import 'package:diamnow/components/Screens/DiamondList/DiamondCompareScreen.dart';
import 'package:diamnow/components/Screens/DiamondList/DiamondListScreen.dart';
import 'package:diamnow/components/Screens/Filter/FilterScreen.dart';
import 'package:diamnow/components/Screens/Home/HomeScreen.dart';
import 'package:diamnow/components/Screens/More/OfferViewScreen.dart';
import 'package:diamnow/components/Screens/Auth/SignInAsGuestScreen.dart';
import 'package:diamnow/components/Screens/Order/OrderListScreen.dart';
import 'package:diamnow/components/Screens/QuickSearch/QuickSearch.dart';
import 'package:diamnow/components/Screens/StaticPage/StaticPage.dart';
import 'package:flutter/material.dart';

import 'fade_route.dart';

/// The [RouteType] determines what [PageRoute] is used for the new route.
///
/// This determines the transition animation for the new route.
enum RouteType {
  defaultRoute,
  fade,
  slideIn,
}

/// A convenience class to wrap [Navigator] functionality.
///
/// Since a [GlobalKey] is used for the [Navigator], the [BuildContext] is not
/// necessary when changing the current route.
class NavigationUtilities {
  static GlobalKey<NavigatorState> key = GlobalKey<NavigatorState>();

  /// A convenience method to push a new [MaterialPageRoute] to the [Navigator].
  static void push(Widget widget, {String name}) {
    key.currentState.push(MaterialPageRoute(
      builder: (context) => widget,
      settings: RouteSettings(name: name),
    ));
  }

  /// A convenience method to push a new [route] to the [Navigator].
  static void pushRoute(String route,
      {RouteType type = RouteType.fade, Map args}) {
    if (args == null) {
      args = Map<String, dynamic>();
    }
    args["routeType"] = type;
    key.currentState.pushNamed(route, arguments: args);
  }

  /// A convenience method to push a named replacement route.
  static void pushReplacementNamed(String route,
      {RouteType type = RouteType.fade, Map args}) {
    if (args == null) {
      args = Map<String, dynamic>();
    }
    args["routeType"] = type;

    key.currentState.pushReplacementNamed(
      route,
      arguments: args,
    );
  }

  /// Returns a [RoutePredicate] similar to [ModalRoute.withName] except it
  /// compares a list of route names.
  ///
  /// Can be used in combination with [Navigator.pushNamedAndRemoveUntil] to
  /// pop until a route has one of the name in [names].
  static RoutePredicate namePredicate(List<String> names) {
    return (route) =>
        !route.willHandlePopInternally &&
        route is ModalRoute &&
        (names.contains(route.settings.name));
  }
}

/// [onGenerateRoute] is called whenever a new named route is being pushed to
/// the app.
///
/// The [RouteSettings.arguments] that can be passed along the named route
/// needs to be a `Map<String, dynamic>` and can be used to pass along
/// arguments for the screen.
Route<dynamic> onGenerateRoute(RouteSettings settings) {
  final routeName = settings.name;
  final arguments = settings.arguments as Map<String, dynamic> ?? {};
  final routeType =
      arguments["routeType"] as RouteType ?? RouteType.defaultRoute;

  Widget screen;

  switch (routeName) {
    // case SetupScreen.route:
    //   screen = SetupScreen();
    //   break;
    case LoginScreen.route:
      screen = LoginScreen();
      break;
    case QuickSearchScreen.route:
      screen = QuickSearchScreen(arguments);
      break;
    case HomeScreen.route:
      screen = HomeScreen();
      break;
    case FilterScreen.route:
      screen = FilterScreen(arguments);
      break;
    case GuestSignInScreen.route:
      screen = GuestSignInScreen();
      break;
    case SignupScreen.route:
      screen = SignupScreen();
      break;
    case TabBarDemo.route:
      screen = TabBarDemo();
      break;
    case Profile.route:
      screen = Profile();
      break;
    case DiamondListScreen.route:
      screen = DiamondListScreen(arguments);
      break;
    case OrderListScreen.route:
      screen = OrderListScreen(arguments);
      break;
    case DiamondCompareScreen.route:
      screen = DiamondCompareScreen(arguments);
      break;
    case ChangePassword.route:
      screen = ChangePassword();
      break;
    case PersonalInformation.route:
      screen = PersonalInformation();
      break;
    case CompanyInformation.route:
      screen = CompanyInformation();
      break;
    case StaticPageScreen.route:
      screen = StaticPageScreen(arguments);
      break;
    case ForgetPasswordScreen.route:
      screen = ForgetPasswordScreen();
      break;
    case ResetPassword.route:
      screen = ResetPassword(arguments);
      break;
    case PasswordResetSuccessfully.route:
      screen = PasswordResetSuccessfully();
      break;
    case ProfileList.route:
      screen = ProfileList();
      break;
    case DiamondDetailScreen.route:
      screen = DiamondDetailScreen(
        arguments: arguments,
      );
      break;
    case OfferViewScreen.route:
      screen = OfferViewScreen();
      break;
    case MyAccountScreen.route:
      screen = MyAccountScreen();
      break;
  }

  switch (routeType) {
    case RouteType.fade:
      return FadeRoute(
        builder: (_) => screen,
        settings: RouteSettings(name: routeName),
      );
    case RouteType.defaultRoute:
    default:
      return MaterialPageRoute(
        builder: (_) => screen,
        settings: RouteSettings(name: routeName),
      );
  }
}
