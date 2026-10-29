import XCTest
@testable import TMDB

final class MovieTests: XCTestCase {

    private let decoder = JSONDecoder()

    // MARK: - Decodificación

    func testDecodesMovieFromTMDBJSON() throws {
        let json = """
        {
          "id": 157336,
          "title": "Interstellar",
          "overview": "Un grupo de astronautas viaja por un agujero de gusano.",
          "poster_path": "/abc.jpg",
          "release_date": "2014-11-05",
          "vote_average": 8.4
        }
        """.data(using: .utf8)!

        let movie = try decoder.decode(Movie.self, from: json)

        XCTAssertEqual(movie.id, 157336)
        XCTAssertEqual(movie.title, "Interstellar")
        XCTAssertEqual(movie.posterPath, "/abc.jpg")
        XCTAssertEqual(movie.releaseDate, "2014-11-05")
    }

    func testDecodesMovieWithNullPosterAndMissingReleaseDate() throws {
        let json = """
        { "id": 1, "title": "Sin datos", "overview": "", "poster_path": null }
        """.data(using: .utf8)!

        let movie = try decoder.decode(Movie.self, from: json)

        XCTAssertNil(movie.posterPath)
        XCTAssertNil(movie.releaseDate)
    }

    func testDecodingFailsWhenRequiredFieldIsMissing() {
        let json = #"{ "id": 1, "overview": "sin título" }"#.data(using: .utf8)!

        XCTAssertThrowsError(try decoder.decode(Movie.self, from: json))
    }

    // MARK: - MovieResponse

    func testDecodesMovieResponseWithSeveralResults() throws {
        let json = """
        { "page": 1, "results": [
            { "id": 1, "title": "A", "overview": "a" },
            { "id": 2, "title": "B", "overview": "b" }
        ] }
        """.data(using: .utf8)!

        let response = try decoder.decode(MovieResponse.self, from: json)

        XCTAssertEqual(response.results.map(\.id), [1, 2])
    }

    func testDecodesMovieResponseWithEmptyResults() throws {
        let json = #"{ "results": [] }"#.data(using: .utf8)!

        let response = try decoder.decode(MovieResponse.self, from: json)

        XCTAssertTrue(response.results.isEmpty)
    }

    /// Es lo que pasa con una API key inválida: TMDB responde un JSON de error
    /// sin "results" y HomeView/SearchView lo muestran como ErrorView.
    func testDecodingTMDBErrorPayloadThrows() {
        let json = #"{ "status_code": 7, "status_message": "Invalid API key" }"#.data(using: .utf8)!

        XCTAssertThrowsError(try decoder.decode(MovieResponse.self, from: json))
    }

    // MARK: - posterURL

    func testPosterURLIsBuiltFromPosterPath() {
        let movie = Movie.fixture(posterPath: "/abc.jpg")

        XCTAssertEqual(movie.posterURL?.absoluteString,
                       "https://image.tmdb.org/t/p/w500/abc.jpg")
    }

    func testPosterURLIsNilWithoutPosterPath() {
        XCTAssertNil(Movie.fixture(posterPath: nil).posterURL)
    }

    // MARK: - Codable / Hashable

    /// FavoritesStore persiste con JSONEncoder: el round-trip no debe perder datos.
    func testEncodeThenDecodeReturnsSameMovie() throws {
        let original = Movie.fixture()

        let data = try JSONEncoder().encode(original)
        let decoded = try decoder.decode(Movie.self, from: data)

        XCTAssertEqual(decoded, original)
    }

    func testEncodingUsesSnakeCaseKeys() throws {
        let data = try JSONEncoder().encode(Movie.fixture())
        let json = try XCTUnwrap(String(data: data, encoding: .utf8))

        XCTAssertTrue(json.contains("poster_path"))
        XCTAssertTrue(json.contains("release_date"))
    }

    func testEqualMoviesCollapseInSet() {
        let set: Set<Movie> = [.fixture(id: 1), .fixture(id: 1), .fixture(id: 2)]

        XCTAssertEqual(set.count, 2)
    }
}
