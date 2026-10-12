import SwiftUI

struct HomeView: View {
    @EnvironmentObject var session: SessionStore

    // Caché de sección: vive mientras exista la vista (el TabView la mantiene viva)
    @State private var state: ViewState<[Movie]> = .idle

    private let apiKey = "TU_API_KEY_TMDB"

    var body: some View {
        ZStack {
            AppBackground()
            content
        }
        .navigationTitle("Hola, \(session.userName)")
        .navigationDestination(for: Movie.self) { MovieDetailView(movie: $0) }
        .task { if case .idle = state { await load() } }
    }

    @ViewBuilder
    private var content: some View {
        switch state {
        case .idle, .loading:
            LoadingView()
        case .error(let message):
            ErrorView(message: message) { Task { await load() } }
        case .loaded(let movies):
            List(movies) { movie in
                NavigationLink(value: movie) { MovieRow(movie: movie) }
                    .listRowBackground(Color.clear)
            }
            .scrollContentBackground(.hidden)
        }
    }

    // Hoy la vista hace la llamada de red directamente (se analiza en la Parte 2).
    private func load() async {
        state = .loading
        guard let url = URL(string: "https://api.themoviedb.org/3/movie/popular?api_key=\(apiKey)&language=es-MX") else {
            state = .error("URL inválida")
            return
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoded = try JSONDecoder().decode(MovieResponse.self, from: data)
            state = .loaded(decoded.results)
        } catch {
            state = .error("No se pudo conectar. Revisa tu internet.")
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
            }
        }
    }
}
