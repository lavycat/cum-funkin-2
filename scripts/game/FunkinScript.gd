class_name FunkinScript extends Node2D

var game:Game:
	get:
		return Game.instance
func _enter_tree() -> void:
	Conductor.beat_hit.connect(beat_hit)
	Conductor.step_hit.connect(step_hit)
	Conductor.measure_hit.connect(measure_hit)
	for i in game.play_fields:
		i.note_hit.connect(note_hit)
		i.note_miss.connect(note_miss)
	game.events.event_trigger.connect(event_triggered)
		
func step_hit(step:int):
	pass
func beat_hit(beat:int):
	pass
func measure_hit(measure:int):
	pass
func note_hit(note:Note):
	pass
func note_miss(note:Note):
	pass
func event_triggered(event:Event):
	pass
func song_start():
	pass
