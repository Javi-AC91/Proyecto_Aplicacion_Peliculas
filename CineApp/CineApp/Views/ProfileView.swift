import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var session: SessionStore
    @EnvironmentObject var storage: StorageService // Inyectamos el servicio
    @State private var showEdit = false

    var body: some View {
        ZStack {
            AppBackground()
            VStack(spacing: 16) {
                Image(systemName: "person.circle.fill").font(.system(size: 80))
                Text(session.userName).font(.title.bold())
                
                // Leemos directamente del servicio sin saber qué es SwiftData
                Text("Favoritas: \(storage.favorites.count)")
                
                Button("Editar perfil") { showEdit = true }
                    .buttonStyle(.borderedProminent)
                
                Button("Cerrar sesión", role: .destructive) { session.logout() }
                    .buttonStyle(.borderedProminent)
            }
        }
        .navigationTitle("Perfil")
        .sheet(isPresented: $showEdit) { EditProfileView() }
    }
}

// EditProfileView se queda exactamente igual (como la teníamos)
struct EditProfileView: View {
    @EnvironmentObject var session: SessionStore
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = EditProfileViewModel()

    var body: some View {
        NavigationStack {
            Form { TextField("Nombre", text: $viewModel.draftName) }
            .navigationTitle("Editar perfil")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { Button("Cancelar") { dismiss() } }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Guardar") {
                        viewModel.save(to: session)
                        dismiss()
                    }
                    .disabled(viewModel.isSaveDisabled)
                }
            }
            .onAppear { viewModel.onAppear(currentName: session.userName) }
        }
    }
}
