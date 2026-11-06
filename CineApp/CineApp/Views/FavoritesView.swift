import SwiftUI

struct FavoritesView: View {
    // Adiós SwiftData. Hola inyección del servicio central.
    @EnvironmentObject var storage: StorageService

    var body: some View {
        ZStack {
            AppBackground()
            if storage.favorites.isEmpty {
                EmptyStateView(icon: "heart", text: "Aún no tienes favoritas.\nExplora y guarda las que te gusten.")
            } else {
                List {
                    ForEach(storage.favorites) { movie in
                        NavigationLink(value: movie) { MovieRow(movie: movie) }
                            .listRowBackground(Color.clear)
                    }
                    .onDelete(perform: deleteFavorite) // swipe para quitar
                }
                .scrollContentBackground(.hidden)
            }
        }
        .navigationTitle("Favoritos")
        .navigationDestination(for: Movie.self) { MovieDetailView(movie: $0) }
    }
    
    private func deleteFavorite(at offsets: IndexSet) {
        for index in offsets {
            let movie = storage.favorites[index]
            storage.toggleFavorite(movie: movie) // Si ya existe, esto la borra
        }
    }
}
