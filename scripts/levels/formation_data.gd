class_name FormationData
extends Resource
## Formación en rejilla tipo Space Invaders: entra desde arriba, barre de lado
## a lado bajando un escalón en cada borde y, pasado un tiempo, se retira hacia abajo.

@export var columns: int = 5
@export var rows: int = 2
@export var spacing: Vector2 = Vector2(96.0, 84.0)
## Velocidad de entrada y de retirada, en píxeles por segundo.
@export var enter_speed: float = 260.0
## Velocidad lateral del barrido.
@export var sweep_speed: float = 60.0
## Píxeles que baja al tocar un borde.
@export var step_down: float = 36.0
## Distancia mínima entre la formación y el borde del campo.
@export var edge_margin: float = 48.0
## Segundos barriendo antes de retirarse (0 = no se retira nunca).
@export var lifetime: float = 24.0


func slot_count() -> int:
	return columns * rows


func slot_offset(index: int) -> Vector2:
	var col := index % columns
	var row := index / columns
	return Vector2((col - (columns - 1) * 0.5) * spacing.x, (row - (rows - 1) * 0.5) * spacing.y)


func half_size() -> Vector2:
	return Vector2((columns - 1) * 0.5 * spacing.x, (rows - 1) * 0.5 * spacing.y)
