class_name EnemyData
extends Resource
## Arquetipo de enemigo. Hay un archivo .tres por cada uno de los 12.

@export var display_name: String = ""
@export var max_hp: int = 3
## Velocidad en píxeles por segundo cuando no va en formación.
@export var speed: float = 0.0
@export var radius: float = 18.0
## Escudos que quita al chocar con el jugador.
@export var contact_damage: int = 1
## Provisional hasta tener sprites.
@export var color: Color = Color(0.8, 0.3, 0.5)
## Movimiento propio cuando no va en formación (vacío = línea recta).
@export var movement: MovementPattern

@export_group("Drops")
## Probabilidad (0 a 1) de soltar un escudo al morir.
@export_range(0.0, 1.0) var shield_drop_chance: float = 0.15
## Probabilidad (0 a 1) de soltar una estrella al morir. Un enemigo suelta como mucho un drop.
@export_range(0.0, 1.0) var star_drop_chance: float = 0.1
## Probabilidad (0 a 1) de soltar una mejora de arma. Qué armas pueden salir lo decide el nivel.
@export_range(0.0, 1.0) var weapon_drop_chance: float = 0.05

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
