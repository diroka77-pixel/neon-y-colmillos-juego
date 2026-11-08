extends Node3D

var jugador: Diroka
var terminal: TerminalPrueba
var interfaz: InterfazJuego

var metal_oscuro: StandardMaterial3D
var metal_medio: StandardMaterial3D
var suelo_material: StandardMaterial3D
var cian: StandardMaterial3D
var magenta: StandardMaterial3D
var rojo: StandardMaterial3D


func _ready() -> void:
	_preparar_materiales()
	_configurar_ambiente()
	_construir_callejon()
	_crear_jugador_y_camara()
	_crear_terminal()
	_crear_interfaz()


func _preparar_materiales() -> void:
	metal_oscuro = _material(Color("111720"), 0.78, 0.46)
	metal_medio = _material(Color("27333d"), 0.72, 0.38)
	suelo_material = _material(Color("273640"), 0.48, 0.62)
	cian = _material_emisivo(Color("0c4854"), Color("22e4ee"), 3.0)
	magenta = _material_emisivo(Color("53112f"), Color("f3268d"), 3.2)
	rojo = _material_emisivo(Color("46121c"), Color("d8213d"), 2.4)


func _configurar_ambiente() -> void:
	var entorno := Environment.new()
	entorno.background_mode = Environment.BG_COLOR
	entorno.background_color = Color("04070d")
	entorno.background_energy_multiplier = 0.7
	entorno.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	entorno.ambient_light_color = Color("344b5b")
	entorno.ambient_light_energy = 0.68
	entorno.reflected_light_source = Environment.REFLECTION_SOURCE_DISABLED
	entorno.tonemap_mode = Environment.TONE_MAPPER_ACES
	entorno.fog_enabled = true
	entorno.fog_light_color = Color("152536")
	entorno.fog_light_energy = 0.28
	entorno.fog_density = 0.010
	entorno.fog_sky_affect = 0.0
	var mundo := WorldEnvironment.new()
	mundo.environment = entorno
	add_child(mundo)

	var luna := DirectionalLight3D.new()
	luna.rotation_degrees = Vector3(-58, -28, 0)
	luna.light_color = Color("738aa8")
	luna.light_energy = 0.58
	luna.shadow_enabled = true
	luna.directional_shadow_max_distance = 28.0
	add_child(luna)


func _construir_callejon() -> void:
	_crear_caja("Suelo", Vector3(0, -0.16, 0), Vector3(24, 0.3, 15), suelo_material, true)
	_crear_rejilla_suelo()
	var detalle := RefugioVisual.new()
	detalle.name = "RefugioVisual"
	add_child(detalle)
	detalle.construir()

	_crear_caja("EdificioNorte", Vector3(0, 2.5, -8.0), Vector3(25, 5.2, 1.2), metal_oscuro, true)
	_crear_caja("EdificioSur", Vector3(0, 2.0, 8.0), Vector3(25, 4.2, 1.2), metal_oscuro, true)
	_crear_caja("LimiteOeste", Vector3(-12.5, 1.3, 0), Vector3(1.0, 2.6, 15), metal_oscuro, true)
	_crear_caja("LimiteEste", Vector3(12.5, 1.3, 0), Vector3(1.0, 2.6, 15), metal_oscuro, true)

	for x in [-9.0, -4.5, 0.0, 4.5, 9.0]:
		_crear_caja("Contrafuerte", Vector3(x, 1.5, -7.25), Vector3(0.42, 3.0, 0.42), metal_medio, false)
		_crear_caja("Panel", Vector3(x + 1.45, 1.9, -7.34), Vector3(2.3, 1.5, 0.12), _material(Color("17212b"), 0.75, 0.32), false)

	_crear_tuberias()
	_crear_cartel_neon(Vector3(-6.0, 2.75, -7.28), Vector3(3.2, 0.12, 0.18), cian, Color("2beaf3"))
	_crear_cartel_neon(Vector3(6.5, 2.1, -7.3), Vector3(2.3, 0.1, 0.16), magenta, Color("f52b92"), true)
	_crear_cartel_neon(Vector3(10.8, 1.1, 5.5), Vector3(0.14, 2.2, 0.14), rojo, Color("df263e"))

	_crear_caja("ModuloOeste", Vector3(-8.5, 0.9, -3.6), Vector3(3.0, 1.8, 2.3), metal_medio, true)
	_crear_caja("ModuloEste", Vector3(8.3, 1.1, 3.8), Vector3(3.2, 2.2, 2.6), metal_medio, true)
	_crear_caja("Pasarela", Vector3(-1.5, 0.12, -4.8), Vector3(7.5, 0.22, 2.0), _material(Color("202d35"), 0.85, 0.34), false)

	_crear_caja("Caja1", Vector3(-5.5, 0.45, 3.4), Vector3(1.0, 0.9, 1.0), metal_medio, true)
	_crear_caja("Caja2", Vector3(-4.4, 0.32, 3.7), Vector3(0.72, 0.64, 0.72), metal_oscuro, true)
	_crear_caja("Caja3", Vector3(5.2, 0.42, -2.7), Vector3(0.9, 0.84, 0.9), metal_medio, true)
	for x in [-5.5, 5.2]:
		_crear_caja("BandaCaja", Vector3(x, 0.46, 3.91 if x < 0 else -2.24), Vector3(0.78, 0.12, 0.025), rojo, false)

	_crear_charco(Vector3(-2.3, 0.012, 2.8), Vector2(3.3, 1.5), Color("1d5f72"))
	_crear_charco(Vector3(5.8, 0.014, 1.2), Vector2(2.2, 1.0), Color("5a184b"))
	_crear_desague(Vector3(1.6, 0.018, -1.8))
	_crear_vapor(Vector3(9.5, 0.1, -4.2))

	_crear_luz(Vector3(-5.8, 3.0, -5.8), Color("27e7f1"), 2.7, 7.0, true)
	_crear_luz(Vector3(6.2, 2.7, -5.7), Color("f22b91"), 2.8, 7.5, true, true)
	_crear_luz(Vector3(6.5, 1.5, 3.0), Color("2aa5ff"), 1.7, 5.0, false)


