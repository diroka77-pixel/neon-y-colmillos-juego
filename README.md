# Neón y Colmillos — Corte vertical

RPG isométrico 3D para Android y Windows, creado con Godot 4.7.2 y GDScript. La base contiene movimiento, cámara isométrica, un callejón cyberpunk tridimensional, controles multiplataforma y un diálogo sencillo. El primer corte vertical visual añade arquitectura por capas, materiales procedurales y cuatro vistas 2.5D de Diroka basadas en su diseño canónico. Todavía no incluye combate, inventario ni historia del juego.

La guía que fija el aspecto de personajes y escenarios está en `docs/DIRECCION_VISUAL.md`.

## Descargar e instalar la APK desde el móvil

1. Abre el repositorio en GitHub y entra en la pestaña **Actions**.
2. Abre la ejecución más reciente llamada **Compilar Android y Windows** que tenga una marca verde.
3. Baja hasta **Artifacts** y toca **neon-y-colmillos-android**.
4. Descomprime el archivo descargado y abre `neon-y-colmillos.apk`.
5. Si Android lo solicita, permite instalar aplicaciones desde el navegador o el gestor de archivos que estés usando.
6. Confirma la instalación y abre **Neón y Colmillos**.

La APK es una compilación de depuración destinada a pruebas. GitHub conserva los artefactos durante 30 días; se puede lanzar otra compilación desde **Actions > Compilar Android y Windows > Run workflow**.

## Versión de Windows

En la misma ejecución de Actions, descarga **neon-y-colmillos-windows**, descomprime el archivo y ejecuta `NeonYColmillos.exe`. El paquete lleva los recursos integrados en el ejecutable.

## Controles

- Android: joystick virtual y botón **Acción** sobre una cámara isométrica.
- Teclado: WASD o flechas para moverse, E o Intro para actuar y Esc para volver al inicio.
- Mando: stick izquierdo o cruceta para moverse y botón A para actuar.

Al acercarse a la terminal aparece el aviso **Acción**. El diálogo avanza tocando el cuadro, pulsando su botón o usando la acción del teclado o mando.

## Organización

- `scenes/`: escenas de inicio, callejón isométrico y Diroka.
- `scripts/`: personaje 3D procedural, escenario, cámara, interfaz, controles, terminal y carga de datos.
- `assets/placeholder/`: recursos provisionales creados para el proyecto.
- `assets/characters/diroka/`: vistas isométricas provisionales del personaje canónico.
- `data/dialogos/`: diálogos en JSON.
- `data/ui.json`: todos los textos visibles de la interfaz.
- `docs/DIRECCION_VISUAL.md`: canon visual, presupuestos de recursos y orden de producción.
- `export_presets.cfg`: exportaciones de Android y Windows.
- `.github/workflows/build.yml`: compilación automática en GitHub Actions.

## Compilación automática

Cada `push` a `main` inicia la compilación. También puede iniciarse a mano desde `workflow_dispatch`. El flujo usa versiones fijas de Godot y de las acciones, comprueba los archivos oficiales de Godot antes de descargarlos, instala Java 17 y Android SDK, crea una keystore temporal de depuración y publica los dos artefactos.

El identificador Android está en `export_presets.cfg` como `com.neonycolmillos.juego` y se puede cambiar más adelante.

## Demostración isométrica

El callejón se construye enteramente por código con geometría y materiales propios: edificios industriales, tuberías, cajas, pasarela, desagües, charcos reflectantes, vapor, luces de neón y niebla ambiental. Diroka tiene un modelo provisional tridimensional con gabardina, línea roja, ojos verdes y placa facial. No se utiliza ningún recurso artístico de terceros.

