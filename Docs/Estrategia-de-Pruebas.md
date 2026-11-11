
## Pruebas (Testing)

### Estructura

```
cineAppTest/                (pruebas unitarias)
├── MovieFixture.swift
├── StubMovieService.swift
├── MovieTests.swift
├── FavoritesStoreTests.swift
├── SessionStoreTests.swift
└── HomeViewModelTests.swift

cineAppUITest/              (pruebas de interfaz)
├── cineAppUITest.swift
└── cineAppUITestLaunchTests.swift
```

Se eliminaron las pruebas anteriores (`cineApptest.swift` y `MovieViewModelTests.swift`), porque probaban clases que ya no existen en el proyecto (`MovieViewModel`, `MovieServiceProtocol`) y duplicaban el mock del servicio.

### Pruebas unitarias (`cineAppTest`)

| Archivo | Qué prueba |
|---|---|
| `MovieFixture.swift` | Datos de ejemplo reutilizables para crear un `Movie` sin repetir código. |
| `StubMovieService.swift` | Servicio falso que responde al instante con éxito o error, sin red ni `Task.sleep`. Evita el nombre `MockMovieService`, que ya existe en la app. |
| `MovieTests.swift` | Decodificación del JSON de TMDB (campos nulos, campos faltantes, respuesta de error), construcción de `posterURL` y codificación/decodificación (`Codable`). |
| `FavoritesStoreTests.swift` | Agregar y quitar favoritas, orden, identificación por `id`, persistencia entre instancias, datos corruptos y notificación de cambios a SwiftUI. |
| `SessionStoreTests.swift` | Login, logout, recorte de espacios, nombres vacíos, persistencia de la sesión y notificación de cambios. |
| `HomeViewModelTests.swift` | Estado inicial, carga exitosa, lista vacía, error, recuperación tras un error y que `loadIfNeeded()` no recargue si ya hay datos. |

Los tests de `FavoritesStore` y `SessionStore` guardan y restauran el contenido de `UserDefaults`, para que cada prueba parta de un estado limpio y no afecte los datos del simulador.

### Pruebas de interfaz (`cineAppUITest`)

Cubren el flujo de la app sin depender de internet ni de la API key:

- Botón "Entrar" deshabilitado con nombre vacío o solo espacios, y habilitado al escribir un nombre.
- Login correcto: aparecen las 4 pestañas (Inicio, Buscar, Favoritos, Perfil) y el saludo.
- Pestaña Buscar muestra el mensaje inicial; pestaña Favoritos es accesible.
- Perfil muestra el nombre y el contador de favoritas.
- Editar perfil: Cancelar conserva el nombre, Guardar lo actualiza, y Guardar se deshabilita con nombre vacío.
- Cerrar sesión regresa a la pantalla de login.
- Medición del rendimiento de lanzamiento y captura de pantalla de arranque.
