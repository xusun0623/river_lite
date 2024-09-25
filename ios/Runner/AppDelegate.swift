import UIKit
import Flutter

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    if #available(iOS 15.0, *) {
      let displayLink = CADisplayLink(target: self, selector: #selector(step))
      displayLink.preferredFrameRateRange = CAFrameRateRange(minimum:120, maximum:120, preferred:120)
      displayLink.add(to: .current, forMode: .default)
    }
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
  @objc func step(displaylink: CADisplayLink) {
      // Will be called once a frame has been built while matching desired frame rate
  }
}
