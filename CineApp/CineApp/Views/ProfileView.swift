import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var session: SessionStore
    @EnvironmentObject var favorites: FavoritesStore
    @State private var showEdit = false   // controla la sheet

    var body: some View {
            ZStack {
                AppBackground()
                VStack(spacing: 16) {
                    Image(systemName: "person.circle.fill").font(.system(size: 80))
                    Text(session.userName).font(.title.bold())
                    Text("Favoritas: \(favorites.movies.count)")   // mismo store que Favoritos
                    
                    Button("Editar perfil") { showEdit = true }
                        .buttonStyle(.borderedProminent)
                    
                    Button("Cerrar sesión", role: .destructive) { session.logout() }
                        .buttonStyle(.borderedProminent) // <-- Agrega esta línea
                }
            }
            .navigationTitle("Perfil")
            .sheet(isPresented: $showEdit) { EditProfileView() }
        }
}

struct EditProfileView: View {
    @EnvironmentObject var session: SessionStore
    @Environment(\.dismiss) private var dismiss
    @State private var draftName = ""   // borrador: no toca el global hasta "Guardar"

    var body: some View {
        NavigationStack {
            Form {
                TextField("Nombre", text: $draftName)
            }
            .navigationTitle("Editar perfil")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Guardar") {
                        session.login(name: draftName)
                        dismiss()
                    }
                    .disabled(draftName.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
            .onAppear { draftName = session.userName }
        }
    }
}
