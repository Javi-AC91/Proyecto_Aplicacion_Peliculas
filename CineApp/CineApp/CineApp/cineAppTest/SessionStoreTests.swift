import XCTest
import Combine
@testable import TMDB

@MainActor
final class SessionStoreTests: XCTestCase {

    /// Misma llave que el @AppStorage de SessionStore.
    private let key = "userName"
    private var savedName: String?
    private var cancellables = Set<AnyCancellable>()

    override func setUp() async throws {
        try await super.setUp()
        savedName = UserDefaults.standard.string(forKey: key)
        UserDefaults.standard.removeObject(forKey: key)
    }

    override func tearDown() async throws {
        cancellables.removeAll()
        if let savedName {
            UserDefaults.standard.set(savedName, forKey: key)
        } else {
            UserDefaults.standard.removeObject(forKey: key)
        }
        try await super.tearDown()
    }

    func testStartsLoggedOut() {
        let session = SessionStore()

        XCTAssertEqual(session.userName, "")
        XCTAssertFalse(session.isLoggedIn)
    }

    func testLoginStoresNameAndLogsIn() {
        let session = SessionStore()

        session.login(name: "Javi")

        XCTAssertEqual(session.userName, "Javi")
        XCTAssertTrue(session.isLoggedIn)
    }

    func testLoginTrimsSurroundingSpaces() {
        let session = SessionStore()

        session.login(name: "   Javi  ")

        XCTAssertEqual(session.userName, "Javi")
    }

    func testLoginWithOnlySpacesDoesNotLogIn() {
        let session = SessionStore()

        session.login(name: "     ")

        XCTAssertFalse(session.isLoggedIn)
    }

    func testLoginWithEmptyNameDoesNotLogIn() {
        let session = SessionStore()

        session.login(name: "")

        XCTAssertFalse(session.isLoggedIn)
    }

    func testLogoutClearsSession() {
        let session = SessionStore()
        session.login(name: "Javi")

        session.logout()

        XCTAssertEqual(session.userName, "")
        XCTAssertFalse(session.isLoggedIn)
    }

    func testLoginCanReplaceExistingName() {
        let session = SessionStore()
        session.login(name: "Javi")

        session.login(name: "José")   // lo que hace "Guardar" en EditProfileView

        XCTAssertEqual(session.userName, "José")
    }

    func testSessionPersistsAcrossInstances() {
        SessionStore().login(name: "Javi")

        let reopened = SessionStore()   // simula cerrar y reabrir la app

        XCTAssertTrue(reopened.isLoggedIn)
        XCTAssertEqual(reopened.userName, "Javi")
    }

    func testLogoutPersistsAcrossInstances() {
        let session = SessionStore()
        session.login(name: "Javi")
        session.logout()

        XCTAssertFalse(SessionStore().isLoggedIn)
    }

    func testLoginNotifiesObservers() {
        let session = SessionStore()
        var notifications = 0
        session.objectWillChange
            .sink { notifications += 1 }
            .store(in: &cancellables)

        session.login(name: "Javi")

        XCTAssertGreaterThanOrEqual(notifications, 1)
    }
}
