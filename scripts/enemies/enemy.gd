class_name Enemy
extends Node2D
## Enemigo genérico. Todo lo que lo distingue llega por `setup()` desde recursos.

signal defeated(enemy: Enemy)

var data: EnemyData
var tier: TierData
var bullets: BulletManager
var player: Player
var field: Rect2

var _pattern: BulletPattern
var _origin_x: float
var _time: float = 0.0

@onready var health: HealthComponent = $HealthComponent
@onready var hitbox: HitboxComponent = $HitboxComponent
@onready var weapon: WeaponComponent = $WeaponComponent


## Llamar antes de añadir el enemigo al árbol.
func setup(enemy_data: EnemyData, tier_data: TierData) -> void:
	data = enemy_data
	tier = tier_data


func _ready() -> void:
	add_to_group(&"enemies")
	_origin_x = position.x
	health.reset(roundi(data.max_hp * tier.hp_mult))
	hitbox.radius = data.radius
	health.died.connect(_on_died)
	weapon.fired.connect(_on_fired)
	_pattern = data.pattern_for(tier.rank)
	if _pattern:
		weapon.interval = _pattern.interval
		weapon.active = true


func _physics_process(delta: float) -> void:
	_time += delta
	position.x = _origin_x + sin(_time * data.sway_frequency * TAU) * data.sway_amplitude
	position.y += data.speed * tier.speed_mult * delta
	if position.y > field.end.y + data.radius * 2.0:
		queue_free()


func _on_fired(_origin: Vector2) -> void:
	if bullets == null:
		return
	var target := player.position if player else position + Vector2.DOWN
	_pattern.emit(bullets, position, target)


func _on_died() -> void:
	remove_from_group(&"enemies")
	defeated.emit(self)
	queue_free()


func _draw() -> void:
	# Forma provisional hasta tener sprites y el shader de paleta.
	var c := data.color * tier.tint
	if tier.glow_strength > 0.0:
		draw_circle(Vector2.ZERO, data.radius * 1.5, Color(c, 0.25 * tier.glow_strength))
	draw_circle(Vector2.ZERO, data.radius, c)
	draw_circle(Vector2.ZERO, data.radius * 0.4, c.darkened(0.5))
