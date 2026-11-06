@testable import CineApp

extension Movie {
    static func fixture(
        id: Int = 1,
        title: String = "Interstellar",
        overview: String = "Sinopsis de prueba",
        posterPath: String? = "/poster.jpg",
        releaseDate: String? = "2014-11-05",
        voteAverage: Double = 8.6
    ) -> Movie {
        Movie(id: id, title: title, overview: overview,
              posterPath: posterPath, releaseDate: releaseDate,
              voteAverage: voteAverage)
    }
}
