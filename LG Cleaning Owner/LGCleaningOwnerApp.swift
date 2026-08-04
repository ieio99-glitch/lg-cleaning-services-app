import SwiftUI
import GoogleSignIn

@main
struct LGCleaningOwnerApp: App {
    @StateObject private var store = OwnerStore()
    
    init() {
        GIDSignIn.sharedInstance.configuration = GIDConfiguration(
            clientID: "723508270041-hsev04ukrke1kv2e1hnv6u6909ieucbb.apps.googleusercontent.com"
        )
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(store)
                .onOpenURL { url in
                    GIDSignIn.sharedInstance.handle(url)
                }
        }
    }
}

