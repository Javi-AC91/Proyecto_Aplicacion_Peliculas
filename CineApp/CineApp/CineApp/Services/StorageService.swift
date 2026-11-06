import Foundation
import SwiftData
import Combine

@MainActor
final class StorageService: ObservableObject {
    private let container: ModelContainer
    private let context: ModelContext
    
    // Estos arreglos reemplazan la "magia" del @Query.
    // Los ViewModels se suscribirán a ellos para actualizar las vistas.
    @Published private(set) var favorites: [Movie] = []
    @Published private(set) var reviews: [Review] = []
    
    init() {
        do {
            // 1. Inicializamos la base de datos física
            container = try ModelContainer(for: Movie.self, Review.self)
            context = ModelContext(container)
            
            // 2. Cargamos los datos iniciales
            refreshData()
        } catch {
            fatalError("No se pudo inicializar la base de datos de SwiftData: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Lectura (Fetch)
    func refreshData() {
        fetchFavorites()
        fetchReviews()
    }
    
    private func fetchFavorites() {
        let descriptor = FetchDescriptor<Movie>()
        favorites = (try? context.fetch(descriptor)) ?? []
    }
    
    private func fetchReviews() {
        let descriptor = FetchDescriptor<Review>()
        reviews = (try? context.fetch(descriptor)) ?? []
    }
    
    // MARK: - Escritura (Favoritos)
    func toggleFavorite(movie: Movie) {
        if let existing = favorites.first(where: { $0.id == movie.id }) {
            context.delete(existing)
        } else {
            context.insert(movie)
        }
        save()
        fetchFavorites() // Actualiza la lista para los ViewModels
    }
    
    // MARK: - Escritura (Reseñas)
    func saveReview(movieId: Int, rating: Int, comment: String, existingReview: Review?) {
        if let existing = existingReview {
            existing.rating = rating
            existing.comment = comment
        } else {
            let newReview = Review(movieId: movieId, rating: rating, comment: comment)
            context.insert(newReview)
        }
        save()
        fetchReviews()
    }
    
    private func save() {
        if context.hasChanges {
            try? context.save()
        }
    }
}
