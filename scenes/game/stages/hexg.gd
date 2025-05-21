extends Stage
@onready var wire: Node2D = $wire
var old_dad:Character
var old_bf:Character
@onready var wire_dad: Character = $wire/wire_dad
@onready var wire_bf: Character = $wire/wire_bf
var funni:bool = false
func _ready() -> void:
	old_dad = game.dad
	old_bf = game.bf
	wire.z_index += 1
	#create_tween().set_loops(-1).tween_property(Conductor.player,"pitch_scale",0.5,.3)
func beat_hit(beat:int):
	if not wire_dad.player.is_playing():
		wire_dad.sing_timer = 0
		wire_dad.play_anim("idle",true)
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
	if funni:
		if note.play_field.id == 0:
			if not note.was_hit:
				Conductor.rate -= 0.13 * Conductor.rate * 0.9887112543165990872143
			else:
				Conductor.rate -= 0.26*get_process_delta_time() * 0.9887112543165990872143
			
		else:
			if not note.was_hit:
				Conductor.rate += 0.116 * Conductor.rate
			else:
				Conductor.rate += 0.116*get_process_delta_time()
		Conductor.rate = max(1.0,Conductor.rate)
			
		
	if Conductor.beat > 336 and Conductor.beat < 367:
		if wire.modulate.a > 0.0:
			wiretrans2()
		if wire.modulate.a < 1.0:
			wiretrans()
	if Conductor.beat > 367:
		game.dad = old_dad
		game.bf = old_bf
		wire.modulate.a = 0
			
