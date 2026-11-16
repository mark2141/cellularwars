class_name BulletPattern
extends Resource
## Patrón de disparo reutilizable por enemigos y jefes.

enum Kind { FAN, RING }

@export var kind: Kind = Kind.FAN
## Segundos entre emisiones.
@export var interval: float = 2.0
@export var count: int = 1
## Apertura total del abanico en grados (no se usa en RING).
@export var spread_degrees: float = 0.0
@export var speed: float = 160.0
@export var bullet_radius: float = 6.0
@export var damage: int = 1
@export var color: Color = Color(0.4, 1.0, 0.7)
## Si es true apunta al objetivo; si no, dispara hacia abajo.
@export var aimed: bool = false


func emit(bullets: BulletManager, origin: Vector2, target: Vector2) -> void:
	var base := PI * 0.5
	if aimed and not target.is_equal_approx(origin):
		base = (target - origin).angle()
	for i in count:
		var angle := base
		if kind == Kind.RING:
			angle += TAU * i / count
		elif count > 1:
			angle += deg_to_rad(spread_degrees) * (float(i) / (count - 1) - 0.5)
		bullets.spawn(origin, Vector2.from_angle(angle) * speed, bullet_radius, color,
				BulletManager.Team.ENEMY, damage)
