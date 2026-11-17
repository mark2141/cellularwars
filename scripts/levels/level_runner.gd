class_name LevelRunner
extends Node
## Reproduce las oleadas de un LevelData según el tiempo de nivel.

signal enemy_spawned(enemy: Enemy)
## Ya no quedan oleadas por lanzar ni enemigos en pantalla.
signal waves_finished

const ENEMY_SCENE := preload("res://scenes/enemies/enemy.tscn")

@export var level: LevelData
## Si el campo queda vacío, salta la espera hasta la siguiente oleada.
@export var advance_when_clear: bool = true
## Segundos de respiro entre limpiar el campo y la siguiente oleada.
@export var clear_delay: float = 1.2
## Solo para pruebas: empieza el nivel en este segundo, saltándose lo anterior.
@export var debug_start_time: float = 0.0

var playfield: Playfield
var bullets: BulletManager
var player: Player
var time: float = 0.0

var _events: Array[WaveEvent] = []
var _next: int = 0
## Filas en curso: cada entrada es [evento, índice del siguiente enemigo, segundo en que sale].
var _streams: Array[Array] = []
var _finished: bool = false


func _ready() -> void:
	_events = level.events.duplicate()
	_events.sort_custom(func(a: WaveEvent, b: WaveEvent) -> bool: return a.time < b.time)
	time = debug_start_time
	while _next < _events.size() and _events[_next].time < time:
		_next += 1


func _physics_process(delta: float) -> void:
	time += delta
	while _next < _events.size() and _events[_next].time <= time:
		_start(_events[_next])
		_next += 1

	for i in range(_streams.size() - 1, -1, -1):
		var stream := _streams[i]
		var event: WaveEvent = stream[0]
		while stream[1] < event.count and stream[2] <= time:
			_spawn(event, event.position + event.step * stream[1])
			stream[1] += 1
			stream[2] += event.spawn_interval
		if stream[1] >= event.count:
			_streams.remove_at(i)

	var field_clear := _streams.is_empty() and get_tree().get_nodes_in_group(&"enemies").is_empty()
	if advance_when_clear and field_clear and _next < _events.size():
		time = max(time, _events[_next].time - clear_delay)

	if not _finished and _next >= _events.size() and field_clear:
		_finished = true
		waves_finished.emit()


func _start(event: WaveEvent) -> void:
	if event.formation:
		var formation := Formation.new()
		formation.setup(event.formation, playfield.rect(), event.position)
		add_child(formation)
		for slot in event.formation.slot_count():
			formation.add(_spawn(event, Vector2.ZERO, false), slot)
	elif event.spawn_interval <= 0.0:
		for i in event.count:
			_spawn(event, event.position + event.step * i)
	else:
		_streams.append([event, 0, event.time])


func _spawn(event: WaveEvent, at: Vector2, free_moving: bool = true) -> Enemy:
	var enemy: Enemy = ENEMY_SCENE.instantiate()
	enemy.setup(event.enemy, event.tier)
	enemy.bullets = bullets
	enemy.player = player
	enemy.field = playfield.rect()
	enemy.can_shoot = event.can_shoot
	enemy.position = at
	if free_moving:
		enemy.velocity = event.direction.normalized() * event.enemy.speed
	playfield.add_child(enemy)
	enemy_spawned.emit(enemy)
	return enemy
