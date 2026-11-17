class_name Formation
extends Node
## Mueve las anclas de un grupo de enemigos según un FormationData.
## No es un Node2D a propósito: los enemigos siguen siendo hijos directos de Playfield.

var data: FormationData
var field: Rect2
## Centro de la formación al terminar la entrada.
var target: Vector2

var _origin: Vector2
var _slots: Dictionary[Enemy, Vector2] = {}
var _direction: float = 1.0
var _arrived: bool = false
var _age: float = 0.0


func setup(formation_data: FormationData, field_rect: Rect2, center: Vector2) -> void:
	data = formation_data
	field = field_rect
	target = center
	_origin = Vector2(center.x, field.position.y - data.half_size().y - 60.0)


func add(enemy: Enemy, slot: int) -> void:
	enemy.in_formation = true
	enemy.position = _origin + data.slot_offset(slot)
	_slots[enemy] = data.slot_offset(slot)


func _physics_process(delta: float) -> void:
	for enemy: Enemy in _slots.keys():
		if not is_instance_valid(enemy) or enemy.is_queued_for_deletion():
			_slots.erase(enemy)
	if _slots.is_empty():
		queue_free()
		return

	if not _arrived:
		_origin.y = move_toward(_origin.y, target.y, data.enter_speed * delta)
		_arrived = is_equal_approx(_origin.y, target.y)
	elif data.lifetime > 0.0 and _age >= data.lifetime:
		_origin.y += data.enter_speed * delta
	else:
		_age += delta
		_origin.x += _direction * data.sweep_speed * delta
		_origin.y += data.descend_speed * delta
		var reach := data.half_size().x + data.edge_margin
		if _origin.x + reach > field.end.x or _origin.x - reach < field.position.x:
			_origin.x = clampf(_origin.x, field.position.x + reach, field.end.x - reach)
			_direction = -_direction
			_origin.y += data.step_down

	for enemy: Enemy in _slots:
		enemy.anchor = _origin + _slots[enemy]
