extends Node
## Escena de pruebas provisional: conecta jugador, balas y una fila de enemigos.
## Se sustituirá por Level.tscn con oleadas definidas en recursos.

const ENEMY_SCENE := preload("res://scenes/enemies/enemy.tscn")
const SHIELD_PICKUP := preload("res://scenes/pickups/shield_pickup.tscn")
const STAR_PICKUP := preload("res://scenes/pickups/star_pickup.tscn")
const TEST_ENEMY: EnemyData = preload("res://resources/enemies/bacteriofago_menor.tres")
const TEST_TIER: TierData = preload("res://resources/tiers/regular.tres")
const RESTART_DELAY := 1.5

## True mientras el láser elimina enemigos: esas bajas no sueltan drops.
var _laser_sweep: bool = false

@onready var playfield: Playfield = $Playfield
@onready var bullets: BulletManager = $Playfield/BulletManager
@onready var player: Player = $Playfield/Player
@onready var status: Label = $HUD/Status


func _ready() -> void:
	var field := playfield.rect()
	bullets.field = field
	bullets.player = player
	player.bullets = bullets
	player.field = field
	player.position = Vector2(field.size.x * 0.5, field.size.y - 180.0)
	player.shields_changed.connect(func(_s: int, _m: int) -> void: _update_status())
	player.stars_changed.connect(func(_s: int, _n: int) -> void: _update_status())
	player.laser_fired.connect(_on_laser_fired)
	player.defeated.connect(_on_player_defeated)
	_update_status()
	_spawn_test_row()


func _spawn_test_row() -> void:
	var field := playfield.rect()
	for i in 5:
		var enemy: Enemy = ENEMY_SCENE.instantiate()
		enemy.setup(TEST_ENEMY, TEST_TIER)
		enemy.bullets = bullets
		enemy.player = player
		enemy.field = field
		enemy.position = Vector2(field.size.x * (i + 1) / 6.0, 220.0)
		enemy.defeated.connect(_on_enemy_defeated)
		playfield.add_child(enemy)


func _on_enemy_defeated(enemy: Enemy) -> void:
	if not _laser_sweep:
		_roll_drop(enemy)
	# El enemigo ya salió del grupo al morir: si no queda ninguno, nueva fila.
	if get_tree().get_nodes_in_group(&"enemies").is_empty():
		_spawn_test_row.call_deferred()


## Como mucho un drop por enemigo: primero se sortea el escudo y después la estrella.
func _roll_drop(enemy: Enemy) -> void:
	var roll := randf()
	var scene: PackedScene = null
	if roll < enemy.data.shield_drop_chance:
		scene = SHIELD_PICKUP
	elif roll < enemy.data.shield_drop_chance + enemy.data.star_drop_chance:
		scene = STAR_PICKUP
	if scene == null:
		return
	var pickup: Pickup = scene.instantiate()
	pickup.player = player
	pickup.field = playfield.rect()
	pickup.position = enemy.position
	playfield.add_child.call_deferred(pickup)


## El láser limpia el escenario: todas las balas enemigas y todos los enemigos.
func _on_laser_fired() -> void:
	bullets.clear(BulletManager.Team.ENEMY)
	_laser_sweep = true
	for enemy: Enemy in get_tree().get_nodes_in_group(&"enemies"):
		enemy.health.take_damage(enemy.health.hp)
	_laser_sweep = false
	var beam := LaserBeam.new()
	beam.field = playfield.rect()
	beam.duration = player.data.laser_duration
	beam.position = player.position
	beam.z_index = 2
	playfield.add_child(beam)


func _on_player_defeated() -> void:
	await get_tree().create_timer(RESTART_DELAY).timeout
	get_tree().reload_current_scene()


func _update_status() -> void:
	status.text = "Escudos: %d/%d   Estrellas: %d/%d" % [
		player.shields(), player.data.max_shields, player.stars, player.data.stars_for_laser]
