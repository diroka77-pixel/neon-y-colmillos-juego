class_name MapaPrueba
extends TileMapLayer

const ANCHO := 40
const ALTO := 25
const TAMANO := 16


func _ready() -> void:
	texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	_construir_tileset()
	_colocar_casillas()


func _construir_tileset() -> void:
	var imagen := Image.create(TAMANO * 3, TAMANO, false, Image.FORMAT_RGBA8)
	_pintar_casilla(imagen, 0, Color("34414d"), Color("3e4d5a"))
	_pintar_casilla(imagen, 1, Color("10131a"), Color("262c37"))
	_pintar_casilla(imagen, 2, Color("183e4b"), Color("2d8a9b"))

	var textura := ImageTexture.create_from_image(imagen)
	var atlas := TileSetAtlasSource.new()
	atlas.texture = textura
	atlas.texture_region_size = Vector2i(TAMANO, TAMANO)
	for x in range(3):
		atlas.create_tile(Vector2i(x, 0))

	var conjunto := TileSet.new()
	conjunto.tile_size = Vector2i(TAMANO, TAMANO)
	conjunto.add_physics_layer()
	conjunto.set_physics_layer_collision_layer(0, 1)
	conjunto.set_physics_layer_collision_mask(0, 1)
	conjunto.add_source(atlas, 0)

	var muro: TileData = atlas.get_tile_data(Vector2i(1, 0), 0)
	muro.set_collision_polygons_count(0, 1)
	muro.set_collision_polygon_points(0, 0, PackedVector2Array([
		Vector2(-8, -8), Vector2(8, -8), Vector2(8, 8), Vector2(-8, 8)
	]))
	tile_set = conjunto


func _pintar_casilla(imagen: Image, indice: int, base: Color, detalle: Color) -> void:
	var inicio := indice * TAMANO
	for y in range(TAMANO):
		for x in range(TAMANO):
			var color := detalle if (x + y * 3) % 11 == 0 else base
			imagen.set_pixel(inicio + x, y, color)


func _colocar_casillas() -> void:
	for y in range(ALTO):
		for x in range(ANCHO):
			var borde := x == 0 or y == 0 or x == ANCHO - 1 or y == ALTO - 1
			set_cell(Vector2i(x, y), 0, Vector2i(1 if borde else 0, 0))

	for x in range(6, 15):
		set_cell(Vector2i(x, 6), 0, Vector2i(1, 0))
	for x in range(25, 34):
		set_cell(Vector2i(x, 18), 0, Vector2i(1, 0))
	for y in range(10, 16):
		set_cell(Vector2i(10, y), 0, Vector2i(1, 0))

	for casilla in [Vector2i(17, 8), Vector2i(18, 8), Vector2i(28, 12), Vector2i(29, 12), Vector2i(30, 12), Vector2i(5, 20)]:
		set_cell(casilla, 0, Vector2i(2, 0))

