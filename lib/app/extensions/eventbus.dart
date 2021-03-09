import 'package:event_bus/event_bus.dart';

final EventBus event = EventBus();
final EventBus eventForBank = EventBus();

final String eventMasterSelection = "eventMasterSelection";
final String eventMasterForDeSelectMake = "eventMasterForDeSelectMake";
final String eventMasterForGroupWidget = "eventMasterForGroupWidget";
final String eventMasterForSingleItemOfGroupSelection =
    "eventMasterForSingleItemOfGroupSelection";
final String eventMasterForGroupWidgetSelectAll =
    "eventMasterForGroupWidgetSelectAll";

final String eventSelectAllGroupDiamonds = "selectAllGroupDiamonds";
final String eventForShareCaratRangeSelected =
    "eventForShareCaratRangeSelected";

final String eventOfflineDiamond = "offlineDiamond";
final String eventDiamondRefresh = "diamondRefresh";

final String eventSelectAll = "eventSelectAll";
final String eventGridView = "eventGridView";

final String eventDiamondMoreClick = "eventDiamondMoreClick";
final String eventManageBottomMenuClick = "eventManageBottomMenuClick";
final String eventDiamondDownloadClick = "clickOnDownload";
final String eventSortClick = "eventSortClick";
