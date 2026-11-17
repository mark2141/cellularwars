class_name LaserBeam
extends Node2D
## Efecto visual del láser gigante. La limpieza del escenario la hace quien lo crea;
## este nodo solo dibuja el rayo y un destello, y se borra al terminar.

const BEAM_WIDTH := 220.0

var field: Rect2
var duration: float = 0.7
var _time: float = 0.0


func _ready() -> void:
	var mat := CanvasItemMaterial.new()
	mat.blend_mode = CanvasItemMaterial.BLEND_MODE_ADD
	material = mat


func _physics_process(delta: float) -> void:
	_time += delta
	if _time >= duration:
		queue_free()
	queue_redraw()


func _draw() -> void:
	var fade := 1.0 - clampf(_time / duration, 0.0, 1.0)
	# Destello sobre todo el campo y rayo desde la nave hasta arriba.
	draw_rect(Rect2(field.position - position, field.size), Color(0.6, 0.9, 1.0, 0.35 * fade * fade))
	var top := field.position.y - position.y
	for layer: Array in [[1.0, 0.25], [0.6, 0.5], [0.25, 1.0]]:
		var w: float = BEAM_WIDTH * layer[0] * (0.4 + 0.6 * fade)
		draw_rect(Rect2(-w * 0.5, top, w, -top), Color(0.7, 0.95, 1.0, layer[1] * fade))
