import Foundation

// 1. Manejo de errores clasificado
enum APIError: Error, LocalizedError {
    case invalidURL
    case invalidResponse
    case httpError(Int)
    case networkError(Error)
    case decodingError(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL: return "La URL de la consulta es inválida."
        case .invalidResponse: return "El servidor devolvió una respuesta inesperada."
        case .httpError(let code): return "Error del servidor (Código: \(code))."
        case .networkError(let error): return "Error de red: \(error.localizedDescription)"
        case .decodingError: return "Ocurrió un error al leer los datos de la película."
        }
    }
}

// 2. Implementación real del protocolo MovieServicing
@MainActor
final class TMDBMovieService: MovieServicing {
    // REEMPLAZA ESTO CON TU API KEY REAL
    private let apiKey = "c67a97f3f9ae5fb2dd0d03ab7f875979"
    private let baseURL = "https://api.themoviedb.org/3"
    private let session: URLSession

    // Se puede inyectar otra sesión (por ejemplo, una con respuestas simuladas en las pruebas)
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func popularMovies() async throws -> [Movie] {
        guard let url = URL(string: "\(baseURL)/movie/popular?api_key=\(apiKey)&language=es-MX") else {
            throw APIError.invalidURL
        }
        return try await fetch(from: url)
    }
    
    func searchMovies(query: String) async throws -> [Movie] {
        guard let encoded = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "\(baseURL)/search/movie?api_key=\(apiKey)&language=es-MX&query=\(encoded)") else {
            throw APIError.invalidURL
        }
        return try await fetch(from: url)
    }
    
    // 3. Petición HTTP centralizada, asíncrona y con validaciones
    private func fetch(from url: URL) async throws -> [Movie] {
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            // Validamos que sea una respuesta HTTP
            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.invalidResponse
            }
            
            // Validamos el código de estado HTTP (200-299 es éxito)
            guard (200...299).contains(httpResponse.statusCode) else {
                throw APIError.httpError(httpResponse.statusCode)
            }
            
            // Decodificamos usando JSONDecoder
            let decoded = try JSONDecoder().decode(MovieResponse.self, from: data)
            return decoded.results
            
        } catch let error as APIError {
            throw error // Propagamos nuestros errores controlados
        } catch let error as DecodingError {
            throw APIError.decodingError(error)
        } catch {
            throw APIError.networkError(error) // Errores como falta de internet
        }
    }
}
