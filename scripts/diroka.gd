class_name Diroka
extends CharacterBody3D

@export var velocidad := 4.2
@export var aceleracion := 18.0

var direccion_tactil := Vector2.ZERO
var tiempo_paso := 0.0
var brazos: Array[Node3D] = []
var faldones: Array[Node3D] = []

@onready var modelo: Node3D = $Modelo


func _ready() -> void:
	_construir_modelo()


func _physics_process(delta: float) -> void:
	var entrada := Input.get_vector(
		"mover_izquierda", "mover_derecha", "mover_arriba", "mover_abajo"
	)
	if direccion_tactil.length_squared() > 0.01:
		entrada = direccion_tactil
	if entrada.length() > 1.0:
		entrada = entrada.normalized()

	# Convierte los ejes de pantalla a los ejes del callejón isométrico.
	var direccion := Vector3(entrada.x + entrada.y, 0.0, entrada.y - entrada.x)
	if direccion.length() > 1.0:
		direccion = direccion.normalized()
	var objetivo := direccion * velocidad
	velocity.x = move_toward(velocity.x, objetivo.x, aceleracion * delta)
	velocity.z = move_toward(velocity.z, objetivo.z, aceleracion * delta)
	if not is_on_floor():
		velocity.y -= 18.0 * delta
	else:
		velocity.y = -0.1

	if direccion.length_squared() > 0.01:
		rotation.y = lerp_angle(rotation.y, atan2(direccion.x, direccion.z), 1.0 - exp(-12.0 * delta))
	move_and_slide()
	_animar_modelo(delta, direccion.length())


func establecer_direccion_tactil(valor: Vector2) -> void:
	direccion_tactil = valor


func _animar_modelo(delta: float, intensidad: float) -> void:
	if intensidad > 0.05:
		tiempo_paso += delta * 8.0
		modelo.position.y = absf(sin(tiempo_paso)) * 0.035
		for i in range(brazos.size()):
			brazos[i].rotation.x = sin(tiempo_paso + float(i) * PI) * 0.25
		for i in range(faldones.size()):
			faldones[i].rotation.x = -0.12 + sin(tiempo_paso + float(i)) * 0.05
	else:
		tiempo_paso += delta * 1.6
		modelo.position.y = sin(tiempo_paso) * 0.012
		for brazo in brazos:
			brazo.rotation.x = lerp(brazo.rotation.x, 0.0, delta * 6.0)


func _construir_modelo() -> void:
	var cuero := _material(Color("11151d"), 0.42, 0.5)
	var cuero_claro := _material(Color("242b35"), 0.3, 0.55)
	var metal := _material(Color("394653"), 0.82, 0.27)
	var piel := _material(Color("c5b4aa"), 0.0, 0.78)
	var pelo := _material(Color("08090d"), 0.05, 0.72)
	var rojo := _material_emisivo(Color("a71331"), Color("df1749"), 1.7)
	var verde := _material_emisivo(Color("31b878"), Color("66ffc0"), 2.5)

	_crear_cilindro("PiernaIzq", Vector3(-0.2, 0.52, 0), 0.13, 0.9, cuero)
	_crear_cilindro("PiernaDer", Vector3(0.2, 0.52, 0), 0.13, 0.9, cuero)
	_crear_caja("BotaIzq", Vector3(-0.2, 0.11, 0.08), Vector3(0.3, 0.25, 0.48), cuero_claro)
	_crear_caja("BotaDer", Vector3(0.2, 0.11, 0.08), Vector3(0.3, 0.25, 0.48), cuero_claro)
	_crear_caja("Torso", Vector3(0, 1.48, 0), Vector3(0.78, 1.05, 0.43), cuero_claro)
	_crear_caja("Pecho", Vector3(0, 1.62, 0.235), Vector3(0.7, 0.62, 0.06), metal)

	_crear_esfera("HombroIzq", Vector3(-0.49, 1.78, 0), Vector3(0.22, 0.2, 0.24), metal)
	_crear_esfera("HombroDer", Vector3(0.49, 1.78, 0), Vector3(0.22, 0.2, 0.24), metal)
	for datos in [["BrazoIzq", -0.51], ["BrazoDer", 0.51]]:
		var pivote := Node3D.new()
		pivote.name = datos[0]
		pivote.position = Vector3(datos[1], 1.72, 0)
		modelo.add_child(pivote)
		_crear_cilindro_en(pivote, Vector3(0, -0.42, 0), 0.105, 0.8, cuero)
		_crear_esfera_en(pivote, Vector3(0, -0.86, 0), Vector3(0.12, 0.14, 0.12), piel)
		brazos.append(pivote)

	_crear_esfera("Cabeza", Vector3(0, 2.28, 0), Vector3(0.31, 0.37, 0.3), piel)
	_crear_esfera("Cabello", Vector3(0, 2.43, -0.035), Vector3(0.34, 0.28, 0.33), pelo)
	for i in range(5):
		var mechon := _crear_cilindro("Mechon%d" % i, Vector3(-0.22 + i * 0.11, 2.08, -0.17), 0.035, 0.62 + (i % 2) * 0.12, pelo)
		mechon.rotation_degrees.x = 8.0

	_crear_esfera("OjoIzq", Vector3(-0.105, 2.32, 0.286), Vector3(0.035, 0.025, 0.018), verde)
	_crear_esfera("OjoDer", Vector3(0.105, 2.32, 0.286), Vector3(0.035, 0.025, 0.018), verde)
	var placa := _crear_caja("ImplanteMejilla", Vector3(0.205, 2.20, 0.274), Vector3(0.18, 0.19, 0.035), metal)
	placa.rotation_degrees.z = -12.0
	_crear_caja("BordeImplante", Vector3(0.2, 2.305, 0.297), Vector3(0.21, 0.035, 0.025), _material(Color("aeb8c3"), 0.9, 0.2))

	_crear_caja("LineaAbrigo", Vector3(-0.22, 1.42, 0.27), Vector3(0.055, 1.5, 0.035), rojo)
	for datos in [["FaldonIzq", -0.23, -0.14], ["FaldonDer", 0.23, 0.14]]:
		var pivote := Node3D.new()
		pivote.name = datos[0]
		pivote.position = Vector3(datos[1], 1.05, -0.18)
		pivote.rotation.x = datos[2]
		modelo.add_child(pivote)
		_crear_caja_en(pivote, Vector3(0, -0.52, 0), Vector3(0.4, 1.12, 0.12), cuero)
		faldones.append(pivote)

	var luz := OmniLight3D.new()
	luz.position = Vector3(-0.22, 1.5, 0.35)
	luz.light_color = Color("d91b4b")
	luz.light_energy = 0.45
	luz.omni_range = 1.8
	luz.shadow_enabled = false
	modelo.add_child(luz)


