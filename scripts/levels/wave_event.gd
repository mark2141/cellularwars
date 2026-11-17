class_name WaveEvent
extends Resource
## Una oleada dentro de un nivel: qué enemigo, cuándo, dónde y cómo entra.

## Segundo del nivel en el que empieza la oleada.
@export var time: float = 0.0
@export var enemy: EnemyData
@export var tier: TierData
@export var can_shoot: bool = true

@export_group("En formación")
## Si se asigna, la oleada es una rejilla y `position` es su centro al terminar de entrar.
@export var formation: FormationData

@export_group("Sueltos o en fila")
## Punto de aparición del primero (o centro de la formación), en coordenadas del campo.
@export var position: Vector2 = Vector2(360.0, -40.0)
@export var count: int = 1
## Segundos entre un enemigo y el siguiente (0 = todos a la vez).
@export var spawn_interval: float = 0.0
## Desplazamiento del punto de aparición de cada enemigo respecto al anterior.
@export var step: Vector2 = Vector2.ZERO
## Dirección de avance; se multiplica por la velocidad del arquetipo.
@export var direction: Vector2 = Vector2.DOWN
