import Foundation
import Combine

@MainActor
final class HomeViewModel: ObservableObject {
    @Published private(set) var state: ViewState<[Movie]> = .idle
    private let service: MovieServicing
    // El servicio real se crea dentro del init (ya dentro del MainActor)
    init(service: MovieServicing? = nil) {
        if let service {
            self.service = service
        } else {
            self.service = TMDBMovieService()
        }
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
