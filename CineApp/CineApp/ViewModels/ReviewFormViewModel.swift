import Foundation
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
    
    func save(in storage: StorageService, existingReview: Review?) {
        storage.saveReview(movieId: movieId, rating: rating, comment: comment, existingReview: existingReview)
    }
}