func _crear_jugador_y_camara() -> void:
	jugador = preload("res://scenes/diroka.tscn").instantiate()
	jugador.position = Vector3(0, 0.05, 3.0)
	add_child(jugador)
	var camara := CamaraIsometrica.new()
	add_child(camara)
	camara.configurar(jugador)


func _crear_terminal() -> void:
	terminal = TerminalPrueba.new()
	terminal.position = Vector3(3.0, 0.0, 0.8)
	terminal.rotation_degrees.y = -28.0
	add_child(terminal)
	terminal.configurar(jugador)


func _crear_interfaz() -> void:
	interfaz = InterfazJuego.new()
	add_child(interfaz)
	interfaz.configurar(jugador, terminal)


func _crear_rejilla_suelo() -> void:
	var linea := _material(Color(0.18, 0.28, 0.34, 0.28), 0.7, 0.5)
	linea.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	for x in range(-11, 12, 2):
		_crear_caja("JuntaX", Vector3(float(x), 0.004, 0), Vector3(0.018, 0.01, 14.6), linea, false)
	for z in range(-7, 8, 2):
		_crear_caja("JuntaZ", Vector3(0, 0.005, float(z)), Vector3(23.6, 0.01, 0.018), linea, false)


func _crear_tuberias() -> void:
	var tubo := _material(Color("3d4850"), 0.9, 0.28)
	for x in [-10.4, -9.9, 9.7]:
		var cilindro := _crear_cilindro(Vector3(x, 2.1, -7.25), 0.11, 3.8, tubo)
		cilindro.rotation_degrees.z = 0
	for y in [0.75, 1.05]:
		var horizontal := _crear_cilindro(Vector3(-8.0, y, 7.25), 0.09, 7.0, tubo)
		horizontal.rotation_degrees.z = 90.0


func _crear_cartel_neon(posicion: Vector3, tamano: Vector3, material: Material, color_luz: Color, vertical := false) -> void:
	var cartel := _crear_caja("Neon", posicion, tamano, material, false)
	if vertical:
		cartel.rotation_degrees.z = 90.0
	var luz := OmniLight3D.new()
	luz.position = posicion + Vector3(0, 0, 0.45)
	luz.light_color = color_luz
	luz.light_energy = 1.3
	luz.omni_range = 4.0
	luz.shadow_enabled = false
	add_child(luz)


