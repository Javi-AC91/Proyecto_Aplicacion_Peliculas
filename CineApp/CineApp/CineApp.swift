import SwiftUI

@main
struct CineAppApp: App {
    // Fuentes de verdad globales: se crean UNA sola vez aquí
    // y se inyectan al árbol de vistas con .environmentObject.
    @StateObject private var session = SessionStore()
    @StateObject private var favorites = FavoritesStore()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(session)
                .environmentObject(favorites)
        }
    }
}
