## CODE FROM NOVA ENGINE GODOT https://github.com/The-Coders-Den/NovaEngine-Godot-FNF/blob/main/classes/VelocitySprite.gd ##
extends Sprite2D
class_name VelocitySprite

@export var moving:bool = true

var acceleration:Vector2 = Vector2.ZERO
var velocity:Vector2 = Vector2.ZERO

func _process(elapsed:float) -> void:
	if not moving:
		return

	# copying haxeflixel formulas cuz fuck your mother in the ass :3333
	var velocity_delta: Vector2 = _get_velocity_delta(elapsed)

	position += (velocity + velocity_delta) * elapsed
	velocity += velocity_delta * 2.0

func _get_velocity_delta(elapsed:float) -> Vector2:
	return 0.5 * ((velocity + (acceleration * elapsed)) - velocity)
