class_name WeaponComponent
extends Node2D
## Cadencia de disparo. No crea balas: emite `fired` y quien lo escucha
## (jugador, enemigo o jefe) pide los proyectiles al BulletManager.

signal fired(origin: Vector2)

## Segundos entre disparos. El valor real se inyecta desde un recurso .tres.
@export var interval: float = 0.2
@export var active: bool = false

var _cooldown: float = 0.0


func _physics_process(delta: float) -> void:
	if _cooldown > 0.0:
		_cooldown -= delta
	if active and interval > 0.0 and _cooldown <= 0.0:
		# Se suma el intervalo (no se reinicia) para que la cadencia no derive con los fotogramas.
		_cooldown += interval
		fired.emit(global_position)
	elif not active:
		_cooldown = max(_cooldown, 0.0)
