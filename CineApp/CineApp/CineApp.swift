import SwiftUI

@main
struct CineAppApp: App {
    @StateObject private var session = SessionStore()
    @StateObject private var storageService = StorageService()

    var body: some Scene {
        WindowGroup {
            // Pasamos las dos fuentes de verdad al primer nodo
            RootView(session: session, storage: storageService)
        }
    }
}
