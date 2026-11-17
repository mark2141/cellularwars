class_name PlayerData
extends Resource
## Valores de balance del jugador.

@export_group("Movimiento")
@export var speed: float = 420.0
@export var focus_speed: float = 180.0
## Multiplicador del arrastre táctil (1 = la nave se mueve lo mismo que el dedo).
@export var touch_sensitivity: float = 1.0

@export_group("Escudos")
## Escudos al empezar el nivel. Con 0 escudos, el siguiente impacto destruye la nave.
@export var start_shields: int = 3
@export var max_shields: int = 5
## Distancia a la que se recoge un drop.
@export var pickup_radius: float = 26.0
## Segundos de invulnerabilidad tras perder un escudo.
@export var invuln_time: float = 2.0
@export var hitbox_radius: float = 4.0

@export_group("Graze")
@export var graze_radius: float = 28.0
@export var graze_gain: float = 4.0
@export var graze_max: float = 100.0

@export_group("Disparo")
@export var fire_interval: float = 0.1
@export var shot_speed: float = 900.0
@export var shot_radius: float = 5.0
@export var shot_damage: int = 1
## Separación horizontal de los dos cañones respecto al centro.
@export var shot_offset: float = 10.0
@export var shot_color: Color = Color(0.5, 0.85, 1.0)
