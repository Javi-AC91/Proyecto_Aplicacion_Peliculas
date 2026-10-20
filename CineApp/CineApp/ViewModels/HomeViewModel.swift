import Foundation
import Combine

@MainActor
final class HomeViewModel: ObservableObject {
    @Published private(set) var state: ViewState<[Movie]> = .idle
    private let service: MovieServicing
    
    // Inyectamos el Mock por defecto
    init(service: MovieServicing = MockMovieService()) {
        self.service = service
    }
    
    func loadIfNeeded() async {
        guard case .idle = state else { return }
        await load()
    }
    
    func load() async {
        state = .loading
        do {
            let movies = try await service.popularMovies()
            state = .loaded(movies)
        } catch {
            state = .error("No se pudo cargar la cartelera.")
        }
    }
}
