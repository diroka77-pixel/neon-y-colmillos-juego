class_name DataLoader
extends RefCounted


static func cargar_json(ruta: String) -> Variant:
	if not FileAccess.file_exists(ruta):
		push_error("No existe el archivo JSON: %s" % ruta)
		return null

	var archivo := FileAccess.open(ruta, FileAccess.READ)
	if archivo == null:
		push_error("No se pudo abrir el archivo JSON: %s" % ruta)
		return null

	var resultado: Variant = JSON.parse_string(archivo.get_as_text())
	if resultado == null:
		push_error("JSON no válido: %s" % ruta)
	return resultado


static func cargar_textos() -> Dictionary:
	var datos: Variant = cargar_json("res://data/ui.json")
	return datos if datos is Dictionary else {}

