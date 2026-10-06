Este documento justifica y documenta las decisiones de navegación y organización del estado de la aplicación, previo a la implementación en SwiftUI.

La aplicación utiliza una arquitectura de navegación basada en un flujo de Autenticación inicial y un TabView principal una vez que el usuario ha iniciado sesión. Las vistas de Loading y Error son estados globales que pueden superponerse en cualquier flujo que dependa de llamadas a red.

1. Mapa de Navegación:

CineApp Root
├── Login
└── Main (TabView)
    ├── Tab 1: Inicio
    │   ├── Lista Películas (Por Categoría)
    │   │   └── Detalle Película
    │   └── Detalle Película (Desde Tendencias/Estrenos)
    ├── Tab 2: Buscar
    │   ├── Resultados Búsqueda / Sin Resultados
    │   │   └── Detalle Película
    │   └── Lista Películas (Al tocar un Género)
    ├── Tab 3: Favoritos
    │   ├── Lista Favoritos / Favoritos Vacíos
    │   └── Detalle Película
    └── Tab 4: Perfil
        └── Editar Perfil

2. Información por pantalla: A continuación, se detalla qué datos maneja cada pantalla para definir nuestras variables de estado y dependencias.

  a. Login

Muestra: Formulario de inicio de sesión (email, contraseña), botón de acceso, enlaces a "Crear cuenta" y "Olvidé contraseña".

Recibe: -

Modifica: Estado global de autenticación (@AppStorage o manejador de sesión) al autenticarse correctamente.

Necesita conservar: Tokens de sesión o el ID del usuario actual de manera segura.

  b. Inicio (Tab 1)

Muestra: Saludo al usuario, categorías populares, carrusel de tendencias, lista de estrenos recientes.

Recibe: Objeto User (para el nombre) y listas de Movie (Tendencias, Estrenos).

Modifica: -

Necesita conservar: Caché de las películas cargadas para evitar recargar al cambiar de tab.

  c. Lista Películas (Categorías)

Muestra: Grid de películas correspondientes a una categoría específica.

Recibe: ID o nombre de la categoría (ej. "Acción").

Modifica: -

Necesita conservar: Estado de paginación si la lista es muy larga (scroll infinito).

  d. Detalle Película

Muestra: Póster, metadatos (año, duración, género, calificación), sinopsis, reparto y botón de favoritos.

Recibe: Objeto Movie completo o el MovieID para hacer fetch de los detalles.

Modifica: El estado de "Favorito" de la película actual.

Necesita conservar: Reflejar instantáneamente si la película es favorita (sincronizado con la fuente de verdad global).

  e. Buscar (Tab 2)

Muestra: Barra de búsqueda, historial de búsquedas recientes, grid de géneros.

Recibe: -

Modifica: Lista de búsquedas recientes (al realizar una nueva búsqueda).

Necesita conservar: Historial de búsquedas (preferiblemente en persistencia local con @AppStorage o SwiftData).

  f. Resultados Búsqueda / Sin Resultados

Muestra: Lista de películas coincidentes o pantalla de "Sin resultados" (con sugerencias).

Recibe: El String del término de búsqueda (Query).

Modifica: -

Necesita conservar: El término de búsqueda actual en el TextField para poder editarlo o limpiarlo.

  g. Favoritos (Tab 3) / Favoritos Vacíos

Muestra: Lista de películas guardadas o estado vacío invitando a explorar.

Recibe: Colección global de películas marcadas como favoritas por el usuario.

Modifica: Permite eliminar películas de la lista mediante un gesto de swipe.

Necesita conservar: La actualización en tiempo real. Si quito un favorito aquí, debe desmarcarse en el resto de la app. Requiere un EnvironmentObject u Observable global.

  h. Perfil (Tab 4)

Muestra: Avatar, información del usuario, estadísticas (vistas, favoritos, reviews) y lista de reviews recientes.

