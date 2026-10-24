import SwiftUI
import Combine
import Security

/// Sesión del usuario manejada de forma segura con Keychain en lugar de UserDefaults
final class SessionStore: ObservableObject {
    @Published var userName: String = ""
    
    // Identificadores para el Keychain
    private let keychainService = "com.cineapp.session"
    private let accountName = "userName"
    
    init() {
        loadSession()
    }
    
    var isLoggedIn: Bool { !userName.trimmingCharacters(in: .whitespaces).isEmpty }
    
    func login(name: String) {
        let text = name.trimmingCharacters(in: .whitespaces)
        userName = text
        saveToKeychain(text)
    }
    
    func logout() {
        userName = ""
        deleteFromKeychain()
    }
    
    // MARK: - Keychain Logic
    private func saveToKeychain(_ name: String) {
        guard let data = name.data(using: .utf8) else { return }
        deleteFromKeychain() // Limpiamos el registro anterior
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: keychainService,
            kSecAttrAccount as String: accountName,
            kSecValueData as String: data
        ]
        SecItemAdd(query as CFDictionary, nil)
    }
    
    private func loadSession() {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: keychainService,
            kSecAttrAccount as String: accountName,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        
        if status == errSecSuccess,
           let data = dataTypeRef as? Data,
           let name = String(data: data, encoding: .utf8) {
            self.userName = name
        }
    }
    
    private func deleteFromKeychain() {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: keychainService,
            kSecAttrAccount as String: accountName
        ]
        SecItemDelete(query as CFDictionary)
    }
}
