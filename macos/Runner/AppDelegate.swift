import Cocoa
import FlutterMacOS
import GoogleMaps

@NSApplicationMain
class AppDelegate: FlutterAppDelegate {
  // override func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
  //   return true
  // }
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GMSServices.provideAPIKey("AIzaSyD7KtQoq29-5TqELLdPBSQoqCD376-qGjA")
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
