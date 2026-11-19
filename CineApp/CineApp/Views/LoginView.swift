import SwiftUI

struct LoginView: View {
    // Cambiamos @EnvironmentObject por @ObservedObject para exigir inyección
    @ObservedObject var session: SessionStore
    @State private var name = ""   // estado local: solo le importa a esta pantalla

    var body: some View {
        ZStack {
            AppBackground()
            VStack(spacing: 20) {
                Text("CineApp").font(.largeTitle.bold())
                TextField("Tu nombre", text: $name)
                    .textFieldStyle(.roundedBorder)
                    .padding(.horizontal, 40)
                Button("Entrar") { session.login(name: name) }
                    .buttonStyle(.borderedProminent)
                    .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty)
            }
        }
    }
}

struct AppBackground: View {
    var body: some View {
        ZStack {
            // 1. Fondo base completamente blanco
            Color.white
                .ignoresSafeArea()
            
            // 2. Gradiente con los colores originales pero suavizados individualmente
            LinearGradient(
                colors: [
                    Color.indigo.opacity(0.25),
                    Color.purple.opacity(0.10),
                    Color.blue.opacity(0.25)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
        }
    }
}
