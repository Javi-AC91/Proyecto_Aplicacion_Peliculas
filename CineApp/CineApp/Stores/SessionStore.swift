import SwiftUI
import SwiftUI
import Combine

/// Sesión del usuario. El login solo pide un nombre (sin base de datos).
/// @AppStorage lo guarda en UserDefaults: sobrevive al cerrar la app.
final class SessionStore: ObservableObject {
    @AppStorage("userName") var userName: String = "" {
        willSet { objectWillChange.send() }
    }

    var isLoggedIn: Bool { !userName.trimmingCharacters(in: .whitespaces).isEmpty }

    func login(name: String) {
        userName = name.trimmingCharacters(in: .whitespaces)
    }

    func logout() {
        userName = ""
    }
}
