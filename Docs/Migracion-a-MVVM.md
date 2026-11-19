# Bitácora de Migración a MVVM - CineApp

## 1. Refactorización de la Capa de Servicios (Networking)
* **Problema:** Las vistas hacían peticiones directas a la API de TMDB usando `URLSession`, acoplando la interfaz visual a la red y provocando bloqueos de desarrollo sin una API Key válida.
* **Solución:** Implementación del patrón de inyección de dependencias mediante el protocolo `MovieServicing`.
* **MockService:** Creación de `MockMovieService`, un servicio simulado que emula latencia de red (`Task.sleep`) y devuelve un conjunto de películas predefinidas. Se integró lógica de filtrado local para emular el comportamiento de un endpoint de búsqueda real.

## 2. Creación de ViewModels (Separación de Responsabilidades)
Se extrajo la lógica de negocio, validación y control de estado de las vistas hacia clases dedicadas (`ObservableObject`):
* **`HomeViewModel`:** Gestiona la petición de películas populares y controla de forma centralizada el estado reactivo `ViewState` (idle, loading, loaded, error) para la cartelera.
* **`SearchViewModel`:** Encapsula el texto de búsqueda (`query`), limpia los espacios en blanco y coordina la llamada asíncrona al servicio, exponiendo el arreglo filtrado a la vista.
* **`MovieDetailViewModel`:** Toma la película seleccionada por inyección y actúa como puente de interacción con el `FavoritesStore`, descargando a la vista de la responsabilidad de gestionar favoritos.

## 3. Seguridad y Persistencia: Migración a Keychain
* **Problema:** La gestión de sesión (`SessionStore`) dependía de `@AppStorage` (UserDefaults), un almacenamiento en texto plano no recomendado para datos sensibles o de autenticación.
* **Solución:** Reescritura completa del Store. Se integró el framework nativo `Security` (`SecItemAdd`, `SecItemCopyMatching`, `SecItemDelete`) para guardar, recuperar y destruir el token/nombre de sesión de forma encriptada en el Keychain de iOS.

## 4. Evolución del Modelo de Datos
* **`Movie.swift`:** Incorporación de la propiedad `voteAverage` (calificación), mapeada explícitamente en las `CodingKeys` (`"vote_average"`) para garantizar compatibilidad futura con la estructura JSON de TMDB. Se adaptaron los componentes visuales (`MovieRow`) para renderizar este nuevo dato.
