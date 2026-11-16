class_name HitboxComponent
extends Area2D
## Zona que recibe daño. Reenvía los impactos al HealthComponent asignado.
##
## Las balas enemigas no son nodos (las gestiona BulletManager por distancia),
## así que el daño entra siempre por `hit()`, venga de un solapamiento o del gestor.

signal hit_received(amount: int)

@export var health: HealthComponent
## Radio usado por las comprobaciones por distancia (balas y graze).
@export var radius: float = 8.0


func hit(amount: int) -> void:
	hit_received.emit(amount)
	if health:
		health.take_damage(amount)
