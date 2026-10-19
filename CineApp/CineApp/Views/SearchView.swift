import SwiftUI

struct SearchView: View {
    @State private var query = ""                 // estado temporal local
    @State private var state: ViewState<[Movie]> = .idle

    private let apiKey = "TU_API_KEY_TMDB"

    var body: some View {
        ZStack {
            AppBackground()
            content
        }
        .navigationTitle("Buscar")
        .searchable(text: $query, prompt: "Busca una película")
        .onSubmit(of: .search) { Task { await search() } }
        .navigationDestination(for: Movie.self) { MovieDetailView(movie: $0) }
    }

    @ViewBuilder
    private var content: some View {
        switch state {
        case .idle:
            EmptyStateView(icon: "magnifyingglass", text: "Escribe el nombre de una película")
        case .loading:
            LoadingView()
        case .error(let message):
            ErrorView(message: message) { Task { await search() } }
        case .loaded(let movies) where movies.isEmpty:
            EmptyStateView(icon: "film", text: "Sin resultados para \"\(query)\"")
        case .loaded(let movies):
            List(movies) { movie in
                NavigationLink(value: movie) { MovieRow(movie: movie) }
                    .listRowBackground(Color.clear)
            }
            .scrollContentBackground(.hidden)
        }
    }

    private func search() async {
        let text = query.trimmingCharacters(in: .whitespaces)
        guard !text.isEmpty,
              let encoded = text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "https://api.themoviedb.org/3/search/movie?api_key=\(apiKey)&language=es-MX&query=\(encoded)") else { return }
        state = .loading
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            state = .loaded(try JSONDecoder().decode(MovieResponse.self, from: data).results)
        } catch {
            state = .error("No se pudo conectar. Revisa tu internet.")
        }
    }
}
