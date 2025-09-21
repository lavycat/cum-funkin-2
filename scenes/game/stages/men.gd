extends Node2D
func _ready() -> void:
	Conductor.beat_hit.connect(bop)
func bop(beat:int):
	for i:AnimatedSprite2D in get_children():
		
		if beat%2 == 0:
			i.play("dance_right")
		else:
			i.play("dance_left")
	pass
