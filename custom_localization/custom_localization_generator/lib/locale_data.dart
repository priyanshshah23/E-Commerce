class LocaleData {
  String className; //store the localeClassName
  String languageName; // name of the locale ex. en_us
  String languageCode; // language code ex. en
  String scriptCode; // script code country specific ex. us
  bool isDefault; //true if its the default locale
  Map<String, Map<String, String>> subClassFields =
  {}; // map of subclass name and its fields with values
  List<String> subClassNames = []; //
}
