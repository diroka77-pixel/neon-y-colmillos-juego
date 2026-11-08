# Dirección visual — Neón y Colmillos

Este documento fija las reglas del primer corte vertical. Las hojas de personaje aportadas por el autor son la referencia canónica; no se incluyen en el repositorio para no aumentar el tamaño de la APK.

## Lenguaje visual

- Cámara isométrica cercana, con personajes grandes y siluetas fáciles de reconocer.
- Realismo estilizado con lectura de novela gráfica: sombras marcadas, materiales húmedos y bordes de luz de color.
- Paleta casi negra, azul petróleo y metal. Cian para tecnología y lectura del espacio; rojo y magenta para peligro, implantes y tensión; ámbar para refugios y zonas habitadas.
- Arquitectura construida por capas. Cada pared debe tener zócalo, marco, hueco, tuberías, señalética y desgaste.
- Suelo mojado con charcos localizados y reflejos de neón. No toda la superficie debe parecer un espejo.

## Canon de personajes

### Diroka

- Adulto alto y delgado, hombros marcados y abrigo largo.
- Pelo negro largo, rostro anguloso, ojos verdes y cicatriz sobre el ojo derecho.
- Placa metálica de color cañón en la mejilla, borde superior plateado e implante cian en la sien.
- Cuero negro desgastado, correas, hebillas, guantes y botas pesadas.
- Luces rojas en el abrigo. El cian se reserva para el implante y tecnología asociada.

### Vane

- Adulto corpulento, brazos descubiertos y centro de gravedad más bajo que Diroka.
- Pelo oscuro peinado hacia atrás y barba corta entrecana.
- Implantes rojos grandes en cara y brazos.
- Debe distinguirse de Diroka incluso como silueta negra a tamaño de juego.

### Irina

- Niña de unos cinco años, pequeña y compacta, pelo rizado rojizo.
- Ropa de supervivencia adaptada a su tamaño, pañuelo magenta e interfaz auditiva cian.
- Animación curiosa y enérgica. Nunca debe usar las proporciones de un adulto reducido.

## Dos niveles de detalle

Los modelos jugables se optimizan para Android y para la distancia de cámara. Los retratos de diálogo conservan el detalle de las ilustraciones canónicas.

| Recurso | Objetivo inicial | Uso |
| --- | ---: | --- |
| Personaje principal | 30.000–45.000 triángulos | Juego y primeros planos breves |
| Personaje secundario | 18.000–30.000 triángulos | Juego |
| Texturas de Diroka | 2 juegos de 2048 px | Cuerpo y cabeza |
| Entorno modular | 500–8.000 triángulos por pieza | Escenario reutilizable |
| Texturas de entorno | Atlas de 2048 px | Paredes, suelo y utilería |
| Retrato de diálogo | 1600 × 1600 px | Interfaz narrativa |

En Android se cargará una variante de texturas de 1024 px cuando la memoria disponible lo requiera.

## Orden de producción

1. Terminar el refugio de prueba con composición, colisiones y luz definitivas.
2. Modelar y animar a Diroka según su hoja canónica.
3. Crear el kit modular de callejón y sustituir la geometría provisional.
4. Integrar retratos, caja de diálogo y tipografía final.
5. Crear a Vane e Irina después de aprobar el aspecto de Diroka en móvil.
6. Añadir una interacción narrativa completa y medir rendimiento.

El corte se considera aprobado cuando mantiene 30 FPS en el móvil objetivo, Diroka se reconoce sin acercar la cámara y el escenario ofrece una lectura clara del camino, la terminal y las zonas interactivas.
