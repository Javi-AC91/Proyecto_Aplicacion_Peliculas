import Foundation

/// Centraliza valores sensibles como llaves de API.
///
/// IMPORTANTE: No subas tu llave real a control de versiones.
/// - Para desarrollo local: puedes ponerla aquí temporalmente.
/// - Para producción: considera usar `.xcconfig`, variables de entorno o un script de build para inyectarla.
struct Secrets {
    /// Tu API Key de The Movie Database (TMDB).
    /// Reemplaza el valor vacío por tu llave real para que las peticiones funcionen.
    static let tmdbApiKey: String = "95ad0bd9594aa64505ebdbaa767091be"
}
