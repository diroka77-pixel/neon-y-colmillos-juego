class_name JoystickVirtual
extends Control

signal direccion_cambiada(direccion: Vector2)

var identificador_tactil := -1
var direccion := Vector2.ZERO
var radio := 48.0


func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_STOP
	custom_minimum_size = Vector2(112, 112)
	queue_redraw()


func _gui_input(evento: InputEvent) -> void:
	if evento is InputEventScreenTouch:
		if evento.pressed and identificador_tactil == -1:
			identificador_tactil = evento.index
			_actualizar(evento.position)
		elif not evento.pressed and evento.index == identificador_tactil:
			_liberar()
	elif evento is InputEventScreenDrag and evento.index == identificador_tactil:
		_actualizar(evento.position)
	elif evento is InputEventMouseButton and evento.button_index == MOUSE_BUTTON_LEFT:
		if evento.pressed:
			_actualizar(evento.position)
		else:
			_liberar()
	elif evento is InputEventMouseMotion and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		_actualizar(evento.position)


func _actualizar(posicion: Vector2) -> void:
	var centro := size * 0.5
	var desplazamiento := posicion - centro
	direccion = desplazamiento.limit_length(radio) / radio
	direccion_cambiada.emit(direccion)
	queue_redraw()


func _liberar() -> void:
	identificador_tactil = -1
	direccion = Vector2.ZERO
	direccion_cambiada.emit(direccion)
	queue_redraw()


func _draw() -> void:
	var centro := size * 0.5
	draw_circle(centro, 50.0, Color(0.05, 0.08, 0.11, 0.52))
	draw_arc(centro, 49.0, 0.0, TAU, 48, Color(0.2, 0.88, 0.93, 0.55), 2.0)
	draw_circle(centro + direccion * radio, 21.0, Color(0.22, 0.86, 0.91, 0.68))

