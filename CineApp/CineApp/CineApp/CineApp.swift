import SwiftUI

@main
struct CineAppApp: App {
    @StateObject private var session = SessionStore()
    
    // Instanciamos el servicio central de base de datos
    @StateObject private var storageService = StorageService()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(session)
                // Lo inyectamos al entorno para que las vistas puedan
                // pasárselo a sus respectivos ViewModels
                .environmentObject(storageService)
        }
    }
}
