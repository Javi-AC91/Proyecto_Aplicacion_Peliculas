import SwiftUI

struct ReviewFormView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var storage: StorageService
    
    @StateObject private var viewModel: ReviewFormViewModel
    let existingReview: Review?
    
    init(movieId: Int, existingReview: Review?, storage: StorageService) {
        self.existingReview = existingReview
        self.storage = storage
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
                        viewModel.save(in: storage, existingReview: existingReview)
                        dismiss()
                    }
                    .disabled(viewModel.isSaveDisabled)
                }
            }
        }
    }
}
