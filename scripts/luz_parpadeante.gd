extends PointLight2D

@export var energia_minima := 0.55

var tiempo := 0.0
var energia_base := 1.0


func _ready() -> void:
	energia_base = energy


func _process(delta: float) -> void:
	tiempo += delta
	var pulso := sin(tiempo * 12.0) * 0.12 + sin(tiempo * 31.0) * 0.07
	energy = maxf(energia_minima, energia_base + pulso)

