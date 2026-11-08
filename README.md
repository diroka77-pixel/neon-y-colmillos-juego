# Neón y Colmillos — Fase 1

Base técnica de un RPG 2D por turnos para Android y Windows, creado con Godot 4.7.2 y GDScript. Esta fase contiene el movimiento, un mapa de prueba, controles multiplataforma y un diálogo sencillo. Todavía no incluye combate, inventario ni historia del juego.

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

- Android: joystick virtual y botón **Acción**.
- Teclado: WASD o flechas para moverse, E o Intro para actuar y Esc para volver al inicio.
- Mando: stick izquierdo o cruceta para moverse y botón A para actuar.

Al acercarse a la terminal aparece el aviso **Acción**. El diálogo avanza tocando el cuadro, pulsando su botón o usando la acción del teclado o mando.

## Organización

- `scenes/`: escenas de inicio, callejón y Diroka.
- `scripts/`: movimiento, mapa, interfaz, controles, terminal y carga de datos.
- `assets/placeholder/`: recursos provisionales creados para el proyecto.
- `data/dialogos/`: diálogos en JSON.
- `data/ui.json`: todos los textos visibles de la interfaz.
- `export_presets.cfg`: exportaciones de Android y Windows.
- `.github/workflows/build.yml`: compilación automática en GitHub Actions.

## Compilación automática

Cada `push` a `main` inicia la compilación. También puede iniciarse a mano desde `workflow_dispatch`. El flujo usa versiones fijas de Godot y de las acciones, comprueba los archivos oficiales de Godot antes de descargarlos, instala Java 17 y Android SDK, crea una keystore temporal de depuración y publica los dos artefactos.

El identificador Android está en `export_presets.cfg` como `com.neonycolmillos.juego` y se puede cambiar más adelante.