func _crear_charco(posicion: Vector3, tamano: Vector2, color: Color) -> void:
	var material := StandardMaterial3D.new()
	material.albedo_color = Color(color.r, color.g, color.b, 0.38)
	material.metallic = 0.75
	material.roughness = 0.08
	material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	var plano := PlaneMesh.new()
	plano.size = tamano
	var nodo := MeshInstance3D.new()
	nodo.position = posicion
	nodo.mesh = plano
	nodo.material_override = material
	add_child(nodo)


func _crear_desague(posicion: Vector3) -> void:
	var negro := _material(Color("07090c"), 0.85, 0.42)
	_crear_caja("Desague", posicion, Vector3(2.1, 0.04, 0.72), negro, false)
	for i in range(9):
		_crear_caja("Ranura", posicion + Vector3(-0.88 + i * 0.22, 0.026, 0), Vector3(0.045, 0.025, 0.64), metal_medio, false)


func _crear_vapor(posicion: Vector3) -> void:
	var particulas := GPUParticles3D.new()
	particulas.position = posicion
	particulas.amount = 24
	particulas.lifetime = 2.6
	particulas.randomness = 0.65
	particulas.visibility_aabb = AABB(Vector3(-2, 0, -2), Vector3(4, 6, 4))
	var proceso := ParticleProcessMaterial.new()
	proceso.emission_shape = ParticleProcessMaterial.EMISSION_SHAPE_SPHERE
	proceso.emission_sphere_radius = 0.18
	proceso.direction = Vector3(0, 1, 0)
	proceso.spread = 17.0
	proceso.initial_velocity_min = 0.35
	proceso.initial_velocity_max = 0.75
	proceso.gravity = Vector3(0, 0.08, 0)
	proceso.scale_min = 0.5
	proceso.scale_max = 1.4
	proceso.color = Color(0.5, 0.7, 0.78, 0.22)
	particulas.process_material = proceso
	var quad := QuadMesh.new()
	quad.size = Vector2(0.42, 0.42)
	var humo := StandardMaterial3D.new()
	humo.albedo_color = Color(0.62, 0.76, 0.82, 0.18)
	humo.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	humo.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	humo.billboard_mode = BaseMaterial3D.BILLBOARD_ENABLED
	quad.material = humo
	particulas.draw_pass_1 = quad
	add_child(particulas)


func _crear_luz(posicion: Vector3, color: Color, energia: float, alcance: float, sombras: bool, parpadea := false) -> void:
	var luz := OmniLight3D.new()
	luz.position = posicion
	luz.light_color = color
	luz.light_energy = energia
	luz.omni_range = alcance
	luz.omni_attenuation = 1.35
	luz.shadow_enabled = sombras
	if parpadea:
		luz.set_script(preload("res://scripts/luz_parpadeante.gd"))
	add_child(luz)


func _crear_caja(nombre: String, posicion: Vector3, tamano: Vector3, material: Material, colision: bool) -> MeshInstance3D:
	var malla := BoxMesh.new()
	malla.size = tamano
	var nodo := MeshInstance3D.new()
	nodo.name = nombre
	nodo.position = posicion
	nodo.mesh = malla
	nodo.material_override = material
	add_child(nodo)
	if colision:
		var cuerpo := StaticBody3D.new()
		cuerpo.position = posicion
		var forma := CollisionShape3D.new()
		var caja := BoxShape3D.new()
		caja.size = tamano
		forma.shape = caja
		cuerpo.add_child(forma)
		add_child(cuerpo)
	return nodo


func _crear_cilindro(posicion: Vector3, radio: float, altura: float, material: Material) -> MeshInstance3D:
	var malla := CylinderMesh.new()
	malla.top_radius = radio
	malla.bottom_radius = radio
	malla.height = altura
	malla.radial_segments = 12
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


func _material_emisivo(color: Color, emision: Color, energia: float) -> StandardMaterial3D:
	var material := _material(color, 0.45, 0.3)
	material.emission_enabled = true
	material.emission = emision
	material.emission_energy_multiplier = energia
	return material


func _unhandled_input(evento: InputEvent) -> void:
	if evento.is_action_pressed("accion") and not interfaz.dialogo_abierto():
		interfaz.ejecutar_accion()
		get_viewport().set_input_as_handled()
	elif evento.is_action_pressed("menu"):
		get_tree().change_scene_to_file("res://scenes/inicio.tscn")
