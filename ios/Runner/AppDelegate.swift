import UIKit
import Flutter
import GoogleMaps 

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    GMSServices.provideAPIKey("AIzaSyD9XZBYlnwfrKQ1ZK-EUxJtFePKXW_1sfE")  
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
