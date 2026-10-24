import SwiftUI

struct HomeView: View {
    @EnvironmentObject var session: SessionStore
    @StateObject private var viewModel = HomeViewModel()

    var body: some View {
        ZStack {
            AppBackground()
            content
        }
        .navigationTitle("Hola, \(session.userName)")
        .navigationDestination(for: Movie.self) { MovieDetailView(movie: $0) }
        .task { await viewModel.loadIfNeeded() }
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .idle, .loading:
            LoadingView()
        case .error(let message):
            ErrorView(message: message) { Task { await viewModel.load() } }
        case .loaded(let movies):
            List(movies) { movie in
                NavigationLink(value: movie) { MovieRow(movie: movie) }
                    .listRowBackground(Color.clear)
            }
            .scrollContentBackground(.hidden)
        }
    }
}

struct MovieRow: View {
    let movie: Movie

    var body: some View {
        HStack(spacing: 12) {
            AsyncImage(url: movie.posterURL) { image in
                image.resizable().scaledToFill()
            } placeholder: {
                Color.gray.opacity(0.3)
            }
            .frame(width: 60, height: 90)
            .clipShape(RoundedRectangle(cornerRadius: 8))

            VStack(alignment: .leading, spacing: 4) {
                Text(movie.title).font(.headline)
                Text(movie.releaseDate ?? "").font(.caption)
                
                // Representación de la calificación en UI
                if let rating = movie.voteAverage {
                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                            .font(.caption2)
                        Text(String(format: "%.1f", rating))
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding(.top, 2)
                }
            }
        }
    }
}
