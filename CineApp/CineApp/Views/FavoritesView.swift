import SwiftUI
import SwiftData

struct FavoritesView: View {
    // 1. Accedemos a la sala de operaciones de la base de datos
    @Environment(\.modelContext) private var context
    
    // 2. Le pedimos a SwiftData que nos traiga todas las películas guardadas
    @Query private var favorites: [Movie]

    var body: some View {
        ZStack {
            AppBackground()
            if favorites.isEmpty {
                EmptyStateView(icon: "heart", text: "Aún no tienes favoritas.\nExplora y guarda las que te gusten.")
            } else {
                List {
                    ForEach(favorites) { movie in
                        NavigationLink(value: movie) { MovieRow(movie: movie) }
                            .listRowBackground(Color.clear)
                    }
                    .onDelete(perform: deleteFavorite)   // swipe para quitar
                }
                .scrollContentBackground(.hidden)
            }
        }
        .navigationTitle("Favoritos")
        .navigationDestination(for: Movie.self) { MovieDetailView(movie: $0) }
    }
    
    // 3. Función para borrar usando el contexto de SwiftData
    private func deleteFavorite(at offsets: IndexSet) {
        for index in offsets {
            context.delete(favorites[index])
        }
    }
}
