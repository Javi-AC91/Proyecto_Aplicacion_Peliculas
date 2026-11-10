import Foundation
import Combine

final class EditProfileViewModel: ObservableObject {
    // El borrador ahora vive aquí, no en la vista
    @Published var draftName: String = ""
    
    // Regla de negocio: ¿Debería estar deshabilitado el botón Guardar?
    var isSaveDisabled: Bool {
        draftName.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    // Inicializa el texto cuando se abre la hoja
    func onAppear(currentName: String) {
        draftName = currentName
    }
    
    // Ejecuta el guardado
    func save(to session: SessionStore) {
        session.login(name: draftName)
    }
}
