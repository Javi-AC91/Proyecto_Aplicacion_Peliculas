import Foundation
import SwiftData
import Combine

@MainActor
final class MovieDetailViewModel: ObservableObject {
    let movie: Movie
    @Published var showReviewForm = false
    
    init(movie: Movie) {
        self.movie = movie
    }
    
    // Comprueba si la película actual está en el arreglo de favoritos de la base de datos
    func isFavorite(favorites: [Movie]) -> Bool {
        return favorites.contains(where: { $0.id == movie.id })
    }
    
    // Guarda o borra la película en la base de datos
    func toggleFavorite(in context: ModelContext, favorites: [Movie]) {
        if let existing = favorites.first(where: { $0.id == movie.id }) {
            context.delete(existing) // Si ya existe, la borramos
        } else {
            context.insert(movie)    // Si no existe, la guardamos
        }
    }
    
    func myReview(reviews: [Review]) -> Review? {
        return reviews.first(where: { $0.movieId == movie.id })
    }
}
