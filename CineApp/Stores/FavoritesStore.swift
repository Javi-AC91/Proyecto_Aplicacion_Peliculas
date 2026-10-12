import Foundation

/// CASO REAL DE INFORMACIÓN COMPARTIDA: la lista de favoritas.
/// Una sola instancia (creada en CineAppApp) la leen y modifican
/// Detalle, Favoritos y Perfil. Se persiste en disco (JSON en UserDefaults)
/// para que NO se pierda al cerrar la app.
final class FavoritesStore: ObservableObject {
    @Published private(set) var movies: [Movie] = []

    private let key = "favoriteMovies"

    init() { load() }

    func isFavorite(_ movie: Movie) -> Bool {
        movies.contains { $0.id == movie.id }
    }

    func toggle(_ movie: Movie) {
        if let index = movies.firstIndex(where: { $0.id == movie.id }) {
            movies.remove(at: index)
        } else {
            movies.append(movie)
        }
        save()
    }

    func remove(at offsets: IndexSet) {
        movies.remove(atOffsets: offsets)
        save()
    }

    private func save() {
        if let data = try? JSONEncoder().encode(movies) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }

    private func load() {
        guard let data = UserDefaults.standard.data(forKey: key),
              let saved = try? JSONDecoder().decode([Movie].self, from: data) else { return }
        movies = saved
    }
}
