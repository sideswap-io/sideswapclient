import UIKit
import Flutter
import LocalAuthentication

let kKeyName = "MNEMONIC"

let kErrorOther = "other"
let kErrorNegative = "negative"

public func dummyMethodToEnforceBundling() {
    store_dart_post_cobject()

    sideswap_client_start(0, "", "", 0)
    sideswap_send_request(0, "", 0)
    sideswap_msg_ptr(0)
    sideswap_msg_len(0)
    sideswap_msg_free(0)
    sideswap_generate_mnemonic12()
    sideswap_verify_mnemonic("")
    sideswap_check_addr(0, "", 0)
    sideswap_process_background("");

    let s = ""
    let cs = (s as NSString).utf8String
    let buffer = UnsafeMutablePointer<Int8>(mutating: cs)
    sideswap_string_free(buffer)
}

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        // Fix for crash when using POSIX sockets
        signal(SIGPIPE, SIG_IGN)

        let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
        let encryptionChannel = FlutterMethodChannel(name: "app.sideswap.io/encryption",
                                                     binaryMessenger: controller.binaryMessenger)

        encryptionChannel.setMethodCallHandler({
            [weak self] (call: FlutterMethodCall, result: FlutterResult) -> Void in
            // Note: this method is invoked on the UI thread.
            switch call.method  {
            case "canAuthenticate":
                self?.canAuthenticate(result: result)
            case "encryptBiometric":
                let data: FlutterStandardTypedData = call.arguments as! FlutterStandardTypedData
                self?.encrypt(data: data.data, result: result, userPresence: true)
            case "decryptBiometric":
                self?.decrypt(result: result)
            case "encryptFallback":
                let data: FlutterStandardTypedData = call.arguments as! FlutterStandardTypedData
                self?.encrypt(data: data.data, result: result, userPresence: false)
            case "decryptFallback":
                self?.decrypt(result: result)
            default:
                result(FlutterMethodNotImplemented)
            }
        })

        if #available(iOS 10.0, *) {
          UNUserNotificationCenter.current().delegate = self as UNUserNotificationCenterDelegate
        }
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    private func canAuthenticate(result: FlutterResult) {
        let context = LAContext()
        var error: NSError?
        let canEvaluate = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
        result(canEvaluate)
    }

    private func encrypt(data: Data, result: FlutterResult, userPresence: Bool) {
        var query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                    kSecAttrLabel as String: kKeyName,
                                    kSecValueData as String: data]
        if userPresence {
            let access = SecAccessControlCreateWithFlags(nil,
                                                         kSecAttrAccessibleWhenUnlockedThisDeviceOnly,
                                                         .userPresence, nil)

            let context = LAContext()
            query[kSecAttrAccessControl as String] = access as Any
            query[kSecUseAuthenticationContext as String] = context
        }

        let secItemClasses = [kSecClassGenericPassword]
        for itemClass in secItemClasses {
            let spec: NSDictionary = [kSecClass: itemClass]
            SecItemDelete(spec)
        }

        let status = SecItemAdd(query as CFDictionary, nil)
        if (status != errSecSuccess) {
            result(FlutterError(code: kErrorOther, message: "Encrypt failed: \(status)", details: nil))
            return
        }

        // Just pass something to Flutter side (we send encrypted data on Android, that not used on iOS)
        let kStubResult: Data = "encrypted".data(using: String.Encoding.utf8)!
        result(kStubResult)
    }

    private func decrypt(result: FlutterResult) {
        let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                    kSecMatchLimit as String: kSecMatchLimitOne,
                                    kSecReturnAttributes as String: true,
                                    kSecAttrLabel as String: kKeyName,
                                    kSecUseOperationPrompt as String: "Unlock mnemonic",
                                    kSecReturnData as String: true]

        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        if status == errSecUserCanceled {
            result(FlutterError(code: kErrorNegative, message: "User canceled", details: nil))
            return
        }
        if status != errSecSuccess {
            result(FlutterError(code: kErrorOther, message: "Decrypt failed: \(status)", details: nil))
            return
        }

        guard let existingItem = item as? [String: Any],
              let data = existingItem[kSecValueData as String] as? Data,
              let mnemonic = String(data: data, encoding: String.Encoding.utf8)
        else {
            result(FlutterError(code: kErrorOther, message: "Decrypt failed: unknown error", details: nil))
            return
        }

        let mnemonicEncoded: Data = mnemonic.data(using: String.Encoding.utf8)!
        result(mnemonicEncoded)
    }
}
