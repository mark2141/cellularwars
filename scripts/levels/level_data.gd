class_name LevelData
extends Resource
## Un nivel: sus oleadas ordenadas por tiempo. El fondo y el jefe se añadirán aquí.

@export var display_name: String = ""
@export var events: Array[WaveEvent] = []
## Mejoras de arma que pueden caer en este nivel.
@export var weapon_drops: Array[WeaponData] = []
