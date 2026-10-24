import SwiftUI

struct SearchView: View {
    // La vista ahora delega la lógica al ViewModel
    @StateObject private var viewModel = SearchViewModel()
    
    var body: some View {
        ZStack {
            AppBackground()
            content
        }
        .navigationTitle("Buscar")
        .searchable(text: $viewModel.query, prompt: "Busca una película")
        .onSubmit(of: .search) { Task { await viewModel.search() } }
        .navigationDestination(for: Movie.self) { MovieDetailView(movie: $0) }
    }
    
    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .idle:
            EmptyStateView(icon: "magnifyingglass", text: "Escribe el nombre de una película")
        case .loading:
            LoadingView()
        case .error(let message):
            ErrorView(message: message) { Task { await viewModel.search() } }
        case .loaded(let movies) where movies.isEmpty:
            EmptyStateView(icon: "film", text: "Sin resultados para \"\(viewModel.query)\"")
        case .loaded(let movies):
            List(movies) { movie in
                NavigationLink(value: movie) { MovieRow(movie: movie) }
                    .listRowBackground(Color.clear)
            }
            .scrollContentBackground(.hidden)
        }
    }
}
