extends FunkinScript
func _process(delta: float) -> void:
	Conductor.rate = 1.0 + cos(Conductor.beat*9)*0.05
