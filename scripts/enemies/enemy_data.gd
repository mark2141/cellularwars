class_name EnemyData
extends Resource
## Arquetipo de enemigo. Hay un archivo .tres por cada uno de los 12.

@export var display_name: String = ""
@export var max_hp: int = 3
## Velocidad de descenso en píxeles por segundo.
@export var speed: float = 0.0
@export var radius: float = 18.0
## Provisional hasta tener sprites.
@export var color: Color = Color(0.8, 0.3, 0.5)

@export_group("Oscilación (provisional, pasará a MovementPattern)")
@export var sway_amplitude: float = 0.0
@export var sway_frequency: float = 0.0

@export_group("Patrones por rango")
@export var pattern_regular: BulletPattern
@export var pattern_reforzada: BulletPattern
@export var pattern_elite: BulletPattern


func pattern_for(rank: TierData.Rank) -> BulletPattern:
	match rank:
		TierData.Rank.REFORZADA:
			return pattern_reforzada
		TierData.Rank.ELITE:
			return pattern_elite
	return pattern_regular
