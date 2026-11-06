import SwiftUI

struct ReviewFormView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var storage: StorageService // <-- Inyectamos el servicio
    
    @StateObject private var viewModel: ReviewFormViewModel
    let existingReview: Review?
    
    init(movieId: Int, existingReview: Review?) {
        self.existingReview = existingReview
        _viewModel = StateObject(wrappedValue: ReviewFormViewModel(movieId: movieId, existingReview: existingReview))
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Calificación")) {
                    Stepper(value: $viewModel.rating, in: 1...10) {
                        HStack {
                            Text("\(viewModel.rating)")
                            Image(systemName: "star.fill").foregroundColor(.yellow)
                            Text("de 10")
                        }
                    }
                }
                Section(header: Text("Comentario")) {
                    TextEditor(text: $viewModel.comment).frame(minHeight: 120)
                }
            }
            .navigationTitle(viewModel.comment.isEmpty ? "Nueva Reseña" : "Editar Reseña")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { Button("Cancelar") { dismiss() } }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Guardar") {
                        // El ViewModel y el Servicio hacen el trabajo
                        viewModel.save(in: storage, existingReview: existingReview)
                        dismiss()
                    }
                    .disabled(viewModel.isSaveDisabled)
                }
            }
        }
    }
}
