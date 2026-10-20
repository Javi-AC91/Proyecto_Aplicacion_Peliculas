import Foundation
import Combine

@MainActor
final class MovieDetailViewModel: ObservableObject {
    let movie: Movie
    
    init(movie: Movie) {
        self.movie = movie
    }
    
    // Delegamos la acción del FavoritesStore al ViewModel
    func toggleFavorite(in store: FavoritesStore) {
        store.toggle(movie)
    }
    
    func isFavorite(in store: FavoritesStore) -> Bool {
        return store.isFavorite(movie)
    }
}
