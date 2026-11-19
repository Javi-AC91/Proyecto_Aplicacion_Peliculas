import XCTest
@testable import CineApp

/// Pruebas de la capa de red: solicitud, validación HTTP y decodificación.
/// Usan una URLSession simulada, así que no necesitan internet ni API key.
@MainActor
final class TMDBMovieServiceTests: XCTestCase {

    private func makeService() -> TMDBMovieService {
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [StubURLProtocol.self]
        return TMDBMovieService(session: URLSession(configuration: config))
    }

    // MARK: Escenario 1: respuesta exitosa

    func testPopularMovies_success_decodesMovies() async throws {
        StubURLProtocol.stub(status: 200, body: """
        {"page":1,"results":[
          {"id":1,"title":"Inception","overview":"Sueños dentro de sueños",
           "poster_path":"/abc.jpg","release_date":"2010-07-15","vote_average":8.8},
          {"id":2,"title":"Interstellar","overview":"Viaje espacial",
           "poster_path":null,"release_date":null,"vote_average":null}
        ]}
        """)

        let movies = try await makeService().popularMovies()

        XCTAssertEqual(movies.count, 2)
        XCTAssertEqual(movies[0].id, 1)
        XCTAssertEqual(movies[0].title, "Inception")
        XCTAssertEqual(movies[0].voteAverage, 8.8)
        XCTAssertEqual(movies[0].posterURL?.absoluteString, "https://image.tmdb.org/t/p/w500/abc.jpg")
        XCTAssertNil(movies[1].posterPath)
        XCTAssertNil(movies[1].releaseDate)
        XCTAssertNil(movies[1].voteAverage)
    }

    func testPopularMovies_requestsPopularEndpoint() async throws {
        StubURLProtocol.stub(status: 200, body: #"{"results":[]}"#)

        _ = try await makeService().popularMovies()

        let url = try XCTUnwrap(StubURLProtocol.lastRequest?.url)
        XCTAssertEqual(url.host, "api.themoviedb.org")
        XCTAssertEqual(url.path, "/3/movie/popular")
        XCTAssertTrue(url.absoluteString.contains("language=es-MX"))
    }

    func testSearchMovies_success_sendsEncodedQuery() async throws {
        StubURLProtocol.stub(status: 200, body: """
        {"results":[{"id":603,"title":"Matrix","overview":"Realidad simulada"}]}
        """)

        let movies = try await makeService().searchMovies(query: "el señor")

        XCTAssertEqual(movies.map(\.title), ["Matrix"])
        let url = try XCTUnwrap(StubURLProtocol.lastRequest?.url)
        XCTAssertEqual(url.path, "/3/search/movie")
        XCTAssertTrue(url.absoluteString.contains("query=el%20se%C3%B1or"))
    }

    // MARK: Escenario 3: sin resultados

    func testSearchMovies_emptyResults_returnsEmptyArray() async throws {
        StubURLProtocol.stub(status: 200, body: #"{"page":1,"results":[]}"#)

        let movies = try await makeService().searchMovies(query: "zzzxqwkj")

        XCTAssertTrue(movies.isEmpty)
    }

    // MARK: Escenario 2: errores

    func testPopularMovies_http401_throwsHttpError() async {
        StubURLProtocol.stub(status: 401, body: #"{"status_message":"Invalid API key"}"#)

        do {
            _ = try await makeService().popularMovies()
            XCTFail("Debió lanzar un error HTTP")
        } catch let APIError.httpError(code) {
            XCTAssertEqual(code, 401)
        } catch {
            XCTFail("Error inesperado: \(error)")
        }
    }

    func testPopularMovies_http500_throwsHttpError() async {
        StubURLProtocol.stub(status: 500, body: "{}")

        do {
            _ = try await makeService().popularMovies()
            XCTFail("Debió lanzar un error HTTP")
        } catch let APIError.httpError(code) {
            XCTAssertEqual(code, 500)
        } catch {
            XCTFail("Error inesperado: \(error)")
        }
    }

    func testPopularMovies_invalidJSON_throwsDecodingError() async {
        StubURLProtocol.stub(status: 200, body: "esto no es JSON")

        do {
            _ = try await makeService().popularMovies()
            XCTFail("Debió lanzar un error de decodificación")
        } catch APIError.decodingError(_) {
            // correcto
        } catch {
            XCTFail("Error inesperado: \(error)")
        }
    }

    func testPopularMovies_networkFailure_throwsNetworkError() async {
        StubURLProtocol.stubFailure(URLError(.notConnectedToInternet))

        do {
            _ = try await makeService().popularMovies()
            XCTFail("Debió lanzar un error de red")
        } catch APIError.networkError(_) {
            // correcto
        } catch {
            XCTFail("Error inesperado: \(error)")
        }
    }

    func testPopularMovies_cancelledRequest_throwsCancellationNotNetworkError() async {
        StubURLProtocol.stubFailure(URLError(.cancelled))

        do {
            _ = try await makeService().popularMovies()
            XCTFail("Debió lanzar una cancelación")
        } catch is CancellationError {
            // correcto: una cancelación no debe mostrarse como "error de red"
        } catch {
            XCTFail("Error inesperado: \(error)")
        }
    }

    func testAPIError_descriptions_areUserFriendly() {
        XCTAssertEqual(APIError.httpError(404).errorDescription, "Error del servidor (Código: 404).")
        XCTAssertNotNil(APIError.invalidURL.errorDescription)
        XCTAssertNotNil(APIError.invalidResponse.errorDescription)
    }
}
