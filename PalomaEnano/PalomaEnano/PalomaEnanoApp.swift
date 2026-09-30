import SwiftUI
import SwiftData

@main
struct SwiftUITestApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            // Aquí indicamos que la pantalla inicial al abrir la app será SecondView
            SecondView()
        }
        .modelContainer(sharedModelContainer)
    }
}
