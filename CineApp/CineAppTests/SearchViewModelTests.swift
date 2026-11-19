import XCTest
@testable import CineApp

/// Pruebas de la pantalla de Búsqueda.
@MainActor
final class SearchViewModelTests: XCTestCase {

    func testInitialState_isIdle() {
        let viewModel = SearchViewModel(service: StubMovieService(result: .success([])))

        XCTAssertTrue(viewModel.state.isIdle)
    }

    func testSearch_blankQuery_doesNothing() async {
        let service = StubMovieService(result: .success([makeMovie()]))
        let viewModel = SearchViewModel(service: service)
        viewModel.query = "    "

        await viewModel.search()

        XCTAssertTrue(viewModel.state.isIdle)
        XCTAssertEqual(service.callCount, 0)
    }

    // Escenario 1: respuesta exitosa
    func testSearch_success_showsResultsAndTrimsQuery() async {
        let service = StubMovieService(result: .success([makeMovie(id: 603, title: "Matrix")]))
        let viewModel = SearchViewModel(service: service)
        viewModel.query = "  matrix  "

        await viewModel.search()

        XCTAssertEqual(service.lastQuery, "matrix")
        XCTAssertEqual(viewModel.state.loadedMovies?.map(\.title), ["Matrix"])
    }

    // Escenario 3: sin resultados
    func testSearch_noResults_isLoadedWithNoMovies() async {
        let viewModel = SearchViewModel(service: StubMovieService(result: .success([])))
        viewModel.query = "zzzxqwkj"

        await viewModel.search()

        XCTAssertEqual(viewModel.state.loadedMovies?.isEmpty, true)
    }

    // Escenario 2: error
    func testSearch_error_showsErrorMessage() async {
        let viewModel = SearchViewModel(service: StubMovieService(result: .failure(APIError.httpError(500))))
        viewModel.query = "matrix"

        await viewModel.search()

        XCTAssertTrue(viewModel.state.errorMessage?.contains("500") == true)
    }

    func testRetry_afterError_recovers() async {
        let service = StubMovieService(result: .failure(APIError.networkError(URLError(.timedOut))))
        let viewModel = SearchViewModel(service: service)
        viewModel.query = "matrix"

        await viewModel.search()
        XCTAssertNotNil(viewModel.state.errorMessage)

        service.result = .success([makeMovie(id: 603, title: "Matrix")])
        await viewModel.search()

        XCTAssertEqual(viewModel.state.loadedMovies?.count, 1)
    }

    func testSearch_whileWaiting_showsLoading() async throws {
        let service = StubMovieService(result: .success([makeMovie()]))
        service.delayNanoseconds = 300_000_000
        let viewModel = SearchViewModel(service: service)
        viewModel.query = "matrix"

        let task = Task { await viewModel.search() }
        try await Task.sleep(nanoseconds: 100_000_000)

        XCTAssertTrue(viewModel.state.isLoading)
        await task.value
    }
}
