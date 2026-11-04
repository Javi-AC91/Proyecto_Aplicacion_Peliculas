import SwiftUI
import SwiftData

@main
struct CineAppApp: App {
    @StateObject private var session = SessionStore()
    
    // Ya no inicializamos FavoritesStore ni ReviewsStore aquí,
    // porque SwiftData se encargará de esa persistencia.

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(session)
                // Configuramos SwiftData indicándole qué modelos (tablas) va a guardar
                .modelContainer(for: [Movie.self, Review.self])
        }
    }
}
