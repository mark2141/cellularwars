extends Node
## Escena del nivel: conecta jugador, balas, oleadas, drops, láser y el HUD provisional.

const SHIELD_PICKUP := preload("res://scenes/pickups/shield_pickup.tscn")
const STAR_PICKUP := preload("res://scenes/pickups/star_pickup.tscn")
const RESTART_DELAY := 1.5

## True mientras el láser elimina enemigos: esas bajas no sueltan drops.
var _laser_sweep: bool = false

@onready var playfield: Playfield = $Playfield
@onready var bullets: BulletManager = $Playfield/BulletManager
@onready var player: Player = $Playfield/Player
@onready var runner: LevelRunner = $LevelRunner
@onready var status: Label = $HUD/Status
@onready var message: Label = $HUD/Message


func _ready() -> void:
	var field := playfield.rect()
	bullets.field = field
	bullets.player = player
	player.bullets = bullets
	player.field = field
	player.position = Vector2(field.size.x * 0.5, field.size.y - 180.0)
	player.laser_fired.connect(_on_laser_fired)
	player.defeated.connect(_on_player_defeated)
	runner.playfield = playfield
	runner.bullets = bullets
	runner.player = player
	runner.enemy_spawned.connect(func(enemy: Enemy) -> void: enemy.defeated.connect(_on_enemy_defeated))
	runner.waves_finished.connect(_on_waves_finished)
	message.hide()


func _process(_delta: float) -> void:
	var seconds := int(runner.time)
	status.text = "Escudos: %d/%d   Estrellas: %d/%d   %d:%02d" % [
		player.shields(), player.data.max_shields, player.stars, player.data.stars_for_laser,
		seconds / 60, seconds % 60]


func _on_enemy_defeated(enemy: Enemy) -> void:
	if not _laser_sweep:
		_roll_drop(enemy)


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


## Provisional: aquí entrará el jefe.
func _on_waves_finished() -> void:
	message.text = "Oleadas completadas\nJefe pendiente"
	message.show()


func _on_player_defeated() -> void:
	await get_tree().create_timer(RESTART_DELAY).timeout
	get_tree().reload_current_scene()
