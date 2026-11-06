import XCTest
@testable import CineApp

@MainActor
final class HomeViewModelTests: XCTestCase {

    private let sample = [
        Movie.fixture(id: 1, title: "Inception"),
        Movie.fixture(id: 2, title: "Interstellar")
    ]

    // MARK: - Estado inicial

    func testInitialStateIsIdle() {
        let viewModel = HomeViewModel(service: StubMovieService())

        XCTAssertTrue(viewModel.state.isIdle)
    }

    // MARK: - load()

    func testLoadSuccessSetsLoadedState() async {
        let service = StubMovieService(result: .success(sample))
        let viewModel = HomeViewModel(service: service)

        await viewModel.load()

        XCTAssertEqual(viewModel.state.loadedValue, sample)
    }

    func testLoadWithEmptyListSetsLoadedEmpty() async {
        let viewModel = HomeViewModel(service: StubMovieService(result: .success([])))

        await viewModel.load()

        XCTAssertEqual(viewModel.state.loadedValue, [])
    }

    func testLoadFailureSetsErrorMessage() async {
        let service = StubMovieService(result: .failure(StubError()))
        let viewModel = HomeViewModel(service: service)

        await viewModel.load()

        XCTAssertEqual(viewModel.state.errorMessage, "No se pudo cargar la cartelera.")
    }

    func testLoadCanRecoverAfterError() async {
        let service = StubMovieService(result: .failure(StubError()))
        let viewModel = HomeViewModel(service: service)
        await viewModel.load()

        service.result = .success(sample)   // lo que pasa al pulsar "Reintentar"
        await viewModel.load()

        XCTAssertEqual(viewModel.state.loadedValue, sample)
    }

    // MARK: - loadIfNeeded()

    func testLoadIfNeededLoadsWhenIdle() async {
        let service = StubMovieService(result: .success(sample))
        let viewModel = HomeViewModel(service: service)

        await viewModel.loadIfNeeded()

        XCTAssertEqual(service.popularCallCount, 1)
        XCTAssertEqual(viewModel.state.loadedValue, sample)
    }

    func testLoadIfNeededDoesNotReloadWhenAlreadyLoaded() async {
        let service = StubMovieService(result: .success(sample))
        let viewModel = HomeViewModel(service: service)

        await viewModel.loadIfNeeded()
        await viewModel.loadIfNeeded()

        XCTAssertEqual(service.popularCallCount, 1)
    }
}
