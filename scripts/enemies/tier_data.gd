class_name TierData
extends Resource
## Rango de un enemigo. Hay tres archivos: regular, reforzada y élite.

enum Rank { REGULAR, REFORZADA, ELITE }

@export var rank: Rank = Rank.REGULAR
@export var hp_mult: float = 1.0
@export var speed_mult: float = 1.0
## Provisional: tinte plano. Se sustituirá por un Gradient con el shader de paleta.
@export var tint: Color = Color.WHITE
@export var glow_strength: float = 0.0
