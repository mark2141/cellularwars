class_name Pickup
extends Node2D
## Drop que suelta un enemigo. Cae y se recoge al tocarlo con la nave.
## Debe ser hijo directo de Playfield, como el jugador.

enum Kind { SHIELD, STAR, WEAPON }

@export var kind: Kind = Kind.SHIELD
@export var fall_speed: float = 110.0
@export var radius: float = 12.0

var player: Player
var field: Rect2
## Solo para Kind.WEAPON: el arma que da al recogerlo.
var weapon: WeaponData

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
		Kind.WEAPON:
			player.set_weapon(weapon)


func _draw() -> void:
	# Formas provisionales con pulso.
	var size := radius * (1.0 + 0.12 * sin(_time * 6.0))
	match kind:
		Kind.WEAPON:
			_draw_weapon_box(size)
		Kind.STAR:
			var points := PackedVector2Array()
			for i in 10:
				var r := size * (1.25 if i % 2 == 0 else 0.55)
				points.append(Vector2.from_angle(TAU * i / 10.0 - PI * 0.5) * r)
			_draw_outlined(points, Color(1.0, 0.85, 0.25, 0.95))
		_:
			var points := PackedVector2Array()
			for i in 6:
				points.append(Vector2.from_angle(TAU * i / 6.0 - PI * 0.5) * size)
			_draw_outlined(points, Color(0.3, 0.75, 1.0, 0.85))


func _draw_outlined(points: PackedVector2Array, color: Color) -> void:
	draw_colored_polygon(points, color)
	points.append(points[0])
	draw_polyline(points, Color.WHITE, 2.0)


## Caja con la letra del arma, para que el jugador sepa qué va a recoger.
func _draw_weapon_box(size: float) -> void:
	var box := Rect2(Vector2(-size, -size), Vector2(size, size) * 2.0)
	draw_rect(box, Color(weapon.color, 0.9))
	draw_rect(box, Color.WHITE, false, 2.0)
	var font := ThemeDB.fallback_font
	var font_size := int(size * 1.5)
	var text_size := font.get_string_size(weapon.letter, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size)
	draw_string(font, Vector2(-text_size.x * 0.5, font_size * 0.36), weapon.letter,
			HORIZONTAL_ALIGNMENT_LEFT, -1, font_size, Color(0.05, 0.03, 0.08))
