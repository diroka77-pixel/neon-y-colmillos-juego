class_name Diroka
extends CharacterBody2D

@export var velocidad := 105.0

var direccion_tactil := Vector2.ZERO
var ultima_direccion := "abajo"

@onready var animacion: AnimatedSprite2D = $AnimatedSprite2D


func _physics_process(_delta: float) -> void:
	var direccion := Input.get_vector(
		"mover_izquierda", "mover_derecha", "mover_arriba", "mover_abajo"
	)
	if direccion_tactil.length_squared() > 0.01:
		direccion = direccion_tactil
	if direccion.length() > 1.0:
		direccion = direccion.normalized()

	velocity = direccion * velocidad
	move_and_slide()
	_actualizar_animacion(direccion)
	queue_redraw()


func establecer_direccion_tactil(valor: Vector2) -> void:
	direccion_tactil = valor


func _actualizar_animacion(direccion: Vector2) -> void:
	if direccion.length_squared() > 0.01:
		if absf(direccion.x) > absf(direccion.y):
			ultima_direccion = "derecha" if direccion.x > 0.0 else "izquierda"
		else:
			ultima_direccion = "abajo" if direccion.y > 0.0 else "arriba"
		animacion.play("walk_%s" % ultima_direccion)
	else:
		animacion.play("idle_%s" % ultima_direccion)


func _draw() -> void:
	draw_rect(Rect2(-8, -12, 16, 24), Color("252832"), true)
	draw_rect(Rect2(-8, -12, 16, 24), Color("666b78"), false, 1.0)
	draw_line(Vector2(-4, -10), Vector2(-4, 10), Color("b51d38"), 2.0)
	draw_circle(Vector2(3, -6), 1.0, Color("83ffde"))

