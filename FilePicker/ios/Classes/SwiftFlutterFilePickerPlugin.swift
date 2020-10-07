import Flutter
import UIKit

public class SwiftFlutterFilePickerPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "flutter_files_picker", binaryMessenger: registrar.messenger())
        let instance = SwiftFlutterFilePickerPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        
        // let themeColor = int(for: "themeColor", in: call)
        
        // DocumentPickerHelper.sharedInstance.themeColor = UIColor(rgb: themeColor)

        if (call.method == "pickImage") {
            DocumentPickerHelper.sharedInstance.openImagePicker()            
        }
        else if (call.method == "pickVideo") {
            DocumentPickerHelper.sharedInstance.openVideoPicker()            
        }        
        else if (call.method == "pickDocument") {
            DocumentPickerHelper.sharedInstance.openDocumentPicker()            
        }

        DocumentPickerHelper.sharedInstance.isDocumentGet = { (image, getDocument) in
            result(getDocument.toJson());
        }
    }    
    
    private func int(for key: String, in call: FlutterMethodCall) -> Int {
        return (call.arguments as? [String: Any])?[key] as! Int
    }
}
