extends Node2D

const LIMITE_MAPA := Vector2i(640, 400)

var jugador: Diroka
var terminal: TerminalPrueba
var interfaz: InterfazJuego


func _ready() -> void:
	_construir_mundo()


func _construir_mundo() -> void:
	var modulacion := CanvasModulate.new()
	modulacion.color = Color("83899b")
	add_child(modulacion)

	var mapa := MapaPrueba.new()
	mapa.name = "TileMapLayer"
	add_child(mapa)

	jugador = preload("res://scenes/diroka.tscn").instantiate()
	jugador.position = Vector2(320, 210)
	add_child(jugador)
	var camara: Camera2D = jugador.get_node("Camera2D")
	camara.limit_left = 0
	camara.limit_top = 0
	camara.limit_right = LIMITE_MAPA.x
	camara.limit_bottom = LIMITE_MAPA.y

	terminal = TerminalPrueba.new()
	terminal.position = Vector2(384, 208)
	terminal.configurar(jugador)
	add_child(terminal)

	_crear_luz(Vector2(160, 112), Color("27e5f0"), 0.9, false)
	_crear_luz(Vector2(385, 205), Color("ff2b96"), 1.05, true)
	_crear_luz(Vector2(500, 305), Color("37b9ff"), 0.7, false)

	interfaz = InterfazJuego.new()
	add_child(interfaz)
	interfaz.configurar(jugador, terminal)


func _crear_luz(posicion: Vector2, color: Color, energia: float, parpadea: bool) -> void:
	var luz := PointLight2D.new()
	luz.position = posicion
	luz.color = color
	luz.energy = energia
	luz.texture_scale = 1.7
	luz.texture = _textura_luz()
	if parpadea:
		luz.set_script(preload("res://scripts/luz_parpadeante.gd"))
	add_child(luz)


func _textura_luz() -> Texture2D:
	var degradado := Gradient.new()
	degradado.set_color(0, Color(1, 1, 1, 0.9))
	degradado.set_color(1, Color(1, 1, 1, 0.0))
	var textura := GradientTexture2D.new()
	textura.width = 128
	textura.height = 128
	textura.fill = GradientTexture2D.FILL_RADIAL
	textura.fill_from = Vector2(0.5, 0.5)
	textura.fill_to = Vector2(1.0, 0.5)
	textura.gradient = degradado
	return textura


func _unhandled_input(evento: InputEvent) -> void:
	if evento.is_action_pressed("accion") and not interfaz.dialogo_abierto():
		interfaz.ejecutar_accion()
		get_viewport().set_input_as_handled()
	elif evento.is_action_pressed("menu"):
		get_tree().change_scene_to_file("res://scenes/inicio.tscn")

