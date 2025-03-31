import UIKit
import Flutter

@main
@objc class AppDelegate: FlutterAppDelegate {
    private var eventSink: FlutterEventSink?
    private var lastStatus: Bool = false

    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let controller = window?.rootViewController as! FlutterViewController
        let eventChannel = FlutterEventChannel(
            name: "rotation_channel",
            binaryMessenger: controller.binaryMessenger
        )
        eventChannel.setStreamHandler(self)

        // Start device orientation notifications
        UIDevice.current.beginGeneratingDeviceOrientationNotifications()

        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    deinit {
        UIDevice.current.endGeneratingDeviceOrientationNotifications()
    }
}

extension AppDelegate: FlutterStreamHandler {
    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        self.eventSink = events

        // Initial check for orientation status
        checkRotationStatus(events: events)

        // Observe orientation changes
        NotificationCenter.default.addObserver(
            forName: UIDevice.orientationDidChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.checkRotationStatus(events: events)
        }

        return nil
    }

    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        NotificationCenter.default.removeObserver(self)
        eventSink = nil
        return nil
    }

    private func checkRotationStatus(events: @escaping FlutterEventSink) {
        let interfaceOrientation: UIInterfaceOrientation

        if #available(iOS 13.0, *) {
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
                return
            }
            interfaceOrientation = windowScene.interfaceOrientation
        } else {
            interfaceOrientation = UIApplication.shared.statusBarOrientation
        }

        // Check if rotation lock is enabled or not
        let isLocked = interfaceOrientation == .portrait || interfaceOrientation == .landscapeLeft || interfaceOrientation == .landscapeRight

        if isLocked != lastStatus {
            events(isLocked)  // Send event to Flutter
            lastStatus = isLocked
        }
    }
}
