class_name BotonAccion
extends Control

signal pulsado

var texto := ""
var presionado := false


func configurar(nuevo_texto: String) -> void:
	texto = nuevo_texto
	queue_redraw()


func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_STOP
	custom_minimum_size = Vector2(104, 104)


func _gui_input(evento: InputEvent) -> void:
	if evento is InputEventScreenTouch:
		presionado = evento.pressed
		if evento.pressed:
			pulsado.emit()
		queue_redraw()
	elif evento is InputEventMouseButton and evento.button_index == MOUSE_BUTTON_LEFT:
		presionado = evento.pressed
		if evento.pressed:
			pulsado.emit()
		queue_redraw()


func _draw() -> void:
	var centro := size * 0.5
	var color := Color(0.84, 0.12, 0.43, 0.78 if presionado else 0.58)
	draw_circle(centro, 43.0, Color(0.05, 0.05, 0.09, 0.5))
	draw_arc(centro, 42.0, 0.0, TAU, 48, color, 3.0)
	var fuente := ThemeDB.fallback_font
	var tamano := 16
	var ancho := fuente.get_string_size(texto, HORIZONTAL_ALIGNMENT_LEFT, -1, tamano).x
	draw_string(fuente, centro + Vector2(-ancho * 0.5, 5), texto, HORIZONTAL_ALIGNMENT_LEFT, -1, tamano, Color.WHITE)

