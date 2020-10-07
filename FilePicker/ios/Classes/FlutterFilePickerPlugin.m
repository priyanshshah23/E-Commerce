#import "FlutterFilePickerPlugin.h"
#import <flutter_files_picker/flutter_files_picker-Swift.h>

@implementation FlutterFilePickerPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterFilePickerPlugin registerWithRegistrar:registrar];
}
@end
