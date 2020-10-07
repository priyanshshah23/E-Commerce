import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Removes the timezone to allow [DateTime] to parse the string.
String formatAppDateString(String string) {
  final List sanitized = string.split(" ")
    ..removeAt(0)
    ..removeWhere((part) => part.startsWith("+"));

  return sanitized.join(" ");
}

// todo: use Uri class instead
String appendParamsToUrl(String url, Map<String, String> params) {
  if (params == null || params.isEmpty) {
    return url;
  }

  String paramsString = "?";

  for (int i = 0; i < params.length; i++) {
    if (i != 0) {
      paramsString += "&";
    }
    paramsString += "${params.keys.elementAt(i)}=${params.values.elementAt(i)}";
  }

  return url + paramsString;
}

Map<String, String> htmlEntities = {
  "&amp;": "&",
  "&lt;": "<",
  "&gt;": ">",
};

/// Parses <, > and & when they appear as html entities.
String parseHtmlEntities(String source) {
  htmlEntities.forEach((entity, value) {
    source = source.replaceAll(entity, value);
  });

  return source;
}

/// Reduces the [text] by replacing newlines with spaces and if the length of
/// the text exceeds the [limit], the text will be cut at the closest space
/// after [limit] with an ellipsis.
String reduceText(String text, {int limit = 100}) {
  text = text.replaceAll("\n", " ").trim();

  if (text.length > limit) {
    final int index = text.substring(limit).indexOf(" ");

    if (index != -1) {
      // cut off the text before the nearest space
      text = "${text.substring(0, limit + index)}...";
    }
  }

  return text;
}

bool isStringEmpty(String string) {
  return string == null || string.trim().isEmpty ? true : false;
}

bool validateEmail(String value) {
  Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regex = new RegExp(pattern);
  return (!regex.hasMatch(value)) ? false : true;
}

bool validateMobile(String value) {
  String patttern = r'^[0-9]{10}$';
print(value);
 // String patttern = r'(^(?:[+0]9)?[0-9]{10}$)';
  RegExp regExp = new RegExp(patttern);
  if (isStringEmpty(value)) {
    return false;
  }
  else if (!regExp.hasMatch(value)) {
    if(value.length>10)
      return true;
    return false;
  }
  return true;
}


Color darken(Color color, [double amount = .1]) {
  assert(amount >= 0 && amount <= 1);

  final hsl = HSLColor.fromColor(color);
  final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));

  return hslDark.toColor();
}

Color lighten(Color color, [double amount = .1]) {
  assert(amount >= 0 && amount <= 1);

  final hsl = HSLColor.fromColor(color);
  final hslLight = hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));

  return hslLight.toColor();
}

bool validatePincode(String value) {
  String patttern = r'^[0-9]{6}$';

  // String patttern = r'(^(?:[+0]9)?[0-9]{10}$)';
  RegExp regExp = new RegExp(patttern);
  if (isStringEmpty(value)) {
    return false;
  } else if (!regExp.hasMatch(value)) {
    if(value.length>6)
      return true;
    return false;
  }
  return true;
}


bool validationDrivingLicense(String value) {
  String patttern = r'(^[A-Z]{2}[0-9]{13}$)';
  RegExp regExp = new RegExp(patttern);
  if (isStringEmpty(value)) {
    return false;
  } else if (!regExp.hasMatch(value)  ) {
    print(value);
    if( value.length>15)
    return true;
    return false;

  }
  return true;
}
bool validationPANCard(String value) {
  String patttern = r'(^[A-Z]{5}[0-9]{4}[A-Z]{1}$)';
  RegExp regExp = new RegExp(patttern);
  if (isStringEmpty(value)) {
    return false;
  } else if (!regExp.hasMatch(value) || value.length<10) {
    return false;
  }
  return true;
}
bool validationIFSCCode(String value) {
  String patttern = r'(^[A-Z|a-z]{4}[0][\d]{6}$)';
  RegExp regExp = new RegExp(patttern);
  if (isStringEmpty(value)) {
    return false;
  } else if (!regExp.hasMatch(value)) {
    return false;
  }
  return true;
}

//Validator
abstract class StringValidator {
  bool isValid(String value);
}

class ValidatorInputFormatter implements TextInputFormatter {
  ValidatorInputFormatter({this.editingValidator});

  final StringValidator editingValidator;

  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final oldValueValid = editingValidator.isValid(oldValue.text);
    final newValueValid = editingValidator.isValid(newValue.text);
    if (oldValueValid && !newValueValid) {
      return oldValue;
    }
    return newValue;
  }
}

//Decimal Regex
class DecimalNumberEditingRegexValidator extends RegexValidator {
  final int maxLimit;

  DecimalNumberEditingRegexValidator(this.maxLimit)
      : super(regexSource: "^\$|^([0-9]{0,$maxLimit})?\$");
}

class LicenceValidator extends RegexValidator {
  final int maxLimit;

   LicenceValidator(this.maxLimit)
      : super(regexSource: "^\$|^([A-Z|0-9]{0,$maxLimit})?\$");
}



class RegexValidator implements StringValidator {
  RegexValidator({this.regexSource});

  final String regexSource;

  /// value: the input string
  /// returns: true if the input string is a full match for regexSource
  bool isValid(String value) {
    try {
      final regex = RegExp(regexSource);
      final matches = regex.allMatches(value);
      for (Match match in matches) {
        if (match.start == 0 && match.end == value.length) {
          return true;
        }
      }
      return false;
    } catch (e) {
      // Invalid regex
      assert(false, e.toString());
      return true;
    }
  }
}
