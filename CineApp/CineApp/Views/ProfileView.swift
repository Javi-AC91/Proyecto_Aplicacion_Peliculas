import SwiftUI
import SwiftData

struct ProfileView: View {
    @EnvironmentObject var session: SessionStore
    @State private var showEdit = false
    
    // Consulta a la base de datos para contar los favoritos
    @Query private var favorites: [Movie]

    var body: some View {
        ZStack {
            AppBackground()
            VStack(spacing: 16) {
                Image(systemName: "person.circle.fill").font(.system(size: 80))
                Text(session.userName).font(.title.bold())
                Text("Favoritas: \(favorites.count)")
                
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
