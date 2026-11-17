class_name ShieldPickup
extends Node2D
## Escudo que suelta un enemigo. Cae y se recoge al tocarlo con la nave.
## Debe ser hijo directo de Playfield, como el jugador.

@export var fall_speed: float = 110.0
@export var radius: float = 12.0

var player: Player
var field: Rect2

var _time: float = 0.0


func _physics_process(delta: float) -> void:
	_time += delta
	position.y += fall_speed * delta
	if position.y > field.end.y + radius * 2.0:
		queue_free()
	elif player and not player.health.is_dead():
		var reach := radius + player.data.pickup_radius
		if position.distance_squared_to(player.position) <= reach * reach:
			player.add_shield()
			queue_free()
	queue_redraw()


func _draw() -> void:
	# Forma provisional: hexágono con pulso.
	var pulse := 1.0 + 0.12 * sin(_time * 6.0)
	var points := PackedVector2Array()
	for i in 6:
		points.append(Vector2.from_angle(TAU * i / 6.0 - PI * 0.5) * radius * pulse)
	draw_colored_polygon(points, Color(0.3, 0.75, 1.0, 0.85))
	points.append(points[0])
	draw_polyline(points, Color.WHITE, 2.0)
