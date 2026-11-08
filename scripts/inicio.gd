extends Node2D

var textos: Dictionary


func _ready() -> void:
	textos = DataLoader.cargar_textos()
	_construir_interfaz()


func _construir_interfaz() -> void:
	var fondo := ColorRect.new()
	fondo.color = Color("080b13")
	fondo.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	$Interfaz.add_child(fondo)

	var brillo := ColorRect.new()
	brillo.color = Color(0.02, 0.35, 0.42, 0.18)
	brillo.anchor_left = 0.18
	brillo.anchor_top = 0.34
	brillo.anchor_right = 0.82
	brillo.anchor_bottom = 0.66
	fondo.add_child(brillo)

	var contenedor := VBoxContainer.new()
	contenedor.alignment = BoxContainer.ALIGNMENT_CENTER
	contenedor.add_theme_constant_override("separation", 30)
	contenedor.set_anchors_and_offsets_preset(Control.PRESET_CENTER)
	contenedor.position = Vector2(-180, -65)
	contenedor.size = Vector2(360, 130)
	fondo.add_child(contenedor)

	var titulo := Label.new()
	titulo.text = textos.get("titulo", "")
	titulo.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	titulo.add_theme_font_size_override("font_size", 30)
	titulo.add_theme_color_override("font_color", Color("d9faff"))
	titulo.add_theme_color_override("font_shadow_color", Color("e21b78"))
	titulo.add_theme_constant_override("shadow_offset_x", 2)
	titulo.add_theme_constant_override("shadow_offset_y", 2)
	contenedor.add_child(titulo)

	var boton := Button.new()
	boton.text = textos.get("empezar", "")
	boton.custom_minimum_size = Vector2(190, 48)
	boton.focus_mode = Control.FOCUS_ALL
	boton.add_theme_font_size_override("font_size", 18)
	boton.add_theme_stylebox_override("normal", _estilo_boton(Color("182633"), Color("35e2ee")))
	boton.add_theme_stylebox_override("hover", _estilo_boton(Color("213c4b"), Color("e73291")))
	boton.add_theme_stylebox_override("pressed", _estilo_boton(Color("101820"), Color("e73291")))
	boton.pressed.connect(_empezar)
	contenedor.add_child(boton)
	boton.grab_focus()


func _estilo_boton(fondo: Color, borde: Color) -> StyleBoxFlat:
	var estilo := StyleBoxFlat.new()
	estilo.bg_color = fondo
	estilo.border_color = borde
	estilo.set_border_width_all(2)
	estilo.set_corner_radius_all(8)
	return estilo


func _empezar() -> void:
	get_tree().change_scene_to_file("res://scenes/callejon.tscn")

