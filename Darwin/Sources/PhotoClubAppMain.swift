import SwiftUI
import PhotoClub
import FirebaseCore

/// The entry point to the app simply loads the App implementation from SPM module.
@main
struct AppMain: App, PhotoClubApp {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
}

class AppDelegate : NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        return true
    }
}
