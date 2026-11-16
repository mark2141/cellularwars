class_name Playfield
extends Node2D
## Campo de juego de tamaño fijo, centrado en la ventana.
##
## Con estirado `canvas_items` + aspecto `expand`, la ventana crece a lo ancho
## (escritorio) o a lo alto (móvil) y el espacio sobrante queda para el HUD.
## Todo lo jugable cuelga de este nodo y usa coordenadas de 0,0 a `size`.

signal layout_changed(field_rect: Rect2, viewport_size: Vector2)

var size: Vector2


func _ready() -> void:
	size = Vector2(
		ProjectSettings.get_setting("display/window/size/viewport_width"),
		ProjectSettings.get_setting("display/window/size/viewport_height"),
	)
	get_viewport().size_changed.connect(_update_layout)
	_update_layout()


func rect() -> Rect2:
	return Rect2(Vector2.ZERO, size)


func _update_layout() -> void:
	var view := get_viewport_rect().size
	position = ((view - size) * 0.5).floor()
	layout_changed.emit(Rect2(position, size), view)
	queue_redraw()


func _draw() -> void:
	# Marcador provisional del campo hasta que existan los fondos.
	draw_rect(rect(), Color(0.10, 0.02, 0.06))
	draw_rect(rect(), Color(0.45, 0.10, 0.20), false, 2.0)
