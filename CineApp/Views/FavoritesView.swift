import SwiftUI

struct FavoritesView: View {
    @EnvironmentObject var favorites: FavoritesStore

    var body: some View {
        ZStack {
            AppBackground()
            if favorites.movies.isEmpty {
                EmptyStateView(icon: "heart", text: "Aún no tienes favoritas.\nExplora y guarda las que te gusten.")
            } else {
                List {
                    ForEach(favorites.movies) { movie in
                        NavigationLink(value: movie) { MovieRow(movie: movie) }
                            .listRowBackground(Color.clear)
                    }
                    .onDelete(perform: favorites.remove)   // swipe para quitar
                }
                .scrollContentBackground(.hidden)
            }
        }
        .navigationTitle("Favoritos")
        .navigationDestination(for: Movie.self) { MovieDetailView(movie: $0) }
    }
}
