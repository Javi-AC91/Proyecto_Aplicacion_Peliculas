import SwiftUI

struct MainTabView: View {
    var userName: String
    
    var body: some View {
        TabView {
            // Pestaña 1: Inicio (Nuestra HomeView)
            HomeView(userName: userName)
                .tabItem {
                    Label("Inicio", systemImage: "house.fill")
                }
            
            // Pestaña 2: Buscar
            Text("Pantalla de Búsqueda")
                .tabItem {
                    Label("Buscar", systemImage: "magnifyingglass")
                }
            
            // Pestaña 3: Favoritos
            Text("Pantalla de Favoritos")
                .tabItem {
                    Label("Favoritos", systemImage: "heart.fill")
                }
            
            // Pestaña 4: Perfil
            Text("Perfil de \(userName)")
                .tabItem {
                    Label("Perfil", systemImage: "person.fill")
                }
        }
    }
}

#Preview {
    MainTabView(userName: "Usuario")
}
