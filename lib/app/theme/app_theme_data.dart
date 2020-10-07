import '../app.export.dart';

class AppThemeData {
  AppThemeData();

  AppThemeData.fromAppTheme(AppTheme appTheme) {
    name = appTheme.name;
    backgroundColors =
        appTheme.backgroundColors.map((color) => color.value).toList();
    accentColor = appTheme.accentColor.value;
  }

  factory AppThemeData.fromJson(Map<String, dynamic> json) => AppThemeData()
    ..name = json['name'] as String
    ..backgroundColors =
        (json['backgroundColors'] as List)?.map((e) => e as int)?.toList()
    ..accentColor = json['accentColor'] as int;

  String name;
  List<int> backgroundColors;
  int accentColor;

  Map<String, dynamic> toJson() => _$AppThemeDataToJson(this);

  Map<String, dynamic> _$AppThemeDataToJson(AppThemeData instance) =>
      <String, dynamic>{
        'name': instance.name,
        'backgroundColors': instance.backgroundColors,
        'accentColor': instance.accentColor,
      };

  @override
  String toString() {
    return 'AppThemeData{name: $name,'
        'backgroundColors: $backgroundColors,'
        'accentColor: $accentColor}';
  }
}
