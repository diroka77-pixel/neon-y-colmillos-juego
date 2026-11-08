class_name InterfazJuego
extends CanvasLayer

var textos: Dictionary
var jugador: Diroka
var terminal: TerminalPrueba
var controles_tactiles: Control
var aviso: Label
var dialogo: CuadroDialogo
var boton_accion: BotonAccion


func configurar(nuevo_jugador: Diroka, nueva_terminal: TerminalPrueba) -> void:
	jugador = nuevo_jugador
	terminal = nueva_terminal
	textos = DataLoader.cargar_textos()
	_construir()
	terminal.proximidad_cambiada.connect(_cambiar_aviso)
	terminal.dialogo_solicitado.connect(_abrir_dialogo)


func _construir() -> void:
	var raiz := Control.new()
	raiz.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(raiz)

	var barras := VBoxContainer.new()
	barras.position = Vector2(14, 12)
	barras.size = Vector2(190, 54)
	barras.add_theme_constant_override("separation", 4)
	raiz.add_child(barras)
	_crear_barra(barras, textos.get("vida", ""), 82, Color("b9203c"))
	_crear_barra(barras, textos.get("reservas", ""), 64, Color("651f38"))

	aviso = Label.new()
	aviso.text = textos.get("aviso_accion", "")
	aviso.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	aviso.add_theme_font_size_override("font_size", 17)
	aviso.add_theme_color_override("font_color", Color("e7ffff"))
	aviso.anchor_left = 0.5
	aviso.anchor_right = 0.5
	aviso.anchor_top = 0.68
	aviso.anchor_bottom = 0.68
	aviso.offset_left = -70
	aviso.offset_right = 70
	aviso.offset_top = -18
	aviso.offset_bottom = 18
	aviso.visible = false
	raiz.add_child(aviso)

	controles_tactiles = Control.new()
	controles_tactiles.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	controles_tactiles.mouse_filter = Control.MOUSE_FILTER_IGNORE
	controles_tactiles.visible = DisplayServer.is_touchscreen_available()
	raiz.add_child(controles_tactiles)

	var joystick := JoystickVirtual.new()
	joystick.anchor_top = 1.0
	joystick.anchor_bottom = 1.0
	joystick.offset_left = 18
	joystick.offset_top = -130
	joystick.offset_right = 130
	joystick.offset_bottom = -18
	joystick.direccion_cambiada.connect(jugador.establecer_direccion_tactil)
	controles_tactiles.add_child(joystick)

	boton_accion = BotonAccion.new()
	boton_accion.configurar(textos.get("accion", ""))
	boton_accion.anchor_left = 1.0
	boton_accion.anchor_right = 1.0
	boton_accion.anchor_top = 1.0
	boton_accion.anchor_bottom = 1.0
	boton_accion.offset_left = -126
	boton_accion.offset_top = -126
	boton_accion.offset_right = -22
	boton_accion.offset_bottom = -22
	boton_accion.pulsado.connect(_pulsar_accion)
	controles_tactiles.add_child(boton_accion)

	dialogo = CuadroDialogo.new()
	dialogo.anchor_left = 0.06
	dialogo.anchor_right = 0.94
	dialogo.anchor_top = 0.55
	dialogo.anchor_bottom = 0.94
	dialogo.visible = false
	dialogo.configurar(textos)
	dialogo.terminado.connect(_cerrar_dialogo)
	raiz.add_child(dialogo)


func _crear_barra(padre: Control, etiqueta: String, valor: int, color: Color) -> void:
	var fila := HBoxContainer.new()
	fila.custom_minimum_size = Vector2(190, 24)
	padre.add_child(fila)
	var nombre := Label.new()
	nombre.text = etiqueta
	nombre.custom_minimum_size = Vector2(70, 20)
	nombre.add_theme_font_size_override("font_size", 13)
	fila.add_child(nombre)
	var barra := ProgressBar.new()
	barra.max_value = 100
	barra.value = valor
	barra.show_percentage = false
	barra.custom_minimum_size = Vector2(116, 16)
	barra.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	var fondo := StyleBoxFlat.new()
	fondo.bg_color = Color(0.02, 0.025, 0.04, 0.8)
	fondo.set_corner_radius_all(3)
	var relleno := StyleBoxFlat.new()
	relleno.bg_color = color
	relleno.set_corner_radius_all(3)
	barra.add_theme_stylebox_override("background", fondo)
	barra.add_theme_stylebox_override("fill", relleno)
	fila.add_child(barra)


func _cambiar_aviso(cerca: bool) -> void:
	aviso.visible = cerca and not dialogo.visible


func _pulsar_accion() -> void:
	if dialogo.visible:
		dialogo.avanzar()
	else:
		terminal.interactuar()


func _abrir_dialogo(ruta: String) -> void:
	jugador.set_physics_process(false)
	jugador.velocity = Vector2.ZERO
	controles_tactiles.visible = false
	aviso.visible = false
	dialogo.abrir(ruta)


func _cerrar_dialogo() -> void:
	jugador.set_physics_process(true)
	controles_tactiles.visible = DisplayServer.is_touchscreen_available()
	aviso.visible = terminal.jugador_cerca


func dialogo_abierto() -> bool:
	return dialogo != null and dialogo.visible


func ejecutar_accion() -> void:
	if dialogo_abierto():
		dialogo.avanzar()
	else:
		terminal.interactuar()

