class_name FunkinScript extends Node2D

var game:Game:
	get:
		return Game.instance
func _enter_tree() -> void:
	Conductor.beat_hit.connect(beat_hit)
	Conductor.step_hit.connect(step_hit)
	Conductor.measure_hit.connect(measure_hit)
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
func chart_note_parsed(note:Dictionary):
	pass
func event_triggered(event:Event):
	pass
func stage_load():
	pass
func song_start():
	pass
