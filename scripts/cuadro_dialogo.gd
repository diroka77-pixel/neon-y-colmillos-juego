class_name CuadroDialogo
extends PanelContainer

signal terminado

var lineas: Array = []
var indice := 0
var textos: Dictionary
var hablante: Label
var contenido: Label
var boton: Button


func configurar(textos_ui: Dictionary) -> void:
	textos = textos_ui
	_construir()


func _construir() -> void:
	mouse_filter = Control.MOUSE_FILTER_STOP
	gui_input.connect(_al_recibir_entrada)
	var estilo := StyleBoxFlat.new()
	estilo.bg_color = Color(0.025, 0.035, 0.055, 0.96)
	estilo.border_color = Color("34dfe9")
	estilo.set_border_width_all(2)
	estilo.set_corner_radius_all(8)
	estilo.set_content_margin_all(14)
	add_theme_stylebox_override("panel", estilo)

	var vertical := VBoxContainer.new()
	vertical.add_theme_constant_override("separation", 8)
	add_child(vertical)
	hablante = Label.new()
	hablante.add_theme_font_size_override("font_size", 18)
	hablante.add_theme_color_override("font_color", Color("ef459b"))
	vertical.add_child(hablante)
	contenido = Label.new()
	contenido.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	contenido.size_flags_vertical = Control.SIZE_EXPAND_FILL
	contenido.add_theme_font_size_override("font_size", 16)
	vertical.add_child(contenido)
	boton = Button.new()
	boton.text = textos.get("continuar", "")
	boton.custom_minimum_size = Vector2(130, 36)
	boton.size_flags_horizontal = Control.SIZE_SHRINK_END
	boton.pressed.connect(avanzar)
	vertical.add_child(boton)


func abrir(ruta: String) -> void:
	var datos: Variant = DataLoader.cargar_json(ruta)
	if datos is Dictionary and datos.get("lineas", []) is Array:
		lineas = datos.get("lineas", [])
	else:
		lineas = [{"hablante": "", "texto": textos.get("dialogo_error", ""), "expresion": ""}]
	indice = 0
	visible = true
	_mostrar_linea()
	boton.grab_focus()


func avanzar() -> void:
	if not visible:
		return
	indice += 1
	if indice >= lineas.size():
		visible = false
		terminado.emit()
		return
	_mostrar_linea()


func _mostrar_linea() -> void:
	var linea: Dictionary = lineas[indice]
	hablante.text = str(linea.get("hablante", ""))
	contenido.text = str(linea.get("texto", ""))


func _al_recibir_entrada(evento: InputEvent) -> void:
	if evento is InputEventScreenTouch and evento.pressed:
		avanzar()
		accept_event()
	elif evento is InputEventMouseButton and evento.button_index == MOUSE_BUTTON_LEFT and evento.pressed:
		avanzar()
		accept_event()


func _unhandled_input(evento: InputEvent) -> void:
	if visible and evento.is_action_pressed("accion"):
		avanzar()
		get_viewport().set_input_as_handled()

