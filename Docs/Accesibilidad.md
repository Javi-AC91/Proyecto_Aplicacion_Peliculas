# Accesibilidad

*Elementos de accesibilidad definidos el 21 de septiembre de 2026.*

Por la naturaleza de la aplicación, se abarcan aspectos de accesibilidad para personas con discapacidad visual (ciegas), mediante lectura en voz alta de los elementos de cada pantalla (VoiceOver).

> **Alcance y estado.** Este documento describe el recorrido de accesibilidad que se definió para la app. En la versión actual, las pantallas usan controles nativos de SwiftUI (`TextField`, `Button`, `List`, `NavigationLink`, `TabView`), que VoiceOver ya lee por defecto. Algunos elementos descritos abajo (por ejemplo categorías, historial de búsquedas, duración, reparto y contadores de reseñas) forman parte del diseño pero aún no están en la interfaz; ver "Mejoras futuras" en el [README](../README.md).

## Índice de flujos

1. [Vista Registro](#1-vista-registro)
2. [Vista Inicio](#2-vista-inicio)
3. [Vista Búsqueda](#3-vista-búsqueda)
4. [Vista Favoritos](#4-vista-favoritos)
5. [Vista Perfil](#5-vista-perfil)
6. [Pantalla "Algo salió mal"](#6-pantalla-algo-salió-mal)

---

## 1. Vista Registro

Primera vez que se abre la app una vez descargada de la App Store.

1. Se leen en altavoz el campo "Nombre" y el botón "Siguiente".

## 2. Vista Inicio

1. Se leen las cajas de texto de Bienvenida.
2. Se leen las categorías. Se menciona que cada categoría es un elemento seleccionable.
   1. El usuario selecciona una categoría.
   2. Se lee la lista de la categoría.
3. Se lee la lista de tendencias.
   1. El usuario selecciona una película de la lista.
   2. Se leen año, duración, calificación (se menciona que se pueden leer las reseñas), sinopsis y reparto.
      1. El usuario selecciona las reseñas.
      2. Se leen las reseñas.
      3. El usuario regresa a la vista del paso 3.2.

## 3. Vista Búsqueda

1. Se lee "Campo para buscar películas".
2. Se lee el historial de búsquedas guardadas.
3. Se leen categorías sugeridas.
4. El usuario escribe una película.
   1. Se muestran resultados de búsqueda.
      1. Si no hay resultados para la búsqueda, se leen cajas de texto relacionadas con "Sin resultados".
      2. Se lee el botón "Limpiar búsqueda".
      3. El usuario regresa a la vista del paso 1.
   2. El usuario selecciona una película de la lista de la búsqueda realizada.
   3. Continúa el flujo del paso 3.1 de la [Vista Inicio](#2-vista-inicio).

## 4. Vista Favoritos

1. Se leen las cajas de texto de Favoritos.
2. Se lee la lista de favoritos. Se menciona por altavoz que son elementos para seleccionar.
3. El usuario selecciona una película de la lista de favoritos.
4. Continúa el flujo del paso 3.1 de la [Vista Inicio](#2-vista-inicio).

## 5. Vista Perfil

1. Se leen los elementos presentes en la vista de perfil.
   1. Se leen número de películas vistas, número de favoritos y número de reseñas.
   2. Se lee la lista de reseñas recientes. Se lee que las reseñas son seleccionables.
2. Se lee el botón "Editar perfil".
3. El usuario selecciona el botón "Editar perfil".
   1. Se leen los elementos que se pueden editar en la vista de editar perfil.
   2. El usuario edita algún campo permitido.
   3. Se leen los botones "Cancelar" y "Guardar".
   4. El usuario selecciona "Cancelar": se repite el flujo de la Vista Perfil.
   5. El usuario selecciona "Guardar": se repite el flujo de la Vista Perfil.

## 6. Pantalla "Algo salió mal"

1. Se leen las cajas de texto con información de que algo salió mal.
2. Se leen los botones "Reintentar" e "Ir al inicio".
   1. El usuario selecciona "Reintentar".
      1. La carga es exitosa: continúa el paso 4.1 de la [Vista Búsqueda](#3-vista-búsqueda).
      2. La carga no es exitosa: se repite el paso 1 de esta pantalla.
