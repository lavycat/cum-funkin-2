extends Stage
@onready var wire: Node2D = $wire
var old_dad:Character
var old_bf:Character
@onready var wire_dad: Character = $wire/wire_dad
@onready var wire_bf: Character = $wire/wire_bf
func _ready() -> void:
	old_dad = game.dad
	old_bf = game.bf
	wire.z_index += 1
func beat_hit(beat:int):
	match beat:
		143,271:
			wiretrans()
		207,334:
			wiretrans2()
			
func wiretrans():
	game.dad = wire_dad
	game.bf = wire_bf
	create_tween().set_parallel().tween_property(wire,"modulate:a",1,0.1)
	pass
func wiretrans2():
	game.dad = old_dad
	game.bf = old_bf
	create_tween().set_parallel().tween_property(wire,"modulate:a",0,0.1)
func note_hit(note:Note):
	if Conductor.beat > 336 and Conductor.beat < 367:
		if wire.modulate.a > 0.0:
			wiretrans2()
		if wire.modulate.a < 1.0:
			wiretrans()
	if Conductor.beat > 367:
		game.dad = old_dad
		game.bf = old_bf
		wire.modulate.a = 0
			
