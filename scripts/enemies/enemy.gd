class_name Enemy
extends Node2D
## Enemigo genérico. Todo lo que lo distingue llega por `setup()` desde recursos.
##
## Su posición es `anchor` más el desplazamiento de su MovementPattern. El ancla
## avanza con `velocity`, o la mueve una Formation si el enemigo va en formación.

signal defeated(enemy: Enemy)

## Distancia fuera del campo (abajo o a los lados) a la que se da por perdido.
const EXIT_MARGIN := 160.0

var data: EnemyData
var tier: TierData
var bullets: BulletManager
var player: Player
var field: Rect2

var anchor: Vector2
var velocity: Vector2 = Vector2.ZERO
var in_formation: bool = false
var can_shoot: bool = true

var _pattern: BulletPattern
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
	anchor = position
	health.reset(roundi(data.max_hp * tier.hp_mult))
	hitbox.radius = data.radius
	health.died.connect(_on_died)
	weapon.fired.connect(_on_fired)
	_pattern = data.pattern_for(tier.rank)
	if _pattern and can_shoot:
		weapon.interval = _pattern.interval
		# Desfase aleatorio para que un grupo no dispare todo a la vez.
		weapon.delay(randf() * _pattern.interval)
		weapon.active = true


func _physics_process(delta: float) -> void:
	_time += delta
	if in_formation:
		position = anchor
	else:
		anchor += velocity * tier.speed_mult * delta
		position = anchor + (data.movement.offset_at(_time) if data.movement else Vector2.ZERO)

	if position.y > field.end.y + EXIT_MARGIN or position.x < field.position.x - EXIT_MARGIN \
			or position.x > field.end.x + EXIT_MARGIN:
		queue_free()
	elif player and player.is_targetable():
		# Chocar con el cuerpo del enemigo quita un escudo; el enemigo sigue vivo.
		var reach := data.radius + player.hitbox.radius
		if position.distance_squared_to(player.position) <= reach * reach:
			player.hitbox.hit(data.contact_damage)


func _on_fired(_origin: Vector2) -> void:
	# No dispara hasta haber entrado en el campo.
	if bullets == null or not field.has_point(position):
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
