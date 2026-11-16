extends Node
## Escena de pruebas provisional: conecta jugador, balas y una fila de enemigos.
## Se sustituirá por Level.tscn con oleadas definidas en recursos.

const ENEMY_SCENE := preload("res://scenes/enemies/enemy.tscn")
const TEST_ENEMY: EnemyData = preload("res://resources/enemies/bacteriofago_menor.tres")
const TEST_TIER: TierData = preload("res://resources/tiers/regular.tres")
const RESTART_DELAY := 1.5

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
	player.lives_changed.connect(func(_l: int) -> void: _update_status())
	player.graze_changed.connect(func(_v: float, _m: float) -> void: _update_status())
	player.ability_used.connect(_on_ability_used)
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


func _on_enemy_defeated(_enemy: Enemy) -> void:
	# El enemigo ya salió del grupo al morir: si no queda ninguno, nueva fila.
	if get_tree().get_nodes_in_group(&"enemies").is_empty():
		_spawn_test_row.call_deferred()


## Provisional: la habilidad del graze es una bomba que limpia las balas enemigas.
func _on_ability_used() -> void:
	bullets.clear(BulletManager.Team.ENEMY)


func _on_player_defeated() -> void:
	await get_tree().create_timer(RESTART_DELAY).timeout
	get_tree().reload_current_scene()


func _update_status() -> void:
	status.text = "Vidas: %d   Graze: %d/%d" % [player.health.hp, player.graze, player.data.graze_max]
