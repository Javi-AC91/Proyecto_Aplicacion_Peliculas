import XCTest
@testable import CineApp

@MainActor
final class MovieDetailViewModelTests: XCTestCase {

    /// Misma llave que usa FavoritesStore.
    private let key = "favoriteMovies"
    private var savedData: Data?

    override func setUp() async throws {
        try await super.setUp()
        savedData = UserDefaults.standard.data(forKey: key)
        UserDefaults.standard.removeObject(forKey: key)
    }

    override func tearDown() async throws {
        if let savedData {
            UserDefaults.standard.set(savedData, forKey: key)
        } else {
            UserDefaults.standard.removeObject(forKey: key)
        }
        try await super.tearDown()
    }

    // MARK: - Datos de la película

    func testExposesTheMovieItWasCreatedWith() {
        let movie = Movie.fixture(id: 7, title: "Dune")

        let viewModel = MovieDetailViewModel(movie: movie)

        XCTAssertEqual(viewModel.movie, movie)
    }

    // MARK: - isFavorite

    func testIsFavoriteIsFalseWhenMovieIsNotInStore() {
        let store = FavoritesStore()
        let viewModel = MovieDetailViewModel(movie: .fixture(id: 1))

        XCTAssertFalse(viewModel.isFavorite(in: store))
    }

    func testIsFavoriteIsTrueWhenMovieIsAlreadyInStore() {
        let store = FavoritesStore()
        let movie = Movie.fixture(id: 1)
        store.toggle(movie)
        let viewModel = MovieDetailViewModel(movie: movie)

        XCTAssertTrue(viewModel.isFavorite(in: store))
    }

    // MARK: - toggleFavorite

    func testToggleFavoriteAddsMovieToStore() {
        let store = FavoritesStore()
        let movie = Movie.fixture(id: 1)
        let viewModel = MovieDetailViewModel(movie: movie)

        viewModel.toggleFavorite(in: store)

        XCTAssertTrue(viewModel.isFavorite(in: store))
        XCTAssertEqual(store.movies, [movie])
    }

    func testToggleFavoriteTwiceRemovesMovieFromStore() {
        let store = FavoritesStore()
        let viewModel = MovieDetailViewModel(movie: .fixture(id:
