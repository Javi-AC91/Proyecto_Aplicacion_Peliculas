import XCTest
@testable import CineApp

/// Pruebas de la pantalla de Inicio: estados Loading, Content, Empty y Error + reintento.
@MainActor
final class HomeViewModelTests: XCTestCase {

    func testInitialState_isIdle() {
        let viewModel = HomeViewModel(service: StubMovieService(result: .success([])))

        XCTAssertTrue(viewModel.state.isIdle)
    }

    // Escenario 1: respuesta exitosa → Content
    func testLoad_success_showsContent() async {
        let service = StubMovieService(result: .success([makeMovie(id: 1), makeMovie(id: 2, title: "Interstellar")]))
        let viewModel = HomeViewModel(service: service)

        await viewModel.load()

        XCTAssertEqual(viewModel.state.loadedMovies?.map(\.title), ["Inception", "Interstellar"])
        XCTAssertEqual(service.callCount, 1)
    }

    // Escenario 3: sin resultados → Empty (la vista muestra EmptyStateView cuando la lista está vacía)
    func testLoad_emptyList_isLoadedWithNoMovies() async {
        let viewModel = HomeViewModel(service: StubMovieService(result: .success([])))

        await viewModel.load()

        XCTAssertNotNil(viewModel.state.loadedMovies)
        XCTAssertEqual(viewModel.state.loadedMovies?.isEmpty, true)
    }

    // Escenario 2: error HTTP → Error con mensaje (no se silencia)
    func testLoad_httpError_showsErrorMessage() async {
        let viewModel = HomeViewModel(service: StubMovieService(result: .failure(APIError.httpError(401))))

        await viewModel.load()

        let message = viewModel.state.errorMessage
        XCTAssertNotNil(message)
        XCTAssertTrue(message?.contains("401") == true)
    }

    func testLoad_networkError_showsErrorMessage() async {
        let failure = APIError.networkError(URLError(.notConnectedToInternet))
        let viewModel = HomeViewModel(service: StubMovieService(result: .failure(failure)))

        await viewModel.load()

        XCTAssertTrue(viewModel.state.errorMessage?.hasPrefix("Error de red") == true)
    }

    func testLoad_unknownError_showsGenericMessage() async {
        struct Boom: Error {}
        let viewModel = HomeViewModel(service: StubMovieService(result: .failure(Boom())))

        await viewModel.load()

        XCTAssertNotNil(viewModel.state.errorMessage)
    }

    // Reintentar: después de un error, volver a llamar a load() recupera el contenido
    func testRetry_afterError_recoversWithContent() async {
        let service = StubMovieService(result: .failure(APIError.httpError(500)))
        let viewModel = HomeViewModel(service: service)

        await viewModel.load()
        XCTAssertNotNil(viewModel.state.errorMessage)

        service.result = .success([makeMovie()])
        await viewModel.load()

        XCTAssertEqual(viewModel.state.loadedMovies?.count, 1)
        XCTAssertEqual(service.callCount, 2)
    }

    // La interfaz no se bloquea: mientras la solicitud está en curso el estado es Loading
    // y el hilo principal sigue libre (esta misma prueba puede "dormir" y despertar).
    func testLoad_whileWaiting_showsLoadingAndDoesNotBlock() async throws {
        let service = StubMovieService(result: .success([makeMovie()]))
        service.delayNanoseconds = 300_000_000
        let viewModel = HomeViewModel(service: service)

        let task = Task { await viewModel.load() }
        try await Task.sleep(nanoseconds: 100_000_000)

        XCTAssertTrue(viewModel.state.isLoading)

        await task.value
        XCTAssertEqual(viewModel.state.loadedMovies?.count, 1)
    }

    func testLoadIfNeeded_doesNotReloadWhenAlreadyLoaded() async {
        let service = StubMovieService(result: .success([makeMovie()]))
        let viewModel = HomeViewModel(service: service)

        await viewModel.loadIfNeeded()
        await viewModel.loadIfNeeded()

        XCTAssertEqual(service.callCount, 1)
    }

    // Cambiar de pestaña cancela la tarea: no debe quedar un error falso en pantalla
    func testLoad_cancelled_returnsToIdle() async {
        let viewModel = HomeViewModel(service: StubMovieService(result: .failure(CancellationError())))

        await viewModel.load()

        XCTAssertTrue(viewModel.state.isIdle)
    }
}
