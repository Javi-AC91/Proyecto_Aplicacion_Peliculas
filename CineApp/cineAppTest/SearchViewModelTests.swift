import XCTest
@testable import CineApp

@MainActor
final class SearchViewModelTests: XCTestCase {

    private let sample = [
        Movie.fixture(id: 1, title: "Dune"),
        Movie.fixture(id: 2, title: "Dune: Parte Dos")
    ]

    // MARK: - Estado inicial

    func testInitialStateIsIdleWithEmptyQuery() {
        let viewModel = SearchViewModel(service: StubMovieService())

        XCTAssertTrue(viewModel.state.isIdle)
        XCTAssertEqual(viewModel.query, "")
    }

    // MARK: - Consultas vacías

    func testSearchWithEmptyQueryDoesNothing() async {
        let service = StubMovieService(result: .success(sample))
        let viewModel = SearchViewModel(service: service)

        await viewModel.search()

        XCTAssertTrue(viewModel.state.isIdle)
        XCTAssertEqual(service.searchCallCount, 0)
    }

    func testSearchWithOnlySpacesDoesNothing() async {
        let service = StubMovieService(result: .success(sample))
        let viewModel = SearchViewModel(service: service)
        viewModel.query = "    "

        await viewModel.search()

        XCTAssertTrue(viewModel.state.isIdle)
        XCTAssertEqual(service.searchCallCount, 0)
    }

    // MARK: - Búsqueda exitosa

    func testSearchSuccessSetsLoadedState() async {
        let service = StubMovieService(result: .success(sample))
        let viewModel = SearchViewModel(service: service)
        viewModel.query = "Dune"

        await viewModel.search()

        XCTAssertEqual(viewModel.state.loadedValue, sample)
    }

    func testSearchSendsTrimmedQueryToService() async {
        let service = StubMovieService(result: .success(sample))
        let viewModel = SearchViewModel(service: service)
        viewModel.query = "  Dune  "

        await viewModel.search()

        XCTAssertEqual(service.lastQuery, "Dune")
        XCTAssertEqual(service.searchCallCount, 1)
    }

    func testSearchWithNoMatchesSetsLoadedEmpty() async {
        let service = StubMovieService(result: .success([]))
        let viewModel = SearchViewModel(service: service)
        viewModel.query = "zzzz"

        await viewModel.search()

        // SearchView muestra "Sin resultados" cuando la lista cargada está vacía
        XCTAssertEqual(viewModel.state.loadedValue, [])
    }

    // MARK: - Error

    func testSearchFailureSetsErrorMessage() async {
        let service = StubMovieService(result: .failure(StubError()))
        let viewModel = SearchViewModel(service: service)
        viewModel.query = "Dune"

        await viewModel.search()

        XCTAssertEqual(viewModel.state.errorMessage,
                       "No se pudo conectar. Revisa tu internet.")
    }

    func testSearchCanRecoverAfterError() async {
        let service = StubMovieService(result: .failure(StubError()))
        let viewModel = SearchViewModel(service: service)
        viewModel.query = "Dune"
        await viewModel.search()

        service.result = .success(sample)   // lo que pasa al pulsar "Reintentar"
        await viewModel.search()

        XCTAssertEqual(viewModel.state.loadedValue, sample)
    }

    // MARK: - Varias búsquedas

    func testSecondSearchReplacesPreviousResults() async {
        let service = StubMovieService(result: .success(sample))
        let viewModel = SearchViewModel(service: service)
        viewModel.query = "Dune"
        await viewModel.search()

        let other = [Movie.fixture(id: 9, title: "Alien")]
        service.result = .success(other)
        viewModel.query = "Alien"
        await viewModel.search()

        XCTAssertEqual(viewModel.state.loadedValue, other)
        XCTAssertEqual(service.lastQuery, "Alien")
        XCTAssertEqual(service.searchCallCount, 2)
    }
}
