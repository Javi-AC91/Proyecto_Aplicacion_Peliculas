import XCTest

final class TMDBUITests: XCTestCase {

    private var app: XCUIApplication!

    // MARK: - Elementos frecuentes

    private var nameField: XCUIElement { app.textFields["Tu nombre"] }
    private var enterButton: XCUIElement { app.buttons["Entrar"] }
    private var tabBar: XCUIElement { app.tabBars.firstMatch }

    // MARK: - Ciclo de vida

    @MainActor
    override func setUp() async throws {
        try await super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
        logoutIfNeeded()
    }

    // MARK: - Login

    @MainActor
    func testLoginButtonIsDisabledWithEmptyName() {
        XCTAssertTrue(nameField.waitForExistence(timeout: 5))
        XCTAssertFalse(enterButton.isEnabled)
    }

    @MainActor
    func testLoginButtonIsDisabledWithOnlySpaces() {
        XCTAssertTrue(nameField.waitForExistence(timeout: 5))
        nameField.tap()
        nameField.typeText("   ")

        XCTAssertFalse(enterButton.isEnabled)
    }

    @MainActor
    func testLoginButtonEnablesWhenNameIsTyped() {
        XCTAssertTrue(nameField.waitForExistence(timeout: 5))
        nameField.tap()
        nameField.typeText("Ana")

        XCTAssertTrue(enterButton.isEnabled)
    }

    @MainActor
    func testLoginShowsMainTabsAndGreeting() {
        login(as: "Ana")

        for tab in ["Inicio", "Buscar", "Favoritos", "Perfil"] {
            XCTAssertTrue(tabBar.buttons[tab].exists, "Falta la pestaña \(tab)")
        }
        XCTAssertTrue(app.navigationBars["Hola, Ana"].waitForExistence(timeout: 5))
    }

    // MARK: - Navegación

    @MainActor
    func testSearchTabShowsInitialPrompt() {
        login(as: "Ana")

        tabBar.buttons["Buscar"].tap()

        XCTAssertTrue(app.staticTexts["Escribe el nombre de una película"]
            .waitForExistence(timeout: 5))
    }

    @MainActor
    func testFavoritesTabIsReachable() {
        login(as: "Ana")

        tabBar.buttons["Favoritos"].tap()

        XCTAssertTrue(app.navigationBars["Favoritos"].waitForExistence(timeout: 5))
    }

    // MARK: - Perfil

    @MainActor
    func testProfileShowsUserNameAndFavoritesCount() {
        login(as: "Ana")

        tabBar.buttons["Perfil"].tap()

        XCTAssertTrue(app.staticTexts["Ana"].waitForExistence(timeout: 5))
        let counter = app.staticTexts.matching(
            NSPredicate(format: "label BEGINSWITH 'Favoritas:'")).firstMatch
        XCTAssertTrue(counter.exists)
    }

    @MainActor
    func testEditProfileCancelKeepsOriginalName() {
        login(as: "Ana")
        tabBar.buttons["Perfil"].tap()
        app.buttons["Editar perfil"].tap()

        let field = app.textFields.firstMatch
        XCTAssertTrue(field.waitForExistence(timeout: 5))
        field.clearAndType("Otro nombre")
        app.buttons["Cancelar"].tap()

        XCTAssertTrue(app.staticTexts["Ana"].waitForExistence(timeout: 5))
        XCTAssertFalse(app.staticTexts["Otro nombre"].exists)
    }

    @MainActor
    func testEditProfileSaveUpdatesName() {
        login(as: "Ana")
        tabBar.buttons["Perfil"].tap()
        app.buttons["Editar perfil"].tap()

        let field = app.textFields.firstMatch
        XCTAssertTrue(field.waitForExistence(timeout: 5))
        field.clearAndType("Beto")
        app.buttons["Guardar"].tap()

        XCTAssertTrue(app.staticTexts["Beto"].waitForExistence(timeout: 5))
    }

    @MainActor
    func testEditProfileSaveIsDisabledWithEmptyName() {
        login(as: "Ana")
        tabBar.buttons["Perfil"].tap()
        app.buttons["Editar perfil"].tap()

        let field = app.textFields.firstMatch
        XCTAssertTrue(field.waitForExistence(timeout: 5))
        field.clearAndType("")

        XCTAssertFalse(app.buttons["Guardar"].isEnabled)
    }

    @MainActor
    func testLogoutReturnsToLogin() {
        login(as: "Ana")
        tabBar.buttons["Perfil"].tap()

        app.buttons["Cerrar sesión"].tap()

        XCTAssertTrue(nameField.waitForExistence(timeout: 5))
        XCTAssertFalse(tabBar.exists)
    }

    // MARK: - Rendimiento

    @MainActor
    func testLaunchPerformance() throws {
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            XCUIApplication().launch()
        }
    }

    // MARK: - Helpers

    /// Deja la app en la pantalla de login, sin importar el estado previo.
    @MainActor
    private func logoutIfNeeded() {
        if nameField.waitForExistence(timeout: 2) { return }
        guard tabBar.waitForExistence(timeout: 5) else { return }
        tabBar.buttons["Perfil"].tap()
        app.buttons["Cerrar sesión"].tap()
        _ = nameField.waitForExistence(timeout: 5)
    }

    @MainActor
    private func login(as name: String) {
        XCTAssertTrue(nameField.waitForExistence(timeout: 5))
        nameField.tap()
        nameField.typeText(name)
        enterButton.tap()
        XCTAssertTrue(tabBar.waitForExistence(timeout: 5))
    }
}

private extension XCUIElement {
    /// Borra el texto actual del campo y escribe uno nuevo.
    func clearAndType(_ text: String) {
        tap()
        if let current = value as? String, !current.isEmpty {
            typeText(String(repeating: XCUIKeyboardKey.delete.rawValue, count: current.count))
        }
        if !text.isEmpty { typeText(text) }
    }
}
