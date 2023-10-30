import UIKit
import Flutter
import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GMSServices.provideAPIKey("AIzaSyD7KtQoq29-5TqELLdPBSQoqCD376-qGjA")
    GeneratedPluginRegistrant.register(with: self)
    if #available(iOS 10.0, *) {
     UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
    }
    GMSServices.provideAPIKey("AIzaSyD7KtQoq29-5TqELLdPBSQoqCD376-qGjA")
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
