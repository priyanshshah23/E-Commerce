import 'package:build/build.dart';
import 'package:custom_localization_generator/custom_localization_generator.dart';
import 'package:source_gen/source_gen.dart';

Builder customLocalizationGenerator(BuilderOptions options) {
  return SharedPartBuilder(
      [CustomLocalizationGenerator()], 'custom_localization');
}
