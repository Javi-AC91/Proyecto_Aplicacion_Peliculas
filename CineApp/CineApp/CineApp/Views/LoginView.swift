import SwiftUI

struct LoginView: View {
    @EnvironmentObject var session: SessionStore
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
        LinearGradient(colors: [.indigo, .purple, .pink.opacity(0.7)],
                       startPoint: .topLeading, endPoint: .bottomTrailing)
            .ignoresSafeArea()
    }
}
