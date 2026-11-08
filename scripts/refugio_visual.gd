class_name RefugioVisual
extends Node3D

var piedra: StandardMaterial3D
var hormigon: StandardMaterial3D
var metal: StandardMaterial3D
var metal_negro: StandardMaterial3D
var madera: StandardMaterial3D
var vidrio: StandardMaterial3D
var cian: StandardMaterial3D
var rojo: StandardMaterial3D
var ambar: StandardMaterial3D


func construir() -> void:
	_preparar_materiales()
	_suelo_con_detalle()
	_fachada_taller()
	_puesto_callejero()
	_utileria()


func _preparar_materiales() -> void:
	piedra = _material_textura(Color("30383d"), Color("596269"), 0.08, 0.82, 17)
	hormigon = _material_textura(Color("252c31"), Color("4b5357"), 0.02, 0.9, 31)
	metal = _material_textura(Color("273138"), Color("5a676d"), 0.76, 0.34, 53)
	metal_negro = _material(Color("090e13"), 0.68, 0.4)
	madera = _material_textura(Color("3c2b27"), Color("805640"), 0.02, 0.72, 71, true)
	vidrio = _material(Color("092832"), 0.46, 0.08)
	cian = _emisivo(Color("064b54"), Color("2ceeff"), 4.3)
	rojo = _emisivo(Color("541020"), Color("ff294d"), 4.1)
	ambar = _emisivo(Color("5f4315"), Color("ffc35a"), 3.7)


func _suelo_con_detalle() -> void:
	# Baldosas independientes: rompen la superficie plana y reciben el neón de forma distinta.
	for z in range(-3, 4):
		for x in range(-5, 6):
			var tono := piedra if (x + z) % 3 else hormigon
			var baldosa := _caja(Vector3(x * 2.02, 0.015, z * 1.92), Vector3(1.94, 0.07, 1.84), tono)
			baldosa.rotation_degrees.y = float((x * 7 + z * 11) % 3 - 1) * 0.22

	# Canal de desagüe legible y con relieve real.
	_caja(Vector3(0.0, 0.075, 4.9), Vector3(8.5, 0.05, 0.8), metal_negro)
	for i in range(20):
		_caja(Vector3(-4.0 + i * 0.42, 0.108, 4.9), Vector3(0.25, 0.035, 0.66), metal)


func _fachada_taller() -> void:
	# El fondo existente se convierte en una fachada por capas.
	_caja(Vector3(-5.8, 2.2, -7.33), Vector3(3.55, 3.9, 0.16), metal_negro)
	for y in range(14):
		_caja(Vector3(-5.8, 0.52 + y * 0.245, -7.18), Vector3(3.25, 0.15, 0.13), metal)
	_marquesina(Vector3(-5.8, 4.25, -6.85), 4.0)
	_cartel(Vector3(-5.8, 4.62, -7.08), Vector3(3.0, 0.42, 0.12), ambar, Color("ffc35a"))

	# Puerta principal y marco profundo.
	_caja(Vector3(1.1, 1.75, -7.29), Vector3(2.5, 3.2, 0.18), madera)
	_caja(Vector3(1.1, 3.48, -7.05), Vector3(3.0, 0.28, 0.5), metal)
	for x in [-0.3, 2.5]:
		_caja(Vector3(x, 1.82, -7.05), Vector3(0.28, 3.55, 0.5), metal)
	for x in [0.45, 1.75]:
		_caja(Vector3(x, 2.1, -7.17), Vector3(0.86, 1.35, 0.06), vidrio)
	_cartel(Vector3(1.1, 3.92, -6.86), Vector3(2.5, 0.13, 0.12), cian, Color("2ceeff"))

	# Ventanas, persianas y ventilación dan escala humana.
	for x in [5.2, 8.0]:
		_caja(Vector3(x, 2.65, -7.29), Vector3(1.8, 1.8, 0.15), vidrio)
		_caja(Vector3(x, 3.65, -7.06), Vector3(2.1, 0.18, 0.34), metal)
		for y in range(5):
			_caja(Vector3(x, 2.05 + y * 0.3, -7.12), Vector3(1.62, 0.08, 0.14), metal)
	_ventilador(Vector3(8.0, 1.15, -7.0))

	# Tuberías y abrazaderas añaden detalle vertical.
	for x in [-10.1, -9.55, 3.55]:
		_cilindro(Vector3(x, 2.55, -7.0), 0.1, 4.7, metal)
		for y in [0.7, 2.25, 4.25]:
			_cilindro(Vector3(x, y, -7.0), 0.15, 0.12, metal_negro)
	var tubo_horizontal := _cilindro(Vector3(-3.0, 4.75, -7.0), 0.09, 13.0, metal)
	tubo_horizontal.rotation_degrees.z = 90.0


func _puesto_callejero() -> void:
	_caja(Vector3(-8.4, 0.18, -3.6), Vector3(3.3, 0.25, 2.45), madera)
	_caja(Vector3(-8.4, 0.83, -2.65), Vector3(3.2, 1.0, 0.5), madera)
	for x in [-9.75, -7.05]:
		_caja(Vector3(x, 1.95, -3.55), Vector3(0.15, 3.4, 0.15), metal)
	var techo := _caja(Vector3(-8.4, 3.56, -3.55), Vector3(3.55, 0.16, 2.75), madera)
	techo.rotation_degrees.z = -2.5
	_cartel(Vector3(-8.4, 3.25, -2.14), Vector3(2.6, 0.13, 0.12), rojo, Color("ff294d"))
	for i in range(5):
		_caja(Vector3(-9.55 + i * 0.58, 1.43, -2.66), Vector3(0.34, 0.42 + (i % 2) * 0.13, 0.34), metal)


