import SwiftUI
import FirebaseCore

@main
struct TranslateMeApp: App {
    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            TranslationHomeView()
        }
    }
}
