import Foundation

struct Movie: Identifiable, Codable, Hashable {
    let id: Int
    let title: String
    let overview: String
    let posterPath: String?
    let releaseDate: String?

    enum CodingKeys: String, CodingKey {
        case id, title, overview
        case posterPath = "poster_path"
        case releaseDate = "release_date"
    }

    var posterURL: URL? {
        guard let posterPath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)")
    }
}

struct MovieResponse: Codable {
    let results: [Movie]
}

/// Estado de una carga de red. Es un ESTADO que modifica lo que
/// muestra una vista; las vistas de Loading/Error son solo su reflejo visual.
enum ViewState<Value> {
    case idle
    case loading
    case loaded(Value)
    case error(String)
}
