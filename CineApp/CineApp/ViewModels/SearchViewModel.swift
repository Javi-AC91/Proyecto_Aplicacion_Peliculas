import Foundation
import Combine

@MainActor
final class SearchViewModel: ObservableObject {
    @Published var query: String = ""
    @Published private(set) var state: ViewState<[Movie]> = .idle
    
    private let service: MovieServicing
    
    // Inyectamos el Mock por defecto para que funcione sin internet
    init(service: MovieServicing = MockMovieService()) {
        self.service = service
    }
    
    func search() async {
        let text = query.trimmingCharacters(in: .whitespaces)
        guard !text.isEmpty else { return }
        
        state = .loading
        do {
            // Llamamos al servicio (actualmente el Mock)
            let movies = try await service.searchMovies(query: text)
            state = .loaded(movies)
        } catch {
            state = .error("No se pudo conectar. Revisa tu internet.")
        }
    }
}
