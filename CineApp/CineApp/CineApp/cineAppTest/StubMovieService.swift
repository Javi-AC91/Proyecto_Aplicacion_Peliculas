import Foundation
@testable import CineApp

/// Servicio falso para tests: responde al instante, sin Task.sleep ni red.
/// (No uso el nombre MockMovieService porque ya existe en tu app.)
final class StubMovieService: MovieServicing {

    var result: Result<[Movie], Error>

    private(set) var popularCallCount = 0
    private(set) var searchCallCount = 0
    private(set) var lastQuery: String?

    init(result: Result<[Movie], Error> = .success([])) {
        self.result = result
    }

    func popularMovies() async throws -> [Movie] {
        popularCallCount += 1
        return try result.get()
    }

    func searchMovies(query: String) async throws -> [Movie] {
        searchCallCount += 1
        lastQuery = query
        return try result.get()
    }
}

struct StubError: Error {}

/// ViewState no es Equatable, así que estos helpers permiten comprobar su valor.
extension ViewState {
    var isIdle: Bool {
        if case .idle = self { return true }
        return false
    }

    var loadedValue: Value? {
        if case .loaded(let value) = self { return value }
        return nil
    }

    var errorMessage: String? {
        if case .error(let message) = self { return message }
        return nil
    }
}
