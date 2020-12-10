import 'package:diamnow/app/constant/constants.dart';
import 'package:diamnow/app/utils/navigator.dart';
import 'package:diamnow/components/Screens/DiamondList/DiamondListScreen.dart';
import 'package:diamnow/components/Screens/Filter/FilterScreen.dart';
import 'package:diamnow/components/Screens/More/OfferViewScreen.dart';
import 'package:diamnow/components/Screens/Order/OrderListScreen.dart';
import 'package:diamnow/components/Screens/SavedSearch/SavedSearchScreen.dart';
import 'package:diamnow/models/DiamondList/DiamondConstants.dart';
import 'package:diamnow/models/Notification/NotificationModel.dart';

class NotificationManger {
  notificationRedirection(NotificationModel notificationModel,
      {bool isFromNotificationMenu}) {
    int type = notificationModel.module;
    switchCaseMethod(type);
  }

  void switchCaseMethod(int type) {
    switch (type) {
      case NotificationConstant.MODULE_TYPE_SEARCH:
        NavigationUtilities.pushRoute(FilterScreen.route);
        break;
      case NotificationConstant.MODULE_TYPE_WATCHLIST:
      case NotificationConstant.MODULE_TYPE_OFFER:
      case NotificationConstant.MODULE_TYPE_CART:
      case NotificationConstant.MODULE_TYPE_APPOINTMENTS:
      case NotificationConstant.MODULE_TYPE_ENQUIRY:
      case NotificationConstant.MODULE_TYPE_COMMENT:
      case NotificationConstant.MODULE_TYPE_NEW_GOODS:
        Map<String, dynamic> arguments = {};
        arguments[ArgumentConstant.ModuleType] = getDiamondModulyType(type);
        NavigationUtilities.pushRoute(DiamondListScreen.route, args: arguments);
        break;
      case NotificationConstant.MODULE_TYPE_ORDER_PLACE:
        Map<String, dynamic> arguments = {};
        arguments[ArgumentConstant.ModuleType] = getDiamondModulyType(type);
        NavigationUtilities.pushRoute(OrderListScreen.route, args: arguments);
        break;
    }
  }

  int getDiamondModulyType(int moduleType) {
    switch (moduleType) {
      case NotificationConstant.MODULE_TYPE_WATCHLIST:
        return DiamondModuleConstant.MODULE_TYPE_MY_WATCH_LIST;
      case NotificationConstant.MODULE_TYPE_OFFER:
        return DiamondModuleConstant.MODULE_TYPE_MY_OFFER;
      case NotificationConstant.MODULE_TYPE_CART:
        return DiamondModuleConstant.MODULE_TYPE_MY_CART;
      case NotificationConstant.MODULE_TYPE_APPOINTMENTS:
        return DiamondModuleConstant.MODULE_TYPE_MY_OFFICE;
      case NotificationConstant.MODULE_TYPE_ENQUIRY:
        return DiamondModuleConstant.MODULE_TYPE_MY_ENQUIRY;
      case NotificationConstant.MODULE_TYPE_NEW_GOODS:
        return DiamondModuleConstant.MODULE_TYPE_NEW_ARRIVAL;
      case NotificationConstant.MODULE_TYPE_COMMENT:
        return DiamondModuleConstant.MODULE_TYPE_MY_WATCH_LIST;
      case NotificationConstant.MODULE_TYPE_ORDER_PLACE:
        return DiamondModuleConstant.MODULE_TYPE_MY_ORDER;
      case NotificationConstant.MODULE_TYPE_SAVED_SEARCH:
        return DiamondModuleConstant.MODULE_TYPE_MY_SAVED_SEARCH;
      default:
        return 0;
    }
  }
}
