class_name MovementPattern
extends Resource
## Movimiento individual de un enemigo, como desplazamiento sobre su trayectoria base.
## La trayectoria base (dirección y velocidad, o la casilla de una formación) la pone quien lo crea.

enum Kind { STRAIGHT, SWAY, CIRCLE, ZIGZAG }

@export var kind: Kind = Kind.STRAIGHT
## Píxeles: mitad del recorrido lateral (SWAY, ZIGZAG) o radio (CIRCLE).
@export var amplitude: float = 0.0
## Segundos que tarda un ciclo completo.
@export var period: float = 2.0


func offset_at(time: float) -> Vector2:
	if kind == Kind.STRAIGHT or period <= 0.0:
		return Vector2.ZERO
	var phase := time / period
	match kind:
		Kind.SWAY:
			return Vector2(sin(phase * TAU) * amplitude, 0.0)
		Kind.CIRCLE:
			return Vector2(sin(phase * TAU), 1.0 - cos(phase * TAU)) * amplitude
		Kind.ZIGZAG:
			# Onda triangular: cambia de sentido en seco, sin frenar.
			return Vector2((4.0 * absf(fposmod(phase - 0.25, 1.0) - 0.5) - 1.0) * amplitude, 0.0)
	return Vector2.ZERO
