class_name TerminalPrueba
extends Node2D

signal proximidad_cambiada(cerca: bool)
signal dialogo_solicitado(ruta: String)

const RADIO_INTERACCION := 45.0

var jugador: CharacterBody2D
var jugador_cerca := false


func configurar(nuevo_jugador: CharacterBody2D) -> void:
	jugador = nuevo_jugador


func _process(_delta: float) -> void:
	if jugador == null:
		return
	var cerca := global_position.distance_to(jugador.global_position) <= RADIO_INTERACCION
	if cerca != jugador_cerca:
		jugador_cerca = cerca
		proximidad_cambiada.emit(cerca)


func interactuar() -> bool:
	if not jugador_cerca:
		return false
	dialogo_solicitado.emit("res://data/dialogos/prueba.json")
	return true


func _draw() -> void:
	draw_rect(Rect2(-9, -15, 18, 30), Color("171a22"), true)
	draw_rect(Rect2(-7, -12, 14, 11), Color("173944"), true)
	draw_rect(Rect2(-7, -12, 14, 11), Color("42e5e8"), false, 1.0)
	draw_circle(Vector2(0, 8), 2.0, Color("ee2d91"))

