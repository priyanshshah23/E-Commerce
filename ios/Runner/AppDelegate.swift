import UIKit
import Flutter
import flutter_local_notifications

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    
    if #available(iOS 10.0, *) {
       UNUserNotificationCenter.current().delegate = self 
    }
    
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    let batteryChannel = FlutterMethodChannel(name: "diamnow/signupwebview",
                                              binaryMessenger: controller.binaryMessenger)
    batteryChannel.setMethodCallHandler({
      (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
      
    })

    let channel = FlutterMethodChannel(name: "dexterx.dev/flutter_local_notifications_example",
                                                        binaryMessenger: controller.binaryMessenger)
    channel.setMethodCallHandler { (call, result) in
        if call.method == "getTimeZoneName"{
            result(NSTimeZone.local.identifier)
        }
    }

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
