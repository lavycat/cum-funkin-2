extends FunkinScript


var timer: float = 0.0
var start: float = 0.0


func _enter_tree() -> void:
	super()
	start = Conductor.rate


func _process(delta: float) -> void:
	timer += delta
	Conductor.rate = start * maxf((tan(timer/Conductor.beat_length*0.5) * 0.5 + 1.5), 0.1)


func note_hit(note: Note) -> void:
	if note.was_hit:
		timer -= randf_range(-0.01, 0.01)
	else:
		timer += randf_range(0.0, 0.2)
