import Foundation
import SwiftData

@Model
final class Review: Identifiable {
    @Attribute(.unique) var id: UUID
    var movieId: Int
    var rating: Int
    var comment: String
    var date: Date

    init(id: UUID = UUID(), movieId: Int, rating: Int, comment: String, date: Date = Date()) {
        self.id = id
        self.movieId = movieId
        self.rating = rating
        self.comment = comment
        self.date = date
    }
}
