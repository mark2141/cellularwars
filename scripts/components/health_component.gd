class_name HealthComponent
extends Node
## Vida compartida por jugador, enemigos y jefes.

signal damaged(amount: int, current: int)
signal healed(amount: int, current: int)
signal died

@export var max_hp: int = 1
@export var invulnerable: bool = false

var hp: int


func _ready() -> void:
	hp = max_hp


## Reinicia la vida con un máximo nuevo (lo usa `setup()` al inyectar datos de un recurso).
func reset(new_max_hp: int) -> void:
	max_hp = max(new_max_hp, 1)
	hp = max_hp


func is_dead() -> bool:
	return hp <= 0


func take_damage(amount: int) -> void:
	if invulnerable or is_dead() or amount <= 0:
		return
	hp = max(hp - amount, 0)
	damaged.emit(amount, hp)
	if hp == 0:
		died.emit()


func heal(amount: int) -> void:
	if is_dead() or amount <= 0:
		return
	var before := hp
	hp = min(hp + amount, max_hp)
	if hp != before:
		healed.emit(hp - before, hp)
