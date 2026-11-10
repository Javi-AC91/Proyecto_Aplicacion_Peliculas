import SwiftUI

struct FavoritesView: View {
    @ObservedObject var storage: StorageService

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
        .navigationDestination(for: Movie.self) { movie in
            MovieDetailView(movie: movie, storage: storage)
        }
    }
    
    private func deleteFavorite(at offsets: IndexSet) {
        for index in offsets {
            let movie = storage.favorites[index]
            storage.toggleFavorite(movie: movie)
        }
    }
}