func _material(color: Color, metalicidad: float, rugosidad: float) -> StandardMaterial3D:
	var material := StandardMaterial3D.new()
	material.albedo_color = color
	material.metallic = metalicidad
	material.roughness = rugosidad
	return material


func _material_emisivo(color: Color, emision: Color, energia: float) -> StandardMaterial3D:
	var material := _material(color, 0.35, 0.35)
	material.emission_enabled = true
	material.emission = emision
	material.emission_energy_multiplier = energia
	return material


func _crear_caja(nombre: String, posicion: Vector3, tamano: Vector3, material: Material) -> MeshInstance3D:
	return _crear_caja_en(modelo, posicion, tamano, material, nombre)


func _crear_caja_en(padre: Node3D, posicion: Vector3, tamano: Vector3, material: Material, nombre := "Caja") -> MeshInstance3D:
	var malla := BoxMesh.new()
	malla.size = tamano
	var nodo := MeshInstance3D.new()
	nodo.name = nombre
	nodo.position = posicion
	nodo.mesh = malla
	nodo.material_override = material
	padre.add_child(nodo)
	return nodo


func _crear_cilindro(nombre: String, posicion: Vector3, radio: float, altura: float, material: Material) -> MeshInstance3D:
	return _crear_cilindro_en(modelo, posicion, radio, altura, material, nombre)


func _crear_cilindro_en(padre: Node3D, posicion: Vector3, radio: float, altura: float, material: Material, nombre := "Cilindro") -> MeshInstance3D:
	var malla := CylinderMesh.new()
	malla.top_radius = radio
	malla.bottom_radius = radio
	malla.height = altura
	malla.radial_segments = 12
	var nodo := MeshInstance3D.new()
	nodo.name = nombre
	nodo.position = posicion
	nodo.mesh = malla
	nodo.material_override = material
	padre.add_child(nodo)
	return nodo


func _crear_esfera(nombre: String, posicion: Vector3, escala: Vector3, material: Material) -> MeshInstance3D:
	return _crear_esfera_en(modelo, posicion, escala, material, nombre)


func _crear_esfera_en(padre: Node3D, posicion: Vector3, escala: Vector3, material: Material, nombre := "Esfera") -> MeshInstance3D:
	var malla := SphereMesh.new()
	malla.radius = 1.0
	malla.height = 2.0
	malla.radial_segments = 16
	malla.rings = 8
	var nodo := MeshInstance3D.new()
	nodo.name = nombre
	nodo.position = posicion
	nodo.scale = escala
	nodo.mesh = malla
	nodo.material_override = material
	padre.add_child(nodo)
	return nodo