func _utileria() -> void:
	# Contenedor, cajas, bolardos y cableado llenan el plano sin cerrar el paso jugable.
	_caja(Vector3(8.4, 0.76, 4.7), Vector3(2.9, 1.4, 1.7), metal)
	var tapa := _caja(Vector3(8.4, 1.54, 4.62), Vector3(3.0, 0.18, 1.75), metal_negro)
	tapa.rotation_degrees.x = -7.0
	for datos in [[-5.3, 3.7, 1.2], [-4.2, 4.1, 0.75], [5.3, -3.3, 0.9]]:
		var medida := float(datos[2])
		var caja := _caja(Vector3(float(datos[0]), medida * 0.5 + 0.06, float(datos[1])), Vector3(medida, medida, medida), madera)
		caja.rotation_degrees.y = float(int(float(datos[0]) * 11.0) % 9)

	for x in [-1.2, 0.8, 2.8]:
		_cilindro(Vector3(x, 0.45, -4.75), 0.17, 0.86, metal)
		_caja(Vector3(x, 0.75, -4.75), Vector3(0.21, 0.15, 0.21), cian)

	for z in [-5.8, -3.9, -2.0]:
		_caja(Vector3(11.75, 2.0, z), Vector3(0.16, 2.8, 0.42), metal)
	_cartel(Vector3(11.6, 2.4, 2.9), Vector3(0.14, 2.8, 0.5), rojo, Color("ff294d"))


func _marquesina(posicion: Vector3, ancho: float) -> void:
	var techo := _caja(posicion, Vector3(ancho, 0.16, 1.15), metal)
	techo.rotation_degrees.x = -8.0
	_caja(posicion + Vector3(0, -0.17, 0.42), Vector3(ancho * 0.82, 0.06, 0.08), ambar)


func _ventilador(posicion: Vector3) -> void:
	var aro := _cilindro(posicion, 0.68, 0.18, metal)
	aro.rotation_degrees.x = 90.0
	for angulo in [0.0, 45.0, 90.0, 135.0]:
		var pala := _caja(posicion + Vector3(0, 0, 0.13), Vector3(0.12, 1.05, 0.07), metal_negro)
		pala.rotation_degrees.z = angulo


func _cartel(posicion: Vector3, tamano: Vector3, material: Material, color_luz: Color) -> void:
	_caja(posicion, tamano, material)
	var luz := OmniLight3D.new()
	luz.position = posicion + Vector3(0, 0, 0.5)
	luz.light_color = color_luz
	luz.light_energy = 1.25
	luz.omni_range = 4.2
	luz.shadow_enabled = false
	add_child(luz)


func _caja(posicion: Vector3, tamano: Vector3, material: Material) -> MeshInstance3D:
	var malla := BoxMesh.new()
	malla.size = tamano
	var nodo := MeshInstance3D.new()
	nodo.position = posicion
	nodo.mesh = malla
	nodo.material_override = material
	add_child(nodo)
	return nodo


func _cilindro(posicion: Vector3, radio: float, altura: float, material: Material) -> MeshInstance3D:
	var malla := CylinderMesh.new()
	malla.top_radius = radio
	malla.bottom_radius = radio
	malla.height = altura
	malla.radial_segments = 16
	var nodo := MeshInstance3D.new()
	nodo.position = posicion
	nodo.mesh = malla
	nodo.material_override = material
	add_child(nodo)
	return nodo


func _material(color: Color, metalicidad: float, rugosidad: float) -> StandardMaterial3D:
	var material := StandardMaterial3D.new()
	material.albedo_color = color
	material.metallic = metalicidad
	material.roughness = rugosidad
	return material


func _material_textura(base: Color, detalle: Color, metalicidad: float, rugosidad: float, semilla: int, vetas := false) -> StandardMaterial3D:
	var imagen := Image.create(96, 96, false, Image.FORMAT_RGBA8)
	for y in range(96):
		for x in range(96):
			var grano := (sin(float(x * 19 + y * 31 + semilla * 17)) * 0.5 + 0.5) * 0.18
			if vetas:
				grano += (sin(float(y) * 0.31 + sin(float(x) * 0.08) * 2.0) * 0.5 + 0.5) * 0.2
			var color := base.lerp(detalle, grano)
			if (x + semilla) % 47 == 0 or (y + semilla * 2) % 61 == 0:
				color = color.darkened(0.12)
			imagen.set_pixel(x, y, color)
	var material := _material(Color.WHITE, metalicidad, rugosidad)
	material.albedo_texture = ImageTexture.create_from_image(imagen)
	material.uv1_scale = Vector3(2.4, 2.4, 2.4)
	return material


func _emisivo(color: Color, emision: Color, energia: float) -> StandardMaterial3D:
	var material := _material(color, 0.42, 0.28)
	material.emission_enabled = true
	material.emission = emision
	material.emission_energy_multiplier = energia
	return material
