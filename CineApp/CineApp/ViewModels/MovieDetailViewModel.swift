import Foundation
import Combine

@MainActor
final class MovieDetailViewModel: ObservableObject {
    let movie: Movie
    @Published var showReviewForm = false
    
    init(movie: Movie) {
        self.movie = movie
    }
    
    func isFavorite(in storage: StorageService) -> Bool {
        return storage.favorites.contains(where: { $0.id == movie.id })
    }
    
    func toggleFavorite(in storage: StorageService) {
        storage.toggleFavorite(movie: movie)
    }
    
    func myReview(in storage: StorageService) -> Review? {
        return storage.reviews.first(where: { $0.movieId == movie.id })
    }
}
