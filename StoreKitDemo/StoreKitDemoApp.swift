import SwiftUI

@main
struct StoreKitDemoApp: App {
    @StateObject private var store = StoreKitStore()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
