extends Node


func _ready() -> void:
	_registrar_acciones()


func _registrar_acciones() -> void:
	_crear_accion("mover_arriba")
	_agregar_tecla("mover_arriba", KEY_W, true)
	_agregar_tecla("mover_arriba", KEY_UP)
	_agregar_boton_mando("mover_arriba", JOY_BUTTON_DPAD_UP)
	_agregar_eje_mando("mover_arriba", JOY_AXIS_LEFT_Y, -1.0)

	_crear_accion("mover_abajo")
	_agregar_tecla("mover_abajo", KEY_S, true)
	_agregar_tecla("mover_abajo", KEY_DOWN)
	_agregar_boton_mando("mover_abajo", JOY_BUTTON_DPAD_DOWN)
	_agregar_eje_mando("mover_abajo", JOY_AXIS_LEFT_Y, 1.0)

	_crear_accion("mover_izquierda")
	_agregar_tecla("mover_izquierda", KEY_A, true)
	_agregar_tecla("mover_izquierda", KEY_LEFT)
	_agregar_boton_mando("mover_izquierda", JOY_BUTTON_DPAD_LEFT)
	_agregar_eje_mando("mover_izquierda", JOY_AXIS_LEFT_X, -1.0)

	_crear_accion("mover_derecha")
	_agregar_tecla("mover_derecha", KEY_D, true)
	_agregar_tecla("mover_derecha", KEY_RIGHT)
	_agregar_boton_mando("mover_derecha", JOY_BUTTON_DPAD_RIGHT)
	_agregar_eje_mando("mover_derecha", JOY_AXIS_LEFT_X, 1.0)

	_crear_accion("accion")
	_agregar_tecla("accion", KEY_E, true)
	_agregar_tecla("accion", KEY_ENTER)
	_agregar_boton_mando("accion", JOY_BUTTON_A)

	_crear_accion("menu")
	_agregar_tecla("menu", KEY_ESCAPE)
	_agregar_boton_mando("menu", JOY_BUTTON_BACK)


func _crear_accion(nombre: StringName) -> void:
	if not InputMap.has_action(nombre):
		InputMap.add_action(nombre, 0.22)


func _agregar_tecla(accion: StringName, tecla: Key, fisica := false) -> void:
	var evento := InputEventKey.new()
	if fisica:
		evento.physical_keycode = tecla
	else:
		evento.keycode = tecla
	_agregar_si_falta(accion, evento)


func _agregar_boton_mando(accion: StringName, boton: JoyButton) -> void:
	var evento := InputEventJoypadButton.new()
	evento.button_index = boton
	_agregar_si_falta(accion, evento)


func _agregar_eje_mando(accion: StringName, eje: JoyAxis, valor: float) -> void:
	var evento := InputEventJoypadMotion.new()
	evento.axis = eje
	evento.axis_value = valor
	_agregar_si_falta(accion, evento)


func _agregar_si_falta(accion: StringName, evento: InputEvent) -> void:
	if not InputMap.action_has_event(accion, evento):
		InputMap.action_add_event(accion, evento)

