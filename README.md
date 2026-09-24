# Proyecto_Aplicacion_Peliculas

Equipo 7

Por: Ricardo Javier Anaya Cortés and José Angel Riverón Badillo.

Este repositorio contiene la información relevante para la entrega del proyecto integrador 'Aplicación de películas'.

El flujo actua consta de los siguientes puntos: 

Inicio → lista de películas → detalle.
Inicio → búsqueda → resultados → detalle.
Inicio → favoritos → película guardada → detalle.

Los wireframes se realizaron en Figma con base en los siguientes prompts: 

1. 17/9/2026 
Diseña las pantallas para los siguientes flujos para una app de películas. Usa el mismo contenido y estilo en las pantallas, una al lado de la otra. Usa un degradado abstracto para el fondo, nada de fotos. 
Inicio → lista de películas → detalle.
Inicio → búsqueda → resultados → detalle.
Inicio → favoritos → película guardada → detalle.
Incluir:
Lista de películas desde TMDB con poster, título e información básica.
Detalle con poster, título, sinopsis y fecha de estreno.
Agregar y quitar favoritas.
Estados de loading, error, sin resultados y favoritos vacíos.

2. 17/9/2026
Diseña las pantallas para los siguientes flujos para una app de películas. Usa el mismo contenido y estilo en las pantallas, una al lado de la otra. Usa un degradado abstracto para el fondo, nada de fotos, usa la misma tipografía como la que usaste en donde dice categorías populares y usa esa tipografía para exactamente todo el diseño. 
Antes de la parte de inicio pon la parte de login, y agrega otro flujo para modificar el perfil donde incluya los reviews y calificaciones propias de las películas que hayas visto 
Inicio → lista de películas → detalle.
Inicio → búsqueda → resultados → detalle.
Inicio → favoritos → película guardada → detalle.
Incluir:
Lista de películas desde TMDB con poster, título e información básica.
Detalle con poster, título, sinopsis y fecha de estreno.
Agregar y quitar favoritas.
Estados de loading, error, sin resultados y favoritos vacíos.


Login 
<img width="267" height="582" alt="Captura de pantalla 2026-09-21 a la(s) 5 22 38 p m" src="https://github.com/user-attachments/assets/9a01cb04-06fb-490f-9bca-bb46d38d694b" />

Inicio
<img width="238" height="563" alt="image" src="https://github.com/user-attachments/assets/9c48c65d-9b8a-40e4-9d6c-eb73fa414562" />

Lista peliculas
<img width="238" height="563" alt="image" src="https://github.com/user-attachments/assets/aff706cb-1a5a-4677-bd90-46ef4f725d69" />

Resultados-Busqueda
<img width="168" height="375" alt="image" src="https://github.com/user-attachments/assets/88593379-0f17-48c6-b6bf-4a2e9f3fd36a" />

Detalle pelicula
<img width="168" height="375" alt="image" src="https://github.com/user-attachments/assets/43121b0c-0fcd-446c-b57a-468d20e21334" />

Búsqueda
<img width="168" height="375" alt="image" src="https://github.com/user-attachments/assets/4d1780af-1bd0-4181-a1d1-f4a91414184e" />

Favoritos
<img width="162" height="367" alt="image" src="https://github.com/user-attachments/assets/7b41cf51-87d5-466c-ac26-9d47bdfac3a8" />

Favoritos-vacios
<img width="166" height="367" alt="image" src="https://github.com/user-attachments/assets/1e0526a1-7dc5-4f50-b9cb-2813e938effe" />

Perfil
<img width="166" height="367" alt="image" src="https://github.com/user-attachments/assets/8b7028f6-8587-45e4-a2e1-51aa742fd4d6" />

editar-perfil
<img width="164" height="372" alt="image" src="https://github.com/user-attachments/assets/adff4e2e-e701-46fa-ba24-9fbe62d0299d" />

loading
<img width="172" height="372" alt="image" src="https://github.com/user-attachments/assets/ea347fc5-cd39-4ab2-a075-6c472ce4c958" />

