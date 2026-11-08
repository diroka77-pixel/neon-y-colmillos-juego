extends OmniLight3D

@export var energia_minima := 1.2

var tiempo := 0.0
var energia_base := 2.0


func _ready() -> void:
	energia_base = light_energy


func _process(delta: float) -> void:
	tiempo += delta
	var pulso := sin(tiempo * 11.0) * 0.24 + sin(tiempo * 27.0) * 0.13
	light_energy = maxf(energia_minima, energia_base + pulso)