Recibe: Datos del perfil del usuario logueado.

Modifica: -

Necesita conservar: -

  i. Editar Perfil

Muestra: Formulario pre-llenado con datos del usuario y toggles de preferencias (notificaciones, modo oscuro, etc.).

Recibe: Clon del objeto User actual.

Modifica: Actualiza los datos del usuario en el servidor/base de datos local y cambia preferencias de la app (ej. Modo Oscuro global).

Necesita conservar: El estado borrador (@State) del formulario hasta que el usuario presione "Guardar".

Estados Globales Transversales (Loading / Error)

Estas vistas no son flujos de navegación per se, sino representaciones visuales que reaccionan a un enumerador de estado de red (ej. enum ViewState { case loading, loaded, error }). Deben poder recibir un mensaje de error o una acción de reintento (retryAction).

Para cumplir con el análisis y la justificación que pide tu práctica, aquí tienes una versión mucho más digerible, pensada para que puedas explicarla fácilmente o entenderla como conceptos del día a día, sin perder el enfoque en SwiftUI.





 3. Organización del estado (Dónde vive la información y por qué)

* Memoria Global:
* Es: El inicio de sesión y tu lista de películas Favoritas.
* ¿Dónde vive?: En un archivo central que toda la app puede leer (usando `@EnvironmentObject` o `@AppStorage` en SwiftUI).
 Si la sesión caduca, no importa en qué pantalla estés, la app entera debe enterarse para sacarte al Login. Igual con los favoritos: si le doy "Me gusta" a una peli en la pestaña "Buscar", cuando cambie a la pestaña "Favoritos" ya debe estar ahí.


* Memoria de Sección (Caché para no gastar datos):
* Es: Las listas de películas de "Inicio" o los resultados de "Búsqueda".
  ¿Dónde vive?: En el controlador de cada pantalla principal (usando `ViewModel` o `@StateObject`).
 Si cambias de la pestaña de Inicio a tu Perfil, y luego regresas al Inicio, no queremos que la app vuelva a descargar todas las portadas de internet. Se guardan en la "memoria" de esa sección para que carguen al instante.


* Memoria Temporal o Local:
* Es: Lo que vas escribiendo letra por letra en la barra de búsqueda o en tu contraseña.
* ¿Dónde vive?: Dentro de la misma vista de la pantalla (usando un simple `@State`).
Al resto de la aplicación no le importa qué estás tecleando hasta que le des al botón de "Buscar" o "Guardar". Es información que solo le importa a esa pantallita en ese momento.





4. Estrategia de navegación (Cómo nos movemos por la app)

Aquí explicamos cómo el usuario viaja de una pantalla a otra usando las herramientas que nos da SwiftUI.

* Navegación Condicional:
* Un simple `if/else` al arrancar la app.
*  Si tienes sesión abierta, ves la app; si no, ves el Login. Al hacerlo así, evitamos que el usuario pueda hacer el gesto de "deslizar hacia atrás" para saltarse la pantalla de inicio de sesión.


* Las Secciones Principales (El menú de abajo):
* El menú de pestañas o `TabView`.
 Permite tener las 4 secciones principales (Inicio, Buscar, Favoritos, Perfil) vivas al mismo tiempo. El usuario puede saltar de una a otra sin perder en qué parte de la lista se había quedado.


* Ir al detalle (Navegación en Pila / Stack):
* `NavigationStack`.
 Estás viendo la lista de "Estrenos", tocas una película y la nueva pantalla se desliza de derecha a izquierda. Si le das "Atrás", regresas exactamente a la lista.


* Las Tareas Rápidas (Pantallas Emergentes):**
 Las ventanas modales o `.sheet`.
 Lo usaremos para "Editar Perfil". La pantalla sube desde abajo cubriendo la vista. Esto psicológicamente le dice al usuario: "Estás haciendo una tarea rápida, guárdala o cancélala para regresar a donde estabas".
