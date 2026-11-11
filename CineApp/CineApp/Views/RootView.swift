import SwiftUI

/// Navegación condicional: Login y Main NO están al mismo nivel.
/// Main solo existe si hay sesión; sin sesión no hay forma de llegar a ella.
struct RootView: View {
    // Recibimos las dependencias inyectadas desde CineAppApp
    @ObservedObject var session: SessionStore
    @ObservedObject var storage: StorageService

    var body: some View {
        if session.isLoggedIn {
            // Pasamos ambas fuentes de verdad a la vista de pestañas
            MainTabView(session: session, storage: storage)
        } else {
            // Login solo necesita la sesión, no la base de datos
            LoginView(session: session)
        }
    }
}

struct MainTabView: View {
    @ObservedObject var session: SessionStore
    @ObservedObject var storage: StorageService

    var body: some View {
        TabView {
            // Repartimos las dependencias necesarias a cada pestaña
            NavigationStack { HomeView(session: session, storage: storage) }
                .tabItem { Label("Inicio", systemImage: "house") }

            NavigationStack { SearchView(storage: storage) }
                .tabItem { Label("Buscar", systemImage: "magnifyingglass") }

            NavigationStack { FavoritesView(storage: storage) }
                .tabItem { Label("Favoritos", systemImage: "heart") }

            NavigationStack { ProfileView(session: session, storage: storage) }
                .tabItem { Label("Perfil", systemImage: "person") }
        }
    }
}
