class_name Player
extends Node2D
## Nave del jugador: movimiento, Focus, escudos, graze y disparo.
##
## Los escudos son la vida: HealthComponent guarda escudos + 1, porque con
## 0 escudos la nave aún aguanta hasta el siguiente impacto.

signal shields_changed(shields: int, max_shields: int)
signal graze_changed(value: float, max_value: float)
signal ability_used
signal defeated

## Margen para que la nave no salga a medias del campo.
const EDGE_MARGIN := 16.0

@export var data: PlayerData

var bullets: BulletManager
var field: Rect2
var graze: float = 0.0
var focusing: bool = false

var _invuln_left: float = 0.0
var _touching: bool = false

@onready var health: HealthComponent = $HealthComponent
@onready var hitbox: HitboxComponent = $HitboxComponent
@onready var weapon: WeaponComponent = $WeaponComponent


func _ready() -> void:
	health.reset(data.max_shields + 1, data.start_shields + 1)
	hitbox.radius = data.hitbox_radius
	weapon.interval = data.fire_interval
	health.damaged.connect(_on_damaged)
	health.died.connect(_on_died)
	weapon.fired.connect(_on_fired)


func is_targetable() -> bool:
	return not health.is_dead() and not health.invulnerable


func shields() -> int:
	return max(health.hp - 1, 0)


## Devuelve false si ya estaba al máximo (el drop se recoge igual).
func add_shield() -> bool:
	if health.is_dead() or health.hp >= health.max_hp:
		return false
	health.heal(1)
	shields_changed.emit(shields(), data.max_shields)
	return true


func add_graze() -> void:
	if graze >= data.graze_max:
		return
	graze = min(graze + data.graze_gain, data.graze_max)
	graze_changed.emit(graze, data.graze_max)


func _physics_process(delta: float) -> void:
	focusing = Input.is_action_pressed(&"focus")
	var dir := Input.get_vector(&"move_left", &"move_right", &"move_up", &"move_down")
	_move(dir * (data.focus_speed if focusing else data.speed) * delta)
	weapon.active = Input.is_action_pressed(&"shoot") or _touching

	if Input.is_action_just_pressed(&"ability") and graze >= data.graze_max:
		graze = 0.0
		graze_changed.emit(graze, data.graze_max)
		ability_used.emit()

	if _invuln_left > 0.0:
		_invuln_left -= delta
		if _invuln_left <= 0.0:
			health.invulnerable = false
		# Parpadeo mientras dura la invulnerabilidad.
		modulate.a = 1.0 if _invuln_left <= 0.0 or fmod(_invuln_left, 0.2) < 0.1 else 0.3
	queue_redraw()


func _unhandled_input(event: InputEvent) -> void:
	# Táctil: arrastre relativo con el primer dedo; dispara mientras se toca.
	if event is InputEventScreenTouch and event.index == 0:
		_touching = event.pressed
	elif event is InputEventScreenDrag and event.index == 0 and not health.is_dead():
		_move(event.relative * data.touch_sensitivity)


func _move(offset: Vector2) -> void:
	var area := field.grow(-EDGE_MARGIN)
	position = (position + offset).clamp(area.position, area.end)


func _on_damaged(_amount: int, current: int) -> void:
	shields_changed.emit(shields(), data.max_shields)
	if current > 0:
		health.invulnerable = true
		_invuln_left = data.invuln_time


func _on_died() -> void:
	weapon.active = false
	set_physics_process(false)
	hide()
	defeated.emit()


func _on_fired(_origin: Vector2) -> void:
	if bullets == null:
		return
	for side: float in [-1.0, 1.0]:
		bullets.spawn(position + Vector2(side * data.shot_offset, -18.0),
				Vector2(0.0, -data.shot_speed), data.shot_radius, data.shot_color,
				BulletManager.Team.PLAYER, data.shot_damage)


func _draw() -> void:
	# Forma provisional hasta tener el sprite del nanobot.
	draw_colored_polygon(
		PackedVector2Array([Vector2(0, -22), Vector2(16, 16), Vector2(0, 8), Vector2(-16, 16)]),
		Color(0.75, 0.9, 1.0))
	# Anillo provisional: más opaco cuantos más escudos quedan.
	if shields() > 0:
		draw_arc(Vector2.ZERO, 26.0, 0.0, TAU, 40,
				Color(0.4, 0.8, 1.0, 0.25 + 0.15 * shields()), 2.0)
	if focusing:
		draw_arc(Vector2.ZERO, data.graze_radius, 0.0, TAU, 40, Color(0.4, 1.0, 0.9, 0.5), 1.5)
		draw_circle(Vector2.ZERO, data.hitbox_radius + 1.5, Color(1.0, 0.2, 0.3))
		draw_circle(Vector2.ZERO, data.hitbox_radius, Color.WHITE)
