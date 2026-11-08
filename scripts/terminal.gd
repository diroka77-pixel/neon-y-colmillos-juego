class_name TerminalPrueba
extends Node3D

signal proximidad_cambiada(cerca: bool)
signal dialogo_solicitado(ruta: String)

const RADIO_INTERACCION := 2.2

var jugador: CharacterBody3D
var jugador_cerca := false
var pantalla_material: StandardMaterial3D
var tiempo := 0.0


func _ready() -> void:
	_construir_terminal()


func configurar(nuevo_jugador: CharacterBody3D) -> void:
	jugador = nuevo_jugador


func _process(delta: float) -> void:
	tiempo += delta
	if pantalla_material != null:
		pantalla_material.emission_energy_multiplier = 2.3 + sin(tiempo * 3.0) * 0.35
	if jugador == null:
		return
	var distancia := Vector2(global_position.x, global_position.z).distance_to(
		Vector2(jugador.global_position.x, jugador.global_position.z)
	)
	var cerca := distancia <= RADIO_INTERACCION
	if cerca != jugador_cerca:
		jugador_cerca = cerca
		proximidad_cambiada.emit(cerca)


func interactuar() -> bool:
	if not jugador_cerca:
		return false
	dialogo_solicitado.emit("res://data/dialogos/prueba.json")
	return true


func _construir_terminal() -> void:
	var carcasa := StandardMaterial3D.new()
	carcasa.albedo_color = Color("151a22")
	carcasa.metallic = 0.85
	carcasa.roughness = 0.3
	var borde := StandardMaterial3D.new()
	borde.albedo_color = Color("46515e")
	borde.metallic = 0.95
	borde.roughness = 0.18
	pantalla_material = StandardMaterial3D.new()
	pantalla_material.albedo_color = Color("092b35")
	pantalla_material.emission_enabled = true
	pantalla_material.emission = Color("26e6f1")
	pantalla_material.emission_energy_multiplier = 2.4
	var magenta := StandardMaterial3D.new()
	magenta.albedo_color = Color("681335")
	magenta.emission_enabled = true
	magenta.emission = Color("ff2489")
	magenta.emission_energy_multiplier = 2.0

	_crear_caja(Vector3(0, 0.7, 0), Vector3(0.85, 1.4, 0.55), carcasa)
	_crear_caja(Vector3(0, 1.18, 0.31), Vector3(0.66, 0.46, 0.05), pantalla_material)
	_crear_caja(Vector3(0, 0.25, 0.3), Vector3(0.45, 0.08, 0.05), magenta)
	_crear_caja(Vector3(-0.44, 0.7, 0), Vector3(0.06, 1.46, 0.6), borde)
	_crear_caja(Vector3(0.44, 0.7, 0), Vector3(0.06, 1.46, 0.6), borde)

	var cuerpo := StaticBody3D.new()
	var forma := CollisionShape3D.new()
	var caja := BoxShape3D.new()
	caja.size = Vector3(0.9, 1.45, 0.62)
	forma.position.y = 0.72
	forma.shape = caja
	cuerpo.add_child(forma)
	add_child(cuerpo)

	var luz := OmniLight3D.new()
	luz.position = Vector3(0, 1.15, 0.55)
	luz.light_color = Color("29e8f3")
	luz.light_energy = 1.0
	luz.omni_range = 3.2
	luz.shadow_enabled = false
	add_child(luz)


func _crear_caja(posicion: Vector3, tamano: Vector3, material: Material) -> void:
	var malla := BoxMesh.new()
	malla.size = tamano
	var nodo := MeshInstance3D.new()
	nodo.position = posicion
	nodo.mesh = malla
	nodo.material_override = material
	add_child(nodo)
