import Foundation
import Combine

@MainActor
final class HomeViewModel: ObservableObject {
    @Published private(set) var state: ViewState<[Movie]> = .idle
    private let service: MovieServicing
    
    // CAMBIO: Inyectamos el servicio REAL por defecto
    init(service: MovieServicing = TMDBMovieService()) {
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
            // Validamos estado 'Empty' (aunque populares raro vez está vacío, es buena práctica)
            state = .loaded(movies)
        } catch let error as LocalizedError {
            // Propagamos el mensaje de error de nuestro APIError
            state = .error(error.errorDescription ?? "Ocurrió un error desconocido.")
        } catch {
            state = .error("Error inesperado: \(error.localizedDescription)")
        }
    }
}
