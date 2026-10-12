import SwiftUI

struct MovieDetailView: View {
    let movie: Movie
    @EnvironmentObject var favorites: FavoritesStore   // fuente de verdad compartida

    var body: some View {
        ZStack {
            AppBackground()
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    AsyncImage(url: movie.posterURL) { $0.resizable().scaledToFit() } placeholder: {
                        Color.gray.opacity(0.3).frame(height: 300)
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 12))

                    Text(movie.title).font(.title.bold())
                    Text("Estreno: \(movie.releaseDate ?? "N/D")").font(.subheadline)
                    Text(movie.overview.isEmpty ? "Sin sinopsis disponible." : movie.overview)
                }
                .padding()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            Button {
                favorites.toggle(movie)
            } label: {
                Image(systemName: favorites.isFavorite(movie) ? "heart.fill" : "heart")
            }
        }
    }
}
