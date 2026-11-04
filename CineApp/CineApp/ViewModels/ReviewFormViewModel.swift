import Foundation
import SwiftData
import Combine

final class ReviewFormViewModel: ObservableObject {
    @Published var rating: Int = 5
    @Published var comment: String = ""
    let movieId: Int
    
    init(movieId: Int, existingReview: Review?) {
        self.movieId = movieId
        if let review = existingReview {
            self.rating = review.rating
            self.comment = review.comment
        }
    }
    
    var isSaveDisabled: Bool { comment.trimmingCharacters(in: .whitespaces).isEmpty }
    
    func save(in context: ModelContext, existingReview: Review?) {
        if let existing = existingReview {
            // Si ya existe, solo actualizamos sus propiedades
            existing.rating = rating
            existing.comment = comment
        } else {
            // Si no existe, creamos una nueva y la insertamos
            let newReview = Review(movieId: movieId, rating: rating, comment: comment)
            context.insert(newReview)
        }
    }
}