Error
<img width="293" height="650" alt="image" src="https://github.com/user-attachments/assets/1d2e983e-fbd7-4397-bd8e-893fc256983b" />

sin-resultados
<img width="293" height="650" alt="image" src="https://github.com/user-attachments/assets/2c044e01-d875-4db6-8885-7235b1159e4b" />

Elementos de Accesibilidad (21 septiembre 2026)

Los elementos que contienen asistencia de accesibilidad. Por la naturaleza de la aplicación abarcaremos aspectos de accesibilidad para personas discapacidad visual (ciegos).

Flujo de accesibilidad flujo Vista Registro (primera vez que se abre la app una vez descargada de la AppStore): 
1. Se leen en altavoz el campo 'Nombre' y el botón 'Siguiente'.

Flujo de accesibilidad Vista Inicio:
1. Se leen las cajas de texto de Bienvenida.
2. Se leen las categorías. Se menciona que cada categoría es un elemento seleccionable.
   2.1 El usuario selecciona una categoría.
   2.2 Se lee la lista de la categoría. 
4. Se lee la lista de tendencias.
   3.1 El usuario selecciona una película de la lista.
   3.2 Se leen año, duración, calificación (se menciona que se pueden leer las reseñas), sinopsis y reparto.
       3.2.1 El usuario selecciona las reseñas.
       3.2.2 Se leen las reseñas.
       3.2.3 El usuario regresa a la vista 3.2.

Flujo de accesibilidad Vista Búsqueda. 
1. Se lee 'Campo para buscar películas'.
2. Se lee el historial de búsquedas guardadas.
3. Se leen categorías sugeridas.
4. El usuario escribe una película.
   4.1 Se muestran resultados de búsqueda.
       4.1.1 Si no hay resultados para la búsqueda se leen cajas de texto relacionados con 'Sin resultados'.
       4.1.2 Se lee el botón 'Limpiar Búsqueda'.
       4.1.3 El usuario regresa a la vista 1.
   4.2 El usuario selecciona una película de la lista de búsqueda realizada.
   4.3 Comienza el flujo 3.1 Flujo de accesibilidad Vista Inicio.

Flujo de accesibilidad Vista Favoritos.
1. Se leen las cajas de texto de Favoritos.
2. Se lee la lista de favoritos. Se menciona por altavoz que son elementos para seleccionar.
3. El usuario selecciona una película de la lista de favoritos.
4. Comienza el flujo 3.1 Flujo de accesibilidad Vista Inicio.

Flujo de accesibilidad Vista de Perfil.
1. Se leen los elementos presentes en la vista de perfil. 
	1.1 Se leen número de películas vistas, número de favoritos, número de reviews. 
	1.2 Se lee lista de reviews recientes. Se lee que las reviews son seleccionables.
2. Se lee el botón ‘Editar Perfil’.
3. El usuario selecciona el botón ‘Editar Perfil’.
	3.1 Se leen los elementos que se pueden editar en la vista de editar perfil.
	3.2 El usuario edita algún campo permitido. 
	3.3 Se leen botones ‘Cancelar’ y ‘Guardar’.
	3.3 El usuario selecciona Cancelar. 
		3.3.1 Se repite el flujo accesibilidad Vista de Perfil. 
	3.4 El usuario selecciona ‘Guardar’. 
		3.4.1 Se repite el flujo 3.1 de flujo de accesibilidad Vista de Perfil. 

Flujo accesibilidad Algo salió mal.
1. Se leen las cajas de texto con información de que algo salió mal. 
2. Se leen los botones ‘Reintentar’ e ‘Ir al inicio’.
	2.1 El usuario selecciona ‘Reintentar’. 
		2.1.1 La carga es exitosa. Se lee el flujo 4.1 de Flujo de accesibilidad Vista Búsqueda. 
		2.1.2 La carga no es exitosa. Se repite el flujo 1 de Flujo accesibilidad Algo salió mal.







