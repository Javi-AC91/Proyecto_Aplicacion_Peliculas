import SwiftUI

/// Navegación condicional: Login y Main NO están al mismo nivel.
/// Main solo existe si hay sesión; sin sesión no hay forma de llegar a ella.
struct RootView: View {
    @EnvironmentObject var session: SessionStore

    var body: some View {
        if session.isLoggedIn {
            MainTabView()
        } else {
            LoginView()
        }
    }
}

struct MainTabView: View {
    var body: some View {
        TabView {
            // Cada tab tiene su PROPIO NavigationStack
            NavigationStack { HomeView() }
                .tabItem { Label("Inicio", systemImage: "house") }

            NavigationStack { SearchView() }
                .tabItem { Label("Buscar", systemImage: "magnifyingglass") }

            NavigationStack { FavoritesView() }
                .tabItem { Label("Favoritos", systemImage: "heart") }

            NavigationStack { ProfileView() }
                .tabItem { Label("Perfil", systemImage: "person") }
        }
    }
}
