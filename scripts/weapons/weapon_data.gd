class_name WeaponData
extends Resource
## Arma del jugador. Hay un .tres por arma. Las mejoras caen como drop en una caja
## con su letra (estilo Contra / Metal Slug) para que el jugador sepa qué recoge.

@export var display_name: String = ""
## Letra de la caja del drop y del HUD. El arma base no la necesita.
@export var letter: String = ""
## Color de la caja y de los disparos.
@export var color: Color = Color(0.5, 0.85, 1.0)
## Segundos entre ráfagas.
@export var fire_interval: float = 0.1
@export var shot_speed: float = 900.0
## Radio de colisión del disparo (se dibuja como una línea).
@export var shot_radius: float = 4.0
@export var shot_damage: int = 1
## Disparos por ráfaga.
@export var shot_count: int = 1
## Separación horizontal entre disparos paralelos.
@export var shot_spacing: float = 20.0
## Apertura total en grados (0 = todos rectos hacia arriba).
@export var spread_degrees: float = 0.0


func fire(bullets: BulletManager, origin: Vector2) -> void:
	for i in shot_count:
		var t := 0.0 if shot_count == 1 else float(i) / (shot_count - 1) - 0.5
		var angle := -PI * 0.5 + deg_to_rad(spread_degrees) * t
		bullets.spawn(origin + Vector2(t * (shot_count - 1) * shot_spacing, 0.0),
				Vector2.from_angle(angle) * shot_speed, shot_radius, color,
				BulletManager.Team.PLAYER, shot_damage)
