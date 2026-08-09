import SwiftUI

@main
struct LGCleaningOwnerApp: App {
    @StateObject private var store = OwnerStore()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(store)
        }
    }
}
