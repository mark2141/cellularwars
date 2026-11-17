class_name Pickup
extends Node2D
## Drop que suelta un enemigo. Cae y se recoge al tocarlo con la nave.
## Debe ser hijo directo de Playfield, como el jugador.

enum Kind { SHIELD, STAR }

@export var kind: Kind = Kind.SHIELD
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
			_collect()
			queue_free()
	queue_redraw()


func _collect() -> void:
	match kind:
		Kind.SHIELD:
			player.add_shield()
		Kind.STAR:
			player.add_star()


func _draw() -> void:
	# Formas provisionales con pulso: hexágono azul (escudo) o estrella amarilla.
	var size := radius * (1.0 + 0.12 * sin(_time * 6.0))
	var points := PackedVector2Array()
	var color := Color(0.3, 0.75, 1.0, 0.85)
	if kind == Kind.STAR:
		color = Color(1.0, 0.85, 0.25, 0.95)
		for i in 10:
			var r := size * (1.25 if i % 2 == 0 else 0.55)
			points.append(Vector2.from_angle(TAU * i / 10.0 - PI * 0.5) * r)
	else:
		for i in 6:
			points.append(Vector2.from_angle(TAU * i / 6.0 - PI * 0.5) * size)
	draw_colored_polygon(points, color)
	points.append(points[0])
	draw_polyline(points, Color.WHITE, 2.0)
