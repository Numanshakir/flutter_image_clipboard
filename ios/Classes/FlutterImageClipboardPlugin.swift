import Flutter
import UIKit

public class FlutterImageClipboardPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "clipboard_image", binaryMessenger: registrar.messenger())
    let instance = FlutterImageClipboardPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
  switch call.method {
    case "copyImageToClipboard":
       if let args = call.arguments as? [String: Any],
           let path = args["path"] as? String {
          if let image = UIImage(contentsOfFile: path) {
            UIPasteboard.general.image = image
            result(nil)
          } else {
            result(FlutterError(code: "UNAVAILABLE",
                                message: "Failed to load image",
                                details: nil))
          }
        }
    default:
      result(FlutterMethodNotImplemented)
    }
  }
}
