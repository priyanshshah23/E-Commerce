# custom_localization

A Flutter package to generate Localization classes from JSON File

## Getting Started

1. Use following command and clone this package into your package.

```shell script
git submodule add http://gitlab.coruscate.in/flutter/custom_localization.git
```

2. Add following dependencies to `pubspec.yaml`.

```yaml
dependencies:
    custom_localization:
        path: ./custom_localization

dev_dependencies:
    build_runner: any
    custom_localization_generator:
        path: ./custom_localization/custom_localization_generator
```

3. Create a json file in following format

- Root elements must be language code
- ``language_code``,``script_code``  are required.
- set ``is_default`` to ``true`` if the locale is default locale otherwise not required.
- You can create any number of objects inside locale object ex. inside ```"en_us"```. 

```json
{
  "en_us": {
    "language_code": "en",
    "script_code": "us",
    "is_default": true,
    "lbl": {
      "app_name": "Test Localization",
      "user_name": "UserName"
    }
  },
  "iw": {
    "language_code": "iw",
    "lbl": {
      "user_name": "יציאה"
    }
  }
}
```

4. Create a class with ``@CustomLocalization("")`` and pass path of the JSON file in this annotation.

```dart
import 'package:custom_localization/custom_localization.dart';

part 'app_localization.g.dart';

@CustomLocalization("assets/strings.json")
class AppLocalization {}

```

5. Run ``build_runner`` to generate classes.

```shell script
flutter pub run build_runner build 
```