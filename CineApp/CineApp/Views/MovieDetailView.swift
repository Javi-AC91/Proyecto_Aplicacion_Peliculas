import SwiftUI

struct MovieDetailView: View {
    @StateObject private var viewModel: MovieDetailViewModel
    @EnvironmentObject var favorites: FavoritesStore
    
    // Inicializamos el ViewModel inyectando la película
    init(movie: Movie) {
        _viewModel = StateObject(wrappedValue: MovieDetailViewModel(movie: movie))
    }
    
    var body: some View {
        ZStack {
            AppBackground()
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    AsyncImage(url: viewModel.movie.posterURL) { $0.resizable().scaledToFit() } placeholder: {
                        Color.gray.opacity(0.3).frame(height: 300)
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    
                    Text(viewModel.movie.title).font(.title.bold())
                    Text("Estreno: \(viewModel.movie.releaseDate ?? "N/D")").font(.subheadline)
                    Text(viewModel.movie.overview.isEmpty ? "Sin sinopsis disponible." : viewModel.movie.overview)
                }
                .padding()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            Button {
                viewModel.toggleFavorite(in: favorites)
            } label: {
                Image(systemName: viewModel.isFavorite(in: favorites) ? "heart.fill" : "heart")
            }
        }
    }
}
