import Foundation

// El protocolo ahora exige dos métodos: populares y búsqueda
protocol MovieServicing {
    func popularMovies() async throws -> [Movie]
    func searchMovies(query: String) async throws -> [Movie]
}

final class MockMovieService: MovieServicing {
    // Base de datos ficticia centralizada con calificaciones (voteAverage) del 1 al 10
    private let mockMovies = [
        Movie(id: 1, title: "Inception", overview: "Un ladrón que roba secretos corporativos...", posterPath: nil, releaseDate: "2010-07-15", voteAverage: 8.8),
        Movie(id: 2, title: "Interstellar", overview: "Un equipo de exploradores viaja a través del espacio.", posterPath: nil, releaseDate: "2014-11-05", voteAverage: 8.6),
        Movie(id: 3, title: "Batman: El Caballero de la Noche", overview: "El Joker causa estragos en Gotham.", posterPath: nil, releaseDate: "2008-07-18", voteAverage: 9.0)
    ]
    
    // Método para HomeView (devuelve todas)
    func popularMovies() async throws -> [Movie] {
        try await Task.sleep(nanoseconds: 500_000_000)
        return mockMovies
    }
    
    // Método para SearchView (filtra por texto)
    func searchMovies(query: String) async throws -> [Movie] {
        try await Task.sleep(nanoseconds: 500_000_000)
        
        // Filtra el arreglo comprobando si el título contiene la búsqueda (ignorando mayúsculas)
        return mockMovies.filter { movie in
            movie.title.localizedCaseInsensitiveContains(query)
        }
    }
}
