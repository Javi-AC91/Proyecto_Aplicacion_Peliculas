import Foundation
import XCTest
@testable import CineApp

// MARK: - Datos de prueba

@MainActor
func makeMovie(id: Int = 1, title: String = "Inception") -> Movie {
    Movie(id: id, title: title, overview: "Sinopsis de prueba",
          posterPath: nil, releaseDate: "2010-07-15", voteAverage: 8.8)
}

// MARK: - Servicio falso (para probar los ViewModels sin red)

/// Responde lo que le indiques en `result`. Si `delayNanoseconds` > 0, tarda en responder
/// (sirve para observar el estado "Cargando").
@MainActor
final class StubMovieService: MovieServicing {
    var result: Result<[Movie], Error>
    var delayNanoseconds: UInt64 = 0
    private(set) var callCount = 0
    private(set) var lastQuery: String?

    init(result: Result<[Movie], Error>) {
        self.result = result
    }

    func popularMovies() async throws -> [Movie] {
        callCount += 1
        try await waitIfNeeded()
        return try result.get()
    }

    func searchMovies(query: String) async throws -> [Movie] {
        callCount += 1
        lastQuery = query
        try await waitIfNeeded()
        return try result.get()
    }

    private func waitIfNeeded() async throws {
        if delayNanoseconds > 0 {
            try await Task.sleep(nanoseconds: delayNanoseconds)
        }
    }
}

// MARK: - Red simulada (para probar TMDBMovieService sin internet ni API key)

/// Intercepta las peticiones de una URLSession y responde con lo que configuremos.
nonisolated final class StubURLProtocol: URLProtocol {
    nonisolated(unsafe) static var handler: ((URLRequest) throws -> (HTTPURLResponse, Data))?
    nonisolated(unsafe) static var lastRequest: URLRequest?

    /// El servidor responde con este código HTTP y este cuerpo.
    static func stub(status: Int, body: String) {
        handler = { request in
            let response = HTTPURLResponse(url: request.url!, statusCode: status,
                                           httpVersion: nil, headerFields: nil)!
            return (response, Data(body.utf8))
        }
    }

    /// La petición falla (por ejemplo, sin internet).
    static func stubFailure(_ error: Error) {
        handler = { _ in throw error }
    }

    override class func canInit(with request: URLRequest) -> Bool { true }
    override class func canonicalRequest(for request: URLRequest) -> URLRequest { request }

    override func startLoading() {
        StubURLProtocol.lastRequest = request
        guard let handler = StubURLProtocol.handler else {
            client?.urlProtocol(self, didFailWithError: URLError(.badServerResponse))
            return
        }
        do {
            let (response, data) = try handler(request)
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: data)
            client?.urlProtocolDidFinishLoading(self)
        } catch {
            client?.urlProtocol(self, didFailWithError: error)
        }
    }

    override func stopLoading() {}
}

// MARK: - Ayudas para leer ViewState sin que sea Equatable

extension ViewState {
    var isIdle: Bool {
        if case .idle = self { return true }
        return false
    }

    var isLoading: Bool {
        if case .loading = self { return true }
        return false
    }

    var errorMessage: String? {
        if case .error(let message) = self { return message }
        return nil
    }
}

extension ViewState where Value == [Movie] {
    var loadedMovies: [Movie]? {
        if case .loaded(let movies) = self { return movies }
        return nil
    }
}
