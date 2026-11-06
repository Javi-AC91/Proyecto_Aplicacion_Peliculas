import Foundation
import Combine

@MainActor
final class SearchViewModel: ObservableObject {
    @Published var query: String = ""
    @Published private(set) var state: ViewState<[Movie]> = .idle
    
    private let service: MovieServicing
    
    // CAMBIO: Usamos el servicio REAL
    init(service: MovieServicing = TMDBMovieService()) {
        self.service = service
    }
    
    func search() async {
        let text = query.trimmingCharacters(in: .whitespaces)
        guard !text.isEmpty else { return }
        
        state = .loading
        do {
            let movies = try await service.searchMovies(query: text)
            state = .loaded(movies)
        } catch let error as LocalizedError {
            state = .error(error.errorDescription ?? "Error de conexión.")
        } catch {
            state = .error("Error inesperado: \(error.localizedDescription)")
        }
    }
}
