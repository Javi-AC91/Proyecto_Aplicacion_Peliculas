import XCTest
import Combine
@testable import TMDB

@MainActor
final class FavoritesStoreTests: XCTestCase {

    /// Misma llave que usa FavoritesStore (es privada en el código de producción).
    private let key = "favoriteMovies"
    private var savedData: Data?
    private var cancellables = Set<AnyCancellable>()

    override func setUp() async throws {
        try await super.setUp()
        savedData = UserDefaults.standard.data(forKey: key)
        UserDefaults.standard.removeObject(forKey: key)
    }

    override func tearDown() async throws {
        cancellables.removeAll()
        if let savedData {
            UserDefaults.standard.set(savedData, forKey: key)
        } else {
            UserDefaults.standard.removeObject(forKey: key)
        }
        try await super.tearDown()
    }

    // MARK: - Estado inicial

    func testStartsEmpty() {
        XCTAssertTrue(FavoritesStore().movies.isEmpty)
    }

    // MARK: - toggle / isFavorite

    func testToggleAddsMovie() {
        let store = FavoritesStore()
        let movie = Movie.fixture(id: 1)

        store.toggle(movie)

        XCTAssertEqual(store.movies, [movie])
        XCTAssertTrue(store.isFavorite(movie))
    }

    func testToggleTwiceRemovesMovie() {
        let store = FavoritesStore()
        let movie = Movie.fixture(id: 1)

        store.toggle(movie)
        store.toggle(movie)

        XCTAssertTrue(store.movies.isEmpty)
        XCTAssertFalse(store.isFavorite(movie))
    }

    func testIsFavoriteIsFalseForUnknownMovie() {
        let store = FavoritesStore()
        store.toggle(.fixture(id: 1))

        XCTAssertFalse(store.isFavorite(.fixture(id: 99)))
    }

    /// La identidad se decide por `id`, no por el resto de campos.
    func testIsFavoriteComparesById() {
        let store = FavoritesStore()
        store.toggle(.fixture(id: 1, title: "Título original"))

        XCTAssertTrue(store.isFavorite(.fixture(id: 1, title: "Título distinto")))
    }

    func testToggleKeepsInsertionOrder() {
        let store = FavoritesStore()

        store.toggle(.fixture(id: 3))
        store.toggle(.fixture(id: 1))
        store.toggle(.fixture(id: 2))

        XCTAssertEqual(store.movies.map(\.id), [3, 1, 2])
    }

    // MARK: - remove(at:)

    func testRemoveAtOffsetsRemovesOnlyThatMovie() {
        let store = FavoritesStore()
        [1, 2, 3].forEach { store.toggle(.fixture(id: $0)) }

        store.remove(at: IndexSet(integer: 1))

        XCTAssertEqual(store.movies.map(\.id), [1, 3])
    }

    func testRemoveAtMultipleOffsets() {
        let store = FavoritesStore()
        [1, 2, 3, 4].forEach { store.toggle(.fixture(id: $0)) }

        store.remove(at: IndexSet([0, 2]))

        XCTAssertEqual(store.movies.map(\.id), [2, 4])
    }

    // MARK: - Persistencia

    func testFavoritesPersistAcrossInstances() {
        let first = FavoritesStore()
        first.toggle(.fixture(id: 1, title: "Dune"))
        first.toggle(.fixture(id: 2, title: "Inception"))

        let second = FavoritesStore()   // simula cerrar y reabrir la app

        XCTAssertEqual(second.movies.map(\.title), ["Dune", "Inception"])
    }

    func testRemovalPersistsAcrossInstances() {
        let first = FavoritesStore()
        first.toggle(.fixture(id: 1))
        first.toggle(.fixture(id: 2))
        first.remove(at: IndexSet(integer: 0))

        XCTAssertEqual(FavoritesStore().movies.map(\.id), [2])
    }

    func testCorruptedStoredDataResultsInEmptyList() {
        UserDefaults.standard.set(Data("no es json".utf8), forKey: key)

        XCTAssertTrue(FavoritesStore().movies.isEmpty)
    }

    // MARK: - Publicación de cambios (SwiftUI se redibuja por esto)

    func testToggleNotifiesObservers() {
        let store = FavoritesStore()
        var notifications = 0
        store.objectWillChange
            .sink { notifications += 1 }
            .store(in: &cancellables)

        store.toggle(.fixture(id: 1))

        XCTAssertEqual(notifications, 1)
    }
}
