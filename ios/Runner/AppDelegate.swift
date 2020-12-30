import UIKit
import Flutter
import flutter_local_notifications
import UserNotifications

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    
    var notificationChannel : FlutterMethodChannel?
    
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
        
        if true{
            notificationChannel = FlutterMethodChannel(name: "com.base/notification", binaryMessenger: controller.binaryMessenger)
            
        }
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}

extension AppDelegate {
    
    override func userNotificationCenter(_ center: UNUserNotificationCenter,
                                         willPresent notification: UNNotification,
                                         withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        completionHandler([.alert, .sound])
    }
    
    override func userNotificationCenter(_ center: UNUserNotificationCenter,
                                         didReceive response: UNNotificationResponse,
                                         withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let userInfo = response.notification.request.content.userInfo
        print("Handling notifications with the Local Notification Identifier")
        print(userInfo)
        if let strData = userInfo["payload"] as? String{
            if let data = strData.data(using: .utf8) {
                if let dict = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]{
                    notificationChannel?.setMethodCallHandler { (call, result) in
                        
                        if call.method == "getNotification" {
                            result(dict)
                        }
                    }
                }
            }
        }
        completionHandler()
    }
}
