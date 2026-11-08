class_name CamaraIsometrica
extends Node3D

@export var suavizado := 5.5

var objetivo: Node3D
var camara: Camera3D


func _ready() -> void:
	camara = Camera3D.new()
	camara.name = "Camera3D"
	camara.projection = Camera3D.PROJECTION_ORTHOGONAL
	camara.size = 10.8
	camara.near = 0.1
	camara.far = 80.0
	camara.position = Vector3(8.8, 10.5, 8.8)
	add_child(camara)
	camara.look_at(Vector3(0, 0.7, 0), Vector3.UP)
	camara.current = true


func configurar(nuevo_objetivo: Node3D) -> void:
	objetivo = nuevo_objetivo
	global_position = Vector3(objetivo.global_position.x, 0.0, objetivo.global_position.z)


func _process(delta: float) -> void:
	if objetivo == null:
		return
	var destino := Vector3(objetivo.global_position.x, 0.0, objetivo.global_position.z)
	global_position = global_position.lerp(destino, 1.0 - exp(-suavizado * delta))
