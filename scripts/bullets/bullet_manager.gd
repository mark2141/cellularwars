class_name BulletManager
extends Node2D
## Mueve, dibuja y colisiona todos los proyectiles desde arrays (sin un nodo por bala).
##
## Trabaja en coordenadas del campo de juego: este nodo, el jugador y los enemigos
## deben ser hijos directos de Playfield para que `position` sea comparable.

enum Team { ENEMY, PLAYER }

const CULL_MARGIN := 32.0
## Largo de la estela de los disparos del jugador, que se dibujan como líneas.
const SHOT_LENGTH := 26.0

var player: Player
var field: Rect2

var _pos := PackedVector2Array()
var _vel := PackedVector2Array()
var _rad := PackedFloat32Array()
var _col := PackedColorArray()
var _team := PackedByteArray()
var _dmg := PackedInt32Array()


func _ready() -> void:
	# Mezcla aditiva: da el brillo bioluminiscente sin posprocesado.
	var mat := CanvasItemMaterial.new()
	mat.blend_mode = CanvasItemMaterial.BLEND_MODE_ADD
	material = mat


func spawn(pos: Vector2, vel: Vector2, radius: float, color: Color, team: Team, damage: int = 1) -> void:
	_pos.append(pos)
	_vel.append(vel)
	_rad.append(radius)
	_col.append(color)
	_team.append(team)
	_dmg.append(damage)


func count() -> int:
	return _pos.size()


## Borra todas las balas de un bando (lo usa el láser).
func clear(team: Team) -> void:
	for i in range(_pos.size() - 1, -1, -1):
		if _team[i] == team:
			_remove(i)
	queue_redraw()


func _physics_process(delta: float) -> void:
	if _pos.is_empty():
		return
	var bounds := field.grow(CULL_MARGIN)
	var enemies := get_tree().get_nodes_in_group(&"enemies")
	var target_ok := player != null and player.is_targetable()
	for i in range(_pos.size() - 1, -1, -1):
		var p := _pos[i] + _vel[i] * delta
		_pos[i] = p
		if not bounds.has_point(p):
			_remove(i)
		elif _team[i] == Team.ENEMY:
			if target_ok and _check_player(i, p):
				_remove(i)
				target_ok = player.is_targetable()
		elif _check_enemies(i, p, enemies):
			_remove(i)
	queue_redraw()


## Devuelve true si la bala impactó al jugador.
func _check_player(i: int, p: Vector2) -> bool:
	var hit_r := player.hitbox.radius + _rad[i]
	if p.distance_squared_to(player.position) <= hit_r * hit_r:
		player.hitbox.hit(_dmg[i])
		return true
	return false


func _check_enemies(i: int, p: Vector2, enemies: Array[Node]) -> bool:
	for e: Enemy in enemies:
		if e.health.is_dead():
			continue
		var r := e.hitbox.radius + _rad[i]
		if p.distance_squared_to(e.position) <= r * r:
			e.hitbox.hit(_dmg[i])
			return true
	return false


func _remove(i: int) -> void:
	var last := _pos.size() - 1
	if i != last:
		_pos[i] = _pos[last]
		_vel[i] = _vel[last]
		_rad[i] = _rad[last]
		_col[i] = _col[last]
		_team[i] = _team[last]
		_dmg[i] = _dmg[last]
	_pos.resize(last)
	_vel.resize(last)
	_rad.resize(last)
	_col.resize(last)
	_team.resize(last)
	_dmg.resize(last)


func _draw() -> void:
	# Dibujo provisional con círculos; se sustituirá por los proyectiles en SVG.
	for i in _pos.size():
		var c := _col[i]
		if _team[i] == Team.PLAYER:
			var tail := _pos[i] - _vel[i].normalized() * SHOT_LENGTH
			draw_line(_pos[i], tail, Color(c, 0.35), _rad[i] * 2.2)
			draw_line(_pos[i], tail, c, _rad[i])
			draw_line(_pos[i], tail, Color.WHITE, _rad[i] * 0.35)
			continue
		draw_circle(_pos[i], _rad[i] * 1.8, Color(c, 0.3))
		draw_circle(_pos[i], _rad[i], c)
		draw_circle(_pos[i], _rad[i] * 0.45, Color.WHITE)
