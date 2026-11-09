# Pruebas y Validación de la Integración con la API REST (Práctica 7, Parte 4)

## Problema

Después de integrar TMDB (ver `Integración API REST y Concurrencia`), faltaba comprobar que la integración se comportara bien en todos los escenarios: respuesta exitosa, error y ausencia de resultados. Al revisarla aparecieron además varios problemas:

- La **API key de TMDB estaba escrita en el código** y había quedado publicada en el repositorio.
- La pantalla **Inicio no tenía el estado Empty**, aunque la documentación decía que los cuatro estados estaban implementados.
- Si el usuario **cambiaba de pestaña mientras cargaba**, la solicitud se cancelaba y la pantalla mostraba un "error de red" falso.
- El proyecto **no compilaba** con la concurrencia estricta de Swift por el valor por defecto de los `init` de los ViewModels.
- No existían **pruebas automatizadas**: la capa de red no se podía probar sin internet porque usaba `URLSession.shared` directamente.

## Solución

Se corrigieron los problemas anteriores y se creó un target de pruebas (`CineAppTests`, XCTest) que verifica la capa de red y los ViewModels sin depender de internet ni de la API key.

## Cambios realizados

### 1. API key fuera del repositorio
- La clave ahora se lee de `Secrets.swift` (`Secrets.tmdbAPIKey`), un archivo incluido en `.gitignore` que no se sube a GitHub.
- Se agregó `Secrets.swift.example` como plantilla: se copia a `CineApp/CineApp/Secrets.swift` y se pega la clave propia.
- La clave anterior sigue en el historial de Git (commit `13ee597`), por lo que se considera comprometida y debe revocarse y reemplazarse por una nueva en TMDB.

### 2. Estado Empty en Inicio
- `HomeView` ahora muestra `EmptyStateView` cuando la solicitud termina bien pero la lista viene vacía. Con esto Inicio y Buscar cubren los cuatro estados: Loading, Content, Empty y Error.

### 3. Cancelación de solicitudes
- `TMDBMovieService` traduce `URLError.cancelled` y `CancellationError` a `CancellationError`, en lugar de `APIError.networkError`.
- `HomeViewModel` atrapa la cancelación y regresa a `.idle`, de modo que la lista se vuelve a cargar al regresar a la pestaña y no queda un error falso en pantalla.

### 4. Compilación con concurrencia estricta
- `HomeViewModel` y `SearchViewModel` usaban `init(service: MovieServicing = TMDBMovieService())`. Como `TMDBMovieService` está aislado a `@MainActor`, ese valor por defecto no compila.
- Ahora el `init` recibe `MovieServicing? = nil` y crea el servicio real dentro del cuerpo, que ya está aislado a `@MainActor`.

### 5. Servicio de red testeable
- `TMDBMovieService` recibe la sesión por inicializador: `init(session: URLSession = .shared)`. En la app se sigue usando `.shared`; en las pruebas se inyecta una sesión con respuestas simuladas.

### 6. Correcciones adicionales
- **Favoritos:** `StorageService.toggleFavorite` y `MovieDetailViewModel` ahora trabajan con una copia desvinculada de la película (`Movie.detached()`). Así las pantallas nunca leen un objeto de SwiftData que ya fue borrado, lo que podía provocar un cierre inesperado al quitar un favorito.
- **Reseñas:** el título de `ReviewFormView` ("Nueva Reseña" / "Editar Reseña") ahora depende de si existe una reseña previa y ya no cambia mientras se escribe el comentario.
- Se agregó `.gitignore` (claves, `xcuserdata`, `DerivedData`).

## Pruebas automatizadas (target `CineAppTests`)

Se ejecutan con ⌘U. Son 27 pruebas.

| Archivo | Pruebas | Qué verifica |
|---|---|---|
| `TestSupport.swift` | — | Datos de ejemplo, `StubMovieService` (servicio falso) y `StubURLProtocol` (red simulada). |
| `TMDBMovieServiceTests.swift` | 10 | Éxito y decodificación (incluyendo campos nulos y URL del póster); endpoint, idioma y búsqueda con texto codificado; respuesta vacía; HTTP 401 y 500; JSON inválido; falla de red; cancelación; mensajes de `APIError`. |
| `HomeViewModelTests.swift` | 10 | Estado inicial; Content; Empty; Error por HTTP, por red y desconocido; reintento tras un error; Loading sin bloquear el hilo principal; `loadIfNeeded` no recarga; cancelación regresa a `idle`. |
| `SearchViewModelTests.swift` | 7 | Estado inicial; consulta vacía no llama al servicio; éxito y recorte de espacios; sin resultados; error; reintento; estado de carga. |

### Escenarios cubiertos

| Escenario | Cómo se verifica |
|---|---|
| Respuesta exitosa | El servicio decodifica el JSON de TMDB y el ViewModel pasa a `.loaded` con las películas. |
| Error / respuesta HTTP no exitosa | Códigos 401 y 500 producen `APIError.httpError`; el ViewModel pasa a `.error` con un mensaje visible (no se silencia). Lo mismo para falla de red y JSON inválido. |
| Sin resultados | `{"results":[]}` termina en `.loaded([])`, que la vista dibuja como `EmptyStateView`. |
| Reintento | Después de un error, volver a llamar a `load()` / `search()` recupera el contenido. |
| Interfaz no bloqueada | Mientras la solicitud está en curso el estado es `.loading` y el hilo principal sigue disponible. |

### Pruebas manuales (con la API real)

Las pruebas automáticas simulan la red, por lo que no demuestran que los datos vengan de TMDB. Esto se verifica a mano en el simulador:

- Inicio muestra ~20 películas reales con póster y calificación (no solo las 3 del mock).
- Con una clave inválida aparece "Error del servidor (Código: 401)" y el botón **Reintentar**.
- Sin internet (modo avión) aparece "Error de red" y **Reintentar** funciona al reconectar.
- Buscar un texto sin coincidencias (por ejemplo `zzzxqwkj`) muestra "Sin resultados".
- Navegación, favoritos, reseñas y perfil siguen funcionando.

## Cómo ejecutar

1. Copiar `CineApp/Secrets.swift.example` a `CineApp/CineApp/Secrets.swift` y pegar la API key propia de TMDB.
2. Abrir `CineApp.xcodeproj`, seleccionar el esquema `CineApp` y un simulador.
3. Ejecutar las pruebas con ⌘U (los resultados aparecen en el navegador de pruebas, ⌘6).

## Problemas conocidos y pendientes

- Revocar y reemplazar la API key anterior, que sigue en el historial de Git.
- `StorageService` usa `try?` al guardar y leer SwiftData, por lo que un fallo de base de datos no se reporta al usuario.
- No hay paginación: solo se muestra la primera página de resultados (20).
- La búsqueda se ejecuta al presionar Enter; no hay búsqueda en tiempo real.
- No hay pruebas de interfaz (UI tests) ni pruebas de `StorageService` / `SessionStore`.
- El documento `Tests` describe pruebas de una versión anterior del proyecto y debe actualizarse.
