# CineApp

Aplicación iOS hecha con **SwiftUI** para explorar películas populares, buscarlas por título, guardarlas como favoritas y escribir reseñas personales. El catálogo de películas viene de la API de [TMDB](https://www.themoviedb.org/).

**Equipo 7** · Ricardo Javier Anaya Cortés y José Angel Riverón Badillo
Proyecto integrador "Aplicación de películas".

## Contenido

- [¿Qué hace la app?](#qué-hace-la-app)
- [Favoritos y reseñas: datos del usuario](#favoritos-y-reseñas-datos-del-usuario)
- [Requisitos](#requisitos)
- [¿Cómo se descarga e instala?](#cómo-se-descarga-e-instala)
- [¿Dónde se aloja el token de la API?](#dónde-se-aloja-el-token-de-la-api)
- [Arquitectura](#arquitectura)
- [Pruebas](#pruebas)
- [Documentación](#documentación)
- [Capturas de la versión final](#capturas-de-la-versión-final)
- [Wireframes de diseño (Figma)](#wireframes-de-diseño-figma)
- [¿Se planea mejorar la aplicación?](#se-planea-mejorar-la-aplicación)
- [Créditos](#créditos)

## ¿Qué hace la app?

- **Inicio de sesión local:** solo pide un nombre (sin correo ni contraseña). El nombre se guarda en el Keychain de iOS y se muestra como saludo en Inicio.
- **Inicio:** lista de películas populares de TMDB con póster, título, fecha de estreno y calificación.
- **Búsqueda:** búsqueda de películas por título.
- **Detalle:** póster, sinopsis y fecha de estreno; botón para agregar o quitar de favoritas y para escribir o editar tu reseña.
- **Favoritos:** lista de películas guardadas; se quitan deslizando.
- **Reseñas:** calificación de 1 a 10 y comentario, por película.
- **Perfil:** nombre, cantidad de favoritas, editar nombre y cerrar sesión.
- **Estados de la interfaz:** cargando, error con botón "Reintentar", sin resultados y favoritos vacíos.

Flujos principales:

```
Inicio    → lista de películas → detalle
Inicio    → búsqueda → resultados → detalle
Inicio    → favoritos → película guardada → detalle
Perfil    → editar perfil
Detalle   → escribir / editar reseña
```

## Favoritos y reseñas: datos del usuario

Los **favoritos** y las **reseñas** son únicamente para **consulta del propio usuario**. Se guardan **localmente en el dispositivo** (SwiftData) y **no se envían** a la base de datos de la API ni a ningún otro servidor.

TMDB solo se usa para **leer** el catálogo (películas populares y resultados de búsqueda). Por lo tanto:

- Tus favoritos y reseñas no son visibles para otros usuarios.
- No se sincronizan entre dispositivos.
- Se eliminan si desinstalas la app.

## Requisitos

| Requisito | Detalle |
|---|---|
| Versión mínima de iOS | **iOS 26.5** |
| Dispositivos | iPhone |
| Xcode | Una versión que incluya el SDK de iOS 26.5 o posterior |
| Tecnologías | Swift, SwiftUI, SwiftData, Keychain |
| Conexión | Internet (para consultar TMDB) |
| API key de TMDB | Gratuita, se obtiene en [themoviedb.org/settings/api](https://www.themoviedb.org/settings/api) |

## ¿Cómo se descarga e instala?

La app **aún no está publicada**: por ahora se instala compilándola desde Xcode. La distribución prevista es a través de la **App Store**.

1. Clona el repositorio:
   ```bash
   git clone https://github.com/Javi-AC91/Proyecto_Aplicacion_Peliculas.git
   ```
2. Abre `CineApp/CineApp.xcodeproj` en Xcode.
3. **Configura tu API key** (el proyecto no compila sin este paso):
   1. Copia `CineApp/Secrets.swift.example` a `CineApp/CineApp/Secrets.swift` (junto a `CineApp.swift`) y quítale la extensión `.example`.
   2. Reemplaza `PEGA_AQUI_TU_API_KEY_DE_TMDB` por tu API key de TMDB.
4. Elige un simulador o dispositivo con iOS 26.5 o superior y ejecuta con **⌘R**.

## ¿Dónde se aloja el token de la API?

- La API key de TMDB **no está escrita en el código de las pantallas ni en el repositorio**. Vive en un archivo local, `CineApp/CineApp/Secrets.swift`, que está en el `.gitignore` y por eso nunca se sube a GitHub.
- Solo se lee en un lugar: `TMDBMovieService`, mediante `Secrets.tmdbApiKey`.
- El repositorio incluye únicamente la plantilla `CineApp/Secrets.swift.example`, con un valor de ejemplo, para que cualquier persona sepa cómo configurar la suya.

> **Limitación conocida:** como la app llama a TMDB directamente, la clave queda incluida dentro de la app compilada. Para este proyecto académico es suficiente; en una app publicada lo recomendable es que las consultas pasen por un servidor intermedio propio que guarde la clave.

## Arquitectura

La app sigue el patrón **MVVM**: las vistas dibujan y reaccionan; los ViewModels guardan el estado de cada pantalla; los servicios hablan con el exterior.

```
CineApp/CineApp/
├── CineApp.swift          Punto de entrada
├── Models/                Movie (incluye ViewState), Review
├── Services/              MovieService (protocolo + mock), TMDBMovieService (red), StorageService (SwiftData)
├── Stores/                SessionStore (sesión en Keychain)
├── ViewModels/            HomeViewModel, SearchViewModel, MovieDetailViewModel, ReviewFormViewModel, EditProfileViewModel
└── Views/                 RootView, LoginView, HomeView, SearchView, MovieDetailView, FavoritesView, ProfileView, ReviewFormView, StateViews
```

| Dato | Dónde vive |
|---|---|
| Catálogo de películas | TMDB (solo lectura, por internet) |
| Favoritos y reseñas | SwiftData, en el dispositivo |
| Nombre de usuario (sesión) | Keychain de iOS |
| API key de TMDB | `Secrets.swift` local, fuera de Git |

## Pruebas

Las pruebas unitarias están en `CineApp/CineAppTests` y se ejecutan con **⌘U**. Cubren los ViewModels de Inicio y Búsqueda (carga, error, reintento, sin resultados) y el servicio de TMDB (decodificación, errores HTTP y de red) usando respuestas simuladas, sin internet ni API key.

## Documentación

Los documentos de diseño y decisiones están en la carpeta [`Docs/`](Docs/):

| Documento | Contenido |
|---|---|
| [Diseno-de-Navegacion-y-Estado.md](Docs/Diseno-de-Navegacion-y-Estado.md) | Mapa de navegación y estado de cada pantalla (diseño inicial). |
| [Propuesta-de-Arquitectura-MVVM.md](Docs/Propuesta-de-Arquitectura-MVVM.md) | Análisis de responsabilidades y propuesta de capas MVVM. |
| [Migracion-a-MVVM.md](Docs/Migracion-a-MVVM.md) | Bitácora de la migración a MVVM (servicios, ViewModels, Keychain). |
| [Persistencia-con-SwiftData.md](Docs/Persistencia-con-SwiftData.md) | Migración de favoritos y reseñas de `UserDefaults` a SwiftData. |
| [Estrategia-de-Pruebas.md](Docs/Estrategia-de-Pruebas.md) | Estructura y alcance de las pruebas. |
| [Accesibilidad.md](Docs/Accesibilidad.md) | Recorridos de accesibilidad (VoiceOver) definidos por pantalla. |

## Capturas de la versión final

<table>
  <tr>
    <td align="center"><img src="Docs/Capturas/01-login.png" width="170"><br><sub>Login</sub></td>
    <td align="center"><img src="Docs/Capturas/02-inicio.png" width="170"><br><sub>Inicio</sub></td>
    <td align="center"><img src="Docs/Capturas/03-busqueda.png" width="170"><br><sub>Búsqueda</sub></td>
    <td align="center"><img src="Docs/Capturas/04-resultados.png" width="170"><br><sub>Resultados</sub></td>
  </tr>
  <tr>
    <td align="center"><img src="Docs/Capturas/05-detalle.png" width="170"><br><sub>Detalle</sub></td>
    <td align="center"><img src="Docs/Capturas/06-resena.png" width="170"><br><sub>Reseña</sub></td>
    <td align="center"><img src="Docs/Capturas/07-favoritos.png" width="170"><br><sub>Favoritos</sub></td>
    <td align="center"><img src="Docs/Capturas/08-favoritos-vacio.png" width="170"><br><sub>Favoritos vacíos</sub></td>
  </tr>
  <tr>
    <td align="center"><img src="Docs/Capturas/09-perfil.png" width="170"><br><sub>Perfil</sub></td>
    <td align="center"><img src="Docs/Capturas/10-editar-perfil.png" width="170"><br><sub>Editar perfil</sub></td>
    <td align="center"><img src="Docs/Capturas/11-error.png" width="170"><br><sub>Error</sub></td>
    <td align="center"><img src="Docs/Capturas/12-sin-resultados.png" width="170"><br><sub>Sin resultados</sub></td>
  </tr>
</table>

## Wireframes de diseño (Figma)

> **Importante:** estos wireframes corresponden a la etapa de diseño y **no son la versión final de la app**. La interfaz definitiva puede diferir; consulta las [capturas de la versión final](#capturas-de-la-versión-final).

<table>
  <tr>
    <td align="center"><img src="https://github.com/user-attachments/assets/9a01cb04-06fb-490f-9bca-bb46d38d694b" width="150"><br><sub>Login</sub></td>
    <td align="center"><img src="https://github.com/user-attachments/assets/9c48c65d-9b8a-40e4-9d6c-eb73fa414562" width="150"><br><sub>Inicio</sub></td>
    <td align="center"><img src="https://github.com/user-attachments/assets/aff706cb-1a5a-4677-bd90-46ef4f725d69" width="150"><br><sub>Lista de películas</sub></td>
    <td align="center"><img src="https://github.com/user-attachments/assets/4d1780af-1bd0-4181-a1d1-f4a91414184e" width="150"><br><sub>Búsqueda</sub></td>
  </tr>
  <tr>
    <td align="center"><img src="https://github.com/user-attachments/assets/88593379-0f17-48c6-b6bf-4a2e9f3fd36a" width="150"><br><sub>Resultados de búsqueda</sub></td>
    <td align="center"><img src="https://github.com/user-attachments/assets/43121b0c-0fcd-446c-b57a-468d20e21334" width="150"><br><sub>Detalle de película</sub></td>
    <td align="center"><img src="https://github.com/user-attachments/assets/7b41cf51-87d5-466c-ac26-9d47bdfac3a8" width="150"><br><sub>Favoritos</sub></td>
    <td align="center"><img src="https://github.com/user-attachments/assets/1e0526a1-7dc5-4f50-b9cb-2813e938effe" width="150"><br><sub>Favoritos vacíos</sub></td>
  </tr>
  <tr>
    <td align="center"><img src="https://github.com/user-attachments/assets/8b7028f6-8587-45e4-a2e1-51aa742fd4d6" width="150"><br><sub>Perfil</sub></td>
    <td align="center"><img src="https://github.com/user-attachments/assets/adff4e2e-e701-46fa-ba24-9fbe62d0299d" width="150"><br><sub>Editar perfil</sub></td>
    <td align="center"><img src="https://github.com/user-attachments/assets/ea347fc5-cd39-4ab2-a075-6c472ce4c958" width="150"><br><sub>Cargando</sub></td>
    <td align="center"><img src="https://github.com/user-attachments/assets/1d2e983e-fbd7-4397-bd8e-893fc256983b" width="150"><br><sub>Error</sub></td>
  </tr>
  <tr>
    <td align="center"><img src="https://github.com/user-attachments/assets/2c044e01-d875-4db6-8885-7235b1159e4b" width="150"><br><sub>Sin resultados</sub></td>
    <td></td>
    <td></td>
    <td></td>
  </tr>
</table>

<details>
<summary>Prompts usados para generar los wireframes en Figma</summary>

**1. (17/9/2026)**

Diseña las pantallas para los siguientes flujos para una app de películas. Usa el mismo contenido y estilo en las pantallas, una al lado de la otra. Usa un degradado abstracto para el fondo, nada de fotos.

- Inicio → lista de películas → detalle.
- Inicio → búsqueda → resultados → detalle.
- Inicio → favoritos → película guardada → detalle.

Incluir:
- Lista de películas desde TMDB con poster, título e información básica.
- Detalle con poster, título, sinopsis y fecha de estreno.
- Agregar y quitar favoritas.
- Estados de loading, error, sin resultados y favoritos vacíos.

**2. (17/9/2026)**

Diseña las pantallas para los siguientes flujos para una app de películas. Usa el mismo contenido y estilo en las pantallas, una al lado de la otra. Usa un degradado abstracto para el fondo, nada de fotos, usa la misma tipografía como la que usaste en donde dice categorías populares y usa esa tipografía para exactamente todo el diseño.

Antes de la parte de inicio pon la parte de login, y agrega otro flujo para modificar el perfil donde incluya los reviews y calificaciones propias de las películas que hayas visto.

- Inicio → lista de películas → detalle.
- Inicio → búsqueda → resultados → detalle.
- Inicio → favoritos → película guardada → detalle.

Incluir:
- Lista de películas desde TMDB con poster, título e información básica.
- Detalle con poster, título, sinopsis y fecha de estreno.
- Agregar y quitar favoritas.
- Estados de loading, error, sin resultados y favoritos vacíos.

</details>

## ¿Se planea mejorar la aplicación?

Sí. La versión actual es funcional, pero hay mejoras previstas:

- **Pantalla de inicio más completa:** categorías, tendencias y estrenos, como en los wireframes (hoy muestra la lista de películas populares).
- **Perfil con reseñas:** lista de reseñas y calificaciones propias, y contadores de películas vistas, favoritas y reseñas (hoy las reseñas se consultan desde el detalle de cada película).
- **Detalle ampliado:** duración, reparto y calificación de TMDB.
- **Accesibilidad:** etiquetas y descripciones de VoiceOver explícitas según [`Docs/Accesibilidad.md`](Docs/Accesibilidad.md).
- **Búsqueda:** historial de búsquedas y paginación de resultados.
- **Seguridad:** que las consultas a TMDB pasen por un servidor intermedio para no incluir la clave en la app.
- **Datos:** sincronización opcional de favoritos y reseñas entre dispositivos.
- **Pruebas:** pruebas de interfaz (UI) del flujo completo.

## Créditos

Los datos y pósters de películas son proporcionados por [TMDB](https://www.themoviedb.org/). *Este producto usa la API de TMDB pero no está respaldado ni certificado por TMDB.*
